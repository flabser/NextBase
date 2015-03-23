package form.milestone

import java.util.Map;

import kz.nextbase.script._Document;
import kz.nextbase.script._Session;
import kz.nextbase.script._WebFormData;
import kz.nextbase.script.events._FormQuerySave;
import kz.nextbase.script._Helper;

class QuerySave extends _FormQuerySave {

	def validate(_WebFormData webFormData){ 
		
		if (webFormData.getValueSilently("description") == ""){
			localizedMsgBox("Поле \"Описание\" не заполнено.");
			return false;
		}
		if (webFormData.getValueSilently("startdate") == ""){
			localizedMsgBox("Поле \"Дата начала\" не указано.");
			return false;
		}
		if (webFormData.getValueSilently("duedate") == ""){
			localizedMsgBox("Поле \"Дата завершения\" не указано.");
			return false;
		}
		if (webFormData.getValueSilently('description').length() > 2046){
			localizedMsgBox('Поле \'Описание\' содержит значение превышающее 2046 символов');
			return false;
		}
		return true;
	}

	@Override
	public void doQuerySave(_Session ses, _Document doc, _WebFormData webFormData, String lang) {

			//println(webFormData);
			
			boolean v = validate(webFormData);
			if(v == false){
				stopSave()
				return;
			}
			
			doc.setForm("milestone")
						
			doc.addStringField("percentage_of_completion", webFormData.getValueSilently("percentage_of_completion"))
			doc.addStringField("description", webFormData.getValueSilently("description"))
			String author = webFormData.getValueSilently("docauthor")
			doc.addStringField("docauthor", author)
			
			// Позиция - Текущая
			String current =  webFormData.getValueSilently("current")
			doc.addStringField("current", current);
						
			Date tDate = null
			String startdate = webFormData.getValueSilently("startdate")
			if(startdate != "")
				tDate = _Helper.convertStringToDate(startdate)
			doc.addDateField("startdate", tDate)
			
			String duedate = webFormData.getValueSilently("duedate")
			if(duedate != "")
				tDate = _Helper.convertStringToDate(duedate)
			doc.addDateField("duedate", tDate);
			doc.setViewDate(tDate);
			// Сравниваем с датой оканчания проекта
			def pdoc = doc.getParentDocument();
			String spd = pdoc.getValueString("duedate");
			def pduedate = _Helper.convertStringToDate(spd);
			spd = spd.substring(0, 10)
			if(tDate.compareTo(pduedate) > 0){
				localizedMsgBox("Дата завершения вехи не должно быть позже даты завершения проекта ($spd)");
				stopSave();
				return;
			}
				
			String docdate = webFormData.getValueSilently("docdate");
			if(duedate != "")
				tDate = _Helper.convertStringToDate(docdate);
			doc.addDateField("docdate", tDate);
			doc.addReader('[project_viewer]');
			def returnURL = ses.getURLOfLastPage()
			if(doc.isNewDoc){
				
				//Права на чтение даем всем ответств. лицам проекта
				doc.addEditor(author);
				doc.addReader(author);
				doc.addReader(pdoc.getValueString("manager"));
				doc.addReader(pdoc.getValueString("programmer"));
				doc.addReader(pdoc.getValueString("tester"));
				doc.addReader(pdoc.getValueString("docauthor"))
				doc.addStringField("mailnotification", "");
				returnURL.changeParameter("page", "0");
			}else{
				doc.addStringField("mailnotification", "sent")
			}
			
			doc.setViewText(webFormData.getValueSilently("description") + " : " + _Helper.getDateAsStringShort(doc.getValueDate("startdate")) + "-" + _Helper.getDateAsStringShort(doc.getValueDate("duedate")))
			setRedirectURL(returnURL)
	}
}

