package form.remark

import java.util.Map
import kz.nextbase.script.*
import kz.nextbase.script.events.*;
import kz.nextbase.script.task._Control
import kz.nextbase.script.task._Task

class QueryOpen extends _FormQueryOpen {

	@Override
	public void doQueryOpen(_Session ses, _WebFormData webFormData, String lang) {
		publishValue("title",getLocalizedWord("Задание", lang))
		publishValue("control", new _Control().toXML())
		publishValue("status", "new")
		publishValue("allcontrol", "1")
		publishEmployer("taskauthor",ses.getCurrentAppUser().getUserID())
		publishValue("taskdate", ses.getCurrentDateAsString())
		publishValue("ctrldate", ses.getCurrentDateAsString(30))
		publishValue("diff", "30")
		publishValue("author", ses.getCurrentAppUser().getFullName())
		publishValue("controlcycle", "1")

		def db = ses.getCurrentDatabase();
		try{
			def parentDoc = db.getDocumentByComplexID(webFormData.getParentDocID())
			publishValue("parenttasktype", parentDoc.getValueString("tasktype"))
			publishValue("parentproject", parentDoc.getValueString("project"))
			publishValue("parentcategory", parentDoc.getValueString("category"))
			publishValue("parenthar", parentDoc.getValueString("har"))
		}catch(_Exception e){
			
		}
	}


	@Override
	public void doQueryOpen(_Session ses, _Document doc, _WebFormData webFormData, String lang) {
		def task = (_Task)doc
		publishValue("title",getLocalizedWord("Задание", lang) + ":" + task.getValueString("briefcontent"))
		publishEmployer("taskauthor",task.getAuthorID())
		publishValue("taskvn",task.getValueString("taskvn"))
		publishValue("taskdate", task.getValueString("taskdate"))
		publishValue("tasktype", task.getValueString("tasktype"))
		publishValue("allcontrol", task.getValueString("allcontrol"))
		
		def execs = ""
		def execsList = task.getExecutorsList();
		for ( e in execsList ) {
			execs += e.toXML()
		}
		publishValue("executors", execs)
		publishValue("control", task.getControl().toXML())
		publishGlossaryValue("project",doc.getValueGlossary("project"))
		publishGlossaryValue("category",doc.getValueGlossary("category"))
		publishValue("briefcontent",task.getValueString("briefcontent"))
		publishValue("comment",task.getValueString("comment"))
		publishValue("content",task.getValueString("content"))
		
		try{
			publishAttachment("rtfcontent","rtfcontent")
		}catch(_Exception e){
			
		}
		
		
		def db = ses.getCurrentDatabase();
		try{
			def parentDoc = db.getDocumentByComplexID(webFormData.getParentDocID())
			publishValue("parenttasktype", parentDoc.getValueString("tasktype"))		
		}catch(_Exception e){
			
		}
	}

}