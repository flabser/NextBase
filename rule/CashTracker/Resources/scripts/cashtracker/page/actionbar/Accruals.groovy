package cashtracker.page.actionbar

import kz.nextbase.script.*
import kz.nextbase.script.actions.*
import kz.nextbase.script.events._DoScript

class Accruals extends _DoScript {

	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {

		def actionBar = new _ActionBar(session)
		def user = session.getCurrentAppUser()
		if (user.hasRole(["operations"])){
			def _new = new _Action(getLocalizedWord("Новое начисление", lang), getLocalizedWord("Создать новое начисление", lang), "new_document")
			_new.setURL("Provider?type=edit&id=accrual&key=")
			actionBar.addAction(_new)
			actionBar.addAction(new _Action(getLocalizedWord("Удалить", lang), getLocalizedWord("Удалить", lang), _ActionType.DELETE_DOCUMENT))
		}
		setContent(actionBar)
	}
}
