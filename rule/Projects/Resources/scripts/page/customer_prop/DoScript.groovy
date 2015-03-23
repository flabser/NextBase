package page.customer_prop

import java.util.Map;
import kz.nextbase.script.*
import kz.nextbase.script.constants._AllControlType
import kz.nextbase.script.events._DoScript
import kz.nextbase.script._Helper

class DoScript extends _DoScript {
	
	public DoScript(){}
	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {
		def customer_id = formData.getValueSilently("customer_id")
		def customer_name = formData.getValueSilently("customer_name")
		def rootTag = new _Tag("customer","")
		rootTag.addTag(new _Tag("id",customer_id))
		def xml = new _XMLDocument(rootTag)
		setContent(xml);
	}

}