package projects.page.prjs_actionbar

import kz.nextbase.script.*;
import kz.nextbase.script.actions.*
import kz.nextbase.script.events._DoScript

class projects extends _DoScript { 

	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {
		//println(formData)

		def actionBar = new _ActionBar(session);
		def user = session.getCurrentAppUser();
		if(user.hasRole("registrator_demand")){
			def newDocAction = new _Action(getLocalizedWord("Новый проект", lang),getLocalizedWord("Создать новый проект", lang),"new_project")
			newDocAction.setURL("Provider?type=edit&element=document&id=project&docid=")
			actionBar.addAction(newDocAction);			
		}
		if (user.hasRole("administrator")){
			actionBar.addAction(new _Action(getLocalizedWord("Удалить", lang),getLocalizedWord("Удалить", lang),_ActionType.DELETE_DOCUMENT));
		}
		setContent(actionBar);
	}
}




