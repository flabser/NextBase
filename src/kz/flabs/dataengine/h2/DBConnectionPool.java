package kz.flabs.dataengine.h2;

import kz.flabs.dataengine.*;
import org.apache.commons.dbcp.ConnectionFactory;
import org.apache.commons.dbcp.DriverManagerConnectionFactory;
import org.apache.commons.dbcp.PoolableConnectionFactory;
import org.apache.commons.dbcp.PoolingDataSource;
import org.apache.commons.pool.impl.GenericObjectPool;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.NoSuchElementException;
import java.util.Properties;

public class DBConnectionPool  implements IDBConnectionPool {
    protected GenericObjectPool connectionPool;
    protected static int timeBetweenEvictionRunsMillis = 1000 * 60 * 15;

    private boolean isValid;
    private DatabaseType dt = DatabaseType.DEFAULT;
    private String DBMSVersion = "";
    public void initConnectionPool(String driver, String dbURL, String userName, String password) throws DatabasePoolException, InstantiationException, IllegalAccessException, ClassNotFoundException {
        Properties props = null;
        Class.forName(driver).newInstance();
        connectionPool = new GenericObjectPool(null);
        connectionPool.setTestOnBorrow(true);
        connectionPool.setWhenExhaustedAction(GenericObjectPool.WHEN_EXHAUSTED_BLOCK);
        connectionPool.setMaxWait(15000);
        connectionPool.setTimeBetweenEvictionRunsMillis(timeBetweenEvictionRunsMillis);

        props = new Properties();
        props.setProperty("user", userName);
        props.setProperty("password", password);
        props.setProperty("accessToUnderlyingConnectionAllowed", "true");

        ConnectionFactory connectionFactory = new DriverManagerConnectionFactory(dbURL, props);
        new PoolableConnectionFactory(connectionFactory, connectionPool, null, "SELECT 1", false, true);
        new PoolingDataSource(connectionPool);
        connectionPool.setMaxIdle(200);
        connectionPool.setMaxActive(2000);

        dt = DatabaseUtil.getDatabaseType(dbURL);

        checkConnection();
        isValid = true;
    }

    public void initConnectionPool(String driver, String dbURL) throws DatabasePoolException, InstantiationException, IllegalAccessException, ClassNotFoundException {
        Class.forName(driver).newInstance();
        connectionPool = new GenericObjectPool(null);
        connectionPool.setTestOnBorrow(true);
        connectionPool.setWhenExhaustedAction(GenericObjectPool.WHEN_EXHAUSTED_BLOCK);
        connectionPool.setMaxWait(15000);
        connectionPool.setTimeBetweenEvictionRunsMillis(timeBetweenEvictionRunsMillis);

        ConnectionFactory connectionFactory = new DriverManagerConnectionFactory(dbURL, null,null);
        new PoolableConnectionFactory(connectionFactory, connectionPool, null, "SELECT 1", false, true);
        new PoolingDataSource(connectionPool);
        connectionPool.setMaxIdle(200);
        connectionPool.setMaxActive(2000);

        dt = DatabaseUtil.getDatabaseType(dbURL);

        checkConnection();
        isValid = true;
    }

    public Connection getConnection(){
        Connection con = null;
        try{
            con = (Connection) connectionPool.borrowObject();
            con.setAutoCommit(false);
        }catch(NoSuchElementException nsee){
            Database.logger.errorLogEntry(nsee);
        } catch (SQLException e) {
            DatabaseUtil.debugErrorPrint(e);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return con;
    }

    public void returnConnection(Connection con) {
        if (con == null) {
            //System.err.println("Returning NULL to pool!!!");
            return;
        }

        try {
            connectionPool.returnObject(con);
        } catch (Exception ex) {
            ex.fillInStackTrace();
        }
    }

    public void close(Connection conn) {
		/*	if (null != conn) {
			try {
		//		conn.close();
	//		} catch (SQLException e) {
				//e.printStackTrace();
			}	

		}*/
    }

    @Override
    public DatabaseType getDatabaseType() {
        return dt;
    }

    @Override
    public String getDatabaseVersion() {
        return DBMSVersion;
    }

    public void closeAll() {
        connectionPool.clear();
        try {
            connectionPool.close();
        } catch (Exception e) {
            Database.logger.errorLogEntry(e);
        }
    }

    public int getNumActive() {
        return connectionPool.getNumActive();
    }

    public String toXML() {
        return "<active>" + connectionPool.getNumActive() + "</active>" +
                "<idle>" +  connectionPool.getNumIdle() + "</idle>" +
                "<maxactive>" +  connectionPool.getMaxActive() + "</maxactive>" +
                "<maxidle>" +  connectionPool.getMaxIdle() + "</maxidle>";
    }

    private void checkConnection() throws DatabasePoolException{
        Connection con = null;
        try{
            con = (Connection) connectionPool.borrowObject();
            con.setAutoCommit(false);
            Statement st = con.createStatement();
            String checkVersionQuery = "";
            switch (dt) {
                case H2:
                    checkVersionQuery = "SELECT value\n" +
                            "FROM information_schema.settings\n" +
                            "WHERE name = 'info.VERSION'";
                    break;
                case POSTGRESQL:
                case POSTGRESQL_CT:
                    checkVersionQuery = "SELECT VERSION()";
                    break;
                case MSSQL:
                    checkVersionQuery = "select @@VERSION";
                    break;
                default:
                    checkVersionQuery = "SELECT VERSION()";
                    break;
            }
            ResultSet rs = st.executeQuery(checkVersionQuery);
            if (rs.next()) {
                DBMSVersion = rs.getString(1);
            }
            con.commit();
            rs.close();
            st.close();
        } catch (SQLException e) {
            DatabaseUtil.errorPrint(e);
            if (e.getMessage().contains("Connection refused")){
                throw new DatabasePoolException(DatabasePoolExceptionType.DATABASE_CONNECTION_REFUSED);
            }else if(e.getMessage().contains("password authentication failed")){
                throw new DatabasePoolException(DatabasePoolExceptionType.DATABASE_AUTHETICATION_FAILED);
            }else{
                throw new DatabasePoolException(DatabasePoolExceptionType.DATABASE_SQL_ERROR);
            }
        } catch (Exception e) {
            Database.logger.errorLogEntry(e);
        }finally{
            returnConnection(con);
        }
    }
//@TODO  removeAbandoned=«true» removeAbandonedTimeout=«30» logAbandoned=«true»
}
