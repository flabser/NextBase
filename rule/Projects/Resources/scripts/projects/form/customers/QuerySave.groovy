package projects.form.customers

import kz.nextbase.script.*
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
		glos.setForm("customers")
		glos.setName(webFormData.getValue("name"))
				
		glos.setViewText(glos.getName())
		/*glos.addViewText(glos.getCode())*/
		def returnURL = ses.getURLOfLastPage()
		if (doc.isNewDoc) {
			returnURL.changeParameter("page", "0");
		}
		setRedirectURL(returnURL)
	}

	def validate(_WebFormData webFormData){

		if (webFormData.getValueSilently("name") == ""){
			localizedMsgBox("Поле \"Заказчик\" не заполнено")
			return false
		}

		return true;
	}
}
