package page.DocsListToconsider
import kz.nextbase.script._Session
import kz.nextbase.script._WebFormData
import kz.nextbase.script.events._DoScript
import nextbase.groovy.*

class DoScript extends _DoScript {
	
	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {
		println("test")
		def page = 1;
		if (formData.containsField("page") && formData.getValue("page")){
			page = Integer.parseInt(formData.getValue("page"))
		}
        def formula = "form='order' or form='workdoc' or form='out' or form='L' and recipient#complex ='" + session.getCurrentUserID() + "' and vn != '' and has_response = 0";
		def db = session.getCurrentDatabase()
		def col = db.getCollectionOfDocuments(formula, page, true, true)
		setContent(col)
	}
}