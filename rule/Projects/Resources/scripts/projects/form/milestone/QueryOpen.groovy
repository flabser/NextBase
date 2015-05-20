package projects.form.milestone

import kz.nextbase.script.*
import kz.nextbase.script.actions.*
import kz.nextbase.script.events.*
import kz.nextbase.script.constants.*

class QueryOpen extends _FormQueryOpen {

	@Override
	public void doQueryOpen(_Session session, _WebFormData webFormData, String lang) {
		 
		def nav = session.getPage("outline", webFormData)
		publishElement(nav)
		publishElement(getActionBar(session))
		publishValue("title",getLocalizedWord("Веха", lang));
		publishEmployer("docauthor", session.currentUserID);
		publishValue("docdate",session.getCurrentDateAsString() );
	}
	
	@Override
	public void doQueryOpen(_Session session, _Document doc, _WebFormData webFormData, String lang) {		
		try{
			publishEmployer("docauthor",doc.getAuthorID());
			publishValue("docdate",doc.getValueString("docdate"))		
			publishValue("percentage_of_completion", doc.getValueString("percentage_of_completion"));
			publishValue("description", doc.getValueString("description"));
			publishValue("current", doc.getValueString("current"));
			publishValue("startdate", doc.getValueDate("startdate"));
			publishValue("duedate", doc.getValueDate("duedate"));
			def nav = session.getPage("outline", webFormData)
			publishElement(nav)
			publishElement(getActionBar(session, doc))
							
			publishAttachment("rtfcontent","rtfcontent")

		}catch(Exception e){}		
	}
	
	private getActionBar(_Session session, _Document doc){
		def actionBar = new _ActionBar(session)
		def cuserID = session.getCurrentAppUser().getUserID();
		def user = session.getCurrentAppUser();
		if(user.hasRole("registrator_demand")){
			actionBar.addAction(new _Action("Новая заявка", "Новая заявка", "NEW_DOCUMENT"))
		}
		if(doc.getEditMode() == _DocumentModeType.EDIT){
			actionBar.addAction(new _Action("Сохранить и закрыть","Сохранить и закрыть",_ActionType.SAVE_AND_CLOSE))
		}
		if(user.hasRole("supervisor")){
			actionBar.addAction(new _Action(_ActionType.GET_DOCUMENT_ACCESSLIST))
		}
		actionBar.addAction(new _Action("Закрыть","Закрыть без сохранения",_ActionType.CLOSE))
		return actionBar
	}
	
	private getActionBar(_Session session){
		
		def actionBar = new _ActionBar(session)		
		actionBar.addAction(new _Action("Сохранить и закрыть","Сохранить и закрыть",_ActionType.SAVE_AND_CLOSE))
		actionBar.addAction(new _Action("Закрыть","Закрыть без сохранения",_ActionType.CLOSE))
		
		return actionBar
	}
}
