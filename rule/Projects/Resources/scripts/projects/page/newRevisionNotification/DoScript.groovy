package projects.page.newRevisionNotification

import kz.nextbase.script._Session;
import kz.nextbase.script._WebFormData;
import kz.nextbase.script.events._DoScript;

class DoScript extends _DoScript{

	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {
		
		def recipients = []
		def cdb = session.getCurrentDatabase()
		def struct = session.getStructure()
		def doc = cdb.getDocumentByID(Integer.parseInt(formData.getValue("key")))
		String briefcontent = doc.getValueString("briefcontent")
		
		for(userid in formData.getListOfValues("recipients")){
			def emp = struct.getUser(userid)
			recipients.add(emp.getEmail())
			doc.addReader(userid)
		}
		
		doc.save("[observer]")
		def controloff = new projects.page.controloff.DoScript();
		controloff.doProcess(session, formData,lang);
		try {
			doc.currentUserID = "observer"
			def coll = doc.getDescendants()
			for(rdoc in coll){
				for(userid in formData.getListOfValues("recipients")){
					rdoc.addReader(userid)
				}
				rdoc.save("[observer]")
			}
		} catch(e){
			e.printStackTrace()
		}

		//Уведомление о реализации новой доработки
		String body = '<b><font color="#000080" size="4" face="Default Serif">Уведомление о реализации новой доработки</font></b><hr>'
		body += '<table cellspacing="0" cellpadding="4" border="0" style="padding:10px; font-size:12px; font-family:Arial;">'
		body += '<tr>'
		body += '<td width="210px">Уведомление о реализации доработки:</td>'
		body += '<td width="500px"><b>'+doc.getValueString("vn")+' от '+doc.getValueString("dvn")+'</b></td>'
		body += '</tr><tr>'
		body += '<td style="border-top:1px solid #CCC;" valign="top">Содержание:</td>'
		body += '<td style="border-top:1px solid #CCC;" valign="top">'+ briefcontent +'</td>'
		body += '</tr></table>'
		body += '<p><font size="2" face="Arial">Для просмотра документа, перейдите по этой <a href="' + doc.getFullURL() + '">ссылке...</a></p></font>'
 
		def ma = session.getMailAgent()
		ma.sendMail(recipients, "документ ${doc.getValueString("vn")} реализация новой доработки", body)
				
		setRedirectURL(session.getLastPageURL())		
	}

}
