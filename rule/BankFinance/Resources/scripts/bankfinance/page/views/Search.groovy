package bankfinance.page.views

import kz.nextbase.script._Session
import kz.nextbase.script._WebFormData
import kz.nextbase.script.events._DoScript

class Search extends _DoScript {

	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {
		def page = formData.getNumberValueSilently("page", 1)
		def col = session.getCurrentDatabase().search(formData.getValue("keyword"), page)
		setContent(col)
	}
}
