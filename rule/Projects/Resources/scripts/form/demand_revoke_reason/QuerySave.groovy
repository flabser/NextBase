package form.demand_revoke_reason

import java.text.SimpleDateFormat
import java.util.Map
import kz.nextbase.script.*
import kz.nextbase.script._Glossary
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
		glos.setForm("demand_revoke_reason")
		glos.setName(webFormData.getValue("name"))
		
		glos.setAuthor(ses.currentUserID);
		glos.setViewText(glos.getName()) 
		
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
		if (webFormData.getValueSilently('name').length() > 2046){
			localizedMsgBox('Поле \'Название\' содержит значение превышающее 2046 символов');
			return false;
		}

		return true;
	}
}
