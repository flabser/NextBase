package cashtracker.handler.modify_access

import kz.nextbase.script._Session
import kz.nextbase.script._ViewEntry
import kz.nextbase.script._WebFormData
import kz.nextbase.script.events._DoHandler

class GrantReaderAccessToObserver extends _DoHandler {

	@Override
	public void doHandler(_Session session, _WebFormData formData) {
		log("Start handler " + getClass().getName())
		def formName = "operation"
		def d = 0
		def i = 0
		def toSave
		def db = session.getCurrentDatabase()
		def col = db.getCollectionOfDocuments("form='" + formName + "'", false).getEntries()
		col.each { _ViewEntry entry ->
			d ++
			toSave = false
			def doc = entry.getDocument()
			def readers = doc.getReaders()
			def cashDoc = db.getGlossaryDocument(doc.getValueNumber("cash"))
			def cashObservers = cashDoc.getValueList("observers")
			for(String ai : cashObservers){
				if (!readers.contains(ai)){
					i ++
					doc.addReader(ai)
					toSave = true
				}
			}

			if (toSave){
				doc.save()
				log(i + " Grant was given " + doc.getID())
			}
		}
		log("Stop handler " + getClass().getName() + ", processed " + d + " documents")
	}
}
