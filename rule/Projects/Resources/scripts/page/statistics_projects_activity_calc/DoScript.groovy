package page.statistics_projects_activity_calc

import kz.nextbase.script._Session
import kz.nextbase.script._Tag
import kz.nextbase.script._WebFormData
import kz.nextbase.script._XMLDocument
import kz.nextbase.script.events._DoScript

class DoScript extends _DoScript {
	
	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {
		def cdb = session.getCurrentDatabase();
		def sel_prj = formData.getEncodedValueSilently("projects").tokenize("`");
		def entryTag = new _Tag("statistics");
		def startdate = formData.getValue("startdate");
		def enddate = formData.getValue("enddate");
		def formula = "";
		if(sel_prj.size() > 0){
			for(def p in sel_prj){
				formula = getConditionString(p.tokenize("~")[0], startdate, enddate);
							
				def demands = cdb.getDocsCollection(formula, 1, 2000).getBaseCollection();
				def entry = new _Tag("entry");
				entry.setAttr("value", demands.size())
				entry.setAttr("project_name", p.tokenize("~")[1]);
				entryTag.addTag(entry);
			}
		}else{
			def projects = cdb.getDocsCollection("form='project'",1,2000).getBaseCollection();

			for(def p in projects){
				formula = getConditionString(p.getDdbID(), startdate, enddate)
				def demands = cdb.getDocsCollection(formula, 1, 2000).getBaseCollection();
				if(demands.size() > 0){
					def entry = new _Tag("entry");
					entry.setAttr("value", demands.size())
					entry.setAttr("project_name", p.getValueAsString("project_name")[0]);
					entryTag.addTag(entry);
				}
			}
						
		}
		def xml = new _XMLDocument(entryTag)
		setContent(xml);
	}
	
	def getConditionString(String id, def startdate, def enddate){
		String formula = "";
		
		if(startdate == "" && enddate == ""){
			formula = "form = 'demand' and projectID ~ '"+ id +"' and viewtext4 = '1' and iserror !='on'";
		}else if(startdate == ""){
			formula = "form = 'demand' and projectID ~ '"+ id +"' and viewtext4 = '1' and iserror !='on' and regdate#datetime <= '$enddate'";
		}else if(enddate == ""){
			formula = "form = 'demand' and projectID ~ '"+ id +"' and viewtext4 = '1' and iserror !='on'  and regdate#datetime >= '$startdate'";
		}else{
			formula = "form = 'demand' and projectID ~ '"+ id +"' and viewtext4 = '1' and iserror !='on'  and regdate#datetime >= '$startdate' and regdate#datetime <= '$enddate'";
		}
		return formula;
	}
}
