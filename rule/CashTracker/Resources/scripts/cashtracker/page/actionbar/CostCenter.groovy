package cashtracker.page.actionbar

import kz.nextbase.script.*
import kz.nextbase.script.actions.*
import kz.nextbase.script.events._DoScript

class CostCenter extends _DoScript {

	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {

		def actionBar = new _ActionBar(session)
		def user = session.getCurrentAppUser()
		if (user.hasRole(["supervisor",	"administrator"])){
			def _new = new _Action(getLocalizedWord("Добавить", lang), getLocalizedWord("Добавить", lang), "new_glossary")
			_new.setURL("Provider?type=edit&id=costcenter&key=")
			actionBar.addAction(_new)
			actionBar.addAction(new _Action(getLocalizedWord("Удалить", lang), getLocalizedWord("Удалить", lang), _ActionType.DELETE_DOCUMENT))
		}
		setContent(actionBar)
	}
}
