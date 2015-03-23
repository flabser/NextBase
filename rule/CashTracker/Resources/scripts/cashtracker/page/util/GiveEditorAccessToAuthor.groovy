package cashtracker.page.util

import kz.nextbase.script._Session;
import kz.nextbase.script._ViewEntry
import kz.nextbase.script._WebFormData;
import kz.nextbase.script.events._DoScript;

/**
* Page grant editor access to author of the document 
*
* @author  Kairat
*/

class GiveEditorAccessToAuthor extends _DoScript {

	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {
		def formName = formData.getValueSilently("form")
		def db = session.getCurrentDatabase()
		def col = db.getCollectionOfDocuments("form='" + formName + "'", true).getEntries()
		col.each { _ViewEntry entry ->
			def doc = entry.getDocument()
            doc.addEditor(doc.getAuthorID())
          //  doc.save("[supervisor]") 
			println("Grant was given " + doc.getID())           
		}
		
	}

}
