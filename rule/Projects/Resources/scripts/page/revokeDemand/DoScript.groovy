package page.revokeDemand
import kz.nextbase.script._Session
import kz.nextbase.script._WebFormData
import kz.nextbase.script.constants._AllControlType
import kz.nextbase.script.events._DoScript
import kz.nextbase.script.mail._Memo
import kz.nextbase.script.task._Control

class DoScript extends _DoScript {
	
	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {

		println(formData)

		def cdb = session.getCurrentDatabase()
		def struct = session.getStructure()
		def doc = cdb.getDocumentByID(Integer.parseInt(formData.getValue("docid")))

		doc.setValueString("status", "revoked")
		def control = (_Control)doc.getValueObject("control")
		control.setAllControl(_AllControlType.RESET)
		doc.addNumberField("revoke_demand_reason_id", formData.getNumberValueSilently("reasonID",-1))
		doc.addDateField("dateRevoked", new Date())
		doc.setViewText("-1",4)
		
		def empAuthor = struct.getEmployer(doc.getAuthorID())
		String executeruserid = doc.getValueString('executer')
		def executers = doc.getValueList('executer');
		def executers_shortname = new ArrayList();
		for (String executer: executers) {
			executers_shortname.add(struct.getEmployer(executer).shortName)
		}
	
		doc.save("[supervisor]")

		String body = '<b><font color="#000080" size="4" face="Default Serif">Уведомление об отмене заявки</font></b><hr>'
		body += '<table cellspacing="0" cellpadding="4" border="0" style="padding:10px; font-size:12px; font-family:Arial;">'
		body += '<tr>'
		body += '<td width="210px" valign="top">К Вам уведомление об отмене заявки:</td>'
		body += '<td width="500px" valign="top"><b>документ '+doc.getValueString("vn")+' был отменен от '+doc.getValueString("dateRevoked")+'</b></td>'
		body += '</tr><tr>'
		body += '<td>Автор:</font></td><td><b>'+empAuthor.getShortName()+'</b></td>'
		body += '</tr><tr>'
		body += '<td>Исполнители:</font></td><td><b>'+ executers_shortname.join(", ") +'</b></td>'
		body += '</tr><tr>'
		body += '<td>Срок исполнения:</font></td><td><b>'+doc.getValueString("ctrldate")+'</b></td>'
		body += '</tr><tr>'
		body += '<td style="border-top:1px solid #CCC;" valign="top">Содержание:</td>'
		body += '<td style="border-top:1px solid #CCC;" valign="top">'+ doc.getValueString("briefcontent") +'</td>'
		body += '</tr></table>'
		def ma = session.getMailAgent()
		for (String executer: executers) {
			def empExec = struct.getEmployer(executer)
			if(executer != doc.getValueString('author')){
				try {
	                def memo = new _Memo(doc.getGrandParentDocument().getValueString("project_name") + ': документ ' + doc.getValueString("vn") + ' был отменен', "", body, doc, true)
	                ma.sendMailAfter([empExec.getEmail()], memo)
	            } catch (Exception e) {
	                e.printStackTrace()
	            }
			}
		}
		
		setRedirectURL(session.getURLOfLastPage())		
	}

}




