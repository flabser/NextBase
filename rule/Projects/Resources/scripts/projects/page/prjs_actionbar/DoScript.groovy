package projects.page.prjs_actionbar

import kz.nextbase.script.*;
import kz.nextbase.script.actions.*
import kz.nextbase.script.events._DoScript

class DoScript extends _DoScript { 

	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {
		//println(formData)

		def actionBar = new _ActionBar(session);
		def user = session.getCurrentAppUser();
		if(user.hasRole("registrator_demand")){
			if(formData.get("id")[0] == 'projects'){
				def newDocAction = new _Action(getLocalizedWord("Новый проект", lang),getLocalizedWord("Создать новый проект", lang),"new_project")
				newDocAction.setURL("Provider?type=edit&element=document&id=project&key=")
				actionBar.addAction(newDocAction);			
			}
			if(formData.get("id")[0] == 'demands' || formData.get("id")[0] == 'demandsbyproject' || formData.get("id")[0] == 'current_milestone' || formData.get("id")[0] == 'mytasks' || formData.get("id")[0] == 'tasksforme'){
				def newDocAction = new _Action(getLocalizedWord("Новая заявка", lang),getLocalizedWord("Создать новую заявку", lang),"new_demand")
				newDocAction.setURL("Provider?type=edit&element=document&id=demand&key=")
				actionBar.addAction(newDocAction);			
			}
		}
		if (user.hasRole("administrator")){
			actionBar.addAction(new _Action(getLocalizedWord("Удалить", lang),getLocalizedWord("Удалить", lang),_ActionType.DELETE_DOCUMENT));
			def newGlosAction = new _Action(getLocalizedWord("Добавить", lang),getLocalizedWord("Добавить справочник", lang),"NEW_GLOSSARY"); 			
						
			if(formData.getValueSilently("id") == "customers"){
				newGlosAction.setURL("Provider?type=edit&element=glossary&id=customers&key=")
			}
			if(formData.getValueSilently("id") == "demand_revoke_reason"){
				newGlosAction.setURL("Provider?type=edit&element=glossary&id=demand_revoke_reason&key=")
			} 
			actionBar.addAction(newGlosAction);
		}
		
		/*if(user.hasRole("registrator_demand")){
			def newDemand = new _Action(getLocalizedWord("Новая заявка", lang),getLocalizedWord("Новая заявка", lang),"new_demand");
			newDemand.setURL("Provider?type=edit&element=document&id=demand&key=")
			actionBar.addAction(newDemand);			
		}*/
		setContent(actionBar);
	}
}




