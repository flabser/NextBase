package page.mysupport_search

import kz.nextbase.script._Session;
import kz.nextbase.script._WebFormData;
import kz.nextbase.script.events._DoScript;

class DoScript extends _DoScript {
	
	public void doProcess(_Session session, _WebFormData formData, String lang) {
		println(formData)
		def page = 1;
		def db = session.getCurrentDatabase()
		def col = db.search(formData.getValue("keyword"), page)
		
		setContent(col)
		
		return;
	}
}
