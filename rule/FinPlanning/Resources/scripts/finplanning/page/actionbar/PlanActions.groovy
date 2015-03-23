package finplanning.page.actionbar

import kz.nextbase.script.*
import kz.nextbase.script.actions.*
import kz.nextbase.script.events._DoScript

class PlanActions extends _DoScript {

	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {

		def actionBar = new _ActionBar(session)
		def user = session.getCurrentAppUser()

		if (user.hasRole(["plan_operations"])){
			String pageId = formData.getValue("id")

			if(pageId == "all-plans" || pageId == "all-income"){
				def newIncome = new _Action(getLocalizedWord("Receiving", lang),
						getLocalizedWord("Receiving", lang), "new_document")
				newIncome.setURL("Provider?type=edit&id=income&key=")
				actionBar.addAction(newIncome)
			}

			if(pageId == "all-plans" || pageId == "all-expense"){
				def newExpense = new _Action(getLocalizedWord("Expenses", lang),
						getLocalizedWord("Expenses", lang), "new_document")
				newExpense.setURL("Provider?type=edit&id=expense&key=")
				actionBar.addAction(newExpense)
			}

			actionBar.addAction(new _Action(getLocalizedWord("Delete", lang),
					getLocalizedWord("Delete", lang), _ActionType.DELETE_DOCUMENT))
		}

		setContent(actionBar)
	}
}
