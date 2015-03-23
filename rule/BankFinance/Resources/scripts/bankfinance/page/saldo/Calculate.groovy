package bankfinance.page.saldo

import kz.nextbase.script._Helper
import kz.nextbase.script._Session
import kz.nextbase.script._Tag
import kz.nextbase.script._WebFormData
import kz.nextbase.script._XMLDocument
import kz.nextbase.script.events._DoScript

class Calculate extends _DoScript {

	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {
		def db = session.getCurrentDatabase()
		def user = session.getCurrentAppUser()
		if (user.hasRole("reg_spec_operations")){

			def saldoValue
			def viewParam = session.createViewEntryCollectionParam()
					.setPageNum(0)
					.setPageSize(0)
					.setUseFilter(true)
					.setCheckResponse(true)

			if(formData.getValue("id") == "bankoperationsbyaccount"){
				String sf = "form = 'bank_operation' and bank_account = '" + formData.getValueSilently("bank_account") + "'"
				saldoValue = SaldoUtils.getViewNumberTotal(db, viewParam.setQuery(sf))
			} else if (formData.getValue("id") == "search"){
				saldoValue = db.search(formData.getValue("keyword"), 0).getViewNumberTotal()
			} else if(formData.getValueSilently("ddbid").length() > 0) {
				def doc = db.getDocumentByID(formData.getValue("ddbid"))
				def date = _Helper.getDateAsString(doc.getValueDate("date"))
				viewParam.setUseFilter(true)
						.setCheckResponse(true)
						.setQuery("form = 'bank_operation' and date#datetime <= '$date'")
				saldoValue = SaldoUtils.getViewNumberTotal(db, viewParam)
			} else {
				saldoValue = SaldoUtils.getViewNumberTotal(db, viewParam.setQuery("form = 'bank_operation'"))
			}

			def saldoTag = new _Tag("saldo")
			saldoTag.addTag("sum", saldoValue[0].setScale(2, BigDecimal.ROUND_DOWN))
			saldoTag.addTag("plus", saldoValue[1].setScale(2, BigDecimal.ROUND_DOWN))
			saldoTag.addTag("minus", saldoValue[2].setScale(2, BigDecimal.ROUND_DOWN))

			setContent(new _XMLDocument(saldoTag))
		}
	}
}
