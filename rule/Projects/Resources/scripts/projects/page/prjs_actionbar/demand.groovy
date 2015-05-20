package projects.page.prjs_actionbar

import kz.nextbase.script.*;
import kz.nextbase.script.actions.*
import kz.nextbase.script.events._DoScript

class demand extends _DoScript { 

	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {
		//println(formData)

		def actionBar = new _ActionBar(session);
		def user = session.getCurrentAppUser();
		if(user.hasRole("registrator_demand")){
			def newDocAction = new _Action(getLocalizedWord("Новая заявка", lang),getLocalizedWord("Создать новую заявку", lang),"new_demand")
			newDocAction.setURL("Provider?type=edit&element=document&id=demand&docid=")
			actionBar.addAction(newDocAction);
            actionBar.addAction(new _Action(getLocalizedWord("Удалить", lang),getLocalizedWord("Удалить", lang),_ActionType.DELETE_DOCUMENT));
		}
		//if (user.hasRole("administrator")){

		//}
		setContent(actionBar);
	}
}




