package cashtracker.form.glossary.simpleform

import kz.nextbase.script._Document
import kz.nextbase.script._Glossary
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

		def glos = (_Glossary) doc

		glos.setForm(webFormData.getValue("id"))
		glos.setName(webFormData.getValue("name"))

		int code = webFormData.getNumberValueSilently("code", -999)
		if(code != -999){
			glos.setCode(String.valueOf(code))
			glos.setViewNumber(code)
		}

		glos.setViewText(glos.getName())

		setRedirectURL(session.getURLOfLastPage())
	}

	def validate(_WebFormData webFormData){
		if(webFormData.getValueSilently("name") == ""){
			localizedMsgBox("Поле 'Название' не заполнено")
			return false
		}

		return true
	}
}
