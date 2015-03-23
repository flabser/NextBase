package bankfinance.form.bank_account

import bankfinance.form.FormUtil
import kz.nextbase.script._Document
import kz.nextbase.script._Session
import kz.nextbase.script._WebFormData
import kz.nextbase.script.events._FormQuerySave


class QuerySave extends _FormQuerySave {

	@Override
	public void doQuerySave(_Session session, _Document doc, _WebFormData webForm, String lang) {

		def requiredFields = FormUtil.validate(webForm, ["name"])
		if (requiredFields) {
			stopSave()
			msgBox("require:" + requiredFields.join(","))
			return
		}

		def db = session.getCurrentDatabase()
		def viewNumberVal

		doc.setForm("bank_account")
		doc.addStringField("name", webForm.getValue("name"))

		def valueOfControl
		if(webForm.containsField("value_of_control") && webForm.getValue("value_of_control").length() > 0){
			valueOfControl = webForm.getValue("value_of_control").replaceAll(" ", "")
		} else {
			valueOfControl = "0"
		}
		doc.addStringField("value_of_control", valueOfControl)

		def observers = webForm.getListOfValuesSilently("observers")
		if(observers){
			doc.setValueString("observers", "")
			for(def observer : observers){
				doc.addValueToList("observers", observer)
			}
		}

		doc.setViewText(doc.getValueString("name"))
		doc.addViewText(doc.getValueList("observers")?.join(", "))
		doc.setViewNumber(Integer.parseInt(valueOfControl))

		setRedirectURL(session.getURLOfLastPage())
	}
}
