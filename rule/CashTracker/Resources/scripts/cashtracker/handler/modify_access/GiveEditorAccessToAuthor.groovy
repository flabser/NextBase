package cashtracker.handler.modify_access

import kz.nextbase.script._Session
import kz.nextbase.script._ViewEntry
import kz.nextbase.script._WebFormData
import kz.nextbase.script.events._DoHandler

class GiveEditorAccessToAuthor extends _DoHandler {

	@Override
	public void doHandler(_Session session, _WebFormData formData) {
		log("Start handler " + getClass().getName())
		//def formName = formData.getValueSilently("form")
		def formName = "operation"
		def d = 0
		def i = 0
		def db = session.getCurrentDatabase()
		def col = db.getCollectionOfDocuments("form='" + formName + "'", false).getEntries()
		col.each { _ViewEntry entry ->
			d ++
			def doc = entry.getDocument()
			def ai = doc.getAuthorID()
			if (!doc.getEditors().contains(ai)){
				i ++
				doc.addEditor(ai)
				doc.save()
				log(i + " Grant was given " + doc.getID())
			}
		}
		log("Stop handler " + getClass().getName() + ", processed " + d + " documents")
	}
}
