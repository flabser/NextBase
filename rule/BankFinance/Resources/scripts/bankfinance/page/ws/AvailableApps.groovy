package bankfinance.page.ws

import kz.nextbase.script.*
import kz.nextbase.script.actions.*
import kz.nextbase.script.events._DoScript

class AvailableApps extends _DoScript {

	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {
		publishElement("app_name", session.getAppEntourage().getAppName())
		publishElement("availableapps", session.getAppEntourage().getAvailableApps())
	}
}
