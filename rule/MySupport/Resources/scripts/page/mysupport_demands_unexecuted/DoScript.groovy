package page.mysupport_demands_unexecuted

import kz.nextbase.script._Session;
import kz.nextbase.script._WebFormData;
import kz.nextbase.script.events._DoScript;

class DoScript extends _DoScript {

	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {
		// TODO Auto-generated method stub
		def db = session.getCurrentDatabase();
        def page = 0;
        if(formData.containsField("page")){
            page = formData.getValue("page").toInteger();
        }
		def col = db.getCollectionOfDocuments("form = 'demand' and viewtext4 = '1' and status != 'notActual' and publishforcustomer='1'",page,false);
		setContent(col)
	}
}
