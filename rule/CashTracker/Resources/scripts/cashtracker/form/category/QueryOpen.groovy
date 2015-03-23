package cashtracker.form.category

import kz.nextbase.script.*
import kz.nextbase.script.actions.*
import kz.nextbase.script.constants.*
import kz.nextbase.script.events.*

class QueryOpen extends _FormQueryOpen {

	@Override
	public void doQueryOpen(_Session session, _WebFormData webFormData, String lang) {
		publishElement(session.getPage("outline", webFormData))

		def actionBar = session.createActionBar()
		actionBar.addAction(new _Action(getLocalizedWord("Сохранить и закрыть", lang),
				getLocalizedWord("Сохранить и закрыть", lang), _ActionType.SAVE_AND_CLOSE))
		def closeDoc = new _Action(getLocalizedWord("Закрыть", lang),
				getLocalizedWord("Закрыть без сохранения", lang), _ActionType.CLOSE)
		closeDoc.setURL(session.getLastURL())
		actionBar.addAction(closeDoc)
		publishElement(actionBar)

		publishValue("category_refers_to", "")
		publishValue("typeoperation", "")
		publishValue("by_formula", "")
		publishValue("formula", "")
		publishValue("accessroles", "")
		publishValue("disable_selection", "")

		publishEmployer("author", session.getCurrentAppUser().getUserID())
	}

	@Override
	public void doQueryOpen(_Session session, _Document doc, _WebFormData webFormData, String lang) {
		publishElement(session.getPage("outline", webFormData))

		def actionBar = session.createActionBar()
		if(doc.getEditMode() == _DocumentModeType.EDIT ){
			actionBar.addAction(new _Action(getLocalizedWord("Сохранить и закрыть", lang),
					getLocalizedWord("Сохранить и закрыть", lang), _ActionType.SAVE_AND_CLOSE))

			def newSCAction = new _Action(getLocalizedWord("Добавить подкатегорию", lang),
					getLocalizedWord("Добавить подкатегорию", lang), "new_document")
			newSCAction.setURL("Provider?type=edit&element=glossary&id=subcategory&key=" +
					"&parentdocid=" + doc.getDocID())
			actionBar.addAction(newSCAction)
		}
		def closeDoc = new _Action(getLocalizedWord("Закрыть", lang),
				getLocalizedWord("Закрыть без сохранения", lang), _ActionType.CLOSE)
		closeDoc.setURL(session.getLastURL())
		actionBar.addAction(closeDoc)
		publishElement(actionBar)

		publishValue("name", doc.getValueString("name"))
		publishValue("category_refers_to", doc.getValueList("category_refers_to"))
		publishValue("typeoperation", doc.getValueString("typeoperation"))
		publishValue("by_formula", doc.getValueString("by_formula"))
		publishValue("formula", doc.getValueString("formula"))
		publishValue("accessroles", doc.getValueString("accessroles"))
		publishValue("requiredocument", doc.getValueString("requiredocument"))
		publishValue("requirecostcenter", doc.getValueString("requirecostcenter"))
		publishValue("disable_selection", doc.getValueString("disable_selection"))
		publishValue("comment", doc.getValueString("comment"))

		publishEmployer("author", doc.getValueString("author"))
	}
}
