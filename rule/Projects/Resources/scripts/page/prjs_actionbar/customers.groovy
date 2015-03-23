package page.prjs_actionbar

import java.util.ArrayList;
import java.util.Map;
import kz.nextbase.script.*;
import kz.nextbase.script.actions.*
import kz.nextbase.script.events._DoScript

class customers extends _DoScript { 

	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {
		//println(formData)

		def actionBar = new _ActionBar(session);
		def user = session.getCurrentAppUser();
		
		if (user.hasRole("administrator")){
			actionBar.addAction(new _Action(getLocalizedWord("Удалить", lang),getLocalizedWord("Удалить", lang),_ActionType.DELETE_DOCUMENT));
			def newGlosAction = new _Action(getLocalizedWord("Добавить", lang),getLocalizedWord("Добавить справочник", lang),"NEW_GLOSSARY"); 			
			newGlosAction.setURL("Provider?type=edit&element=glossary&id=customers&key=")
			actionBar.addAction(newGlosAction);
		}
		setContent(actionBar);
	}
}




