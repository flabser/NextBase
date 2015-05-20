package projects.form.projectdoc

import kz.nextbase.script._Document;
import kz.nextbase.script._Session;
import kz.nextbase.script._WebFormData;
import kz.nextbase.script.events._FormQuerySave;
import kz.nextbase.script.*;

class QuerySave extends _FormQuerySave {
	
	 
	def validate(_WebFormData webFormData){
		
		if (webFormData.getValueSilently("title") == ""){
			localizedMsgBox("Поле \"Тема\" не заполнено.");
			return false;
		} 
		if (webFormData.getValueSilently('title').length() > 2046){
			localizedMsgBox('Поле \'Тема\' содержит значение превышающее 2046 символов');
			return false;
		}
		if (webFormData.getValueSilently('content').length() > 2046){
			localizedMsgBox('Поле \'Содержание\' содержит значение превышающее 2046 символов');
			return false;
		}
		if (webFormData.getValueSilently("readers") == ""){
			localizedMsgBox("Поле \"Читатели\" не выбрано.");
			return false;
		} 
		if (webFormData.getValueSilently("editors") == ""){
			localizedMsgBox("Поле \"Редакторы\" не выбрано.");
			return false;
		} 
		
		return true;
	}

	@Override
	public void doQuerySave(_Session ses, _Document doc, _WebFormData webFormData, String lang) {
			
			boolean v = validate(webFormData);
			if(v == false){
				stopSave()
				return;
			} 
			doc.form = "projectDoc"
			doc.setViewText(webFormData.getValueSilently("title"))
			doc.addStringField("docauthor", webFormData.getValueSilently("docauthor"));
			Date tDate = null
			String docdate = webFormData.getValueSilently("docdate")
			if(docdate != "")
				tDate = _Helper.convertStringToDate(docdate)
			doc.addDateField("docdate", tDate);
			doc.addFile("rtfcontent", webFormData);
			doc.addStringField("title", webFormData.getValueSilently("title"))
			doc.addStringField("editors", "")
			def editors = webFormData.getListOfValuesSilently("editors")
			for (String editor: editors) {
				doc.addValueToList("editors",editor)
			}
			doc.addStringField("readers", "");
			def readers = webFormData.getListOfValuesSilently("readers")
			for (String reader: readers) {
				doc.addValueToList("readers",reader)
			}
			
			doc.addStringField("content", webFormData.getValueSilently("content"))
			
			doc.clearReaders();
			doc.clearEditors();
			
			String author = webFormData.getValueSilently("docauthor")
			doc.addEditor(author);
			doc.addReader(author);
			
			for (String reader: readers) {
				doc.addReader(reader);
			}
			for (String editor: editors) {
				doc.addEditor(editor);
			}
			//doc.addFile("rtfcontent", webFormData);
			def returnURL = ses.getURLOfLastPage()
			if(doc.isNewDoc){
				doc.addStringField("mailnotification", "")
				returnURL.changeParameter("page", "0")
			}else{
				doc.addStringField("mailnotification", "sent")
			}
			setRedirectURL(returnURL)
	}
}
