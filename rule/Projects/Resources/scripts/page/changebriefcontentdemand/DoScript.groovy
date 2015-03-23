package page.changebriefcontentdemand
import kz.nextbase.script._Helper
import kz.nextbase.script._Session
import kz.nextbase.script._WebFormData
import kz.nextbase.script.events._DoScript
import kz.nextbase.script.mail._Memo

class DoScript extends _DoScript {
	
	public DoScript(){}
	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {

		println(formData)

		def cdb = session.getCurrentDatabase()
		def doc = cdb.getDocumentByID(Integer.parseInt(formData.getValue("key")))
		String executeruserid = doc.getValueString('executer')
		def struct = session.getStructure()
		def empcurrent = struct.getEmployer(doc.getAuthorID())
		def empexec = struct.getEmployer(executeruserid)
		def executers = doc.getValueList('executer');
		def executers_shortname = new ArrayList();
		for (String executer: executers) {
			executers_shortname.add(struct.getEmployer(executer).shortName)
		}
		doc.setValueString("briefcontent", formData.getValue("briefcontent"))
		doc.setViewText(doc.getValueString('vn')+": " + empcurrent.getShortName() + " -> (" + executers_shortname.join(", ") + ") "+doc.getValueString("briefcontent"),0)
		doc.save("[supervisor]")
	

		if( executeruserid != doc.getValueString('author')){
			String body = '<b><font color="#000080" size="4" face="Default Serif">Уведомление о изменении содержания документа</font></b><hr>'
			body += '<table cellspacing="0" cellpadding="4" border="0" style="padding:10px; font-size:12px; font-family:Arial;">'
			body += '<tr>'
			body += '<td width="210px" valign="top">К Вам уведомление о изменении содержания документа:</td>'
			body += '<td width="500px" valign="top"><b>документ '+doc.getValueString("vn")+' изменен </b></td>'
			body += '</tr><tr>'
			body += '<td>Исполнители:</font></td><td><b>'+ executers_shortname.join(", ") +'</b></td>'
			body += '</tr><tr>'
			body += '<td>Срок исполнения:</font></td><td><b>'+doc.getValueString("ctrldate")+'</b></td>'
			body += '</tr><tr>'
			body += '<td style="border-top:1px solid #CCC;" valign="top">Содержание:</td>'
			body += '<td style="border-top:1px solid #CCC;" valign="top">'+ doc.getValueString("briefcontent") +'</td>'
			body += '</tr></table>'
			body += '<p><font size="2" face="Arial">Для работы с документом, перейдите по этой <a href="' + doc.getFullURL() + '">ссылке...</a></p></font>'
			def ma = session.getMailAgent()
			for (String executer: executers) {
				def empExec = struct.getEmployer(executer)
				if(executer != doc.getValueString('author')){
					try {
		                def memo = new _Memo(doc.getGrandParentDocument().getValueString("project_name") + ': документ ' + doc.getValueString("vn") + ' изменен', "", body, doc, true)
		                ma.sendMail([empExec.getEmail()], memo)
		            } catch (Exception e) {
		                e.printStackTrace()
		            }
				}
			}
			
		}
		def redirectURL = session.getURLOfLastPage()
		setRedirectURL(redirectURL)		
	}

}




