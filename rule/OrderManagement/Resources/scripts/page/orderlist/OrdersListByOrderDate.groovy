package page.orderlist

import kz.nextbase.script._Session
import kz.nextbase.script._WebFormData
import kz.nextbase.script.events._DoScript

/**
 * @author Bekzat  29.01.2014
 *
 */
class OrdersListByOrderDate extends _DoScript {
	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {

		def db = session.getCurrentDatabase();
        String _page = formData.getValueSilently("page");
		def page = _page == "" ? 0 : _page.toInteger();
        def date = formData.getValue("date");
        println(date)
		def col = db.getCollectionOfDocuments("form = 'order' and orderDate#datetime='$date'", page, false, true);
		 
		setContent(col)
	}
}