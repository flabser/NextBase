package page.orderlist

import kz.nextbase.script._Session;
import kz.nextbase.script._WebFormData;
import kz.nextbase.script.events._DoScript;

/**
 * @author Bekzat
 * @date 28.01.2014
 */
class OrdersListAll extends _DoScript {
	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {

		def db = session.getCurrentDatabase();
        String _page = formData.getValueSilently("page");
		def page = _page == "" ? 0 : _page.toInteger();

		def col = db.getCollectionOfDocuments("form = 'order'", page, true, true);
		 
		setContent(col)
	}
}