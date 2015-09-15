package form.contract
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

		doc.setForm("contract");
		doc.addStringField("sign", webFormData.getValueSilently("sign"))
		doc.addStringField("signedfields", webFormData.getValueSilently("signedfields"))
		doc.addStringField("contracttime", webFormData.getValueSilently("contracttime"))
		doc.addStringField("controldate", webFormData.getValueSilently("controldate"))
		doc.addStringField("totalamount", webFormData.getValueSilently("totalamount"))
		doc.addStringField("numcontractor", webFormData.getValueSilently("numcontractor"))
		doc.addStringField("datecontractor", webFormData.getValueSilently("datecontractor"))
		doc.addStringField("kazcontent", webFormData.getValueSilently("kazcontent"))
		doc.addStringField("contractsubject", webFormData.getValueSilently("contractsubject"))
		doc.addStringField("comments", webFormData.getValueSilently("comments"))
		/*doc.addStringField("vn", webFormData.getValueSilently("vn"))*/
		String datecontractor = webFormData.getValueSilently("datecontractor")
		if(datecontractor != "") doc.addDateField("datecontractor", _Helper.convertStringToDate(datecontractor))
		doc.addNumberField("contractor_one", webFormData.getNumberValueSilently("contractor_one",0))
		doc.addNumberField("contractor_two", webFormData.getNumberValueSilently("contractor_two",0))
   		def contracttorname = session.getCurrentDatabase().getGlossaryDocument(webFormData.getNumberValueSilently("contractor_one",0)).getValueString("name")
   		def contracttortwoname = session.getCurrentDatabase().getGlossaryDocument(webFormData.getNumberValueSilently("contractor_two",0)).getValueString("name")
        doc.addStringField("curator", webFormData.getValueSilently("curator"));
		doc.addStringField("briefcontent", webFormData.getValueSilently("briefcontent"))
		doc.addStringField("contractsignedwith", webFormData.getValueSilently("contractsignedwith"))
		doc.addStringField("author", webFormData.getValue("author"))
		doc.addFile("rtfcontent", webFormData)
		doc.setRichText("contentsource", webFormData.getValue("contentsource"))

		doc.addReader(webFormData.getListOfValuesSilently("initemp") as HashSet<String>)
		def returnURL = session.getURLOfLastPage()
        Date tDate = new Date()
        if (doc.isNewDoc){
           def db = session.getCurrentDatabase()
           int num = db.getRegNumber('contract')
           String vnAsText = Integer.toString(num)

            doc.replaceStringField("vn", vnAsText)
            doc.replaceIntField("vnnumber",num)
            //doc.replaceDateField("dvn", new Date())
			doc.addStringField("mailnotification", "")
			localizedMsgBox(getLocalizedWord("Документ зарегистрирован под № ",lang) +  webFormData.getValueSilently("numcontractor"))
			returnURL.changeParameter("page", "0");
		}

        doc.setViewText(getLocalizedWord('Договор',lang) +' № '+ webFormData.getValueSilently("numcontractor") + '  ' + getLocalizedWord('от',lang) + ' ' + webFormData.getValueSilently("datecontractor") + ' '+ session.getStructure().getEmployer(doc.getValueString('author')).shortName)
        doc.addViewText(doc.getValueString('contentsource'))
        doc.addViewText("" + doc.getGlossaryValue("contractor", "docid#number=" + doc.getValueString("contractor"), "name"))
        doc.addViewText(webFormData.getValueSilently("numcontractor"))
        doc.addViewText(webFormData.getValueSilently("contractsubject"))
        doc.addViewText(contracttorname)
        doc.addViewText(contracttortwoname)
		doc.setViewNumber(doc.getValueNumber("vnnumber"))
		doc.setViewDate(doc.getValueDate("datecontractor"))
		setRedirectURL(returnURL)
	}

	def validate(_WebFormData webFormData){

		if (webFormData.getValueSilently("numcontractor") == ""){
			localizedMsgBox("Поле \"№ договора у контрагента\" не заполнено.")
			return false
		}
		if (webFormData.getValueSilently("datecontractor") == ""){
			localizedMsgBox("Поле \"Дата регистрации у контрагента\" не заполнено.")
			return false
		}
		if (webFormData.getValueSilently("contentsource") == ""){
			localizedMsgBox("Поле \"Cодержание\" не заполнено.")
			return false
		}
		if (webFormData.getValueSilently("contractsignedwith") == ""){
			localizedMsgBox("Поле \"Договор заключен с\" не указано.")
			return false
		}

		if (webFormData.getValueSilently("contractor_one") == ""){
			localizedMsgBox("Поле \"Заказчик\" не заполнено.")
			return false
		}
		if (webFormData.getValueSilently("contractor_two") == ""){
			localizedMsgBox("Поле \"Исполнитель\" не заполнено.")
			return false
		}
		if (webFormData.getValueSilently("curator") == ""){
			localizedMsgBox("Поле \"Куратор\" не заполнено.")
			return false
		}
		return true
	}
}
