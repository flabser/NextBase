package cashtracker.handler

import kz.flabs.dataengine.IDBConnectionPool
import kz.nextbase.script._Exception
import kz.nextbase.script._Session
import kz.nextbase.script._WebFormData
import kz.nextbase.script.events._DoHandler


class InsertNotExistsField extends _DoHandler {

	private IDBConnectionPool dbPool
	private java.sql.Connection connection
	private java.sql.Statement statement

	@Override
	public void doHandler(_Session session, _WebFormData formData) {

		//println(formData)

		String fieldName = "category_refers_to"
		String sqlInsert = """
insert into custom_fields_glossary (docid, name, value)
  select docid, '$fieldName', ''
  from glossary g
  where form='category'
    and not exists (select docid from custom_fields_glossary
      where docid=g.docid
        and name='$fieldName')"""

		log(sqlInsert)

		try {
			dbPool = session.getCurrentDatabase().dataBase.getConnectionPool()
			connection = dbPool.getConnection()
			statement = connection.createStatement()
			statement.executeUpdate(sqlInsert)
			connection.commit()

			msgBox("ok")

			//println("ok")
		} catch(_Exception e) {
			throw e
		} finally {
			dbPool?.returnConnection(connection)
		}
	}
}
