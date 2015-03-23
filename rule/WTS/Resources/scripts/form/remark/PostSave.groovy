package form.remark

import kz.nextbase.script.*;
import kz.nextbase.script.events.*;
import kz.nextbase.script.mail._Memo
import kz.nextbase.script.task._Task

class PostSave extends _FormPostSave {
	
	public void doPostSave(_Session ses, _Document doc) {
		
		def t = (_Task)doc;
		
		def recipientsMail = []
		def recipientsID = []
		def mailAgent = ses.getMailAgent()
		def msngAgent = ses.getInstMessengerAgent()
		String msubject = ""
		String body = ""
		String msg = ""
		def events = []
		def mdoc
		def author = ses.getStructure()?.getUser(doc.getValueString("author"))
		def taskReaders = doc.getReaders()
		if (doc.getValueNumber("sendNotify") == 1){
		
			if (t.getResolType() == 1 || t.getResolType() == 2){
				   mdoc = doc.getGrandParentDocument()
				taskReaders.each{ exec ->
					mdoc.addReader(exec)
				}
				mdoc.save("observer")
				def readersList = mdoc.getReaders()
				def rescol = mdoc.getDescendants()
				rescol.each{ response ->
					readersList.each{ reader ->
						response.addReader(reader)
					}
					response.save("observer")
				}
				msubject = '[СЭД] [Задания] Уведомление о новом задании '
			}
		
			//Для модуля Задания в теме сообщения мы указываем Краткое содержание для самих заданий
			//а также для всех ответных резолюций и перепоручений
		
			if (t.getResolType() == 3 || mdoc?.getDocType() == Const.DOCTYPE_TASK) {
				 msubject = "[4MS] " + doc.getValueString("briefcontent")
			}
					
			def executors = t.getExecutorsList()
			executors.each{
				def recipient = ses.getStructure()?.getUser(it.getUserID())
				recipientsMail.add(recipient?.getEmail())
				recipientsID.add(recipient?.getInstMessengerAddr())
			}
			
			def memo = new _Memo("Уведомление о документе на исполнение", "Новое задание", "Задание",t, true)
			def recipient = ses.getStructure().getEmployer(doc.getValueString("recipient"))
			def recipientEmail = recipient.getEmail();
			mailAgent.sendMail(recipientsMail, memo)
			def userActivity = ses.getUserActivity();
			userActivity.postActivity(this.getClass().getName(),"Memo has been send to " + recipientEmail)
			
	}
		
	}
}