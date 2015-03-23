package cashtracker.form.operation

import kz.nextbase.script.*
import kz.nextbase.script.actions.*
import kz.nextbase.script.constants.*
import kz.nextbase.script.events.*

class QueryOpen extends _FormQueryOpen {

	@Override
	public void doQueryOpen(_Session session, _WebFormData webFormData, String lang) {
		def user = session.getCurrentAppUser()

		def nav = session.getPage("outline", webFormData)
		publishElement(nav)

		def actionBar = session.createActionBar()
		actionBar.addAction(new _Action(getLocalizedWord("Сохранить и закрыть", lang),
				getLocalizedWord("Сохранить и закрыть", lang), _ActionType.SAVE_AND_CLOSE))
		def closeDoc = new _Action(getLocalizedWord("Закрыть", lang),
				getLocalizedWord("Закрыть без сохранения", lang), _ActionType.CLOSE)
		closeDoc.setURL(session.getLastURL())
		actionBar.addAction(closeDoc)
		publishElement(actionBar)

		def db = session.getCurrentDatabase()
		publishValue("regdate", session.getCurrentDateAsString())
		def gdoc = db.getGlossaryDocument('cash', "form = 'cash' and user = '" + session.getCurrentUserID() + "'")
		if(gdoc){
			publishValue("cash", gdoc.getDocID(), gdoc.getName())
		}
		publishValue("date", session.getCurrentDateAsString())
		publishEmployer("author", session.getCurrentAppUser().getUserID())
		publishValue("documented", 0)
		//publishElement(FormUtil.glossariesListXML(session, "cash"))

		//def sf = "form = 'category' and category_refers_to != 'bank' and category_refers_to != 'hidden'"
		//publishElement(HTMLUtil.getGlossariesSelectXML(session, "category", sf, "docid", "", false))
	}

	@Override
	public void doQueryOpen(_Session session, _Document doc, _WebFormData webFormData, String lang) {
		def user = session.getCurrentAppUser()
		def db = session.getCurrentDatabase()

		def nav = session.getPage("outline", webFormData)
		publishElement(nav)

		def actionBar =  session.createActionBar()
		if(doc.getEditMode() == _DocumentModeType.EDIT ){
			actionBar.addAction(new _Action(getLocalizedWord("Сохранить и закрыть", lang),
					getLocalizedWord("Сохранить и закрыть", lang), _ActionType.SAVE_AND_CLOSE))
		}
		def closeDoc = new _Action(getLocalizedWord("Закрыть", lang),
				getLocalizedWord("Закрыть без сохранения", lang), _ActionType.CLOSE)
		closeDoc.setURL(session.getLastURL())
		actionBar.addAction(closeDoc)
		publishElement(actionBar)

		publishValue("vn", doc.getValueString("vn"))
		publishValue("regdate", _Helper.getDateAsString(doc.getRegDate()))
		publishGlossaryValue("cash", doc.getValueNumber("cash"))
		publishValue("date", _Helper.getDateAsStringShort(doc.getValueDate("date")))
		publishValue("summa", doc.getValueInt("summa"))

		//
		def catDoc
		int subCatId
		try {
			subCatId = doc.getValueNumber("subcategory")
		} catch(e) {
			// if no field subcategory
			subCatId = 0
		}

		if(subCatId > 0){
			catDoc = db.getGlossaryDocument(subCatId)
		} else {
			catDoc = db.getGlossaryDocument(doc.getValueNumber("category"))
		}

		publishGlossaryValue("category", doc.getValueNumber("category"))
		publishGlossaryValue("subcategory", subCatId)

		//
		publishValue("requiredocument", catDoc.getValueString("requiredocument"))
		publishValue("typeoperation", catDoc.getValueString("typeoperation"))

		try {
			publishGlossaryValue("costcenter", doc.getValueNumber("costcenter"))
		} catch(_Exception e) {
			//println(e)
		}

		try {
			publishGlossaryValue("targetcash", doc.getValueNumber("targetcash"))
		} catch(_Exception e) {
			//println(e)
		}

		try {
			def cs = doc.getValueNumber("calcstaff")
			if (cs == 1){
				publishValue("calcstaff", "1")
				publishEmployer("personal", doc.getValueString("personal"))
			}
		} catch(_Exception e) {
			//println(e)
		}

		publishValue("basis", doc.getValueString("basis"))
		publishValue("documented", doc.getValueNumber("documented"))
		if(doc.getEditMode() == _DocumentModeType.EDIT ){
			//publishElement(FormUtil.glossariesListXML(session, "cash"))

			//def sf = "form = 'category' and category_refers_to != 'bank' and category_refers_to != 'hidden'"
			//publishElement(HTMLUtil.getGlossariesSelectXML(session, "category", sf, "docid", doc.getValueString("category"), false))

			//def sf2 = "form = 'subcategory' and parentdocid = " + doc.getValueNumber("category") +
			//		" and category_refers_to != 'bank' and category_refers_to != 'hidden'"
			//publishElement(HTMLUtil.getGlossariesSelectXML(session, "subcategory", sf2, "docid", doc.getValueString("subcategory"), false))
		}
		publishEmployer("author", doc.getAuthorID())

		try {
			publishAttachment("rtfcontent", "rtfcontent")
		} catch(_Exception e) {
			log(e)
		}
	}
}
