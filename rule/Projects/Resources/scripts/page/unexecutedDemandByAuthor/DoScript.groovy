
package page.unexecutedDemandByAuthor

import java.util.ArrayList;
import java.util.Map;
import kz.nextbase.script.*;
import kz.nextbase.script.events._DoScript
import kz.nextbase.script.outline._Outline
import kz.nextbase.script.outline._OutlineEntry

class DoScript extends _DoScript {

	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {
   
		//println(formData)

		def cdb = session.getCurrentDatabase()
		def struct = session.getStructure()
		
		def col = cdb.getGroupedEntries("docauthor", 1, 100)
		def user_outline = new _Outline(getLocalizedWord("Авторы",lang), getLocalizedWord("Авторы заявок",lang), "outline")		
		
		for(entry in col){
			def userID = entry.getViewText()
			def doc = struct.getEmployer(userID)
			user_outline.addEntry(new _OutlineEntry(doc.getShortName(), doc.getFullName() + " " + doc.getPost(), "author", "Provider?type=page&id=demand-unexecuted-view-by-author&docauthor=" + userID + "&page=0"))
		}
		setContent(user_outline)
	


	}

}

