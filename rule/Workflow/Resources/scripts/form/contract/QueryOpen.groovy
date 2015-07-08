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
		
		if(doc.getEditMode() == _DocumentModeType.EDIT && user.hasRole("registrator_contract")){
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
		if(user.hasRole("registrator_act")){
			actionBar.addAction(new _Action(getLocalizedWord("Акт",lang),getLocalizedWord("Акт",lang),"compose_act"))
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
		publishValue("kazcontent",doc.getValueString("kazcontent"))
		publishValue("contractsubject",doc.getValueString("contractsubject"))
		publishValue("totalamount",doc.getValueString("totalamount"))
		publishValue("contracttime",doc.getValueString("contracttime"))
		publishValue("controldate",doc.getValueString("controldate"))
		publishEmployer("curator",doc.getValueString("curator"))
		publishValue("comments",doc.getValueString("comments"))
		publishValue("contractsignedwith",doc.getValueString("contractsignedwith"))



		if (doc.getField("contractor_one")) {
			publishGlossaryValue("contractor_one",doc.getValueNumber("contractor_one"))
		}
		if (doc.getField("contractor_two")) {
			publishGlossaryValue("contractor_two",doc.getValueNumber("contractor_two"))
		}
		publishValue("briefcontent",doc.getValueString("briefcontent"))
		try{
			publishAttachment("rtfcontent","rtfcontent")
		}catch(_Exception e){

		}
		if(doc.getField("parentdocid") && doc.getValueNumber("parentdocid") != 0){
			try{
				def parentdoc = doc.getParentDocument();
				def	blockCollection  = (_BlockCollection)parentdoc.getValueObject("coordination")
				publishValue("coordination", blockCollection)
			}catch(_Exception e){

			}
		}
		publishValue("contentsource",doc.getValueString("contentsource"))
		def link  = (_CrossLink)doc.getValueObject("link")
		publishValue("link", link)


	}
}