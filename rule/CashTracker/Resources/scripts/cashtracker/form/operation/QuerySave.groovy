package cashtracker.form.operation

import kz.nextbase.script._Document
import kz.nextbase.script._Helper
import kz.nextbase.script._Session
import kz.nextbase.script._WebFormData
import kz.nextbase.script.events._FormQuerySave
import cashtracker.page.saldo.SaldoUtils


class QuerySave extends _FormQuerySave {

	@Override
	public void doQuerySave(_Session session, _Document doc, _WebFormData webFormData, String lang) {

		if(validate(webFormData) == false){
			stopSave()
			return
		}

		def db = session.getCurrentDatabase()
		def addInfo = ""

		doc.setForm("operation")

		//
		int catId = webFormData.getNumberValueSilently("subcategory", 0)
		if(catId == 0){
			catId = webFormData.getNumberValueSilently("category", 0)
		}
		def catDoc = db.getGlossaryDocument(catId)

		if(catDoc.getDocumentForm() == "category"){
			doc.addNumberField("category", catId)
			doc.addNumberField("subcategory", 0)
		} else if(catDoc.getDocumentForm() == "subcategory") {
			doc.addNumberField("category", catDoc.getParentDocID())
			doc.addNumberField("subcategory", catId)
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
		if (doc.isNewDoc){
			def gCashDoc = db.getGlossaryDocument('cash', "form = 'cash' and user = '" + session.getCurrentUserID() + "'")
			doc.addNumberField("cash", webFormData.getNumberValueSilently("cash", gCashDoc.getDocID()))
		}

		def sum = webFormData.getValueSilently("summa").replaceAll(" ", "").toInteger()
		doc.addNumberField("summa", sum)
		def viewNumberVal = sum

		//
		def opType = catDoc.getValueString("typeoperation")
		if (opType == "out" || opType == "calcstaff") {
			viewNumberVal = 0 - sum
		} else if(opType == "transfer") {
			int tc = webFormData.getNumberValueSilently("targetcash", 0)
			if(tc > 0){
				viewNumberVal = 0 - sum
				doc.addNumberField("targetcash", tc)
				def cashDoc = db.getGlossaryDocument(tc)
				if (cashDoc) {
					addInfo = " >> " + cashDoc.getName()
				}
			} else {
				localizedMsgBox("Целевая касса не выбрана")
				stopSave()
				return
			}
		} else if(opType == "withdraw") {
			viewNumberVal = 0 - sum
		}

		if(viewNumberVal < 0){
			def viewParam = session.createViewEntryCollectionParam()
					.setPageNum(0)
					.setPageSize(0)
					.setUseFilter(false)
					.setCheckResponse(false)
			def _saldo = SaldoUtils.getViewNumberTotal(db, viewParam.setQuery("form = 'operation'"))
			def saldoSum = _saldo[0].setScale(2, BigDecimal.ROUND_DOWN)
			def _sum = saldoSum.plus(viewNumberVal)
			if(_sum.signum() == -1){
				localizedMsgBox("Запрещено сохранение операции создающие отрицательный балланс: $_sum")
				stopSave()
				return
			}
		}
		//

		doc.addFile("rtfcontent", webFormData)
		doc.addNumberField("costcenter", webFormData.getNumberValueSilently("costcenter", 0))
		doc.addStringField("basis", webFormData.getValue("basis"))
		doc.addNumberField("documented", webFormData.getNumberValueSilently("documented", 0))
		doc.addDateField("date" , _Helper.convertStringToDate(webFormData.getValue("date")))

		if (doc.isNewDoc){
			doc.addStringField("vn", String.valueOf(db.getRegNumber(doc.getDocumentForm())))
		}

		//
		doc.clearReaders()
		doc.addEditor(doc.getAuthorID())
		// add cash observers
		def cashDoc = db.getGlossaryDocument(doc.getValueNumber("cash"))
		def cashObservers = cashDoc.getValueList("observers")
		for(String userId : cashObservers){
			doc.addReader(userId)
		}

		def costCenterName = ""
		def costCenterDoc = db.getGlossaryDocument(doc.getValueNumber("costcenter"))
		if(costCenterDoc != null){
			costCenterName = costCenterDoc.getName()
		}

		def basis = ""
		if (doc.getValueString("basis").length() > 0){
			basis = "; " + doc.getValueString("basis")
		}

		doc.setViewText("№ " + doc.getValueString("vn") + " - " + _Helper.getDateAsString(doc.getValueDate("date")) +
				" -> " + catDoc.getName() + basis + addInfo)
		doc.addViewText(cashDoc.getName())
		doc.addViewText(catDoc.getID())
		doc.addViewText(opType)
		doc.addViewText(costCenterName)
		doc.setViewNumber(viewNumberVal)
		doc.setViewDate(doc.getValueDate("date"))

		session.setFlash(doc)
		setRedirectURL(session.getURLOfLastPage())
	}

	def validate(_WebFormData webForm){
		if(webForm.getValueSilently("summa") == ""){
			localizedMsgBox("Поле 'Сумма' не заполнено")
			return false
		} else if(webForm.getValueSilently("category") == ""){
			localizedMsgBox("Поле 'Тип операции' не заполнено")
			return false
		}

		return true
	}
}
