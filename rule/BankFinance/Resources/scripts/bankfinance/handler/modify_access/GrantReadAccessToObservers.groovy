package bankfinance.handler.modify_access

import kz.nextbase.script._Session
import kz.nextbase.script._ViewEntry
import kz.nextbase.script._WebFormData
import kz.nextbase.script.events._DoHandler

class GrantReadAccessToObservers extends _DoHandler {

	@Override
	public void doHandler(_Session session, _WebFormData formData) {

		log("Start handler " + getClass().getName())

		def db = session.getCurrentDatabase()
		def acc = "LOF"
		def doc = db.getGlossaryDocument("bank_account","name='" + acc + "'")
		log(doc.getName())
		def observers = doc.getValueList("observer")
		def i = 0

		def accID = doc.getID()
		def pCol = db.getCollectionOfDocuments("form='bank_operation' and bank_account='" + accID + "'" , false).getEntries()
		pCol.each { _ViewEntry pEntry ->
			def pDoc = pEntry.getDocument()
			pDoc.clearReaders()
			pDoc.addReaders(observers)
			pDoc.save("supervisor")
			i ++
		}

		log("Access was been granted to related users of \"" + acc + "\" bank operations (Processed:" + i + " documents)")
	}
}
