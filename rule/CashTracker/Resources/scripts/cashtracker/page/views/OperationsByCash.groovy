package cashtracker.page.views

import java.text.SimpleDateFormat

import kz.nextbase.script._Session
import kz.nextbase.script._WebFormData
import kz.nextbase.script.events._DoScript


class OperationsByCash extends _DoScript {

	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {

		def viewParam = session.createViewEntryCollectionParam()
		def sf = "form = 'operation' and cash#number = " + formData.getNumberValueSilently("cashid", -1);
		viewParam.setQuery(sf)
				.setPageNum(formData.getNumberValueSilently("page", 0))
				.setUseFilter(true)
				.setCheckResponse(true)
				.setDateFormat(new SimpleDateFormat("dd.MM.yyyy"))

		def col = session.getCurrentDatabase().getCollectionOfDocuments(viewParam)
		setContent(col)
	}
}