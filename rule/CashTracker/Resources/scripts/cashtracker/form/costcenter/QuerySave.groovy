package cashtracker.form.costcenter

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

		doc.setForm("costcenter")
		doc.addStringField("name", webFormData.getValue("name"))
		doc.addStringField("bank_account", webFormData.getValue("bank_account"))

		doc.setViewText(webFormData.getValue("name"))

		setRedirectURL(session.getURLOfLastPage())
	}

	def validate(_WebFormData webFormData){
		if(webFormData.getValueSilently("name") == ""){
			localizedMsgBox("Поле 'Наименование' не заполнено")
			return false
		}

		return true
	}
}
