package cashtracker.form.glossary.simpleform

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
		actionBar.addAction(new _Action(getLocalizedWord("Сохранить и закрыть",lang),
				getLocalizedWord("Сохранить и закрыть",lang),_ActionType.SAVE_AND_CLOSE))
		def closeDoc = new _Action(getLocalizedWord("Закрыть", lang),
				getLocalizedWord("Закрыть без сохранения", lang), _ActionType.CLOSE)
		closeDoc.setURL(session.getLastURL())
		actionBar.addAction(closeDoc)
		publishElement(actionBar)
		publishEmployer("author", session.getCurrentAppUser().getUserID())
	}

	@Override
	public void doQueryOpen(_Session session, _Document doc, _WebFormData webFormData, String lang) {
		def user = session.getCurrentAppUser()
		def db = session.getCurrentDatabase()

		def nav = session.getPage("outline", webFormData)
		publishElement(nav)

		def actionBar =  session.createActionBar()
		if(doc.getEditMode() == _DocumentModeType.EDIT ){
			actionBar.addAction(new _Action(getLocalizedWord("Сохранить и закрыть",lang),
					getLocalizedWord("Сохранить и закрыть",lang),_ActionType.SAVE_AND_CLOSE))
		}
		def closeDoc = new _Action(getLocalizedWord("Закрыть", lang),
				getLocalizedWord("Закрыть без сохранения", lang), _ActionType.CLOSE)
		closeDoc.setURL(session.getLastURL())
		actionBar.addAction(closeDoc)
		publishElement(actionBar)

		publishValue("name", doc.getValueString("name"))
		publishEmployer("author", doc.getAuthorID())
	}
}
