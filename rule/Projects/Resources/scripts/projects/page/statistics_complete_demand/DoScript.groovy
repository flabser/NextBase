package projects.page.statistics_complete_demand

import kz.nextbase.script._Session
import kz.nextbase.script._WebFormData
import kz.nextbase.script.events._DoScript


class DoScript extends _DoScript {
	
	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {
		def cdb = session.getCurrentDatabase();
		def struct = session.getStructure();
		def emp = formData.getValue("emp");
		def startdate = formData.getValue("startdate");
		def enddate = formData.getValue("enddate");
		def formula;
		if(startdate == "" && enddate == ""){
			formula = "form = 'demand' and viewtext4 = '0' and iserror != 'on' and executer = '$emp'";
		}else if(startdate == ""){
			formula = "form = 'demand' and viewtext4 = '0' and iserror != 'on' and regdate#datetime <= '$enddate' and executer = '$emp'";
		}else if(enddate == ""){
			formula = "form = 'demand' and viewtext4 = '0' and iserror != 'on' and regdate#datetime >= '$startdate' and executer = '$emp'";
		}else{
			formula = "form = 'demand' and viewtext4 = '0' and iserror != 'on' and regdate#datetime >= '$startdate' and regdate#datetime <= '$enddate' and executer = '$emp'";
		}
		def col = cdb.getCollectionOfDocuments(formula, -1, true, true);
		setContent(col);
	}
}