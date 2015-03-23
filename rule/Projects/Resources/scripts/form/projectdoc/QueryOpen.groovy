package form.projectdoc

import java.util.Collection;
import java.util.HashMap;
import java.util.Map

import kz.flabs.runtimeobj.document.project.Recipient;
import kz.nextbase.script.*
import kz.nextbase.script.actions.*
import kz.nextbase.script.events.*;
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
		//publishValue("title",getLocalizedWord("Проектный документ", lang));
		publishEmployer("docauthor", session.currentUserID);
		publishValue("docdate", session.getCurrentDateAsString());
		
	}
	
	@Override
	public void doQueryOpen(_Session session, _Document doc, _WebFormData webFormData, String lang) {
		
		def actionBar = session.createActionBar();
		if(session.getCurrentAppUser().hasRole("supervisor")){
			actionBar.addAction(new _Action(_ActionType.GET_DOCUMENT_ACCESSLIST))
		}
		actionBar.addAction(new _Action(getLocalizedWord("Сохранить и закрыть", lang),getLocalizedWord("Сохранить и закрыть", lang),_ActionType.SAVE_AND_CLOSE))
		actionBar.addAction(new _Action(getLocalizedWord("Закрыть", lang),getLocalizedWord("Закрыть без сохранения",lang), _ActionType.CLOSE))
		publishElement(actionBar)
		
		try{
			publishValue("title",doc.getValueString("title"))
			publishEmployer("docauthor",doc.getAuthorID());
			publishEmployer("readers",getReaders(doc));
			publishEmployer("editors",getEditors(doc));
			publishValue("docdate",doc.getValueString("docdate"))
			publishValue("content", doc.getValueString("content"))
			try{
				publishAttachment("rtfcontent","rtfcontent")
			}catch(Exception e){}
			def nav = session.getPage("outline", webFormData)
			publishElement(nav)
		//	publishElement(getActionBar(session, doc))
		}catch(Exception e){}		
	}
	
	private Collection<String> getReaders(_Document doc){
		def readers = doc.getValueList("readers");
		return readers
	}
	
	private Collection<String> getEditors(_Document doc){
		def editors = doc.getValueList("editors");
		return editors
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
