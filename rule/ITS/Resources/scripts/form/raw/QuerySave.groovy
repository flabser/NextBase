package form.raw

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
		glos.setForm("raw")
		glos.setName(webFormData.getValue("name"))
		glos.setValueString("norm", webFormData.getValue("norm"))
		glos.addGlossaryField("ednorm", webFormData.getValue("ednorm").toInteger())
		glos.addGlossaryField("supplier", webFormData.getValue("supplier").toInteger())

		glos.setViewText(glos.getName())
		glos.addViewText( webFormData.getValue("norm"))
		//glos.addViewText( webFormData.getValue("ednorm"))
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
		}else if (webFormData.getValueSilently("norm") == ""){
			localizedMsgBox("Поле \"Норма расхода на единицу продукции\" не заполнено")
			return false
		}else if (webFormData.getValueSilently("ednorm") == ""){
			localizedMsgBox("Поле \"Единица измерения нормы расхода\" не заполнено")
			return false
		}

		return true;
	}
}
