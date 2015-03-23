package page.searchdocs

import kz.nextbase.script._Session;
import kz.nextbase.script._WebFormData;
import kz.nextbase.script.events._DoScript;

/**
 * @author Bekzat
 * @date 28.01.2014
 */
class DoScript extends _DoScript {
	
	public void doProcess(_Session session, _WebFormData formData, String lang) {

        String _page = formData.getValueSilently("page");
        def page = _page == "" ? 1 : _page.toInteger();
		def db = session.getCurrentDatabase()
		def col = db.search(formData.getValue("keyword"), page)
		
		setContent(col)
		return;
	}
}
