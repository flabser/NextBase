package page.actionbarom

import kz.nextbase.script.*;
import kz.nextbase.script.actions.*
import kz.nextbase.script.events._DoScript

/**
 * @author Bekzat
 * @date 28.01.2014
 */

class DoScript extends _DoScript{
	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {


		def user = session.getCurrentAppUser();
        def id = formData.getValue("id");
        if(id.startsWith("order"))
            id = "order";
        String extra_fields = "";
        if(id.equals("order_by_customer"))
            extra_fields = "&customer=" + formData.getValueSilently("customer");

        def actionBar = new _ActionBar(session);

//		if (user.hasRole(["order_registrator"])){
			def newDocAction = new _Action(getLocalizedWord("Добавить",lang),getLocalizedWord("Добавить",lang),"new_document")
			newDocAction.setURL("Provider?type=edit&element=document&id=$id&docid=" + extra_fields);
			actionBar.addAction(newDocAction);
			actionBar.addAction(new _Action(getLocalizedWord("Удалить",lang),getLocalizedWord("Удалить",lang),_ActionType.DELETE_DOCUMENT));
//		}
		 
		setContent(actionBar);
	}
}
