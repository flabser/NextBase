package bankfinance.page.saldo

import kz.nextbase.script._Helper
import kz.nextbase.script._Session
import kz.nextbase.script._Tag
import kz.nextbase.script._WebFormData
import kz.nextbase.script._XMLDocument
import kz.nextbase.script.events._DoScript

class SaldoOnDate extends _DoScript {

	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {

		def db = session.getCurrentDatabase()
		def viewParam = session.createViewEntryCollectionParam()
				.setPageNum(0)
				.setPageSize(0)
				.setUseFilter(false)
				.setCheckResponse(false)

		def doc = db.getDocumentByID(formData.getValue("ddbid"))
		def date = _Helper.getDateAsString(doc.getValueDate("date"))
		viewParam.setQuery("form = 'bank_operation' and date#datetime <= '$date'")
		def collection = db.getCollectionOfDocuments(viewParam)
		def saldoValue = collection.getViewNumberTotal()

		def saldoTag = new _Tag("saldo")
		saldoTag.addTag("sum", saldoValue[0].setScale(2, BigDecimal.ROUND_DOWN))
		saldoTag.addTag("plus", saldoValue[1].setScale(2, BigDecimal.ROUND_DOWN))
		saldoTag.addTag("minus", saldoValue[2].setScale(2, BigDecimal.ROUND_DOWN))

		setContent(new _XMLDocument(saldoTag))
	}
}
