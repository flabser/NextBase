package forum.page.search

import kz.nextbase.script._Session
import kz.nextbase.script._WebFormData
import kz.nextbase.script.events._DoScript
import kz.nextbase.script.actions.*

class DoScript extends _DoScript {
	
	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {
		println(formData)
		def page = 1;
		def db = session.getCurrentDatabase()
		def col = db.search(formData.getValue("keyword"), page)
		getActionBar(session, lang);
		setContent(col)
	}
	private getActionBar(_Session session, String lang){
		def actionBar = new _ActionBar(session)
 
		actionBar.addAction(new _Action(getLocalizedWord("Вернуться к списку документов", lang), getLocalizedWord("Вернуться к списку документов", lang), _ActionType.CLOSE))
		setContent(actionBar);
	}
} 
