package page.checkURL

import java.util.Map
import kz.nextbase.script.constants._DocumentType;
import kz.nextbase.script.*;
import kz.nextbase.script.events._DoHandler;
import kz.nextbase.script.events._DoScheduledHandler
import kz.nextbase.script.events._DoScript
import kz.nextbase.script.struct._Employer
import kz.nextbase.script.task._Task
import nextbase.groovy.*;

class DoScript extends _DoScript {
	
	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {
		// TODO Auto-generated method stub
		String url = formData.getValueSilently("url");
		println(_Validator.checkURL(url).toString())
	}
}
