package page.unexecutedDemandByExecutor

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
		
		def col = cdb.getGroupedEntries("executer", 1, 100)		
		def user_outline = new _Outline(getLocalizedWord("Исполнители",lang), getLocalizedWord("Исполнители заявок",lang), "outline")		
		
		for(entry in col){
			def userID = entry.getViewText()
			def doc = struct.getEmployer(userID)
			user_outline.addEntry(new _OutlineEntry(doc.getShortName(), doc.getFullName() + " " + doc.getPost(), "executor", "Provider?type=page&id=demand-unexecuted-view-by-executor&executor=" + userID + "&page=0"))
		}
		setContent(user_outline)
	}

}




