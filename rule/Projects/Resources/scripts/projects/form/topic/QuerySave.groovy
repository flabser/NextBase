package projects.form.topic

import kz.nextbase.script._Document
import kz.nextbase.script._Session
import kz.nextbase.script._WebFormData
import kz.nextbase.script.events._FormQuerySave

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
		//Date tDate = null
		
		//doc.addDateField("topicdate", new Date())
		
		doc.addStringField("theme", webFormData.getValueSilently("theme"))
		

		String author = ses.getCurrentUserID()
		doc.addNumberField("status", 0);
		doc.addNumberField("citationindex", 0);
		doc.addNumberField("shared", 0);
		doc.addStringField("contentsource", "");
		doc.addDateField("topicdate", new Date());

		doc.addStringField("author", author)
		def authorShortName = ses.getStructure().getEmployer(author).getShortName()

		//def pdoc = doc;
	
		doc.setViewText(webFormData.getValueSilently("theme"))//0
		doc.addViewText(webFormData.getValueSilently("topicdate"))//1
		doc.addViewText(authorShortName)//2
		doc.setViewNumber(1)
		doc.setViewDate(new Date())
	
		//setRedirectURL(redirectURL)
		//ses.setFlash(doc)
       try{
            def pdoc = ses.getCurrentDatabase().getDocumentByComplexID(webFormData.getValueSilently("parentdoctype").toInteger(), webFormData.getValueSilently("parentdocid").toInteger());
            doc.addReaders(pdoc.getReaders());
       }catch(Exception e){}
	}
}