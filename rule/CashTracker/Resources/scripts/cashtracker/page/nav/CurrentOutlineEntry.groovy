package cashtracker.page.nav

import kz.nextbase.script.*
import kz.nextbase.script.events._DoScript

class CurrentOutlineEntry extends _DoScript {

	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {

		//println(formData)

		def rootTag = new _Tag()
		def entryTag = new _Tag("entry", formData.getEncodedValueSilently("title"))
		entryTag.setAttr("entryid", formData.getValueSilently("entryid"))
		entryTag.setAttr("id", formData.getValueSilently("id"))

		if(formData.getEncodedValueSilently("id") == "search"){
			def searchTag = new _Tag("search", formData.getEncodedValueSilently("keyword"))
			searchTag.setAttr("search", formData.getEncodedValueSilently("keyword"))
			rootTag.addTag(searchTag)
			def customParam = new _Tag("customparam", "&keyword=" + formData.getEncodedValueSilently("keyword"))
			rootTag.addTag(customParam)
		}
		if(formData.getEncodedValueSilently("id") == "operationsbycash"){
			def customParam = new _Tag("customparam", "&cashid=" + formData.getValueSilently("cashid"))
			rootTag.addTag(customParam)
		}

		rootTag.addTag(entryTag)
		setContent(new _XMLDocument(rootTag))
	}
}
