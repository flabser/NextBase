package form.post

import java.text.SimpleDateFormat
import java.util.Map
import kz.nextbase.script.*
import kz.nextbase.script.events._FormQuerySave
class QuerySaveProjects extends _FormQuerySave {

	@Override
	public void doQuerySave(_Session ses, _Document doc, _WebFormData webFormData, String lang) {
		
		println(webFormData)
		
		boolean v = validate(webFormData);
		if(v == false){
			stopSave()
			return;
		}
		
		def glos = (_Glossary)doc;
		glos.setForm("post")
		glos.setName(webFormData.getValue("name"))
		glos.setCode(webFormData.getValue("code"))
		glos.setRankText(webFormData.getValue("ranktext"))
		
		glos.setViewText(glos.getName())
		glos.addViewText(glos.getCode())
		setRedirectPage("post")
	}

	def validate(_WebFormData webFormData){

		if (webFormData.getValueSilently("name") == ""){
			localizedMsgBox("Поле \"Должность\" не заполнено")
			return false
		}else if (webFormData.getValueSilently("code") == ""){
			localizedMsgBox("Поле \"Код\" не заполнено")
			return false
		}else if (webFormData.getValueSilently("ranktext") == ""){
			localizedMsgBox("Поле \"Ранг\" не заполнено")
			return false
		}

		return true;
	}
}
