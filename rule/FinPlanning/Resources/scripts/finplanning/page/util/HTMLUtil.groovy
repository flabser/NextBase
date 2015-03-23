package finplanning.page.util

import kz.nextbase.script._Session
import kz.nextbase.script._Tag
import kz.nextbase.script._XMLDocument


final class HTMLUtil {

	public static def getGlossariesSelectXML(_Session ses, String form, String formula, String valueAttr,
			String selectedValue, boolean withResponse) {

		def gcoll = ses.getCurrentDatabase().getCollectionOfGlossaries(formula, 0, 0)
		def glossaries = new _Tag("glossaries", "")
		def rootTag = new _Tag("select", "")
		rootTag.setAttr("name", form)

		boolean isId = valueAttr == "id"

		rootTag.addTag(new _Tag("option", ""))

		gcoll.getEntries().each {
			def gdoc = it.getDocument()
			//
			def etag = new _Tag("option")
			if(isId){
				etag.setAttr("value", gdoc.getID())
				if(gdoc.getID().equals(selectedValue)){
					etag.setAttr("selected", "selected")
				}
			} else {
				etag.setAttr("value", gdoc.getDocID())
				if(String.valueOf(gdoc.getDocID()).equals(selectedValue)){
					etag.setAttr("selected", "selected")
				}
			}

			etag.setAttr("data-id", gdoc.getID())
			etag.setAttr("data-docid", gdoc.getDocID())
			etag.setTagValue(gdoc.getViewText())
			rootTag.addTag(etag)
			if(withResponse){
				def resp = gdoc.getResponses()
				if(resp.size() > 0){
					def responses = new _Tag("optgroup")
					responses.setAttr("label", gdoc.getViewText())
					responses.addTag(new _Tag("option", ""))
					for(def d in resp){
						def rentry = new _Tag("option", d.getViewText())
						if(isId){
							rentry.setAttr("value", d.getID())
							if(d.getID().equals(selectedValue)){
								rentry.setAttr("selected", "selected")
							}
						} else {
							rentry.setAttr("value", d.getDocID())
							if(String.valueOf(d.getDocID()).equals(selectedValue)){
								rentry.setAttr("selected", "selected")
							}
						}

						rentry.setAttr("data-id", d.getID())
						rentry.setAttr("data-docid", d.getDocID())
						responses.addTag(rentry)
					}
					rootTag.addTag(responses)
				}
			}
		}
		glossaries.addTag(rootTag)

		return new _XMLDocument(glossaries)
	}
}
