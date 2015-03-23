package fixedassets.form.userprofile

import java.util.Map
import kz.nextbase.script.*
import kz.nextbase.script.actions.*
import kz.nextbase.script.events.*;
import kz.nextbase.script.struct._Employer
import kz.nextbase.script.constants.*

class QueryOpen extends _FormQueryOpen {

	
	@Override
	public void doQueryOpen(_Session session, _WebFormData webFormData, String lang) {
		
		def user = session.getCurrentAppUser()
		
		def nav = session.getPage("outline", webFormData)
		publishElement(nav)
		
		def actionBar = session.createActionBar();
		actionBar.addAction(new _Action(getLocalizedWord("Сохранить и закрыть",lang),getLocalizedWord("Сохранить и закрыть",lang),_ActionType.SAVE_AND_CLOSE))
		actionBar.addAction(new _Action(getLocalizedWord("Закрыть",lang),getLocalizedWord("Закрыть без сохранения",lang),_ActionType.CLOSE))
		publishElement(actionBar)

		
		
		publishEmployer("userid",  user.getUserID())
		publishValue("countdocinview", user.getCountDocInView())
		publishValue("post", user.getPost())
		publishValue("lang",lang)
		publishValue("skin", user.getSkin())
		publishEmployer("email", user.getEmail())
		publishEmployer("shortname", user.getShortName())
		
		
	}


	@Override
	public void doQueryOpen(_Session ses, _Document doc, _WebFormData webFormData, String lang) {
		
		def emp = ses.getCurrentAppUser()
		def nav = ses.getPage("outline", webFormData)
		publishElement(nav)
		
		def actionBar = new _ActionBar(ses)
		
		if(doc.getEditMode() == _DocumentModeType.EDIT){
			actionBar.addAction(new _Action(getLocalizedWord("Сохранить и закрыть",lang),getLocalizedWord("Сохранить и закрыть",lang),_ActionType.SAVE_AND_CLOSE))
		}
		
		actionBar.addAction(new _Action(getLocalizedWord("Закрыть",lang),getLocalizedWord("Закрыть без сохранения",lang),_ActionType.CLOSE))
		publishElement(actionBar)
		
		publishValue("title",getLocalizedWord("Сотрудник ", lang))
		publishValue("post", emp.getPostID(), emp.getPost())  
		def dep = emp.getMainDepartment();
		publishValue("department", dep.getShortName())
		publishValue("userid",emp.getValueString("userid"))
		publishValue("countdocinview",emp.getValueString("countdocinview"))
		publishValue("lang",emp.getValueString("lang"))
		publishEmployer("skin",doc.getValueString("skin"))
		publishValue("email",doc.getValueString("email"))
		publishValue("shortname",emp.getValueString("shortname"))
		publishEmployer("fullname", emp.getUserID())
		publishValue("instmsgaddress",doc.getValueString("instmsgaddress"))
		
	
	}

}