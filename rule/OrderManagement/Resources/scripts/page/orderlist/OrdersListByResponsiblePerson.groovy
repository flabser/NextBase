package page.orderlist

import kz.nextbase.script._Session
import kz.nextbase.script._WebFormData
import kz.nextbase.script.events._DoScript

/**
 * @author Bekzat  29.01.2014
 *
 */
class OrdersListByResponsiblePerson extends _DoScript {
	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {

		def db = session.getCurrentDatabase();
        String _page = formData.getValueSilently("page");
		def page = _page == "" ? 0 : _page.toInteger();
        def person = formData.getValue("person");
		def col = db.getCollectionOfDocuments("form = 'order' and responsiblePerson='$person'", page, false, true);
		 
		setContent(col)
	}
}