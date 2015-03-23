package cashtracker.page.oth

import kz.nextbase.script._Session
import kz.nextbase.script._Tag
import kz.nextbase.script._WebFormData
import kz.nextbase.script._XMLDocument
import kz.nextbase.script.events._DoScript


class GetDocumentData extends _DoScript {

	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {

		def db = session.getCurrentDatabase()

		String ddbid = formData.getValue("ddbid")
		def items = formData.getValue("items").split(",") as List

		def doc = db.getDocumentByID(ddbid)

		def rootTag = new _Tag("document-data")
		items.each {
			rootTag.addTag(new _Tag(it, doc.getValueString(it)))
		}
		setContent(new _XMLDocument(rootTag))
	}
}
