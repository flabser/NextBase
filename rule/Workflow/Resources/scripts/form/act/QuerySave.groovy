package form.act
import kz.nextbase.script._Document
import kz.nextbase.script._Helper
import kz.nextbase.script._Session
import kz.nextbase.script._WebFormData
import kz.nextbase.script.events._FormQuerySave

class QuerySave extends _FormQuerySave {

	@Override
	public void doQuerySave(_Session session, _Document doc, _WebFormData webFormData, String lang) {

		println(webFormData)
		
		boolean v = validate(webFormData)
		if(v == false){
			stopSave()
			return
		}

		doc.setForm("act");
		doc.addStringField("totalamount", webFormData.getValueSilently("totalamount"))
		doc.addStringField("startexecperiod", webFormData.getValueSilently("startexecperiod"))
		doc.addStringField("endexecperiod", webFormData.getValueSilently("endexecperiod"))
		doc.addStringField("numinvoice", webFormData.getValueSilently("numinvoice"))
		doc.addStringField("responsible", webFormData.getValueSilently("responsible"))
		doc.addStringField("vn", webFormData.getValueSilently("vn"))
		String dvn = webFormData.getValueSilently("dvn")
		if(dvn != "") doc.addDateField("dvn", _Helper.convertStringToDate(dvn))

		doc.addStringField("briefcontent", webFormData.getValueSilently("briefcontent"))
		doc.addStringField("author", webFormData.getValue("author"))
		doc.addFile("rtfcontent", webFormData)
		doc.setRichText("contentsource", webFormData.getValue("contentsource"))
		def pdoc = doc.getParentDocument()
		if (pdoc){
			doc.addNumberField("parentdocid", pdoc.getDocID())
			doc.addNumberField("parentdoctype", pdoc.docType)
			pdoc.addReader(doc.getValueString("responsible"));
			pdoc.save("[supervisor]");
		}
		def returnURL = session.getURLOfLastPage()
        Date tDate = new Date()
        if (doc.isNewDoc || !doc.getValueString("vn")){
            def db = session.getCurrentDatabase()
            int num = db.getRegNumber('act')
            String vnAsText = Integer.toString(num)
            doc.addStringField("mailnotification", "")
            doc.replaceStringField("vn", vnAsText)
            doc.replaceIntField("vnnumber",num)
            doc.replaceDateField("dvn", new Date())
			localizedMsgBox(getLocalizedWord("Документ зарегистрирован под № ",lang) + vnAsText)
			returnURL.changeParameter("page", "0");
		}

        doc.setViewText(getLocalizedWord('Акт',lang) +' № '+ doc.getValueString('vnnumber') + '  ' + getLocalizedWord('от',lang) + ' ' + tDate.format("dd.MM.yyyy HH:mm:ss") + ' '+ session.getStructure().getEmployer(doc.getValueString('author')).shortName)
        doc.addViewText(doc.getValueString('contentsource'))
        doc.addViewText(doc.getValueString("vn"))
		doc.setViewNumber(doc.getValueNumber("vnnumber"))
		doc.setViewDate(doc.getValueDate("dvn"))
		setRedirectURL(returnURL)
	}

	def validate(_WebFormData webFormData){
		if (webFormData.getValueSilently("contractor_one") == ""){
			localizedMsgBox("Поле \"Заказчик\" не заполнено.")
			return false
		}
		if (webFormData.getValueSilently("contractor_two") == ""){
			localizedMsgBox("Поле \"Исполнитель\" не заполнено.")
			return false
		}
		if (webFormData.getValueSilently("responsible") == ""){
			localizedMsgBox("Поле \"Ответственный\" не заполнено.")
			return false
		}
		if (webFormData.getValueSilently("numinvoice") == ""){
			localizedMsgBox("Поле \"№ счет-фактуры\" не заполнено.")
			return false
		}
		if (webFormData.getValueSilently("startexecperiod") == ""){
			localizedMsgBox("Поле \"Период оказания услуг\" не заполнено.")
			return false
		}
		if (webFormData.getValueSilently("endexecperiod") == ""){
			localizedMsgBox("Поле \"Период оказания услуг\" не заполнено.")
			return false
		}
		return true
	}
}
