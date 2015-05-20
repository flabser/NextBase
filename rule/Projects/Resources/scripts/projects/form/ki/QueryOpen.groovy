package projects.form.ki

import kz.nextbase.script.*
import kz.nextbase.script.actions.*
import kz.nextbase.script.events.*

class QueryOpen extends _FormQueryOpen {

	@Override
	public void doQueryOpen(_Session session, _WebFormData webFormData, String lang) {
		publishValue("title",getLocalizedWord("Карточка исполнения", lang))
		publishEmployer("docauthor", session.currentUserID);
		publishValue("docdate", session.getCurrentDateAsString())
		def nav = session.getPage("outline", webFormData)
		publishElement(nav)
	//	publishElement(getActionBar(session))
		
		def actionBar = new _ActionBar(session)
		actionBar.addAction(new _Action(getLocalizedWord("Сохранить и закрыть", lang), getLocalizedWord("Сохранить и закрыть", lang),_ActionType.SAVE_AND_CLOSE))
		actionBar.addAction(new _Action(getLocalizedWord("Закрыть", lang), getLocalizedWord("Закрыть без сохранения",lang), _ActionType.CLOSE))
		publishElement(actionBar)
	}


	@Override
	public void doQueryOpen(_Session session, _Document doc, _WebFormData webFormData, String lang) {
		
		publishValue("title",getLocalizedWord("Карточка исполнения", lang))
		publishEmployer("docauthor",doc.getAuthorID());
		publishValue("docdate", _Helper.getDateAsString(doc.getRegDate()))
		publishValue("report", doc.getValueString("report"))
		def pdoc = doc.getParentDocument()
		publishValue("parentdocid",doc.getDocID().toString())
		publishValue("parentdoctype",doc.getDocType().toString())
		/*publishValue("version",doc.getValueNumber("version"))*/ 
		/*publishValue("status", doc.getValueString("status"))*/
		publishValue("link_to_demand", pdoc.getURL())
		publishValue("viewtext_parentdemand", pdoc.getViewText());
		def nav = session.getPage("outline", webFormData)
		publishElement(nav)
		//publishElement(getActionBar(session, doc))
		try{
			publishAttachment("rtfcontent","rtfcontent")
		}catch(Exception e){
		
		}
		
		def actionBar = new _ActionBar(session)
		def cuserID = session.getCurrentAppUser().getUserID();
		//def pdoc = doc.getParentDocument()
		def pauthor  = pdoc.getValueString('docauthor')
		def user = session.getCurrentAppUser();
		if(cuserID == pauthor && user.hasRole("registrator_demand")){
			actionBar.addAction(new _Action(getLocalizedWord("Новая заявка", lang),getLocalizedWord("Новая заявка", lang), "NEW_DOCUMENT"))
		}
		if(user.hasRole("supervisor")){
			actionBar.addAction(new _Action(_ActionType.GET_DOCUMENT_ACCESSLIST))
		}
		actionBar.addAction(new _Action(getLocalizedWord("Закрыть", lang),getLocalizedWord("Закрыть без сохранения", lang),_ActionType.CLOSE))
		publishElement(actionBar)
	}

	/*private getActionBar(_Session session, _Document doc){
		def actionBar = new _ActionBar(session)
		def cuserID = session.getCurrentAppUser().getUserID();
		def pdoc = doc.getParentDocument()
		def pauthor  = pdoc.getValueString('docauthor')
		if(cuserID == pauthor){
			actionBar.addAction(new _Action("Новая заявка","Новая заявка", "NEW_DOCUMENT"))
		}	
		actionBar.addAction(new _Action("Закрыть","Закрыть без сохранения",_ActionType.CLOSE))
		return actionBar
	}
	
	private getActionBar(_Session session){
		
		def actionBar = new _ActionBar(session)		
		actionBar.addAction(new _Action("Сохранить и закрыть","Сохранить и закрыть",_ActionType.SAVE_AND_CLOSE))
		actionBar.addAction(new _Action("Закрыть","Закрыть без сохранения",_ActionType.CLOSE))
		
		return actionBar
	}*/

}