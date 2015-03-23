package bankfinance.form.bank_operation

import bankfinance.form.FormUtil
import kz.nextbase.script._Document
import kz.nextbase.script._Helper
import kz.nextbase.script._Session
import kz.nextbase.script._WebFormData
import kz.nextbase.script.events._FormQuerySave


class QuerySave extends _FormQuerySave {

	@Override
	public void doQuerySave(_Session session, _Document doc, _WebFormData webForm, String lang) {

		def requiredFields = FormUtil.validate(webForm, ["bank_account", "category", "summa", "recipient"])
		if (requiredFields) {
			stopSave()
			msgBox("require:" + requiredFields.join(","))
			return
		}

		def db = session.getCurrentDatabase()

		def operation = BankOperation.of(doc)

		//
		int catId = webForm.getNumberValueSilently("subcategory", 0)
		if(catId == 0){
			catId = webForm.getNumberValueSilently("category", 0)
		}

		def catDoc = db.getGlossaryDocument(catId)

		if(catDoc.getDocumentForm() == "category"){
			operation.category = catId
			operation.subCategory = 0
		} else if(catDoc.getDocumentForm() == "subcategory") {
			operation.category = catDoc.getParentDocID()
			operation.subCategory = catId
		} else {
			msgBox("not category, invalid docid = " + catId + ", form: " + catDoc.getDocumentForm())
			stopSave()
			return
		}

		if(catDoc.getValueString("requirecostcenter") == "1"){
			if(webForm.getNumberValueSilently("costcenter", 0) < 1){
				msgBox("require:costcenter")
				stopSave()
				return
			}
		}

		operation.sum = webForm.getValue("summa").replaceAll(" ", "").toBigDecimal()
		def viewNumberVal = operation.sum

		//
		def opType = catDoc.getValueString("typeoperation")
		if (opType == "out") {
			viewNumberVal = 0 - operation.sum
		} else if (opType == "transfer" || opType == "calcstaff") {
			viewNumberVal = 0 - operation.sum
		}

		operation.addFile(webForm)
		operation.bankAccount = webForm.getValue("bank_account")
		operation.date = _Helper.convertStringToDate(webForm.getValue("date"))
		operation.recipient = webForm.getNumberValueSilently("recipient", 0)
		operation.costCenter = webForm.getNumberValueSilently("costcenter", 0)
		operation.basis = webForm.getValue("basis")
		operation.requisites = webForm.getValue("requisites")
		operation.documented = webForm.getNumberValueSilently("documented", 0)

		if (doc.isNewDoc){
			operation.vn = String.valueOf(db.getRegNumber(doc.getDocumentForm()))
		}

		//
		doc.clearReaders()
		doc.addEditor(doc.getAuthorID())
		// add bank_account observers
		def bankAccountDoc = db.getGlossaryDocument("bank_account", "ddbid='" + operation.bankAccount + "'")
		def bankAccountObservers = bankAccountDoc.getValueList("observers")
		for(String userId : bankAccountObservers){
			doc.addReader(userId)
		}

		def costCenterName = ""
		def costCenterDoc = db.getGlossaryDocument(operation.costCenter)
		if(costCenterDoc != null){
			costCenterName = costCenterDoc.getName()
		}

		def basis = ""
		if (operation.basis.length() > 0){
			basis = "; " + operation.basis
		}

		doc.setViewText("№ " + operation.vn + " - " + _Helper.getDateAsString(operation.date) +
				" -> " + catDoc.getName() + basis)
		doc.addViewText(bankAccountDoc.getName())
		doc.addViewText(catDoc.getID())
		doc.addViewText(opType)
		doc.addViewText(costCenterName)
		doc.addViewText(operation.requisites)
		doc.setViewNumber(viewNumberVal)
		doc.setViewDate(operation.date)

		session.setFlash(doc)
		setRedirectURL(session.getURLOfLastPage())
	}
}
