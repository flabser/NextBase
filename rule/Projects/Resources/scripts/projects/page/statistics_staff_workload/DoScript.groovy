package projects.page.statistics_staff_workload

import kz.nextbase.script._Session
import kz.nextbase.script._Tag
import kz.nextbase.script._WebFormData
import kz.nextbase.script._XMLDocument
import kz.nextbase.script.events._DoScript


class DoScript extends _DoScript {
	
	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {
		def cdb = session.getCurrentDatabase();
		def struct = session.getStructure();
		def emp = formData.getValue("emp").tokenize("`");
		def startdate = formData.getValue("startdate");
		def enddate = formData.getValue("enddate");
		def docs;
		HashMap emap = new HashMap<String, Integer>();
		
		// если были выбраны сотрудники
		if(emp.size() != 0){
			for(def executerID in emp){
				if(startdate == "" && enddate == ""){
					docs = cdb.getDocsCollection("form = 'demand' and viewtext4 = '1' and iserror != 'on' and executer = '$executerID'", 1, 2000).getBaseCollection();
				}else if(startdate == ""){
					docs = cdb.getDocsCollection("form = 'demand' and viewtext4 = '1' and iserror != 'on' and regdate#datetime <= '$enddate' and executer = '$executerID'", 1, 2000).getBaseCollection();
				}else if(enddate == ""){
					docs = cdb.getDocsCollection("form = 'demand' and viewtext4 = '1' and iserror != 'on' and regdate#datetime >= '$startdate' and executer = '$executerID'", 1, 2000).getBaseCollection();
				}else{
					docs = cdb.getDocsCollection("form = 'demand' and viewtext4 = '1' and iserror != 'on' and regdate#datetime >= '$startdate' and regdate#datetime <= '$enddate' and executer = '$executerID'", 1, 2000).getBaseCollection();
				}
				
				for(def d in docs){
					def pri = d.getValueAsString('priority')[0].tokenize('.')[0];
					def comp = d.getValueAsString('complication')[0].tokenize('.')[0];
					int weight = 20 - Integer.parseInt(pri) + Integer.parseInt(comp)
					
					if(emp.contains(executerID) || emp.size() ==0){
						if(emap.containsKey(executerID))
						{
							emap.put(executerID, emap.get(executerID) + weight);
						}
						else
							emap.put(executerID, weight);
					}
				}
				// если у данного сотрудника нету активных заявок, то нужно присвоить к нему значение 0
				if(docs.size() == 0)
					emap.put(executerID, 0);
			}
		}else{
			// Если сотрудники не были выбраны, нужно найти всех активных заявок
			if(startdate == "" && enddate == ""){
				docs = cdb.getDocsCollection("form = 'demand' and viewtext4 = '1' and iserror != 'on'", 1, 2000).getBaseCollection();
			}else if(startdate == ""){
				docs = cdb.getDocsCollection("form = 'demand' and viewtext4 = '1' and iserror != 'on' and regdate#datetime <= '$enddate'", 1, 2000).getBaseCollection();
			}else if(enddate == ""){
				docs = cdb.getDocsCollection("form = 'demand' and viewtext4 = '1' and iserror != 'on' and regdate#datetime >= '$startdate'", 1, 2000).getBaseCollection();
			}else{
				docs = cdb.getDocsCollection("form = 'demand' and viewtext4 = '1' and iserror != 'on' and regdate#datetime >= '$startdate' and regdate#datetime <= '$enddate'", 1, 2000).getBaseCollection();
			}
			
			for(def d in docs){
				String executer = d.getValueAsString("executer")[0]; 
			    def pri = d.getValueAsString('priority')[0].tokenize('.')[0];
				def comp = d.getValueAsString('complication')[0].tokenize('.')[0];
				int weight = 20 - Integer.parseInt(pri) + Integer.parseInt(comp)
				if(emp.contains(executer) || emp.size() ==0){
					if(emap.containsKey(executer))
					{
						emap.put(executer, emap.get(executer) + weight);
					}	
					else
						emap.put(executer, weight);	
				}		
			}
		}
		// print
		def entryTag = new _Tag("statistics");
		for(def userID in emap.keySet()){
			def fullname = struct.getEmployer(userID).getShortName();
			def entry = new _Tag("entry");
			entry.setAttr("weight", emap.get(userID))
			entry.setAttr("userid", userID)
			entry.setAttr("fullname", fullname);
			entryTag.addTag(entry);
		}
		def xml = new _XMLDocument(entryTag)
		setContent(xml);
		println(emap)
	}
}