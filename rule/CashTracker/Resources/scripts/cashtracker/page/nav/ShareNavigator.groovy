package cashtracker.page.nav

import kz.nextbase.script.*
import kz.nextbase.script.events._DoScript
import kz.nextbase.script.outline.*

class ShareNavigator extends _DoScript {

	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {

		//println(formData);

		def list = []
		def user = session.getCurrentAppUser()
		def outline = new _Outline("", "", "outline")

		def operations_outline = new _Outline(getLocalizedWord("Операции", lang),
				getLocalizedWord("Операции", lang),
				"operations")
		def cash = new _OutlineEntry(getLocalizedWord("Все", lang),
				getLocalizedWord("Все", lang),
				"alloperations",
				"Provider?type=page&id=alloperations&page=0")
		def documents = session.currentDatabase.getCollectionOfGlossaries("form='cash'", 0, 0)
		documents.getEntries().each {
			def document = it.getDocument()
			cash.addEntry(new _OutlineEntry(document.getValueString("name"),
					document.getValueString("name"),
					document.getValueString("name"),
					"Provider?type=page&id=operationsbycash&cashid=" + document.getDocID() + "&page=0"))
		}
		operations_outline.addEntry(cash)
		outline.addOutline(operations_outline)
		list.add(operations_outline)

		if (user.hasRole("administrator")){
			def glossary_outline = new _Outline(getLocalizedWord("Справочники", lang),
					getLocalizedWord("Справочники", lang),
					"glossary")
			glossary_outline.addEntry(new _OutlineEntry(getLocalizedWord("Касса", lang),
					getLocalizedWord("Касса", lang),
					"cash",
					"Provider?type=page&id=cash"))
			glossary_outline.addEntry(new _OutlineEntry(getLocalizedWord("Тип операции", lang),
					getLocalizedWord("Тип операции", lang),
					"category",
					"Provider?type=page&id=category"))
			glossary_outline.addEntry(new _OutlineEntry(getLocalizedWord("Место возникновения", lang),
					getLocalizedWord("Место возникновения", lang),
					"costcenter",
					"Provider?type=page&id=costcenter"))
			outline.addOutline(glossary_outline)
			list.add(glossary_outline)
		}

		setContent(list)
	}
}
