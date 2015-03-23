package page.prjs_search
import kz.nextbase.script._Session
import kz.nextbase.script._WebFormData
import kz.nextbase.script.events._DoScript
import nextbase.groovy.*

class DoScript extends _DoScript {
	
	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {
		println(formData)
        String page = formData.containsField("page") ? formData.get("page")[0] : 1;
		def db = session.getCurrentDatabase()
		def col = db.search(formData.getValue("keyword"), (page.isNumber() ? Integer.parseInt(page) : 1))
		setContent(col)
	}
}