package forum.form.topic
import java.util.Date;

import kz.nextbase.script._Document
import kz.nextbase.script._Helper
import kz.nextbase.script._Session
import kz.nextbase.script._WebFormData
import kz.nextbase.script.events._FormQuerySave
import kz.nextbase.script.task._Control

class QuerySave extends _FormQuerySave{

	def validate(_WebFormData webFormData){

		if (webFormData.getValueSilently("theme") == ""){
			localizedMsgBox("Поле \"Тема\" не выбрано.")
			return false;
		}
		
		return true;
	}

	@Override
	public void doQuerySave(_Session ses, _Document doc, _WebFormData webFormData, String lang) {
        println("topic")
		println(webFormData)

		boolean v = validate(webFormData)
		if(v == false){
			stopSave()
			return;
		}
		
		doc.setForm("topic")
				doc.addStringField("theme", webFormData.getValueSilently("theme"))
		

		String author = ses.getCurrentUserID()
		doc.addNumberField("status", 0);
		doc.addNumberField("citationindex", 0);
		doc.addNumberField("shared", 0);
		//doc.addStringField("contentsource", "");
		//doc.addDateField("topicdate", new Date());

		doc.setViewText(webFormData.getValueSilently("theme"))//0
		doc.setViewNumber(1)
		doc.setViewDate(new Date())

       try{
            def pdoc = ses.getCurrentDatabase().getDocumentByComplexID(webFormData.getValueSilently("parentdoctype").toInteger(), webFormData.getValueSilently("parentdocid").toInteger());
            doc.addReaders(pdoc.getReaders());
       }catch(Exception e){}
	}
}