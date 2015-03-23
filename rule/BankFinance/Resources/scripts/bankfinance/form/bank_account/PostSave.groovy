package bankfinance.form.bank_account

import kz.nextbase.script._Document
import kz.nextbase.script._Session
import kz.nextbase.script._ViewEntry
import kz.nextbase.script.events._FormPostSave

class PostSave extends _FormPostSave {

	@Override
	public void doPostSave(_Session ses, _Document doc) {

		def db = ses.getCurrentDatabase()
		def observers = doc.getValueList("observers")
		def i = 0

		def acc = doc.getID()
		def pCol = db.getCollectionOfDocuments("form='bank_operation' and bank_account='$acc'", false).getEntries()
		pCol.each { _ViewEntry pEntry ->
			def pDoc = pEntry.getDocument()
			pDoc.clearReaders()
			pDoc.addReaders(observers)
			pDoc.save("supervisor")
			i++
		}

		log("""Access was been granted to related users of "$acc" bank operations (Processed: $i documents)""")
	}
}
