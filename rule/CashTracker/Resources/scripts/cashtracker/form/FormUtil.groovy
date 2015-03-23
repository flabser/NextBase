package cashtracker.form

import kz.nextbase.script._Session
import kz.nextbase.script._Tag
import kz.nextbase.script._XMLDocument


final class FormUtil {

	public static def glossariesListXML(_Session ses, String gloss_form) {

		def gcoll = ses.getCurrentDatabase().getCollectionOfGlossaries("form='$gloss_form'", 0, 0)

		def glossaries = new _Tag("glossaries", "")
		def rootTag = new _Tag(gloss_form, "")
		gcoll.getEntries().each {
			def gdoc = it.getDocument()
			//
			def etag = new _Tag("entry")
			etag.setAttr("docid", gdoc.getDocID())
			etag.setAttr("id", gdoc.getID())
			etag.setAttr("viewtext", gdoc.getViewText())
			def resp = gdoc.getResponses()
			if(resp.size() > 0){
				def responses = new _Tag("responses")
				for(def d in resp){
					def rentry = new _Tag("entry", d.getViewText())
					rentry.setAttr("id", d.getID())
					rentry.setAttr("docid", d.getDocID())
					responses.addTag(rentry)
				}
				etag.addTag(responses)
			}
			rootTag.addTag(etag)
		}
		glossaries.addTag(rootTag)

		return new _XMLDocument(glossaries)
	}
}
