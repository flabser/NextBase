package projects.form.demand_type

import kz.nextbase.script.*
import kz.nextbase.script.actions.*
import kz.nextbase.script.events.*

class QueryOpen extends _FormQueryOpen {

	@Override
	public void doQueryOpen(_Session session, _WebFormData webFormData, String lang) {
		
		def actionBar = session.createActionBar();
		actionBar.addAction(new _Action(getLocalizedWord("Сохранить и закрыть", lang),getLocalizedWord("Сохранить и закрыть", lang),_ActionType.SAVE_AND_CLOSE))
		actionBar.addAction(new _Action(getLocalizedWord("Закрыть", lang),getLocalizedWord("Закрыть без сохранения",lang), _ActionType.CLOSE))
		publishElement(actionBar)
		
		publishValue("title",getLocalizedWord("Тип заявки", lang))

		def nav = session.getPage("outline", webFormData)
		publishElement(nav)
		//publishElement(getActionBar(session))
		publishEmployer("docauthor", session.currentUserID);
		publishValue("docdate", session.getCurrentDateAsString());

	}


	@Override
	public void doQueryOpen(_Session session, _Document doc, _WebFormData webFormData, String lang) {
		def glos = (_Glossary)doc
		def regDate = doc.getRegDate();
		
		def actionBar = session.createActionBar();
		actionBar.addAction(new _Action(getLocalizedWord("Сохранить и закрыть", lang), getLocalizedWord("Сохранить и закрыть", lang), _ActionType.SAVE_AND_CLOSE))
		actionBar.addAction(new _Action(getLocalizedWord("Закрыть", lang),getLocalizedWord("Закрыть без сохранения",lang), _ActionType.CLOSE))
		publishElement(actionBar)
		
		publishValue("title",getLocalizedWord("Тип заявки", lang) + ":" + glos.getViewText())
		publishEmployer("docauthor", doc.getAuthorID())
		publishValue("name",doc.getValueString("name"))
		publishValue("docdate",_Helper.getDateAsString(regDate))
		def nav = session.getPage("outline", webFormData)
		publishElement(nav)
        def roleTag = new _Tag();
        glos.getValueString("role").split("#").each{
            roleTag.addTag(new _Tag("entry", it))
        }
        def xml = new _XMLDocument(roleTag)
        publishValue("role", xml);
	}
}
 
