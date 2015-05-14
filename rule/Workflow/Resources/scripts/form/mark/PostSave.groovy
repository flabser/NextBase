package form.mark
import kz.nextbase.script._Document
import kz.nextbase.script._Session
import kz.nextbase.script.constants._DocumentType
import kz.nextbase.script.events._FormPostSave
import kz.nextbase.script.mail._Memo
import kz.nextbase.script.task._Task

class PostSave extends _FormPostSave {

    public void doPostSave(_Session ses, _Document doc) {
        def executionReaders = doc.getReaders()
        def mdoc = doc.getGrandParentDocument()
        mdoc.addReader((HashSet<String>) executionReaders.collect { it.userID })


        executionReaders.each{
            mdoc.addReader(it.getUserID());
        }

        mdoc.save("[supervisor]")
        doc.addReader(mdoc.getValueString("curator"))
        doc.addReader(mdoc.getAuthorID())
        doc.save("[supervisor]")
        def readersList = mdoc.getReaders();
        def rescol = mdoc.getDescendants();
        mdoc.setSession(ses);
        rescol.each{ response ->
            readersList.each{ reader ->
                response.addReader(reader.getUserID());
            }
            response.save("[supervisor]");
        }

        String xmppmsg = ""
        def pdoc = doc.getParentDocument();
		doc.addReader(pdoc.getAuthorID())
		doc.save("[supervisor]");
        if (pdoc) {
            if (pdoc.getDocumentType() == _DocumentType.TASK) {
                def task = (_Task) pdoc;
                def execs = task.getExecutorsList();
                for (def e : execs) {
                    if (e.getUserID() == doc.getValueString("author") && e.getResponsible() != 1) {
                        e.setResetDate(new Date());
                        e.setResetAuthorID("auto");
                        task.save("[supervisor]");
                        break;
                    }
                }
            }
        }

        if (doc.getAuthorID() != pdoc.getAuthorID()) {
            println("Уведомление отправлено")
            def msngAgent1 = ses.getInstMessengerAgent()
            def mailAgent = ses.getMailAgent();
            println(pdoc.getAuthorID())

            xmppmsg = "Уведомление о новой отметке \n"
            xmppmsg += doc.getFullURL() + "\n"
            xmppmsg += "Вы получили данное сообщение как автор"

            def memo = new _Memo("Уведомление о новой отметке", "Новая отметка", "Новая отметка", doc, true)
            def recipient = ses.getStructure().getEmployer(pdoc.getAuthorID())
            def recipientEmail = recipient.getEmail();
            msngAgent1.sendMessage([recipient.getInstMessengerAddr()], xmppmsg)
            mailAgent.sendMail([recipientEmail], memo)
            def userActivity = ses.getUserActivity();
            userActivity.postActivity(this.getClass().getName(), "Memo has been send to " + recipientEmail)
        }
    }
}