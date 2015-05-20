package projects.form.project

import kz.nextbase.script._Document;
import kz.nextbase.script._Session;
import kz.nextbase.script._WebFormData;
import kz.nextbase.script.events._FormQuerySave;
import kz.nextbase.script.*;

class QuerySave extends _FormQuerySave {
	
	 
	def validate(_WebFormData webFormData){
		
		if (webFormData.getValueSilently("project_name") == ""){
			localizedMsgBox("Поле \"Название проекта\" не заполнено.");
			return false;
		} 
		if (webFormData.getValueSilently('project_name').length() > 2046){
			localizedMsgBox('Поле \'Название проекта\' содержит значение превышающее 2046 символов');
			return false;
		}
		if (webFormData.getValueSilently("customer") == ""){
			localizedMsgBox("Поле \"Заказчик\" не выбрано.");
			return false;
		}
		if (webFormData.getValueSilently("manager") == ""){
			localizedMsgBox("Поле \"Ответственный менеджер\" не выбрано.");
			return false;
		}
		if (webFormData.getValueSilently("programmer") == ""){
			localizedMsgBox("Поле \"Ответственный программист\" не выбрано.");
			return false;
		}
		if (webFormData.getValueSilently("tester") == ""){
			localizedMsgBox("Поле \"Ответственный тестировщик\" не выбрано.");
			return false;
		}
		if (webFormData.getValueSilently("percentage_of_completion") == ""){
			localizedMsgBox("Поле \"Процент исполнения\" не заполнено.");
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
		if(webFormData.getValueSilently("link_to_poligon") != ""){
			if(_Validator.checkURL(webFormData.getValueSilently("link_to_poligon")) == false){
				localizedMsgBox("Введена неверная ссылка на полигон");
				return false;
			}				
		}
		if (webFormData.getValueSilently('link_to_poligon').length() > 2046){
			localizedMsgBox('Поле \'Ссылка на полигон\' содержит значение превышающее 2046 символов');
			return false;
		}
		if (webFormData.getValueSilently('comment_to_poligon').length() > 2046){
			localizedMsgBox('Поле \'Комментарий\' содержит значение превышающее 2046 символов');
			return false;
		}
		
		return true;
	}

	@Override
	public void doQuerySave(_Session ses, _Document doc, _WebFormData webFormData, String lang) {

        println("Save Project");
        boolean v = validate(webFormData);
        if(v == false){
            stopSave()
            return;
        }

        doc.setForm("project")
        doc.setViewText(webFormData.getValueSilently("project_name"));
        doc.addStringField("docauthor", ses.getCurrentUserID());

        Date tDate = null;
        String docdate = webFormData.getValueSilently("docdate");
        if(docdate != "")
            tDate = _Helper.convertStringToDate(docdate);
        doc.addDateField("docdate", tDate);

        doc.addStringField("project_name", webFormData.getValueSilently("project_name"));
        doc.addStringField("customer", webFormData.getValueSilently("customer"));
        doc.addStringField("customer_emp", "");
        webFormData.getListOfValuesSilently("customer_emp").each {
            doc.addValueToList("customer_emp", it);
        }
        doc.addStringField("manager", webFormData.getValueSilently("manager"));
        doc.addStringField("programmer", webFormData.getValueSilently("programmer"));
        doc.addStringField("tester", webFormData.getValueSilently("tester"));
        doc.addStringField("observer", "");
        def observers = webFormData.getListOfValuesSilently("observer")
        for (String observer: observers) {
            doc.addValueToList("observer",observer);
        }
        doc.addNumberField("status", webFormData.getNumberValueSilently("status", 0))
        doc.addStringField("percentage_of_completion", webFormData.getValueSilently("percentage_of_completion"));
        String startdate = webFormData.getValueSilently("startdate");
        if(startdate != "")
            tDate = _Helper.convertStringToDate(startdate);
        doc.addDateField("startdate", tDate);

        String duedate = webFormData.getValueSilently("duedate");
        if(duedate != "")
            tDate = _Helper.convertStringToDate(duedate);
            doc.setViewDate(tDate);

        doc.addDateField("duedate", tDate);
        doc.addStringField("link_to_poligon", webFormData.getValueSilently("link_to_poligon"))
        doc.addStringField("comment_to_poligon", webFormData.getValueSilently("comment_to_poligon"))

        String author = ses.getCurrentUserID();
        String customer = webFormData.getValueSilently("customer");
        if(author != customer)
            doc.addReader(customer);

        String manager = webFormData.getValueSilently("manager");
        doc.addEditor(author);
        doc.addReader(author);
        doc.addReader(author);
        doc.addReader("[project_viewer]");
        if(author != manager)
            doc.addReader(manager);

        for (String observer: observers) {
            doc.addReader(observer);
        }
        doc.addReader(webFormData.getValueSilently("tester"));
        doc.addReader(webFormData.getValueSilently("programmer"));
        webFormData.getListOfValuesSilently("customer_emp").each {
            doc.addReader(it);
        }

        doc.addViewText(webFormData.getValueSilently("tester"));
        doc.addViewText(webFormData.getValueSilently("programmer"));
        doc.addViewText(webFormData.getValueSilently("manager"));

        //doc.addFile("rtfcontent", webFormData);
        def returnURL = ses.getURLOfLastPage()
        if(doc.isNewDoc){
            doc.addStringField("mailnotification", "");
            returnURL.changeParameter("page", "0");
        }else{
            doc.addStringField("mailnotification", "sent");
        }
        setRedirectURL(returnURL)
	}
}
