package cashtracker.form.subcategory

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

		def db = session.getCurrentDatabase()

		def actionBar = session.createActionBar()
		if(webFormData.getParentDocID()[0]){
			actionBar.addAction(new _Action(getLocalizedWord("Сохранить и закрыть", lang),
					getLocalizedWord("Сохранить и закрыть", lang), _ActionType.SAVE_AND_CLOSE))
		}
		def closeDoc = new _Action(getLocalizedWord("Закрыть", lang),
				getLocalizedWord("Закрыть без сохранения", lang), _ActionType.CLOSE)
		closeDoc.setURL(session.getLastURL())
		actionBar.addAction(closeDoc)
		publishElement(actionBar)

		def catDoc = db.getGlossaryDocument(webFormData.getParentDocID()[0])

		publishValue("category_refers_to", catDoc.getValueString("category_refers_to"))
		publishValue("typeoperation", catDoc.getValueString("typeoperation"))
		publishValue("requiredocument", catDoc.getValueString("requiredocument"))
		publishValue("requirecostcenter", catDoc.getValueString("requirecostcenter"))
		publishValue("accessroles", catDoc.getValueString("accessroles"))
		publishValue("disable_selection", catDoc.getValueString("disable_selection"))
		publishGlossaryValue("category", webFormData.getParentDocID()[0])

		publishEmployer("author", session.getCurrentAppUser().getUserID())
	}

	@Override
	public void doQueryOpen(_Session session, _Document doc, _WebFormData webFormData, String lang) {
		def user = session.getCurrentAppUser()
		def db = session.getCurrentDatabase()

		def nav = session.getPage("outline", webFormData)
		publishElement(nav)

		def actionBar = session.createActionBar()
		if(doc.getEditMode() == _DocumentModeType.EDIT ){
			actionBar.addAction(new _Action(getLocalizedWord("Сохранить и закрыть", lang),
					getLocalizedWord("Сохранить и закрыть", lang), _ActionType.SAVE_AND_CLOSE))
		}
		def closeDoc = new _Action(getLocalizedWord("Закрыть", lang),
				getLocalizedWord("Закрыть без сохранения", lang), _ActionType.CLOSE)
		closeDoc.setURL(session.getLastURL())
		actionBar.addAction(closeDoc)
		publishElement(actionBar)

		publishValue("name", doc.getValueString("name"))
		publishValue("category_refers_to", doc.getValueList("category_refers_to"))
		publishValue("typeoperation", doc.getValueString("typeoperation"))
		publishValue("accessroles", doc.getValueString("accessroles"))
		publishValue("requiredocument", doc.getValueString("requiredocument"))
		publishValue("requirecostcenter", doc.getValueString("requirecostcenter"))
		publishValue("disable_selection", doc.getValueString("disable_selection"))
		publishValue("comment", doc.getValueString("comment"))
		publishGlossaryValue("category", doc.getParentDocument().getID())

		publishEmployer("author", doc.getValueString("author"))
	}
}
