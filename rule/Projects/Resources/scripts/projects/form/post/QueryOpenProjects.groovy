package projects.form.post

import kz.nextbase.script.*
import kz.nextbase.script.actions.*
import kz.nextbase.script.events.*

class QueryOpenProjects extends _FormQueryOpen {

	@Override
	public void doQueryOpen(_Session session, _WebFormData webFormData, String lang) {
		publishValue("title",getLocalizedWord("Должность", lang))

		def nav = session.getPage("outline", webFormData)
		publishElement(nav)
		publishElement(getActionBar(session))
	}


	@Override
	public void doQueryOpen(_Session session, _Document doc, _WebFormData webFormData, String lang) {
		def glos = (_Glossary)doc
		publishValue("title",getLocalizedWord("Должность", lang) + ":" + glos.getViewText())
		publishEmployer("author",glos.getAuthorID())
		publishValue("name",glos.getName())
		publishValue("code",glos.getCode())
		publishValue("ranktext",glos.getRankText())
				
		def nav = session.getPage("outline", webFormData)
		publishElement(nav)
		publishElement(getActionBar(session))
	}

	private getActionBar(_Session session){
		def actionBar = new _ActionBar()

		def user = session.getCurrentAppUser()
		if (user.hasRole("administrator")){
			actionBar.addAction(new _Action("Сохранить и закрыть","Сохранить и закрыть",_ActionType.SAVE_AND_CLOSE))
			actionBar.addAction(new _Action("Закрыть","Закрыть без сохранения",_ActionType.CLOSE))
		}
		return actionBar

	}

}