package form.supplier

import java.text.SimpleDateFormat
import java.util.Map
import kz.nextbase.script.*
import kz.nextbase.script.events._FormQuerySave
class QuerySave extends _FormQuerySave {

	@Override
	public void doQuerySave(_Session session, _Document doc, _WebFormData webFormData, String lang) {
		
		println(webFormData)
		
		boolean v = validate(webFormData);
		if(v == false){
			stopSave()
			return;
		}
		
		def glos = (_Glossary)doc;
		glos.setForm("supplier")
		glos.setName(webFormData.getValue("name"))
		glos.setValueString("address", webFormData.getValue("address"))
		glos.setValueString("phone", webFormData.getValue("phone"))

		glos.setViewText(glos.getName())
		glos.addViewText( webFormData.getValue("address"))
		glos.addViewText( webFormData.getValue("phone"))
		def returnURL = session.getURLOfLastPage()
		if (doc.isNewDoc) {
			returnURL.changeParameter("page", "0");
		}
		setRedirectURL(returnURL)
	}

	def validate(_WebFormData webFormData){

		if (webFormData.getValueSilently("name") == ""){
			localizedMsgBox("Поле \"Наименование\" не заполнено")
			return false
		}else if (webFormData.getValueSilently("address") == ""){
			localizedMsgBox("Поле \"Адрес\" не заполнено")
			return false
		}else if (webFormData.getValueSilently("phone") == ""){
			localizedMsgBox("Поле \"Телефон\" не заполнено")
			return false
		}

		return true;
	}
}
