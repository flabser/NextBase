package cashtracker.form.category

import kz.nextbase.script._Document
import kz.nextbase.script._Session
import kz.nextbase.script._WebFormData
import kz.nextbase.script.events._FormQuerySave


class QuerySave extends _FormQuerySave {

	@Override
	public void doQuerySave(_Session session, _Document doc, _WebFormData webFormData, String lang) {

		if(validate(webFormData) == false){
			stopSave()
			return
		}

		def db = session.getCurrentDatabase()
		def _typeoperation = ""
		def typeoperation = webFormData.getValue("typeoperation")

		doc.setForm("category")
		doc.addStringField("author", session.getCurrentUserID())
		doc.addStringField("name", webFormData.getValue("name"))

		doc.addStringField("category_refers_to", "")
		webFormData.getListOfValuesSilently("category_refers_to").each {
			doc.addValueToList("category_refers_to", it)
		}

		doc.addStringField("typeoperation", typeoperation)
		doc.addStringField("disable_selection", webFormData.getValueSilently("disable_selection"))
		doc.addStringField("by_formula", webFormData.getValueSilently("by_formula"))
		doc.addStringField("formula", webFormData.getValueSilently("formula"))
		doc.addStringField("requiredocument", webFormData.getValueSilently("requiredocument"))
		doc.addStringField("requirecostcenter", webFormData.getValueSilently("requirecostcenter"))
		doc.addStringField("accessroles", webFormData.getValue("accessroles"))
		doc.addStringField("comment", webFormData.getValue("comment"))

		if(typeoperation.equals("in")){
			_typeoperation = "Приход"
		} else if(typeoperation.equals("out")){
			_typeoperation = "Расход"
		} else if(typeoperation.equals("transfer")){
			_typeoperation = "Перевод"
		} else if(typeoperation.equals("calcstaff")){
			_typeoperation = "Расчет с персоналом"
		} else {
			_typeoperation = typeoperation
		}

		doc.setViewText(webFormData.getValue("name"))
		doc.addViewText(_typeoperation)
		doc.addViewText(typeoperation)
		doc.addViewText(doc.getValueString("category_refers_to"))
		doc.addViewText(doc.getValueString("requiredocument"))
		doc.addViewText(doc.getValueString("requirecostcenter"))
		doc.addViewText(doc.getValueString("disable_selection"))

		setRedirectURL(session.getURLOfLastPage())
	}

	def validate(_WebFormData webForm){
		if(webForm.getValueSilently("name") == ""){
			localizedMsgBox("Поле 'Наименование' не заполнено")
			return false
		} else if(webForm.getValueSilently("typeoperation") == ""){
			localizedMsgBox("Поле 'Тип операции' не заполнено")
			return false
		} else if(webForm.getValueSilently("by_formula") == "1" && webForm.getValueSilently("formula") == ""){
			localizedMsgBox("Поле 'формула' не заполнено")
			return false
		}

		return true
	}
}
