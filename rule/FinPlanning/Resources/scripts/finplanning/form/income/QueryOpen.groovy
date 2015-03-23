package finplanning.form.income

import kz.nextbase.script.*
import kz.nextbase.script.actions.*
import kz.nextbase.script.constants.*
import kz.nextbase.script.events.*
import cashtracker.page.util.HTMLUtil

class QueryOpen extends _FormQueryOpen {

	@Override
	public void doQueryOpen(_Session session, _WebFormData webFormData, String lang) {
		def user = session.getCurrentAppUser()

		def nav = session.getPage("outline", webFormData)
		publishElement(nav)

		def actionBar = session.createActionBar()
		if (user.hasRole(["plan_operations"])){
			actionBar.addAction(new _Action(getLocalizedWord("Save and close", lang),
					getLocalizedWord("Save and close", lang), _ActionType.SAVE_AND_CLOSE))
		}
		def closeDoc = new _Action(getLocalizedWord("Close", lang),
				getLocalizedWord("Close without save", lang), _ActionType.CLOSE)
		closeDoc.setURL(session.getLastURL())
		actionBar.addAction(closeDoc)
		publishElement(actionBar)

		def db = session.getCurrentDatabase()
		publishValue("regdate", session.getCurrentDateAsString())
		publishValue("date", session.getCurrentDateAsString())
		publishEmployer("author", session.getCurrentAppUser().getUserID())
		publishValue("repeat", "once-only")

		def sf = "form = 'category' and category_refers_to != 'hidden'"
		publishElement(HTMLUtil.getGlossariesSelectXML(session, "category", sf, "docid", "", false))
	}

	@Override
	public void doQueryOpen(_Session session, _Document doc, _WebFormData webFormData, String lang) {

		def user = session.getCurrentAppUser()
		def db = session.getCurrentDatabase()

		def nav = session.getPage("outline", webFormData)
		publishElement(nav)

		def actionBar =  session.createActionBar()
		if(doc.getEditMode() == _DocumentModeType.EDIT && user.hasRole(["plan_operations"])){
			actionBar.addAction(new _Action(getLocalizedWord("Save and close", lang),
					getLocalizedWord("Save and close", lang), _ActionType.SAVE_AND_CLOSE))
		}
		def closeDoc = new _Action(getLocalizedWord("Close", lang),
				getLocalizedWord("Close without save", lang), _ActionType.CLOSE)
		closeDoc.setURL(session.getLastURL())
		actionBar.addAction(closeDoc)
		publishElement(actionBar)

		def operation = Income.of(doc)

		publishValue("vn", operation.vn)
		publishValue("regdate", _Helper.getDateAsString(doc.getRegDate()))
		publishValue("date", _Helper.getDateAsStringShort(operation.date))
		publishValue("summa", operation.sum)
		publishValue("repeat", operation.repeat)
		publishGlossaryValue("category", operation.category)
		publishGlossaryValue("subcategory", operation.subCategory)
		publishGlossaryValue("costcenter", operation.costCenter)
		publishOrganization("recipient", operation.recipient)
		publishValue("basis", operation.basis)
		publishEmployer("author", doc.getAuthorID())

		//
		try {
			def catDoc = db.getGlossaryDocument(operation.catID)
			publishValue("requiredocument", catDoc.getValueString("requiredocument"))
			publishValue("typeoperation", catDoc.getValueString("typeoperation"))
		} catch(e) {
			log(e)
		}

		try {
			publishAttachment("rtfcontent", "rtfcontent")
		} catch (_Exception e) {
			log(e)
		}
	}
}
