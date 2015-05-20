package projects.handler.grant_read_access_to_observers_in_prj

import kz.nextbase.script._Session;
import kz.nextbase.script._ViewEntry
import kz.nextbase.script._WebFormData;
import kz.nextbase.script.events._DoHandler;

class Trigger extends _DoHandler {

	@Override
	public void doHandler(_Session session, _WebFormData formData) {
		log("Start handler " + getClass().getName())
		def formName = "project"
		def d = 0
		def db = session.getCurrentDatabase()
		def col = db.getCollectionOfDocuments("form='" + formName + "'", false).getEntries()
		col.each { _ViewEntry entry ->
			d ++
			def doc = entry.getDocument()
			doc.clearReaders()
			def observers = doc.getValueList("observer")
			doc.addReaders(observers)
			if (doc.save()){
				def pCol = db.getCollectionOfDocuments("form='demand' and viewtext1='" + doc.getValueString("project_name") + "'" , false).getEntries()
				pCol.each { _ViewEntry pEntry ->
					def pDoc = pEntry.getDocument()
					pDoc.clearReaders()
					pDoc.addReader(pDoc.getValueString("executer"))
					pDoc.addReaders(observers)
					pDoc.save()
					println(" project " + doc.getValueString("project_name"))
				}
				
			}
			log(" Grant was given " + doc.getID())
		}
		log("Stop handler " + getClass().getName() + ", processed " + d + " documents")


	}



}
