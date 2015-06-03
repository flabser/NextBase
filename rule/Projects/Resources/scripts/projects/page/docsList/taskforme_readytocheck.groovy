package projects.page.docsList

import kz.nextbase.script._Session
import kz.nextbase.script._WebFormData
import kz.nextbase.script.events._DoScript
import nextbase.groovy.*

class taskforme_readytocheck extends _DoScript {
	
	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {
		println(formData)
		def page = 1;
		if (formData.containsField("page") && formData.getValue("page")){
			page = Integer.parseInt(formData.getValue("page"))
		}
		def formula = "form='demand' and viewtext4 = '2' and executer ~ '" +  session.getCurrentUserID() + "'";
		def db = session.getCurrentDatabase()
		def col = db.getCollectionOfDocuments(formula, page, true, true)

        setContent(col)
	}
}