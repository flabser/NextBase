package kz.flabs.servlets.admin;

import kz.flabs.appenv.AppEnv;
import kz.flabs.dataengine.IDatabase;
import kz.pchelka.env.Environment;
import kz.pchelka.server.Server;

public class AdminOutline {
	private String XMLText = "";
	private static final String prefix = Server.serverTitle + " - ";

	AdminOutline(String service, String s, String a, String d, String p){

		String serviceID = "", app = "", dbid = "", page= "";
		if (s != null)serviceID = s;
		if (a != null)app = " app=\"" + a + "\"";		
		if (d != null)dbid = " dbid=\"" + d + "\"";
		if (p != null)page = " page=\"" + p + "\"";

		XMLText += "<currentview title=\"" + getTitle(service) + "\" service=\"" + service + "\" " + app + dbid + page + " >" + serviceID +  "</currentview>";		
		XMLText += "<outline>";				
		for(AppEnv appEnv: Environment.getApplications()){
			String dbID = "";
			IDatabase db = appEnv.getDataBase();
			if (db != null){
				dbID = appEnv.getDataBase().getDbID();		
				XMLText += "<application appid= \"" + appEnv.appType.replace("\"", "'") + "\" dbid= \"" + dbID.replace("\"", "'") + "\">";						
				XMLText += "<database appid= \"" + appEnv.appType.replace("\"", "'") + "\" dbid= \"" + dbID.replace("\"", "'") + "\"></database>";			
			}else{
				XMLText += "<application appid= \"" + appEnv.appType.replace("\"", "'") + "\" dbid= \"\">";	
			}
			XMLText += "</application>";		
		}	
		XMLText += "</outline>";
	}
	
	AdminOutline(){
	
		XMLText += "<outline>";				
		for(AppEnv appEnv: Environment.getApplications()){
			String dbID = "";
			IDatabase db = appEnv.getDataBase();
			if (db != null){
				dbID = appEnv.getDataBase().getDbID();		
				XMLText += "<application appid= \"" + appEnv.appType.replace("\"", "'") + "\" dbid= \"" + dbID.replace("\"", "'") + "\">";						
				XMLText += "<database appid= \"" + appEnv.appType.replace("\"", "'") + "\" dbid= \"" + dbID.replace("\"", "'") + "\"></database>";			
			}else{
				XMLText += "<application appid= \"" + appEnv.appType.replace("\"", "'") + "\" dbid= \"\">";	
			}
			XMLText += "</application>";		
		}	
		XMLText += "</outline>";
	}

	public String getOutlineAsXML(){
		return XMLText;
	}

	private String getTitle(String service){

		if(service.equalsIgnoreCase("console")){
			return prefix + "Server console";
		}else if(service.equalsIgnoreCase("settings")){
			return prefix + "Application setting";
		}else if(service.equalsIgnoreCase("get_logs_list")){
			return prefix + "Server logs";
		}else if(service.equalsIgnoreCase("get_users_list")){
			return prefix + "Users list";
		}else if(service.equalsIgnoreCase("get_queries_list")){
			return prefix + "Queries";
		}else if(service.equalsIgnoreCase("get_handlers_list")){
			return prefix + "Handlers";
		}else if(service.equalsIgnoreCase("get_maindocs_list")){
			return prefix + "Main documents";
		}else{
			return prefix;
		}
	}

}
