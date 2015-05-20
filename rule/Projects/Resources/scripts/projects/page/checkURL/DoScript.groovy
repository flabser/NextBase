package projects.page.checkURL

import kz.nextbase.script.*
import kz.nextbase.script.events._DoScript
import nextbase.groovy.*;

class DoScript extends _DoScript {
	
	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {
		// TODO Auto-generated method stub
		String url = formData.getValueSilently("url");
		println(_Validator.checkURL(url).toString())
	}
}
