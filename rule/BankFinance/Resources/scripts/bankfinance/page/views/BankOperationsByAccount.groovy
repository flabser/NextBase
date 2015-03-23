package bankfinance.page.views

import java.text.SimpleDateFormat

import kz.nextbase.script._Session
import kz.nextbase.script._WebFormData
import kz.nextbase.script.events._DoScript

class BankOperationsByAccount extends _DoScript {

	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {

		def viewParam = session.createViewEntryCollectionParam()
		def sf = "form = 'bank_operation' and bank_account = '" + formData.getValueSilently("bank_account") +"'"
		viewParam.setQuery(sf)
				.setPageNum(formData.getNumberValueSilently("page", 0))
				.setUseFilter(true)
				.setCheckResponse(true)
				.setDateFormat(new SimpleDateFormat("dd.MM.yyyy"))

		def col = session.getCurrentDatabase().getCollectionOfDocuments(viewParam)
		setContent(col)
	}
}
