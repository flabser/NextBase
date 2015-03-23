package page.getDocsListMyTasks

import kz.nextbase.script._Helper
import kz.nextbase.script.task._Control

import java.text.SimpleDateFormat
import kz.nextbase.script._Session
import kz.nextbase.script._WebFormData
import kz.nextbase.script.events._DoScript
import nextbase.groovy.*

class DoScript extends _DoScript {
	
	@Override
public void doProcess(_Session session, _WebFormData formData, String lang) {
	//	println(formData)
		def page = 1;
		if (formData.containsField("page") && formData.getValue("page")){
			page = Integer.parseInt(formData.getValue("page"))
		}
		def formula = "form='demand' and author='" + session.getCurrentUserID() +
                "' and (viewtext4 = '1' or viewtext4 = '2' or viewtext4 = '3')";
		def db = session.getCurrentDatabase()
		def col = db.getCollectionOfDocuments(formula, page, true, true);

		setContent(col)
	}
}