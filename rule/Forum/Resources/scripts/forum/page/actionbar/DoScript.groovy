package forum.page.actionbar

import kz.nextbase.script.*;
import kz.nextbase.script.actions.*
import kz.nextbase.script.events._DoScript

class DoScript extends _DoScript { 

	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {
		
		def actionBar = new _ActionBar(session);
		def user = session.getCurrentAppUser();		
		String id = formData.getValueSilently("id");
				
		//if (user.hasRole(["redactor"])){
			actionBar.addAction(new _Action(getLocalizedWord("Удалить", lang),getLocalizedWord("Удалить", lang), "DELETE_GLOSSARY"));
			def newGlosAction = new _Action(getLocalizedWord("Добавить", lang),getLocalizedWord("Добавить справочник", lang),"NEW_GLOSSARY");

            newGlosAction.setURL("Provider?type=edit&element=document&id=$id&key=");

			actionBar.addAction(newGlosAction);
		//}
		
		setContent(actionBar);
	}
}

