package kz.pchelka.log;

import java.io.File;
import java.util.jar.Attributes;
import java.util.jar.JarFile;
import java.util.jar.Manifest;
import kz.pchelka.console.rmi.server.*;
import kz.pchelka.env.Environment;
import kz.pchelka.server.Server;

public class Log4jLogger implements ILogger {
	public org.apache.log4j.Logger log4jLogger;

	private String module = "";
	private RMIServer rmiServer = null;
	private boolean adminConsoleEnabled;

	public Log4jLogger(String module) {
		log4jLogger = org.apache.log4j.Logger.getLogger(module);
		this.module = module;
		rmiServer = Server.rmiServer;
		if(rmiServer != null) adminConsoleEnabled = true;
	}

	public void errorLogEntry(String logtext) {
		log4jLogger.error(logtext);

		if(adminConsoleEnabled)
			rmiServer.rlogger.errorLogEntry(module + ": " + logtext);
	}

	public void fatalLogEntry(String logtext) {
		log4jLogger.fatal(logtext);

		if(adminConsoleEnabled)
			rmiServer.rlogger.errorLogEntry(module + ": " + logtext);
	}

	public void errorLogEntry(Exception exception) {
		log4jLogger.error(exception);

		if(adminConsoleEnabled)
			rmiServer.rlogger.errorLogEntry(exception.toString());

		exception.printStackTrace();
	}

	public void errorLogEntry(String agent, String logtext) {
		log4jLogger.error(agent + "-" + logtext);

		if(adminConsoleEnabled)
			rmiServer.rlogger.errorLogEntry(module + ": " + agent + "-" + logtext);
	}

	public void errorLogEntry(String agent, String logtext, String searchKey) {
		log4jLogger.error(agent + "-" + logtext + " searchKey=" + searchKey);

		if(adminConsoleEnabled)
			rmiServer.rlogger.errorLogEntry(module+": " + agent + "-" + logtext + " searchKey=" + searchKey);
	}

	public void errorLogEntry(String agent, Exception exception) {
		String msg = agent + "-" + exception.toString();
		msg += getErrorStackString(exception.getStackTrace());
		log4jLogger.error(msg, exception);

		if(adminConsoleEnabled)
			rmiServer.rlogger.errorLogEntry(module + ": "+msg);
	}

	public void errorLogEntry(String agent, Exception exception, String searchKey) {
		String msg = exception.toString();
		msg += getErrorStackString(exception.getStackTrace());
		log4jLogger.error(agent + " searchKey=" + searchKey + " " + msg, exception);

		if(adminConsoleEnabled)
			rmiServer.rlogger.errorLogEntry(module + ": " + agent + " searchKey=" + searchKey + " " + msg);
	}

	public void normalLogEntry(String logtext) {
		log4jLogger.info(logtext);

		if(adminConsoleEnabled)
			rmiServer.rlogger.normalLogEntry(module + ": "+logtext);
	}

	public void normalLogEntry(String agent, String logtext) {
		log4jLogger.info(agent + "-" + logtext);

		if(adminConsoleEnabled)
			rmiServer.rlogger.normalLogEntry(module + ": "+agent + "-" + logtext);
	}

	public void verboseLogEntry(String logtext) {
		if (Environment.verboseLogging) {
			log4jLogger.debug(logtext);

			if(adminConsoleEnabled)
				rmiServer.rlogger.debugLogEntry(module + ": "+logtext);
		}
	}

	public void verboseLogEntry(String agent, String logtext) {
		if (Environment.verboseLogging) {
			log4jLogger.debug(agent + "-" + logtext);

			if(adminConsoleEnabled)
				rmiServer.rlogger.debugLogEntry(module+": "+agent + "-" + logtext);
		}
	}

	public void warningLogEntry(String agent, String logtext) {
		log4jLogger.info(agent + "-" + logtext);

		if(adminConsoleEnabled)
			rmiServer.rlogger.normalLogEntry(module+": "+agent + "-" + logtext);
	}

	public void warningLogEntry(String logtext) {
		log4jLogger.warn(logtext);

		if(adminConsoleEnabled)
			rmiServer.rlogger.warnLogEntry(module+": "+logtext);
	}

	public boolean getLoggingMode() {
		return false;
	}

	public static String getErrorStackString(StackTraceElement stack[]) {
		StringBuffer addErrorMessage = new StringBuffer(1000);
		for (int i = 0; i < stack.length; i++) {
			addErrorMessage.append("\n" + stack[i].getClassName()
					+ " > " + stack[i].getMethodName() + " "
					+ Integer.toString(stack[i].getLineNumber()) + "\n");
		}

		return addErrorMessage.toString();
	}

	public String getBuildDateTime(){
        String value = "";
        try{
            String pathToJar = this.getClass().getProtectionDomain().getCodeSource().getLocation().getPath();
            if (pathToJar.contains("jar")) {
                JarFile jarFile = new JarFile(new File(pathToJar));
                Manifest entry = jarFile.getManifest();
                Attributes attrs = entry.getMainAttributes();
                value = attrs.getValue("Built-Date");
            }
		}catch(Exception e){
			errorLogEntry(getClass().getName(),e);
		}
        return value;
	}

	@Override
	public void errorLogEntry(Throwable exception) {
		log4jLogger.error(exception);

		if(adminConsoleEnabled)
			rmiServer.rlogger.errorLogEntry(exception.toString());

		exception.printStackTrace();
		
	}
}
