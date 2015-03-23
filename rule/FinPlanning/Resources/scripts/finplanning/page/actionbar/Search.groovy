package finplanning.page.actionbar

import kz.nextbase.script.*
import kz.nextbase.script.actions.*
import kz.nextbase.script.events._DoScript

class Search extends _DoScript {

	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {

		def actionBar = new _ActionBar(session)
		def user = session.getCurrentAppUser()
		def goBack = new _Action(getLocalizedWord("Go back to a view", lang),
				getLocalizedWord("Go back to a view", lang), "history_back")
		goBack.setURL(session.getURLOfLastPage().urlAsString)
		actionBar.addAction(goBack)
		setContent(actionBar)
	}
}
