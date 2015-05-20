package projects.page.getDocsListExpiredDemands

import kz.nextbase.script._Helper
import kz.nextbase.script.task._Control
import kz.nextbase.script._Session
import kz.nextbase.script._WebFormData
import kz.nextbase.script.events._DoScript
import nextbase.groovy.*

class DoScript extends _DoScript {
	
	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {
		println(formData)
		def page = 1;
		if (formData.containsField("page") && formData.getValue("page")){
			page = Integer.parseInt(formData.getValue("page"))
		}
		def formula = "form='demand' and viewtext4 = '1' and viewtext2::int < 0";
		def db = session.getCurrentDatabase()
		def col = db.getCollectionOfDocuments(formula, page, true, true)
        try{
            col.getEntries().each {
                def control = new _Control(session, new Date(), false, _Helper.convertStringToDate(it.getViewText(9)));
                it.addViewText(control.getDiffBetweenDays(new Date()).toString(), "leftdays");
            }
        }catch(Exception e) {}
        setContent(col)
	}
}