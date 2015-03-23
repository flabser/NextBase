package cashtracker.form.accrual

import kz.nextbase.script.*
import kz.nextbase.script.actions.*
import kz.nextbase.script.constants.*
import kz.nextbase.script.events.*

class QueryOpen extends _FormQueryOpen {

	@Override
	public void doQueryOpen(_Session session, _WebFormData webFormData, String lang) {
		publishValue("title",getLocalizedWord("Начисление", lang))
		def user = session.getCurrentAppUser()

		def nav = session.getPage("outline", webFormData)
		publishElement(nav)

		def actionBar = session.createActionBar()
		actionBar.addAction(new _Action(getLocalizedWord("Сохранить и закрыть",lang),
				getLocalizedWord("Сохранить и закрыть",lang),_ActionType.SAVE_AND_CLOSE))
		def closeDoc = new _Action(getLocalizedWord("Закрыть", lang),
				getLocalizedWord("Закрыть без сохранения", lang), _ActionType.CLOSE)
		closeDoc.setURL(session.getLastURL())
		actionBar.addAction(closeDoc)
		publishElement(actionBar)

		def db = session.getCurrentDatabase()
		publishValue("regdate", session.getCurrentDateAsString())
		publishValue("date", session.getCurrentDateAsString())
		publishValue("month",session.getCurrentMonth())
		publishValue("year",session.getCurrentYear())
		publishEmployer("author", session.getCurrentAppUser().getUserID())
	}

	@Override
	public void doQueryOpen(_Session session, _Document doc, _WebFormData webFormData, String lang) {

		publishValue("title",getLocalizedWord("Начисление", lang))
		def user = session.getCurrentAppUser()
		def db = session.getCurrentDatabase()

		def nav = session.getPage("outline", webFormData)
		publishElement(nav)

		def actionBar =  session.createActionBar()
		if(doc.getEditMode() == _DocumentModeType.EDIT ){
			actionBar.addAction(new _Action(getLocalizedWord("Сохранить и закрыть",lang),
					getLocalizedWord("Сохранить и закрыть",lang),_ActionType.SAVE_AND_CLOSE))
		}
		def closeDoc = new _Action(getLocalizedWord("Закрыть", lang),
				getLocalizedWord("Закрыть без сохранения", lang), _ActionType.CLOSE)
		closeDoc.setURL(session.getLastURL())
		actionBar.addAction(closeDoc)
		publishElement(actionBar)

		publishValue("vn", doc.getValueString("vn"))
		publishValue("regdate", _Helper.getDateAsString(doc.getRegDate()))
		publishValue("date", _Helper.getDateAsStringShort(doc.getValueDate("date")))
		publishValue("month", doc.getValueString("month"))
		publishValue("year", doc.getValueString("year"))
		publishEmployer("personal", doc.getValueString("personal"))
		publishValue("summa", doc.getValueNumber("summa"))
		publishGlossaryValue("typeoperationstaff", doc.getValueNumber("typeoperationstaff"))
		publishEmployer("author", doc.getValueString("author"))

		try{
			publishAttachment("rtfcontent", "rtfcontent")
		}catch(_Exception e){
		}
	}
}