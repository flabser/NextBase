package page.actionbar

import kz.nextbase.script._Session
import kz.nextbase.script._WebFormData
import kz.nextbase.script.actions._Action
import kz.nextbase.script.actions._ActionBar
import kz.nextbase.script.actions._ActionType
import kz.nextbase.script.events._DoScript

class docsbyglossary extends _DoScript {

	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {
		def actionBar = new _ActionBar(session);
		def user = session.getCurrentAppUser();
        def formid = formData.getValueSilently("formid");
        if(formid == "order"){
           if (user.hasRole(["registrator_projects", "administrator"])){
				def newDocAction = new _Action(getLocalizedWord("Новый приказ", lang),getLocalizedWord("Новый приказ", lang),"new_document")
				newDocAction.setURL("Provider?type=edit&element=document&id=order&docid=")
				actionBar.addAction(newDocAction);
			}
			if (user.hasRole(["administrator", "chancellery"])){
				actionBar.addAction(new _Action(getLocalizedWord("Удалить документ", lang),getLocalizedWord("Удалить документ", lang),_ActionType.DELETE_DOCUMENT));
			}

        }else if(formid == "contract"){
            if (user.hasRole(["registrator_projects", "administrator"])){
				def newDocAction = new _Action(getLocalizedWord("Новый договор", lang),getLocalizedWord("Новый договор", lang),"new_document")
				newDocAction.setURL("Provider?type=edit&element=document&id=contract&docid=")
				actionBar.addAction(newDocAction);
			}
			if (user.hasRole(["administrator", "chancellery"])){
				actionBar.addAction(new _Action(getLocalizedWord("Удалить документ", lang),getLocalizedWord("Удалить документ", lang),_ActionType.DELETE_DOCUMENT));
			}
        } else if(formid == "orderprj"){
            if (user.hasRole(["registrator_projects", "administrator"])){
				def newDocAction = new _Action(getLocalizedWord("Проект приказа", lang),getLocalizedWord("Проект приказа", lang),"new_document")
				newDocAction.setURL("Provider?type=edit&element=document&id=orderprj&docid=")
				actionBar.addAction(newDocAction);
			}
			if (user.hasRole(["administrator", "chancellery"])){
				actionBar.addAction(new _Action(getLocalizedWord("Удалить документ", lang),getLocalizedWord("Удалить документ", lang),_ActionType.DELETE_DOCUMENT));
			}
        }else if(formid == "contractprj"){
            if (user.hasRole(["registrator_projects", "administrator"])){
				def newDocAction = new _Action(getLocalizedWord("Проект договора", lang),getLocalizedWord("Проект договора", lang),"new_document")
				newDocAction.setURL("Provider?type=edit&element=document&id=contractprj&docid=")
				actionBar.addAction(newDocAction);
			}
			if (user.hasRole(["administrator", "chancellery"])){
				actionBar.addAction(new _Action(getLocalizedWord("Удалить документ", lang),getLocalizedWord("Удалить документ", lang),_ActionType.DELETE_DOCUMENT));
			}
        }
        setContent(actionBar);
	}
}

