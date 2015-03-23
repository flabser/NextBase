package handler.reminder

import kz.nextbase.script._Exception
import kz.nextbase.script._Session
import kz.nextbase.script._ViewEntry
import kz.nextbase.script.events._DoScheduledHandler
import kz.nextbase.script.mail._Memo
import kz.nextbase.script.struct._Employer

class Trigger extends _DoScheduledHandler {

	@Override
	public int doHandler(_Session session) {
		def massTime = []
		def massTimeOut = []	
		def db = session.getCurrentDatabase()
		def struct = session.getStructure()
		def collection = db.getCollectionOfDocuments("form='demand' and viewtext4='1'", true).getEntries()
		def mAgent = session.getMailAgent()
		def memo
		def recipientEmail = []
		Calendar calendar = Calendar.getInstance()
		String body = ""
		String body2 = ""
		int tasks_count = 0
		int tasks_out_count = 0
		collection.each { _ViewEntry entry ->
			try {
				def doc = entry.getDocument()
				if ((doc.getValueString("status") != 'revoked')){
					def control = doc.getValueObject("control")
					int diff = control.getDiffBetweenDays()
					if (diff >= -1) {
						// просроченные
						massTimeOut.add(doc)
					} else if (diff < -1) {
						// неисполненные
						massTime.add(doc)
					}
				}
			} catch (_Exception e) {
				e.printStackTrace()
			}
		}

		// для сотрудников с неисполненными и просроченными заявками
	
		def employers = struct.getAllEmployers()
		for(def emp: employers){
			tasks_count = 0
			tasks_out_count = 0
			// чтобы не приходило на выходных
			if (massTime.size() > 0 && ((calendar.get(Calendar.DAY_OF_WEEK) != Calendar.SATURDAY) && (calendar.get(Calendar.DAY_OF_WEEK) != Calendar.SUNDAY))) {
				// формируем body
				body = "<b>" + "Просроченные заявки " + "</b><br><br>"
				int i = 1; int j = 0
				body += "<TABLE style='border-collapse:collapse; margin:1px auto' height = 30px cellpadding = 10px>"
				for(def mt: massTime){
				//massTime.each { _ViewEntry mt ->
					// если в документе с полем ... getUserID соответствует
					def doc = mt
					if (doc.getValueString("executer").equals(emp.getUserID())) {
						(j == 0 ? (body += "<TR><td style = 'background-color: #FFEDED; border:1px solid #cdcdcd' width= 20px padding: 10px>" + "<b>" + "№" + 
						"</b></TD><td style = 'background-color: #FFEDED; border:1px solid #cdcdcd' width=120px padding: 10px align=\"center\"><b>Проект</b>" + 
						"</td><TD style =  'background-color: #FFEDED; border:1px solid #cdcdcd' width= 800px ><b>" + "Содержание" + "</b></TD></TR>") : "")
						// формируем боди (№, проект, краткое содержание и урл)
						body += "<TR><td style = 'background-color: #FFEDED; border:1px solid #cdcdcd' width= 20px padding: 10px>" + i + 
						"</TD><td style = 'background-color: #FFEDED; border:1px solid #cdcdcd' width= 120px padding: 10px align=\"center\"><a href=\"" + 
						doc.getGrandParentDocument().getFullURL() + "\">" + doc.getGrandParentDocument().getValueString("project_name") + 
						"</TD>" + "<TD style = 'background-color: #FFEDED; border:1px solid #cdcdcd' width= 800px><a href=\"" + doc.getFullURL() + "\">" + 
						"  " + doc.getViewText() + "</TD></TR></a>"
						i++
						j = 1
						tasks_count++
					}
				}
				body += "</TABLE>"
			}

			// чтобы не приходило на выходных
			if (massTimeOut.size() > 0 && ((calendar.get(Calendar.DAY_OF_WEEK) != Calendar.SATURDAY) && (calendar.get(Calendar.DAY_OF_WEEK) != Calendar.SUNDAY))) {
				body2 = "<b>" + "У Вас есть неисполненные заявки " + "</b><br><br>"
				int i = 1; int j = 0;
				body2 += "<TABLE style='border-collapse:collapse; margin:1px auto' height = 30px cellpadding = 10px>"
				for(def mto: massTimeOut){
					if (mto.getValueString("executer").equals(emp.getUserID())) {
						(j == 0 ? (body2 += "<TR><td style = 'background-color: #F8F8FF; border:1px solid #cdcdcd' width= 20px padding: 10px><b>" + "№" + 
						"</b></TD><td style = 'background-color: #F8F8FF; border:1px solid #cdcdcd' width=120px padding: 10px align=\"center\"><b>" + 
						"Проект</b></td><TD style =  'background-color: #F8F8FF; border:1px solid #cdcdcd' width= 800px align=\"center\"><b>" + "Содержание" + 
						"</b></TD></TR>") : "")
						body2 += "<TR><td style = 'background-color: #F8F8FF; border:1px solid #cdcdcd' width= 20px padding: 10px>" + i + 
						"</TD><td style = 'background-color: #F8F8FF; border:1px solid #cdcdcd' width= 120px padding: 10px align=\"center\"><a href=\"" + 
						mto.getGrandParentDocument().getFullURL() + "\">" + mto.getGrandParentDocument().getValueString("project_name") + 
						"</TD>" + "<TD style = 'background-color: #F8F8FF; border:1px solid #cdcdcd' width= 800px><a href=\"" + 
						mto.getFullURL() + "\">" + "  " + mto.getViewText() + "</TD></TR></a>"
						i++
						j = 1
						tasks_out_count++
					}
				}
				body2 += "</TABLE>"
			}
			recipientEmail.clear()
			recipientEmail.add(emp.getEmail())
			if (tasks_count != 0 || tasks_out_count != 0) {
				memo = new _Memo("Уведомление о неисполненных заявках", "<b>" + "Уведомление о неисполненных заявках" + "</b>", (massTimeOut.any({
					it.getValueString("executer").equals(emp.getUserID())
				}) ? body2 : "") + "<br>" + (massTime.any({
					it.getValueString("executer").equals(emp.getUserID())
				}) ? body : ""), null, true)
				mAgent.sendMail(recipientEmail, memo)
				// log(recipientEmail + " " + memo + " " + body.toString() + " " + massTime.size() + " " + body2.toString() + massTimeOut.size());
			}
		}
		return 0
	}


}