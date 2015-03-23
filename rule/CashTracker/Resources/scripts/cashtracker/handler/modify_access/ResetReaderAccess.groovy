package cashtracker.handler.modify_access

import kz.nextbase.script._Session
import kz.nextbase.script._ViewEntry
import kz.nextbase.script._WebFormData
import kz.nextbase.script.events._DoHandler

class ResetReaderAccess extends _DoHandler {

	@Override
	public void doHandler(_Session session, _WebFormData formData) {
		//def formName = formData.getValueSilently("form")
		def formName = "operation"
		def db = session.getCurrentDatabase()
		def col = db.getCollectionOfDocuments("form='" + formName + "'", false).getEntries()
		col.each { _ViewEntry entry ->
			def doc = entry.getDocument()
			doc.clearReaders()
			doc.save()
			log("Reader access was reseted " + doc.getID())
		}
	}
}
