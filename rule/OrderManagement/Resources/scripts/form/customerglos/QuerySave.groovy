package form.customerglos

import kz.nextbase.script._Document
import kz.nextbase.script._Glossary
import kz.nextbase.script._Session
import kz.nextbase.script._WebFormData
import kz.nextbase.script.events._FormQuerySave

class QuerySave extends _FormQuerySave {

	@Override
	public void doQuerySave(_Session ses, _Document doc, _WebFormData webFormData, String lang) {
		
		println(webFormData)
		
		boolean v = validate(webFormData);
		if(v == false){
			stopSave()
			return;
		}
		
		def glos = (_Glossary)doc;
		glos.setForm("customer")
		glos.setName(webFormData.getValue("name"))
		glos.setCode(webFormData.getValueSilently("bin"));

		glos.setViewText(glos.getName())
		glos.setViewNumber(glos.getCode().toBigDecimal())

		def returnURL = ses.getURLOfLastPage()
		if (doc.isNewDoc) {
			returnURL.changeParameter("page", "0");
		}
		setRedirectURL(returnURL)
	}

	def validate(_WebFormData webFormData){

		if (webFormData.getValueSilently("name") == ""){
			localizedMsgBox("Поле \"Название\" не заполнено")
			return false
		}
        if (webFormData.getValueSilently("bin") == ""){
            localizedMsgBox("Поле \"БИН\" не заполнено")
            return false
        }
		return true;
	}
}
