package form.project

import java.util.Collection;
import java.util.HashMap;
import java.util.Map

import kz.flabs.runtimeobj.document.project.Recipient;
import kz.nextbase.script.*
import kz.nextbase.script.actions.*
import kz.nextbase.script.events.*;
import kz.nextbase.script.struct._Employer;
import kz.nextbase.script.task._Control
import kz.nextbase.script.task._Task

class QueryOpen extends _FormQueryOpen {

	@Override
	public void doQueryOpen(_Session session, _WebFormData webFormData, String lang) {
		 
		def actionBar = session.createActionBar();
		actionBar.addAction(new _Action(getLocalizedWord("Сохранить и закрыть", lang),getLocalizedWord("Сохранить и закрыть", lang),_ActionType.SAVE_AND_CLOSE))
		actionBar.addAction(new _Action(getLocalizedWord("Закрыть", lang),getLocalizedWord("Закрыть без сохранения",lang), _ActionType.CLOSE))
		publishElement(actionBar)
		
		def nav = session.getPage("outline", webFormData)
		publishElement(nav)
	//	publishElement(getActionBar(session))
		publishValue("title",getLocalizedWord("Проект", lang));
		publishEmployer("docauthor", session.currentUserID);
		publishValue("docdate", session.getCurrentDateAsString());
		
	}
	
	@Override
	public void doQueryOpen(_Session session, _Document doc, _WebFormData webFormData, String lang) {
		
		def actionBar = session.createActionBar();
		actionBar.addAction(new _Action(getLocalizedWord("Сохранить и закрыть", lang),getLocalizedWord("Сохранить и закрыть", lang),_ActionType.SAVE_AND_CLOSE))
		actionBar.addAction(new _Action(getLocalizedWord("Закрыть", lang),getLocalizedWord("Закрыть без сохранения",lang), _ActionType.CLOSE))
		if(session.getCurrentAppUser().hasRole("supervisor")){
			actionBar.addAction(new _Action(_ActionType.GET_DOCUMENT_ACCESSLIST))
		}
		publishElement(actionBar)
		
		try{
			publishEmployer("docauthor",doc.getAuthorID());
			publishValue("docdate",doc.getValueString("docdate"))		
			publishValue("startdate",doc.getValueString("startdate"))		
			publishValue("duedate",doc.getValueString("duedate"))		
			publishValue("percentage_of_completion",doc.getValueString("percentage_of_completion"))
			//publishGlossaryValue("customer",doc.getValueString("customer").toInteger())
			publishEmployer("manager", doc.getValueString("manager"))
			publishEmployer("programmer", doc.getValueString("programmer"))
			publishOrganization("customer", doc.getValueString("customer") as int)
			//publishEmployer("customer_emp", doc.getValueString("customer_emp"))
            publishEmployer("customer_emp", doc.getValueList("customer_emp"))
			publishEmployer("tester", doc.getValueString("tester"))
			publishValue("project_name",doc.getValueString("project_name"))
			publishValue("comment_to_poligon",doc.getValueString("comment_to_poligon"))
			def projectDocs = session.currentDatabase.getDocsCollection("form='projectDoc' and parentdocid='"+ doc.docID +"' and parentdoctype='"+doc.getDocType() +"'", 0, 0)
			for (int i = 0; i < projectDocs.count; i++) {
                publishValue("projectDocTitle",projectDocs.getNthDocument(i).getValueString("title"))
                publishValue("projectDocURL",projectDocs.getNthDocument(i).getURL())
            }

			publishEmployer("observer", getObservers(doc))
			publishValue("link_to_poligon",doc.getValueString("link_to_poligon"))
			def nav = session.getPage("outline", webFormData)
			publishElement(nav)
			publishAttachment("rtfcontent","rtfcontent")
		}catch(Exception e){
        }
        try {
            publishValue("status", doc.getValueNumber("status"))
        }catch (Exception e){}
	}
	
	private Collection<String> getObservers(_Document doc){
		def observers = doc.getValueList("observer");
		return observers
	}
	
	/*private getActionBar(_Session session, _Document doc){
		def actionBar = new _ActionBar(session)
		def cuserID = session.getCurrentAppUser().getUserID();
		actionBar.addAction(new _Action("Сохранить и закрыть","Сохранить и закрыть",_ActionType.SAVE_AND_CLOSE))
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
