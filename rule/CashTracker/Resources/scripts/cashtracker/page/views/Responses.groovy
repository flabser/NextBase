package cashtracker.page.views

import kz.nextbase.script._Session
import kz.nextbase.script._WebFormData
import kz.nextbase.script.events._DoScript


class Responses extends _DoScript {

	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {

		def docid = formData.getValue("docid")
		def doctype = formData.getValue("doctype")
		if(doctype == "887"){
			doctype = "894"
		}
		def viewParam = session.createViewEntryCollectionParam()
				.setPageNum(0)
				.setPageSize(0)
				.setUseFilter(true)
				.setCheckResponse(true)
				.setQuery("parentdocid = $docid and parentdoctype = $doctype")

		if(doctype == "894"){
			setContent(session.getCurrentDatabase().getCollectionOfGlossaries(viewParam))
		} else {
			setContent(session.getCurrentDatabase().getCollectionOfDocuments(viewParam))
		}
	}
}
