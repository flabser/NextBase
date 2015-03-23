package cashtracker.page.actions

import kz.nextbase.script.*
import kz.nextbase.script.events._DoScript
import kz.nextbase.script.outline.*

class DeleteDocument extends _DoScript {

	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {

		def deletedList = []
		def unDeletedList = []

		def db = session.getCurrentDatabase()
		def documentid_col = formData.getListOfValuesSilently("docid")
		for(def id : documentid_col){
			try {
				def doc = db.getDocumentByID(id)
				def viewText = doc.getViewText()

				try {
					def parentDoc = doc.getParentDocument()
					if(parentDoc != null){
						if(db.deleteDocument(parentDoc.getID(), true)){
							deletedList << new _Tag("entry", parentDoc.getViewText())
						} else {
							unDeletedList << new _Tag("entry", parentDoc.getViewText())
						}
					}
				} catch(_Exception e) {
					unDeletedList << new _Tag("entry", viewText)
				}

				try {
					def docResponses = doc.getResponses()
					docResponses.each {
						if(db.deleteDocument(it.getID(), true)){
							deletedList << new _Tag("entry", it.getViewText())
						} else {
							unDeletedList << new _Tag("entry", it.getViewText())
						}
					}
				} catch(_Exception e) {
					unDeletedList << new _Tag("entry", viewText)
				}

				try {
					if(db.deleteDocument(id, true)){
						deletedList << new _Tag("entry", viewText)
					}else{
						unDeletedList << new _Tag("entry", viewText)
					}
				} catch(_Exception e) {
					println(e)
					unDeletedList << new _Tag("entry", viewText)
				}
			} catch(_Exception e) {
				unDeletedList << new _Tag("entry", "error=" + e.getMessage())
			}
		}

		def rootTag = new _Tag(formData.getValue("id"), "")
		def d = new _Tag("deleted", deletedList)
		d.setAttr("count", deletedList.size())
		rootTag.addTag(d)
		def ud = new _Tag("undeleted", unDeletedList)
		ud.setAttr("count", unDeletedList.size())
		rootTag.addTag(ud)

		def xml = new _XMLDocument(rootTag)
		//println(xml)
		setContent(xml)
	}
}
