package form.act

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
		def pDoc
		if (webFormData.containsField("parentdocid") && webFormData.containsField("parentdoctype") && webFormData.getValue("parentdocid") != '0') {
			int pdocid = Integer.parseInt(webFormData.getValueSilently("parentdocid"))
			int pdoctype = Integer.parseInt(webFormData.getValueSilently("parentdoctype"))
			pDoc = ses.getCurrentDatabase().getDocumentByComplexID(pdoctype, pdocid);
			publishValue("contractnumber", pDoc.getValueString("vn"))
			publishValue("contractdate", pDoc.getValueString("dvn"))
			if (pDoc.getField("contractor_one")) {
				publishGlossaryValue("contractor_one",pDoc.getValueNumber("contractor_one"))
			}
			if (pDoc.getField("contractor_two")) {
				publishGlossaryValue("contractor_two",pDoc.getValueNumber("contractor_two"))
			}
		}
		publishValue("title",getLocalizedWord("Новый акт от", lang))
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
		
		if(doc.getEditMode() == _DocumentModeType.EDIT && user.hasRole("registrator_act")){
			actionBar.addAction(new _Action(getLocalizedWord("Сохранить и закрыть",lang),getLocalizedWord("Сохранить и закрыть",lang),_ActionType.SAVE_AND_CLOSE))
		}
		if(user.hasRole("supervisor")){
			actionBar.addAction(new _Action(_ActionType.GET_DOCUMENT_ACCESSLIST))
		}
		if(doc.getAuthorID() == user.getUserID()){
			actionBar.addAction(new _Action(getLocalizedWord("Ознакомить",lang),getLocalizedWord("Ознакомить",lang),"acquaint"))
		}
		if(doc.getValueString("responsible") == user.getUserID()){
			actionBar.addAction(new _Action(getLocalizedWord("Отметка",lang),getLocalizedWord("Отметка",lang),"compose_mark"))
		}
		actionBar.addAction(new _Action(getLocalizedWord("Закрыть",lang),getLocalizedWord("Закрыть без сохранения",lang),_ActionType.CLOSE))
		publishElement(actionBar)
		def doctitle = "Акт"
		publishValue("title",getLocalizedWord(doctitle, lang) +  " № "+ doc.getValueString("vn") +" " + getLocalizedWord("от", lang) + " " + doc.getValueString("dvn"))
		publishEmployer("author",doc.getAuthorID())
		publishValue("vn",doc.getValueString("vn"))
		publishValue("dvn",doc.getValueString("dvn"))
		publishValue("numcontractor",doc.getValueString("numcontractor"))
		publishValue("totalamount",doc.getValueString("totalamount"))
		publishValue("startexecperiod",doc.getValueString("startexecperiod"))
		publishValue("endexecperiod",doc.getValueString("endexecperiod"))
		publishEmployer("responsible",doc.getValueString("responsible"))
        publishValue("numinvoice",doc.getValueString("numinvoice"))
		//publishValue("comments",doc.getValueString("comments"))
        def pDoc;
		if (doc.getField("parentdocid") && doc.getValueNumber("parentdocid") != 0) {
			pDoc = doc.getParentDocument()
			publishValue("contractnumber", pDoc.getValueString("vn"))
			publishValue("contractdate", pDoc.getValueString("dvn"))
			if (pDoc.getField("contractor_one")) {
				publishGlossaryValue("contractor_one",pDoc.getValueNumber("contractor_one"))
			}
			if (pDoc.getField("contractor_two")) {
				publishGlossaryValue("contractor_two",pDoc.getValueNumber("contractor_two"))
			}
		}
		//publishValue("briefcontent",doc.getValueString("briefcontent"))
		try{
			publishAttachment("rtfcontent","rtfcontent")
		}catch(_Exception e){

		}
		publishValue("contentsource",doc.getValueString("contentsource"))
	}
}