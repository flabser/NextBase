package finplanning.form.userprofile

import kz.nextbase.script.*
import kz.nextbase.script.actions.*
import kz.nextbase.script.constants.*
import kz.nextbase.script.events.*

class QueryOpen extends _FormQueryOpen {

	@Override
	public void doQueryOpen(_Session session, _WebFormData webFormData, String lang) {
	}

	@Override
	public void doQueryOpen(_Session ses, _Document doc, _WebFormData webFormData, String lang) {

		def emp = ses.getCurrentAppUser()
		def nav = ses.getPage("outline", webFormData)
		publishElement(nav)

		def actionBar = new _ActionBar(ses)

		if(doc.getEditMode() == _DocumentModeType.EDIT){
			actionBar.addAction(new _Action(getLocalizedWord("Save and close", lang),
					getLocalizedWord("Save and close", lang), "save_user_profile"))
		}

		actionBar.addAction(new _Action(getLocalizedWord("Close", lang),
				getLocalizedWord("Close without save", lang), _ActionType.CLOSE))
		publishElement(actionBar)

		publishValue("title", getLocalizedWord("Employer", lang))
		publishValue("post", emp.getPostID(), emp.getPost())
		publishValue("department", emp.getShortName())
		publishValue("userid", emp.getValueString("userid"))
		publishValue("countdocinview", emp.getValueString("countdocinview"))
		publishValue("lang", emp.getValueString("lang"))
		publishValue("skin", doc.getValueString("skin"))
		publishValue("email", doc.getValueString("email"))
		publishValue("shortname", emp.getValueString("shortname"))
		publishEmployer("fullname", emp.getUserID())
		publishValue("instmsgaddress",doc.getValueString("instmsgaddress"))
		publishValue("group", emp.getListOfGroups())
		publishValue("role", emp.getListOfRoles())
	}
}
