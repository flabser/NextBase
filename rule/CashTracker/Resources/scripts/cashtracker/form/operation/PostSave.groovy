package cashtracker.form.operation

import kz.nextbase.script.*
import kz.nextbase.script.events._FormPostSave

class PostSave extends _FormPostSave {

	private def session = null
	private def doc = null
	private def catDoc = null

	public void doPostSave(_Session session, _Document doc) {
		this.session = session
		this.doc = doc

		amountControl(session, doc)
		createOrModify(session, doc)
	}

	private def getCategoryDoc(){
		if(catDoc != null){
			return catDoc
		}

		int catId = doc.getValueNumber("subcategory")
		if(catId == 0){
			catId = doc.getValueNumber("category")
		}
		catDoc = session.getCurrentDatabase().getGlossaryDocument(catId)

		return catDoc
	}

	private void notifyRecipientIfTransfer(_Session session, _Document doc, _Document childDoc){
		//def opType = getCategoryDoc().getValueString("typeoperation")
		//if(opType == "transfer"){
		def targetCashId = doc.getValueNumber("targetcash")
		def cashDoc = session.getCurrentDatabase().getGlossaryDocument(targetCashId)
		def emp = session.getStructure().getEmployer(cashDoc.getValueString("user"))
		def recipient = [emp.email]

		//Уведомление CashTracker
		String body = '<b><font color="#000080" size="4" face="Default Serif">Уведомление CashTracker</font></b><hr>'
		body += '<p>Произведена операция перевода в кассу ' + cashDoc.getValueString('name') + '</p>'
		//Для просмотра документа, перейдите по этой ссылке
		body += '<p><font size="2" face="Arial">Для просмотра документа, перейдите по этой <a href="' + childDoc.getFullURL() + '">ссылке...</a></p></font>'

		session.getMailAgent().sendMail(recipient, 'Уведомление CashTracker', body)
		//}
	}

	private void amountControl(_Session session, _Document doc){
		//rn_amount_control
		try {
			def typeOperation = getCategoryDoc().getValueString("typeoperation")
			if(typeOperation != "out"){
				return
			}

			int cash = Integer.parseInt(doc.getValueString("cash").trim())
			int summa = doc.getValueNumber("summa")

			def gdoc = session.getCurrentDatabase().getGlossaryDocument(cash)
			int amountcontrol = new Integer(gdoc.getValueString("amountcontrol"))
			String cashName = gdoc.getValueString("name")

			if(summa >= amountcontrol){
				def recipients = []
				session.getStructure().getAllEmployers().each { emp ->
					if(emp.hasRole("rn_amount_control")){
						recipients << emp.email
					}
				}

				if(recipients.size() > 0){
					println "amountControl: send notification $recipients"

					//Уведомление CashTracker
					String body = '<b><font color="#000080" size="4" face="Default Serif">Уведомление CashTracker</font></b><hr>'
					body += '<table cellspacing="0" cellpadding="4" border="0" style="padding:10px; font-size:12px; font-family:Arial;">'
					body += '<tr>'
					//Сумма установленная для контроля по кассе
					body += '<td width="210px">Сумма установленная для контроля по кассе [<b>' + cashName + '</b>]:</td>'
					body += '<td width="500px"><b>'+amountcontrol+'</b></td>'
					body += '</tr><tr>'
					//Сумма производимой операции
					body += '<td>Сумма производимой операции:</font></td><td><b>' + summa + '</b></td>'
					body += '<td>-</td><td>' + doc.getValueString("viewtext") + '</td>'
					body += '</tr></table>'
					//Для просмотра документа, перейдите по этой ссылке
					body += '<p><font size="2" face="Arial">Для просмотра документа, перейдите по этой <a href="' + doc.getFullURL() + '">ссылке...</a></p></font>'

					session.getMailAgent().sendMail(recipients, 'Уведомление CashTracker ' + doc.getValueString('date'), body)
				} else {
					println "amountControl: no employers has role rn_amount_control"
				}
			}
		} catch(e) {
			e.printStackTrace()
		}
	}

	private void createOrModify(_Session session, _Document doc){
		def catDoc = (_Document) getCategoryDoc()
		if(catDoc){
			def opType = catDoc.getValueString("typeoperation")
			if(opType == "transfer"){
				def childDoc = createOrModifyTransferChildDoc(session, doc)
				notifyRecipientIfTransfer(session, doc, childDoc)
			} else if(opType == "getcash") {
				createOrModifyBankFinanceDocumentWithdraw(session, doc)
			}
		}
	}

	private def createOrModifyTransferChildDoc(_Session session, _Document doc){
		def db = session.getCurrentDatabase()
		def childDoc
		String vnAsText
		def responses = doc.getResponses()
		if(responses != null && !responses.isEmpty()){
			def respDoc = responses.toArray()[0]
			childDoc = ((_Document)respDoc)
			vnAsText = childDoc.getValueString("vn")
		} else {
			childDoc = new _Document(session.getCurrentDatabase())
			childDoc.setForm("operation")
			vnAsText = String.valueOf(db.getRegNumber("operation"))
			childDoc.addStringField("vn", vnAsText)
			childDoc.setParentDoc(doc)
		}
		childDoc.addStringField("author", session.getCurrentUserID())
		childDoc.addNumberField("cash", doc.getValueNumber("targetcash"))
		childDoc.addNumberField("summa", doc.getValueNumber("summa"))
		childDoc.addDateField("date", doc.getValueDate("date"))
		def receiveOperation = db.getGlossaryDocument("category", "typeoperation = 'received'")
		childDoc.addNumberField("category",receiveOperation.getDocID())
		childDoc.addStringField("basis", doc.getValueString("basis"))
		childDoc.addNumberField("documented", doc.getValueNumber("documented"))
		doc.copyAttachments(childDoc)

		childDoc.clearReaders()
		childDoc.clearEditors()
		childDoc.addReaders(doc.getReaders())
		childDoc.addEditor(doc.getAuthorID())
		def targetCashDoc = db.getGlossaryDocument(doc.getValueNumber("targetcash"))
		def receiver = targetCashDoc.getValueString("user")
		childDoc.addReader(receiver)

		def basis = ""
		if (doc.getValueString("basis").length() > 0) {
			basis = "; " + doc.getValueString("basis")
		}

		def addInfo = ""
		if (targetCashDoc) {
			addInfo = " << " + targetCashDoc.getName()
		}
		childDoc.setViewText("№ " + vnAsText + " - " + _Helper.getDateAsString(doc.getValueDate("date")) +
				" -> "+ receiveOperation.getName() + addInfo + basis)
		if (targetCashDoc) {
			childDoc.addViewText(targetCashDoc.getName())
		}
		childDoc.setViewDate(doc.getValueDate("date"))
		childDoc.setViewNumber(doc.getValueNumber("summa"))

		childDoc.save("[supervisor]")

		return childDoc
	}

	private void createOrModifyBankFinanceDocumentWithdraw(_Session session, _Document doc){
		def db = session.getCurrentDatabase()
		def childDoc
		String vnAsText
		def responses = doc.getResponses()
		if(responses != null && !responses.isEmpty()){
			def respDoc = responses.toArray()[0]
			childDoc = ((_Document)respDoc)
			vnAsText = childDoc.getValueString("vn")
		} else {
			childDoc = new _Document(session.getCurrentDatabase())
			childDoc.setForm("bank_operation")
			vnAsText = String.valueOf(db.getRegNumber("bank_operation"))
			childDoc.addStringField("vn", vnAsText)
			childDoc.setParentDoc(doc)
		}
		childDoc.addStringField("author", session.getCurrentUserID())

		def costCenterDoc = db.getGlossaryDocument(doc.getValueNumber("costcenter"))
		def bankAccountDoc
		if(costCenterDoc){
			childDoc.addStringField("bank_account", costCenterDoc.getValueString("bank_account"))
			bankAccountDoc = db.getGlossaryDocument("bank_account", "ddbid='" + childDoc.getValueString("bank_account") + "'")
		}
		childDoc.addNumberField("summa", doc.getValueNumber("summa"))
		childDoc.addDateField("date", doc.getValueDate("date"))
		def withdrawOperation = db.getGlossaryDocument("category", "typeoperation = 'withdraw'")
		childDoc.addNumberField("category", withdrawOperation.getDocID())
		childDoc.addNumberField("recipient", -1)
		childDoc.addStringField("requisites", "")
		childDoc.addStringField("basis", doc.getValueString("basis"))
		childDoc.addNumberField("documented", doc.getValueNumber("documented"))
		childDoc.addDateField("date", doc.getValueDate("date"))
		doc.copyAttachments(childDoc)

		childDoc.clearReaders()
		childDoc.clearEditors()
		childDoc.addReaders(doc.getReaders())
		childDoc.addEditor(doc.getAuthorID())
		//def targetCashDoc = db.getGlossaryDocument(doc.getValueNumber("targetcash"))
		//def receiver = targetCashDoc.getValueString("user")
		//childDoc.addReader(receiver)

		def basis = ""
		if (doc.getValueString("basis").length() > 0) {
			basis = "; " + doc.getValueString("basis")
		}

		def addInfo = ""
		//if (targetCashDoc) {
		//	addInfo = " << " + targetCashDoc.getName()
		//}
		childDoc.setViewText("№ " + vnAsText + " - " + _Helper.getDateAsString(doc.getValueDate("date")) +
				" -> "+ withdrawOperation.getName() + addInfo + basis)
		if(costCenterDoc){
			childDoc.addViewText(bankAccountDoc.getName())
		}
		//if (targetCashDoc) {
		//	childDoc.addViewText(targetCashDoc.getName())
		//}
		childDoc.setViewDate(doc.getValueDate("date"))
		childDoc.setViewNumber(0 - doc.getValueNumber("summa"))

		childDoc.save("[supervisor]")
	}
}
