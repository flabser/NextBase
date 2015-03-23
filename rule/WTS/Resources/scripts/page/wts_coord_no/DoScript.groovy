package page.wts_coord_no

import kz.nextbase.script.*
import kz.nextbase.script.constants._CoordStatusType;
import kz.nextbase.script.events._DoScript
import kz.nextbase.script.project._Project

class DoScript extends _DoScript {

	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {
		def cdb = session.getCurrentDatabase();
        def doc = cdb.getDocumentByID(formData.getNumberValueSilently("key",-1));
		def mailAgent = session.getMailAgent();
		def msngAgent = session.getInstMessengerAgent();
		def recipientsMail = [];
		def recipientsID = [];
		String msubject;
		String body;
		String msg;
		def prj = (_Project)cdb.getProjectByID(Integer.parseInt(formData.getValue("key")));
		def author = session.getStructure().getEmployer(prj.getValueString("author"));
		def block = prj.getCurrentBlock();
		def coordlist = block.getCurrentCoordinators();
		boolean finalblock = false;
		def rejectProject = {project->
			project.setCoordStatus("rejected");
			project.setLastUpdate(new Date());
			project.setValueString("oldversion", "1");
			project.setIsRejected(1);
			project.save("observer");
		}
		for (coord in coordlist){
			if(coord.getUserID() == session.getCurrentUserID()){
				coord.setDecision("disagree", formData.getValue("comment"));
				if (block.getType() == "pos"){
					block.setStatus("coordinated");
					rejectProject(prj);
				}else{
					if(block.getType() == "par" && coordlist.size <= 1){
						finalblock = true;
					}
				}
				if (finalblock){
					block.setStatus("coordinated");
					def nextBlock = prj.getNextBlock(block);
					if (nextBlock){
						if (nextBlock.getType() == "par"){
							nextBlock.setStatus("coordinating");
							def nextcoords = nextBlock.getCoordinators();
							nextcoords.each{ nextcoord ->
								nextcoord.setCurrent(true);
								prj.addReader(nextcoord.getUserID());
								if (nextcoord.getEmail()){
									recipientsMail.add(nextcoord.getEmail());
								}
								if (nextcoord.getInstMessengerAgent()){
									recipientsID.add(nextcoord.getInstMessengerAgent());
								}
							}
						}else{
							if(nextBlock.getType() == "pos"){
								nextBlock.setStatus("coordinating");
								def nextcoord = nextBlock.getFirstCoordinator();
								if (nextcoord){
									nextcoord.setCurrent(true);
									prj.addReader(nextcoord.getUserID());
									if (nextcoord.getEmail()){
										recipientsMail.add(nextcoord.getEmail());
									}
									if (nextcoord.getInstMessengerAgent()){
										recipientsID.add(nextcoord.getInstMessengerAgent());
									}
								}
							}else{
								if (nextBlock.getType() == "sign"){
									def decisions = [];
									def cusers = prj.getBlocks()*.getCoordinators();
									cusers.each{
										for (c in it) {
											decisions.add(c.getDecision())
										}
									}
									if (!decisions.find({it == "disagree"})) {
										prj.setCoordStatus("coordinated");
										if (prj.getAutoSendToSign() == 1){
											prj.setCoordStatus("signing");
											nextBlock.setStatus("coordinating");
											def signer = prj.getSigner();
											signer.setCurrent(true);
											if (signer.getUserID()){
												prj.addReader(signer.getUserID());
											}
											prj.sendToSignining();
										}
									} else {
										rejectProject(prj);
									}
								}
							}
						}
					}
				}
			}
		}
        if (prj.getCoordStatus() == _CoordStatusType.COORDINATING){
			if (recipientsID){
				msg = "Вам документ на согласование. \nДля работы с документом перейдите по ссылке " + prj.getFullURL();
				msngAgent.sendMessage(recipientsID, doc.getGrandParentDocument().getValueString("project_name") + ": " + msg);
			}

			msubject = '[СЭД] [Проекты] -> Прошу согласовать документ \"' + prj.getValueString("briefcontent") + '\"';
			body = '<b><font color="#000080" size="4" face="Default Serif">Документ на согласование</font></b><hr>';
			body += '<table cellspacing="0" cellpadding="4" border="0" style="padding:10px; font-size:12px; font-family:Arial;">';
			body += '<tr>';
			body += '<td style="border-bottom:1px solid #CCC;" valign="top" colspan="2">';
			body += 'Вам документ на согласование \"' +  prj.getValueString("briefcontent") + '\"' + '<br>';
			body += '</td></tr><tr>';
			body += '<td colspan="2"></td>';
			body += '</tr></table>';
			body += '<p><font size="2" face="Arial">Для работы с документом перейдите по <a href="' + prj.getFullURL() + '">ссылке...</a></p></font>';

			if (recipientsMail){
				mailAgent.sendMail(recipientsMail, msubject, body);
			}

		}
		if (prj.getCoordStatus() == _CoordStatusType.COORDINATED || prj.getCoordStatus() == _CoordStatusType.SIGNING){

			msg = "По документу: \"" + prj.getValueString("briefcontent") + "\" завершено согласование. Для работы с документом перейдите по ссылке " + prj.getFullURL();
			msngAgent.sendMessage([author.getInstMessengerAddr()], doc.getGrandParentDocument().getValueString("project_name") + ": " + msg);



			msubject = '[СЭД] [Проекты] Согласование документа \"' + prj.getValueString("briefcontent") + '\" завершено.';
			body = '<b><font color="#000080" size="4" face="Default Serif">Завершено согласование</font></b><hr>';
			body += '<table cellspacing="0" cellpadding="4" border="0" style="padding:10px; font-size:12px; font-family:Arial;">';
			body += '<tr>';
			body += '<td style="border-bottom:1px solid #CCC;" valign="top" colspan="2">';
			body += 'По документу \"' +  prj.getValueString("briefcontent") + '\" завершено согласование. <br>';
			body += '</td></tr><tr>';
			body += '<td colspan="2"></td>';
			body += '</tr></table>';
			body += '<p><font size="2" face="Arial">Для работы с документом перейдите по <a href="' + prj.getFullURL() + '">ссылке...</a></p></font>';

			mailAgent.sendMail([author?.getEmail()], msubject, body);

		}

        if (prj.getCoordStatus() == _CoordStatusType.REJECTED){

            msg = "Документ № " + prj.getVn() + " от " + prj.getProjectDate().format("dd.MM.yyyy HH:mm:ss") + " был отклонен. Для ознакомления с документом перейдите по ссылке " + prj.getFullURL();
            msngAgent.sendMessage([author.getInstMessengerAddr()], doc.getGrandParentDocument().getValueString("project_name") + ": " + msg);



            msubject = "Документ № " + prj.getVn() + " от " + prj.getProjectDate().format("dd.MM.yyyy HH:mm:ss") + " был отклонен.";
            body = '<b><font color="#000080" size="4" face="Default Serif">Документ отклонен</font></b><hr>';
            body += '<table cellspacing="0" cellpadding="4" border="0" style="padding:10px; font-size:12px; font-family:Arial;">';
            body += '<tr>';
            body += '<td style="border-bottom:1px solid #CCC;" valign="top" colspan="2">';
            body += "Документ № " + prj.getVn() + " от " + prj.getProjectDate().format("dd.MM.yyyy HH:mm:ss") + " был отклонен.<br>";
            body += '</td></tr><tr>';
            body += '<td colspan="2"></td>';
            body += '</tr></table>';
            body += '<p><font size="2" face="Arial">Для ознакомления с документом перейдите по <a href="' + prj.getFullURL() + '">ссылке...</a></p></font>';

            mailAgent.sendMail([author?.getEmail()], msubject, body);

        }

		if (prj.getCoordStatus() == _CoordStatusType.COORDINATED){
			msg = "Документ \"" + prj.getValueString("briefcontent") + "\" готов к отправке на исполнение. Пожалуйста, проверьте правильность составления документа и все ли участники согласования ";
			msg += "одобрили документ. \nДля работы с документом перейдите по ссылке " + prj.getFullURL();
			msngAgent.sendMessage([author?.getInstMessengerAddr()], doc.getGrandParentDocument().getValueString("project_name") + ": " + msg);

			msubject = '[СЭД] [Проекты] Проект для отправки на исполнение \"' + prj.getValueString("briefcontent") + '\"';
			body = '<b><font color="#000080" size="4" face="Default Serif">Согласование завершено</font></b><hr>';
			body += '<table cellspacing="0" cellpadding="4" border="0" style="padding:10px; font-size:12px; font-family:Arial;">';
			body += '<tr>';
			body += '<td style="border-bottom:1px solid #CCC;" valign="top" colspan="2">';
			body += 'Проект документа завершил согласование и готов к отправке на исполнение. Проверьте правильность составления документа ';
			body += 'и все ли участники согласования одобрили документ.<br>';
			body += '</td></tr><tr>';
			body += '<td colspan="2"></td>';
			body += '</tr></table>';
			body += '<p><font size="2" face="Arial">Для работы с документом перейдите по <a href="' + prj.getFullURL() + '">ссылке...</a></p></font>';

			mailAgent.sendMail([author?.getEmail()], msubject, body);

		}
		if (prj.getCoordStatus() == _CoordStatusType.SIGNING){
			msg = "После рассмотрения документа: \"" + prj.getValueString("briefcontent") + "\" он отправлен на исполнение к " + prj.getSigner()?.getShortName();
			msg += "\nДля работы с документом перейдите по ссылке " + prj.getFullURL();
			msngAgent.sendMessage([author?.getInstMessengerAddr()], doc.getGrandParentDocument().getValueString("project_name") + ": " + msg);

			msg = "Вам документ: \"" + prj.getValueString("briefcontent") + "\" на исполнение. \nДля работы с документом перейдите по ссылке " + prj.getFullURL();
			msngAgent.sendMessage([prj.getSigner()?.getInstMessengerAgent()], msg);

			msubject = '[СЭД] [Проекты] Отправлен на исполнение документ \"' + prj.getValueString("briefcontent") + '\"';
			body = '<b><font color="#000080" size="4" face="Default Serif">Документ на исполнение</font></b><hr>';
			body += '<table cellspacing="0" cellpadding="4" border="0" style="padding:10px; font-size:12px; font-family:Arial;">';
			body += '<tr>';
			body += '<td style="border-bottom:1px solid #CCC;" valign="top" colspan="2">';
			body += 'После рассмотрения документа: \"' +  prj.getValueString("briefcontent") + '\" он отправлен на исполнение к ';
			body += prj.getSigner()?.getShortName() + ' <br>';
			body += '</td></tr><tr>';
			body += '<td colspan="2"></td>';
			body += '</tr></table>';
			body += '<p><font size="2" face="Arial">Для работы с документом перейдите по <a href="' + prj.getFullURL() + '">ссылке...</a></p></font>';

			mailAgent.sendMail([author?.getEmail()], msubject, body);

			msubject = '[СЭД] [Проекты] -> Документ на исполнение: \"' + prj.getValueString("briefcontent") + '\"';
			body = '<b><font color="#000080" size="4" face="Default Serif">Документ на исполнение</font></b><hr>';
			body += '<table cellspacing="0" cellpadding="4" border="0" style="padding:10px; font-size:12px; font-family:Arial;">';
			body += '<tr>';
			body += '<td style="border-bottom:1px solid #CCC;" valign="top" colspan="2">';
			body += 'Вам документ: \"' +  prj.getValueString("briefcontent") + '\" на исполнение. <br>';
			body += '</td></tr><tr>';
			body += '<td colspan="2"></td>';
			body += '</tr></table>';
			body += '<p><font size="2" face="Arial">Для работы с документом перейдите по <a href="' + prj.getFullURL() + '">ссылке...</a></p></font>';

			mailAgent.sendMail([prj.getSigner()?.getEmail()], msubject, body);

		}

		prj.setLastUpdate(new Date());
		prj.save("observer");

	}

}




