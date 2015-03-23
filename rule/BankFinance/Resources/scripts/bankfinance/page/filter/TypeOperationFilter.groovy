package bankfinance.page.filter

import kz.nextbase.script._Session
import kz.nextbase.script._Tag
import kz.nextbase.script._WebFormData
import kz.nextbase.script._XMLDocument
import kz.nextbase.script.events._DoScript


class TypeOperationFilter extends _DoScript {

	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {

		def typeTag = new _Tag("category", "")
		typeTag.setAttr("title", getLocalizedWord("Type of the operation", lang))
		String sf = "form = 'category' and category_refers_to != 'cash' and category_refers_to != 'hidden'"
		def docs = session.currentDatabase.getCollectionOfGlossaries(sf, 0, 0)
		docs.getEntries().each {
			def document = it.getDocument()
			def entryTag = new _Tag("entry", document.getValueString("name"))
			entryTag.setAttr("id", document.getID())
			typeTag.addTag(entryTag)
		}

		setContent(new _XMLDocument(typeTag))
	}
}
