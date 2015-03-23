package form.outputproduction

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
		
		doc.setForm("outputproduction")
		doc.setValueString("product", webFormData.getValue("product"))
		doc.setValueString("count", webFormData.getValue("count"))
		doc.setValueString("date", webFormData.getValue("date"))
		doc.setViewText(session.dataBase.getGlossaryCustomFieldValueByID(webFormData.getValue("product").toInteger(), "name") +" " + webFormData.getValue("date")+" : "+ webFormData.getValue("count"));
		doc.addViewText(session.dataBase.getGlossaryCustomFieldValueByID(webFormData.getValue("product").toInteger(), "name"))
		doc.addViewText(webFormData.getValue("date"))
		doc.addViewText(webFormData.getValue("count"))
		//glos.addViewText( webFormData.getValue("ednorm"))
		def returnURL = session.getURLOfLastPage()
		if (doc.isNewDoc) {
			returnURL.changeParameter("page", "0");
		}
		setRedirectURL(returnURL)
	}

	def validate(_WebFormData webFormData){

		if (webFormData.getValueSilently("product") == ""){
			localizedMsgBox("Поле \"Тип продукции\" не заполнено")
			return false
		}else if (webFormData.getValueSilently("count") == ""){
			localizedMsgBox("Поле \"Количество\" не заполнено")
			return false
		}else if (webFormData.getValueSilently("date") == ""){
			localizedMsgBox("Поле \"Дата производства\" не заполнено")
			return false
		}

		return true;
	}
}
