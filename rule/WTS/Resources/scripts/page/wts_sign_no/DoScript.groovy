package page.wts_sign_no

import kz.nextbase.script.*;
import kz.nextbase.script.events._DoScript
import kz.nextbase.script.project._Project

class DoScript extends _DoScript {

	@Override
	public void doProcess(_Session ses, _WebFormData formData, String lang) {

        def cdb = ses.getCurrentDatabase();
        def prj = (_Project)cdb.getProjectByID(Integer.parseInt(formData.getValue("key")));
        def mailAgent = ses.getMailAgent();
        def msngAgent = ses.getInstMessengerAgent();
        String msubject;
        String body;
        String msg;
        def author = ses.getStructure()?.getEmployer(prj.getValueString("author"));
        def block = prj.getSignBlock();
        block.setStatus("coordinated");
        def signerlist = block.getCurrentCoordinators();
        for (signer in signerlist) {
            if(signer.getUserID() == ses.getCurrentUserID()){
                signer.setDecision('disagree', formData.getValue("comment"));
            }
        }
        prj.setCoordStatus("executing");
        prj.setLastUpdate(new Date());
        prj.setValueString("oldversion", "1");
        prj.setIsRejected(1);
        def doc = new _Document(cdb);
        prj.copyAttachments(doc);
        prj.save("observer");

        msg = "Отклонен документ: \"" + prj.getValueString("briefcontent") + "\"(" + prj.getSigner()?.getComment() + ")";
        msngAgent.sendMessage([author?.getInstMessengerAddr()], doc.getGrandParentDocument().getValueString("project_name") + ": " + msg);


        msubject = "[СЭД] [Замечания] Отклонен документ №" + prj.getVn() + " от " + prj.getProjectDate().format("dd.MM.yyyy HH:mm:ss") + " (" + prj.getSigner()?.getComment() + ")";
        body = '<b><font color="#000080" size="4" face="Default Serif">Документ отклонен</font></b><hr>';
        body += '<table cellspacing="0" cellpadding="4" border="0" style="padding:10px; font-size:12px; font-family:Arial;">';
        body += '<tr>';
        body += '<td style="border-bottom:1px solid #CCC;" valign="top" colspan="2">';
        body += "Документ №" + prj.getVn() + " от " + prj.getProjectDate().format("dd.MM.yyyy HH:mm:ss") + ' был отклонен. <br>';
        body += 'Комментарий: ' + prj.getSigner()?.getComment();
        body += '</td></tr><tr>';
        body += '<td colspan="2"></td>';
        body += '</tr></table>';
        body += '<p><font size="2" face="Arial">Для работы с документом перейдите по <a href="' + prj.getFullURL() + '">ссылке...</a></p></font>';

        mailAgent.sendMail([author?.getEmail()], msubject, body);
	}

}




