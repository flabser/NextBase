package bankfinance.form.bank_operation

import kz.nextbase.script.*
import kz.nextbase.script.actions.*
import kz.nextbase.script.constants.*
import kz.nextbase.script.events.*
import bankfinance.form.FormUtil

class QueryOpen extends _FormQueryOpen {

	@Override
	public void doQueryOpen(_Session session, _WebFormData webFormData, String lang) {
		def user = session.getCurrentAppUser()

		def nav = session.getPage("outline", webFormData)
		publishElement(nav)

		def actionBar = session.createActionBar();
		actionBar.addAction(new _Action(getLocalizedWord("Сохранить и закрыть", lang),
				getLocalizedWord("Сохранить и закрыть", lang), _ActionType.SAVE_AND_CLOSE))
		def closeDoc = new _Action(getLocalizedWord("Закрыть", lang),
				getLocalizedWord("Закрыть без сохранения", lang), _ActionType.CLOSE)
		closeDoc.setURL(session.getLastURL())
		actionBar.addAction(closeDoc)
		publishElement(actionBar)

		def db = session.getCurrentDatabase()
		publishValue("regdate", session.getCurrentDateAsString())
		def gdoc = db.getGlossaryDocument('bank_account', "form = 'bank_account' and user = '" + session.getCurrentUserID() + "'")
		if(gdoc){
			publishValue("bank_account", gdoc.getDocID(), gdoc.getName())
		}
		publishValue("date", session.getCurrentDateAsString())
		publishEmployer("author", session.getCurrentAppUser().getUserID())
		publishValue("documented", 0)
		publishElement(FormUtil.glossariesListXML(session, "bank_account"))
	}

	@Override
	public void doQueryOpen(_Session session, _Document doc, _WebFormData webFormData, String lang) {

		def user = session.getCurrentAppUser()
		def db = session.getCurrentDatabase()

		def nav = session.getPage("outline", webFormData)
		publishElement(nav)

		def actionBar =  session.createActionBar();
		if(doc.getEditMode() == _DocumentModeType.EDIT ){
			actionBar.addAction(new _Action(getLocalizedWord("Сохранить и закрыть", lang),
					getLocalizedWord("Сохранить и закрыть", lang), _ActionType.SAVE_AND_CLOSE))
		}
		def closeDoc = new _Action(getLocalizedWord("Закрыть", lang),
				getLocalizedWord("Закрыть без сохранения", lang), _ActionType.CLOSE)
		closeDoc.setURL(session.getLastURL())
		actionBar.addAction(closeDoc)
		publishElement(actionBar)

		def operation = BankOperation.of(doc)

		publishValue("vn", operation.vn)
		publishValue("regdate", _Helper.getDateAsString(doc.getRegDate()))
		publishGlossaryValue("bank_account", operation.bankAccount)
		publishValue("date", _Helper.getDateAsStringShort(operation.date))
		publishValue("summa", operation.sum)
		publishGlossaryValue("category", operation.category)
		publishGlossaryValue("subcategory", operation.subCategory)
		publishGlossaryValue("costcenter", operation.costCenter)
		try {
			publishOrganization("recipient", operation.recipient)
		} catch(e) {
			log("exception: recipient not found: ${operation.recipient}")
		}
		publishValue("basis", operation.basis)
		publishValue("requisites", operation.requisites)
		publishValue("documented", operation.documented)
		publishEmployer("author", doc.getAuthorID())

		//
		try {
			def catDoc = db.getGlossaryDocument(operation.catID)
			publishValue("requiredocument", catDoc.getValueString("requiredocument"))
			publishValue("typeoperation", catDoc.getValueString("typeoperation"))
		} catch(e) {
			log(e)
		}

		publishElement(FormUtil.glossariesListXML(session, "bank_account"))

		try {
			publishAttachment("rtfcontent", "rtfcontent")
		} catch (_Exception e) {
			log(e)
		}
	}
}
