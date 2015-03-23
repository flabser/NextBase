package cashtracker.form.accrual

import kz.nextbase.script.*
import kz.nextbase.script.events.*


class QuerySave extends _FormQuerySave {

	@Override
	public void doQuerySave(_Session session, _Document doc, _WebFormData webFormData, String lang) {

		boolean v = validate(webFormData)
		if(v == false){
			stopSave()
			return
		}

		def db = session.getCurrentDatabase()

		doc.setForm("accrual")
		doc.addStringField("author", session.getCurrentUserID())
		doc.addNumberField("typeoperationstaff", webFormData.getValue("typeoperationstaff"))
		doc.addStringField("month", webFormData.getValue("month"))
		doc.addNumberField("year", webFormData.getValue("year"))
		doc.addStringField("personal", webFormData.getValue("personal"))
		def sum = webFormData.getNumberValueSilently("summa", 0)
		doc.addNumberField("summa", sum)

		if (doc.isNewDoc){
			doc.addDateField("date", _Helper.convertStringToDate(webFormData.getValue("date")))
			doc.addStringField("vn", String.valueOf(db.getRegNumber('accrual')))
		}

		doc.setViewText("№ " + doc.getValueString('vn') + " " + doc.getValueString('date') + " " + session.getStructure().getUser(doc.getValueString('personal')).getShortName())
		doc.setViewDate(doc.getValueDate("date"))
		doc.setViewNumber(sum)
		doc.addViewText(session.getCurrentDatabase().getGlossaryCustomFieldValueByDOCID(doc.getValueString('typeoperationstaff').toInteger(), "name"))

		setRedirectURL(session.getURLOfLastPage())
	}

	def validate(_WebFormData webFormData){
		if (webFormData.getValueSilently("typeoperationstaff") == ""){
			localizedMsgBox("Поле \"Тип операции\" не заполнено.")
			return false
		}else if (webFormData.getValueSilently("summa") == ""){
			localizedMsgBox("Поле \"Сумма\" не заполнено.")
			return false
		}
		return true
	}
}
