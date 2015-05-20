package projects.form.topic

import kz.nextbase.script.*
import kz.nextbase.script.actions.*
import kz.nextbase.script.events.*

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
		if (cuserID == doc.getAuthorID()) {
			actionBar.addAction(new _Action("Снять с контроля", "Снять с контроля", "RESET_CONTROL"))
			actionBar.addAction(new _Action("Отметить как не актуальное", "Отметить как не актуальное", "STOP_DOCUMENT"))
			actionBar.addAction(new _Action("Отменить заявку", "Отменить заявку", "REVOKE_DEMAND"))
			actionBar.addAction(new _Action("Продлить заявку", "Продлить заявку", "EXTEND_DEMAND"))
			if(doc.getResponses().size() == 0){
				actionBar.addAction(new _Action("Изменить содержание документа", "Изменить содержание документа", "EDITCONTENT_DEMAND"))
			}
		}
		def user = session.getCurrentAppUser();
		if (doc.isNewDoc == false && user.hasRole("registrator_demand")) {
			actionBar.addAction(new _Action("Новая заявка", "Новая заявка", "NEW_DOCUMENT"))
		}
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
