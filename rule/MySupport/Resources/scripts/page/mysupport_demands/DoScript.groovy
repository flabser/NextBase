package page.mysupport_demands

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
		// без КИ и без дочерних
		def col = db.getCollectionOfDocuments("form = 'demand' and publishforcustomer='1'",page,false);
		 
		setContent(col)
	}
}