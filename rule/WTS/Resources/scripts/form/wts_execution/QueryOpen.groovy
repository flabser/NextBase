package form.wts_execution

import java.util.Map
import kz.nextbase.script.*
import kz.nextbase.script.actions.*
import kz.nextbase.script.events.*;
import kz.nextbase.script.task._Control
import kz.nextbase.script.task._Task

class QueryOpen extends _FormQueryOpen {

	@Override
	public void doQueryOpen(_Session ses, _WebFormData webFormData, String lang) {

		def actionBar = new _ActionBar(ses)
		actionBar.addAction(new _Action("Сохранить и закрыть","Сохранить и закрыть",_ActionType.SAVE_AND_CLOSE))
		actionBar.addAction(new _Action("Закрыть","Закрыть без сохранения",_ActionType.CLOSE))
		publishElement(actionBar)
		
		
		publishValue("title",getLocalizedWord("Исполнение", lang))
		publishValue("author", ses.getCurrentAppUser().getFullName())
		publishEmployer("executor",ses.getCurrentAppUser().getUserID())
		publishValue("finishdate", ses.getCurrentDateAsString())
	}


	@Override
	public void doQueryOpen(_Session ses, _Document doc, _WebFormData webFormData, String lang) {
		def exec = (_Execution)doc
		def user = ses.getCurrentAppUser()
		
		def actionBar = new _ActionBar(ses)
		if (user.getUserID() == exec.getAuthorID() ){
			actionBar.addAction(new _Action("Сохранить и закрыть","Сохранить и закрыть",_ActionType.SAVE_AND_CLOSE))
		}
		actionBar.addAction(new _Action("Закрыть","Закрыть без сохранения",_ActionType.CLOSE))
		publishElement(actionBar)
		
		publishValue("title",getLocalizedWord("Исполнение", lang) + ":" + exec.getValueString("briefcontent"))
		publishEmployer("author",exec.getAuthorID())
		publishEmployer("executor",exec.getExecutorID())
		publishValue("finishdate", _Helper.getDateAsString(exec.getFinishDate()))
		publishValue("report", exec.getReport())
		publishGlossaryValue("nomentype", exec.getNomenType())
		
		try{
			publishAttachment("rtfcontent","rtfcontent")
		}catch(_Exception e){

		}
	}	
		

}