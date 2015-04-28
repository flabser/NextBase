package form.contract

import kz.nextbase.script.*
import kz.nextbase.script.actions._Action
import kz.nextbase.script.actions._ActionBar
import kz.nextbase.script.actions._ActionType
import kz.nextbase.script.constants._DocumentModeType
import kz.nextbase.script.coordination._BlockCollection
import kz.nextbase.script.events._FormQueryOpen

class QueryOpen extends _FormQueryOpen {

	
	@Override
	public void doQueryOpen(_Session ses, _WebFormData webFormData, String lang) {
		def user = ses.getCurrentAppUser()
		
		def nav = ses.getPage("outline", webFormData)
		publishElement(nav)
		
		def actionBar = ses.createActionBar();
		actionBar.addAction(new _Action(getLocalizedWord("Сохранить и закрыть",lang),getLocalizedWord("Сохранить и закрыть",lang),_ActionType.SAVE_AND_CLOSE))
		actionBar.addAction(new _Action(getLocalizedWord("Закрыть",lang),getLocalizedWord("Закрыть без сохранения",lang),_ActionType.CLOSE))
		publishElement(actionBar)

		publishValue("title",getLocalizedWord("Новый договор от", lang))
		publishEmployer("author", ses.getCurrentAppUser().getUserID())
		publishValue("dvn", ses.getCurrentDateAsString())
		publishValue("ctrldate", ses.getCurrentDateAsString(30))
	}


	@Override
	public void doQueryOpen(_Session ses, _Document doc, _WebFormData webFormData, String lang) {
		def user = ses.getCurrentAppUser()
		
		def nav = ses.getPage("outline", webFormData)
		publishElement(nav)
		
		def actionBar = new _ActionBar(ses)
		def show_compose_actions = false
		/*def recipients = doc.getValueList("recipients")*/
		
		if(doc.getEditMode() == _DocumentModeType.EDIT && user.hasRole("registrator_outgoing")){
			if(doc.getValueString("vn") != ''){
				actionBar.addAction(new _Action(getLocalizedWord("Сохранить и закрыть",lang),getLocalizedWord("Сохранить и закрыть",lang),_ActionType.SAVE_AND_CLOSE))
			}else{
				actionBar.addAction(new _Action(getLocalizedWord("Зарегистрировать документ",lang),getLocalizedWord("Зарегистрировать документ",lang),_ActionType.SAVE_AND_CLOSE))
			}
		}
		if(user.hasRole("supervisor")){
			actionBar.addAction(new _Action(_ActionType.GET_DOCUMENT_ACCESSLIST))
		}
		if(doc.getAuthorID() == user.getUserID()){
			actionBar.addAction(new _Action(getLocalizedWord("Ознакомить",lang),getLocalizedWord("Ознакомить",lang),"acquaint"))
		}
		actionBar.addAction(new _Action(getLocalizedWord("Закрыть",lang),getLocalizedWord("Закрыть без сохранения",lang),_ActionType.CLOSE))
		publishElement(actionBar)
		def doctitle = "Договор"
		publishValue("title",getLocalizedWord(doctitle, lang) +  " № "+ doc.getValueString("vn") +" " + getLocalizedWord("от", lang) + " " + doc.getValueString("dvn"))
		publishEmployer("author",doc.getAuthorID())
		publishValue("vn",doc.getValueString("vn"))
		publishValue("dvn",doc.getValueString("dvn"))
		publishValue("numcontractor",doc.getValueString("numcontractor"))
		publishValue("datecontractor",doc.getValueString("datecontractor"))
		publishValue("contractsubject",doc.getValueString("contractsubject"))
		publishValue("totalamount",doc.getValueString("totalamount"))
		publishValue("contracttime",doc.getValueString("contracttime"))
		publishValue("controldate",doc.getValueString("controldate"))
		publishValue("corrstring",doc.getValueString("corrstring"))
		
		publishValue("comments",doc.getValueString("comments"))
		if (doc.getField("initdivision") != null) {
			publishDepartment("initdivision", doc.getValueString("initdivision") as int)
		}
		if (doc.getField("contracttype")) {
			publishGlossaryValue("contracttype",doc.getValueGlossary("contracttype"))
		}
		if (doc.getField("currency")) {
			publishGlossaryValue("currency",doc.getValueGlossary("currency"))
		}
		if (doc.getField("contractor")) {
			publishGlossaryValue("contractor",doc.getValueGlossary("contractor"))
		}
		publishEmployer("initemp", doc.getValueString("initemp"))
		publishValue("briefcontent",doc.getValueString("briefcontent"))
		publishGlossaryValue("contracttype",doc.getValueNumber("contracttype"))
		try{
			publishAttachment("rtfcontent","rtfcontent")
		}catch(_Exception e){

		}
		try{
			def parentdoc = doc.getParentDocument();
			def	blockCollection  = (_BlockCollection)parentdoc.getValueObject("coordination")
			publishValue("coordination", blockCollection)
		}catch(_Exception e){
		
		}
		publishValue("contentsource",doc.getValueString("contentsource"))
		def link  = (_CrossLink)doc.getValueObject("link")
		publishValue("link", link)


	}
	
	/*private Collection<String> getRecipient(_Document doc){
		def recipients = doc.getValueList("recipient");
		return recipients
	}*/

}