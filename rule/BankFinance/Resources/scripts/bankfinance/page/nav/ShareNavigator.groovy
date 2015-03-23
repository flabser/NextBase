package bankfinance.page.nav

import kz.nextbase.script.*
import kz.nextbase.script.events._DoScript
import kz.nextbase.script.outline.*


class ShareNavigator extends _DoScript {

	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {

		def list = []
		def user = session.getCurrentAppUser()
		def outline = new _Outline("", "", "outline")

		def operations_outline = new _Outline(getLocalizedWord("Операции", lang),
				getLocalizedWord("Операции", lang),
				"bankoperations")
		def cash = new _OutlineEntry(getLocalizedWord("Все", lang),
				getLocalizedWord("Все", lang),
				"allbankoperations",
				"Provider?type=page&id=allbankoperations&page=0")
		def documents = session.currentDatabase.getCollectionOfGlossaries("form='bank_account'", 0, 0)
		documents.getEntries().each {
			def document = it.getDocument()
			cash.addEntry(new _OutlineEntry(document.getValueString("name"),
					document.getValueString("name"),
					document.getValueString("name"),
					"Provider?type=page&id=bankoperationsbyaccount&bank_account=" + it.getID() + "&page=0"))
		}
		operations_outline.addEntry(cash)
		outline.addOutline(operations_outline)
		list.add(operations_outline)

		if (user.hasRole("administrator")){
			def glossary_outline = new _Outline(getLocalizedWord("Справочники", lang),
					getLocalizedWord("Справочники", lang),
					"glossary")
			glossary_outline.addEntry(new _OutlineEntry(getLocalizedWord("Расчетный счет", lang),
					getLocalizedWord("Расчетный счет", lang),
					"bank_account",
					"Provider?type=page&id=bank_account"))
			outline.addOutline(glossary_outline)
			list.add(glossary_outline)
		}

		setContent(list)
	}
}
