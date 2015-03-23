package finplanning.page.saldo

import kz.nextbase.script._Session
import kz.nextbase.script._Tag
import kz.nextbase.script._WebFormData
import kz.nextbase.script._XMLDocument
import kz.nextbase.script.events._DoScript

class Calculate extends _DoScript {

	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {
		def db = session.getCurrentDatabase()
		def saldoValue

		if(formData.getValue("id") == "search"){
			saldoValue = db.search(formData.getValue("keyword"), 0).getViewNumberTotal()
		} else {
			def viewParam = session.createViewEntryCollectionParam()
					.setQuery("form in ('income', 'expense')")
					.setPageNum(0)
					.setPageSize(0)
					.setUseFilter(true)
					.setCheckResponse(true)

			saldoValue = db.getCollectionOfDocuments(viewParam).getViewNumberTotal()
		}

		def saldoTag = new _Tag("saldo")
		saldoTag.addTag("sum", saldoValue[0].setScale(2, BigDecimal.ROUND_DOWN))
		saldoTag.addTag("plus", saldoValue[1].setScale(2, BigDecimal.ROUND_DOWN))
		saldoTag.addTag("minus", saldoValue[2].setScale(2, BigDecimal.ROUND_DOWN))

		setContent(new _XMLDocument(saldoTag))
	}
}
