package page.actionbar

import kz.nextbase.script._Session
import kz.nextbase.script._WebFormData
import kz.nextbase.script.actions._Action
import kz.nextbase.script.actions._ActionBar
import kz.nextbase.script.actions._ActionType
import kz.nextbase.script.events._DoScript

class contracttype extends _DoScript {

	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {
		def actionBar = new _ActionBar(session);
		def user = session.getCurrentAppUser();
			if (user.hasRole(["supervisor","administrator","chancellery"])){
				def newDocAction = new _Action(getLocalizedWord("Новый тип договора", lang),getLocalizedWord("Новый тип договора",lang), "new_glossary")
				newDocAction.setURL("Provider?type=edit&id=contracttype&key=")
				actionBar.addAction(newDocAction);
			}
			if (user.hasRole(["supervisor","administrator","chancellery"])){
				actionBar.addAction(new _Action(getLocalizedWord("Удалить документ", lang),getLocalizedWord("Удалить документ", lang),_ActionType.DELETE_DOCUMENT));
			}
		setContent(actionBar);
	}
}

