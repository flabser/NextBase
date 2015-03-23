package forum.form.comment
import java.util.Date;

import kz.nextbase.script._Document
import kz.nextbase.script._Helper
import kz.nextbase.script._Session
import kz.nextbase.script._WebFormData
import kz.nextbase.script.events._FormQuerySave
import kz.nextbase.script.task._Control

class QuerySave extends _FormQuerySave{

	def validate(_WebFormData webFormData){

		if (webFormData.getValueSilently("contentsource") == ""){
			localizedMsgBox("Поле \"Содержание\" не заполнено.")
			return false;
		}
		
		return true;
	}

	@Override
	public void doQuerySave(_Session ses, _Document doc, _WebFormData webFormData, String lang) {
        println("comment")
		println(webFormData)

		boolean v = validate(webFormData)
		if(v == false){
			stopSave()
			return;
		}
		
		doc.setForm("comment")
		//Date tDate = null
		
		//doc.addDateField("topicdate", new Date())
		
		doc.addStringField("contentsource", webFormData.getValueSilently("contentsource"))
		

		String author = ses.getCurrentUserID()
		doc.addNumberField("status", 0);
		doc.addNumberField("citationindex", 0);
		doc.addNumberField("shared", 0);
		doc.addDateField("postdate", new Date());

		doc.addStringField("author", author)
		//doc.addReader(webFormData.getValueSilently("executer"))
		
		//def pdoc = doc;
	
		doc.setViewText(webFormData.getValueSilently("contentsource"))//0
		doc.addViewText(webFormData.getValueSilently("postdate"))//1
		doc.setViewNumber(1)
		doc.setViewDate(new Date())

        try{
            def pdoc = ses.getCurrentDatabase().getDocumentByComplexID(webFormData.getValueSilently("parentdoctype").toInteger(), webFormData.getValueSilently("parentdocid").toInteger());
            println(pdoc.getDocumentForm());
            doc.addReaders(pdoc.getReaders());
        }catch(Exception e){}

		//setRedirectURL(redirectURL)
		//ses.setFlash(doc)
	}
}