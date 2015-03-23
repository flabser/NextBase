package forum.form.topic

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
		actionBar.addAction(new _Action(getLocalizedWord("Сохранить и закрыть", lang), getLocalizedWord("Сохранить и закрыть", lang), _ActionType.SAVE_AND_CLOSE))
		actionBar.addAction(new _Action(getLocalizedWord("Закрыть", lang), getLocalizedWord("Закрыть без сохранения", lang), _ActionType.CLOSE))
		publishElement(actionBar)
		def nav = session.getPage("outline", webFormData)
		publishElement(nav)
		publishValue("title", getLocalizedWord("Обсуждение", lang))
		publishEmployer("author", session.currentUserID)
		publishValue("topicdate", session.getCurrentDateAsString())
	}

	@Override
	public void doQueryOpen(_Session session, _Document doc, _WebFormData webFormData, String lang) {
		def actionBar = session.createActionBar();
		def cuserID = session.getCurrentAppUser().getUserID();

		def user = session.getCurrentAppUser();

		if(user.hasRole("supervisor")){
			actionBar.addAction(new _Action(_ActionType.GET_DOCUMENT_ACCESSLIST))
		}
		actionBar.addAction(new _Action(getLocalizedWord("Закрыть", lang), getLocalizedWord("Закрыть без сохранения", lang), _ActionType.CLOSE))
		publishElement(actionBar)

		def nav = session.getPage("outline", webFormData)
		publishElement(nav)
		publishEmployer("author", doc.getAuthorID());
		publishValue("topicdate", doc.getValueString("topicdate"))
		publishValue("theme", doc.getValueString("theme"))
	}
}
