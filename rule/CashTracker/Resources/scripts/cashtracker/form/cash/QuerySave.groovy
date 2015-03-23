package cashtracker.form.cash

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
		def viewNumberVal

		doc.setForm("cash")

		doc.addStringField("name", webFormData.getValue("name"))
		doc.addStringField("user", webFormData.getValueSilently("user"))

		def amountControl
		if(webFormData.getValueSilently("amountcontrol").length() > 0) {
			amountControl = webFormData.getValueSilently("amountcontrol").replaceAll(" ", "")
		} else {
			amountControl = "0"
		}
		doc.addStringField("amountcontrol", amountControl)

		def observers = webFormData.getListOfValuesSilently("observers")
		if(observers){
			doc.setValueString("observers", "")
			for(def observer : observers){
				doc.addValueToList("observers", observer)
			}
		}

		doc.setViewText(doc.getValueString("name"))
		doc.addViewText(doc.getValueString("user"))
		doc.addViewText(doc.getValueList("observers")?.join(", "))
		doc.setViewNumber(Integer.parseInt(amountControl))

		setRedirectURL(session.getURLOfLastPage())
	}

	def validate(_WebFormData webFormData){
		if(webFormData.getValueSilently("name") == ""){
			localizedMsgBox("Поле 'Касса' не заполнено")
			return false
		}

		return true
	}
}
