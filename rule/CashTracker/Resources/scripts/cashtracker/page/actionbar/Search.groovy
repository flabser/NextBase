package cashtracker.page.actionbar

import kz.nextbase.script.*
import kz.nextbase.script.actions.*
import kz.nextbase.script.events._DoScript

class Search extends _DoScript {

	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {

		def actionBar = new _ActionBar(session)
		def user = session.getCurrentAppUser()
		def _goBack = new _Action(getLocalizedWord("Вернуться к списку документов", lang),
				getLocalizedWord("Вернуться к списку документов", lang), "history_back")
		_goBack.setURL(session.getURLOfLastPage().urlAsString)
		actionBar.addAction(_goBack)

		if (user.hasRole(["operations"])){
			def _new = new _Action(getLocalizedWord("Новая операция", lang),
					getLocalizedWord("Создать новую операцию", lang), "new_document")
			_new.setURL("Provider?type=edit&id=operation&key=")
			actionBar.addAction(_new)
		}

		setContent(actionBar)
	}
}
