package page.wts_sign_yes

import kz.nextbase.script.*;
import kz.nextbase.script.mail._Memo
import kz.nextbase.script.project._Project;
import kz.nextbase.script.events._DoScript;

class DoScript extends _DoScript {

    @Override
    public void doProcess(_Session ses, _WebFormData formData, String lang) {
        try {
            def cdb = ses.getCurrentDatabase();
            def doc1 = cdb.getDocumentByID(formData.getNumberValueSilently("key",-1));
            def prj = (_Project)cdb.getProjectByID(Integer.parseInt(formData.getValue("key")));
            def mailAgent = ses.getMailAgent();
            def msngAgent = ses.getInstMessengerAgent();
            def recipientsMail = [];
            def recipientsID = [];
            String msubject;
            String subj;
            String body;
            String msg;
            def author = ses.getStructure()?.getEmployer(prj.getValueString("author"));
            def block = prj.getSignBlock();
            block.setStatus("coordinated");
            def signerlist = block.getCurrentCoordinators();
            for (signer in signerlist) {
                if (signer.getUserID() == ses.getCurrentUserID()) {
                    String comment = (formData.containsField("comment") ? formData.getValue("comment") : "");
                    signer.setDecision("agree", comment != null ? comment : "");
                }
            }
            if (prj.getForm()[0] == "remark") {
                prj.setCoordStatus("executed");
            } else {
                prj.setCoordStatus("signed");
            }
            prj.setLastUpdate(new Date());
            def recipients = prj.getRecipients();
            recipients.each { r ->
                if (r) {
                    prj.addReader(r);
                }
            }
            prj.save("observer");
            msg = "После исполнения документ № " + prj.getVn() + " от " + prj.getProjectDate().format("dd.MM.yyyy HH:mm:ss") + "\" отправлен ";
            msg += (prj.getForm()[0] == "workdocprj" ? "получателю." : "на ревизию исполнения.") + "\nДля ознакомления с документом перейдите по ссылке: " + prj.getFullURL();
            msngAgent.sendMessage([author?.getInstMessengerAddr()], doc1.getGrandParentDocument().getValueString("project_name") + ": " + msg);

            subj = " Исполнено замечание № " + prj.getVn() + " от " + prj.getProjectDate().format("dd.MM.yyyy HH:mm:ss");
            body = "После исполнения документ №" + prj.getVn() + " от " + prj.getProjectDate().format("dd.MM.yyyy HH:mm:ss") + " отправлен ";
            body += (prj.getForm()[0] == "workdocprj" ? " получателю. " : " на ревизию исполнения.");
            mailAgent.sendMail([author?.getEmail()], new _Memo(subj, 'Документ исполнен', body, prj, false));



            if (prj.getAutoSendAfterSign() == 1) {
                def doc = new _Document(cdb);
                if (prj.getForm()[0] == "workdocprj") {
                    doc.setForm("SZ");
                    doc.setDefaultRuleID("sz");
                    doc.addStringField("vn", prj.getVn());
                    doc.addDateField("dvn", new Date());
                    doc.addStringField("corr", prj.getSigner()?.getUserID());
                    prj.getRecipients().each {
                        doc.addValueToList("recipient", it);
                    }
                    int num = cdb.getRegNumber("sz");
                    doc.addStringField("vn", num.toString());
                    doc.addNumberField("vnnumber", num);
                    doc.setViewText("Служебная записка № " + num + " " + ses.getStructure()?.getUser(prj.getValueString("author"))?.getShortName());
                    Calendar c = Calendar.getInstance();
                    c.add(Calendar.MONTH, 1);
                    java.util.Date date = c.getTime();
                    doc.addDateField("ctrldate", date);
                } else {
                    doc.setForm("ISH");
                    doc.setDefaultRuleID("ish");
                    doc.addStringField("signedby", prj.getSigner()?.getUserID());
                    doc.addStringField("intexec", prj.getValueString("author"));
                    doc.addStringField("in", prj.getVn());
                    doc.addStringField("vn", "");
                    doc.setViewText("Исходящий документ №" + doc.getValueString("in") + " от " + new Date().format('dd.MM.yyyy HH:mm:ss'));
                    doc.addNumberField("nomentype", prj.getValueNumber("nomentype"));
                    String glossValue = prj.getValueString("deliverytype");
                    def glossDoc = cdb.getGlossaryDocument("deliverytype", "viewtext = '" + glossValue + "'");
                    doc.addGlossaryField("deliverytype", glossDoc.getDocID());
                    prj.getRecipients().each {
                        doc.addValueToList("corr", it);
                    }
                }
                prj.getReaders().each {
                    doc.addReader(it);
                }
                prj.copyAttachments(doc);
                doc.addStringField("contentsource", prj.getValueString("contentsource"));
                doc.addStringField("author", prj.getValueString("author"));
                doc.addStringField("briefcontent", prj.getValueString("briefcontent"));
                doc.addNumberField("vnnumber", prj.getVnNumber());
                doc.addNumberField("projectdocid", prj.getDocID());
                doc.addReader("stavieva");
                doc.addEditor("stavieva");
                doc.addReader("dbutarev");
                doc.save("observer");
                prj.setRegDocID(doc.getDocID());
                prj.save("observer");
            } else {
             /*   msg = "Документ \"" + prj.getValueString("briefcontent") + "\" готов к отправке на регистрацию. Пожалуйста, проверьте правильность составления документа и все ли участники согласования ";
                msg += "одобрили документ. \nДля работы с документом перейдите по ссылке " + prj.getFullURL();
                msngAgent.sendMessage([author?.getInstMessengerAddr()], msg);

                subj = ' Проект для отправки на регистрацию \"' + prj.getValueString("briefcontent") + '\"';
                body += 'Проект документа подписан и готов к отправке на регистрацию. Проверьте правильность составления документа ';
                body += 'и все ли участники согласования одобрили документ.';
                mailAgent.sendMail([author?.getEmail()], new _Memo(subj, 'Согласование завершено', body, prj, false));
*/
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}






