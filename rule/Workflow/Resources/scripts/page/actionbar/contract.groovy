package page.actionbar

import kz.nextbase.script._Session
import kz.nextbase.script._WebFormData
import kz.nextbase.script.actions._Action
import kz.nextbase.script.actions._ActionBar
import kz.nextbase.script.actions._ActionType
import kz.nextbase.script.events._DoScript

class contract extends _DoScript {

	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {
		def actionBar = new _ActionBar(session);
		def user = session.getCurrentAppUser();
		if (user.hasRole(["registrator_contract", "administrator"])){
			def newDocAction = new _Action(getLocalizedWord("Новый договор", lang),getLocalizedWord("Новый договор", lang),"new_document")
			newDocAction.setURL("Provider?type=edit&element=document&id=contract&docid=")
			actionBar.addAction(newDocAction);
		}
		if (user.hasRole(["administrator", "chancellery"])){
			actionBar.addAction(new _Action(getLocalizedWord("Удалить документ", lang),getLocalizedWord("Удалить документ", lang),_ActionType.DELETE_DOCUMENT));
		}
		setContent(actionBar);
	}
}

