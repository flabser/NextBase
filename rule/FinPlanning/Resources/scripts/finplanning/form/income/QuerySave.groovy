package finplanning.form.income

import kz.nextbase.script._Document
import kz.nextbase.script._Helper
import kz.nextbase.script._Session
import kz.nextbase.script._WebFormData
import kz.nextbase.script.events._FormQuerySave


class QuerySave extends _FormQuerySave {

	def repeatName = [
		"end-week" : "в конце недели",
		"end-month" : "в конце месяца",
		"end-quarter" : "в конце квартала",
		"end-year" : "в конце года" ]

	@Override
	public void doQuerySave(_Session session, _Document doc, _WebFormData webFormData, String lang) {

		if(validate(webFormData) == false){
			stopSave()
			return
		}

		def db = session.getCurrentDatabase()

		def operation = Income.of(doc)

		//
		int catId = webFormData.getNumberValueSilently("subcategory", 0)
		if(catId == 0){
			catId = webFormData.getNumberValueSilently("category", 0)
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
			if(webFormData.getNumberValueSilently("costcenter", 0) < 1){
				localizedMsgBox("Тип операции требует указания 'место возникновения'")
				stopSave()
				return
			}
		}

		if(catDoc.getValueString("requiredocument") == "1"){
			if((!doc.hasAttachment()) && webFormData.getValueSilently("filename").length() == 0){
				localizedMsgBox("Тип операции требует указания 'подтверждающего документа'")
				stopSave()
				return
			}
		} else if(webFormData.getNumberValueSilently("documented", 0) == 1) {
			if((!doc.hasAttachment()) && webFormData.getValueSilently("filename").length() == 0){
				localizedMsgBox("Не вложен документ подтверждения")
				stopSave()
				return
			}
		}

		//
		operation.sum = webFormData.getValue("summa").replaceAll(" ", "").toBigDecimal()
		def viewNumberVal = operation.sum

		//
		def addInfo = ""
		def categoryName = catDoc.getValueString("name")
		def opType = catDoc.getValueString("typeoperation")
		if (opType == "out" || opType == "calcstaff") {
			viewNumberVal = 0 - operation.sum
		} else if(opType == "transfer") {
			operation.targetCash = webFormData.getNumberValueSilently("targetcash", 0)
			if(operation.targetCash > 0){
				viewNumberVal = 0 - operation.sum
				def cashDoc = db.getGlossaryDocument(operation.targetCash)
				if (cashDoc) {
					addInfo = " >> " + cashDoc.getName()
				}
			} else {
				localizedMsgBox("Целевая касса не выбрана")
				stopSave()
				return
			}
		} else if(opType == "withdraw") {
			viewNumberVal = 0 - operation.sum
		}
		//

		operation.addFile(webFormData)
		operation.repeat = webFormData.getValueSilently("repeat")
		operation.recipient = webFormData.getNumberValueSilently("recipient", 0)
		operation.costCenter = webFormData.getNumberValueSilently("costcenter", 0)
		operation.basis = webFormData.getValue("basis")

		def dateStr
		if(operation.repeat == "once-only"){
			operation.date = _Helper.convertStringToDate(webFormData.getValue("date"))
			dateStr = _Helper.getDateAsString(operation.date)
		} else {
			operation.date = _Helper.convertStringToDate(webFormData.getValue("date"))
			/*if (doc.isNewDoc){
			 operation.date = new Date()
			 } else {
			 operation.date = doc.getRegDate()
			 }*/
			dateStr = " периодично: " + repeatName[operation.repeat]
		}

		if (doc.isNewDoc){
			operation.vn = String.valueOf(db.getRegNumber(doc.getDocumentForm()))
		}

		//
		doc.clearReaders()
		doc.addEditor(doc.getAuthorID())
		doc.addReader(doc.getAuthorID())

		def costCenterName = ""
		def costCenterDoc = db.getGlossaryDocument(operation.costCenter)
		if(costCenterDoc != null){
			costCenterName = costCenterDoc.getName()
		}

		def recipientName = ""
		if(operation.recipient > 0){
			def recipientDoc = db.getOrganization(operation.recipient)
			if(recipientDoc != null){
				recipientName = recipientDoc.getFullName()
			}
		}

		def basis = ""
		if (operation.basis.length() > 0){
			basis = "; " + operation.basis
		}

		doc.setViewText("№ " + operation.vn + " - " + dateStr + " -> " + catDoc.getName() + basis + addInfo)
		doc.addViewText(categoryName)
		doc.addViewText(catDoc.getID())
		doc.addViewText(opType)
		doc.addViewText(costCenterName)
		doc.addViewText(operation.repeat)
		doc.addViewText(recipientName)
		doc.setViewNumber(viewNumberVal)
		doc.setViewDate(operation.date)

		session.setFlash(doc)
		setRedirectURL(session.getURLOfLastPage())
	}

	def validate(_WebFormData webFormData){
		if(webFormData.getValueSilently("category") == ""){
			localizedMsgBox("Поле 'Тип операции' не заполнено")
			return false
		} else if(webFormData.getValueSilently("summa") == ""){
			localizedMsgBox("Поле 'Сумма' не заполнено")
			return false
		}

		return true
	}
}
