package form.demand_mysupport

import kz.nextbase.script.*
import kz.nextbase.script.actions._Action
import kz.nextbase.script.actions._ActionType
import kz.nextbase.script.events._FormQueryOpen
import kz.nextbase.script.task._Control
import java.util.Date;

class QueryOpen  extends _FormQueryOpen {
 
    public void doQueryOpen(_Session session, _WebFormData webFormData, String lang) {

    }

    def getRespProgress(_Document doc, _Session session) {
        String progress = "";
        doc.getResponses().each {
            progress += "<entry url='" + it.getFullURL().replace("&", "&amp;") + "'>" + it.getViewText().replace("<", "&lt;").replace(">", "&gt;").replace("&", "&amp;") + "<responses>" + getRespProgress(it, session) + "</responses>" + "</entry>"
        };
        return progress;
    }


    def publishParentDocs(_Document doc, _Session session) {
        String progress = getRespProgress(doc, session);

        def mdoc = doc;
		while (true) {
			if (mdoc == null) {
				break;
			}

			progress = "<entry url='" + mdoc.getFullURL().replace("&", "&amp;") + "'>" + mdoc.getViewText().replace("<", "&lt;").replace(">", "&gt;").replace("&", "&amp;") + "<responses>" + progress + "</responses></entry>";
			if (mdoc.getDocumentForm() == "milestone")
				break;
			else
				mdoc = mdoc.getParentDocument();
		}

		publishValue("parentMilestone", mdoc.getValueString("description"));
        def pdoc = mdoc.getParentDocument();
        publishValue("parentProject", pdoc.getValueString("project_name"));
    }

    public void doQueryOpen(_Session session, _Document doc, _WebFormData webFormData, String lang) {
        def actionBar = session.createActionBar();
        def cuserID = session.getCurrentAppUser().getUserID();
       
        actionBar.addAction(new _Action(getLocalizedWord("Закрыть", lang), getLocalizedWord("Закрыть без сохранения", lang), _ActionType.CLOSE))
        actionBar.addAction(new _Action(getLocalizedWord("Написать сообщение менеджеру", lang), getLocalizedWord("Написать сообщение менеджеру", lang), _ActionType.CUSTOM_ACTION));
        publishElement(actionBar)
        try {
            def nav = session.getPage("outline", webFormData)
            publishElement(nav)
            publishEmployer("docauthor", doc.getAuthorID());
            publishValue("docdate", doc.getValueString("docdate"))
            publishValue("vn", doc.getValueString("vn"))
            publishValue("regDate", _Helper.getDateAsString(doc.getRegDate()))
            publishValue("dvn", doc.getValueString("dvn"))
            publishValue("version", doc.getValueNumber("version"))
            publishValue("briefcontent", doc.getValueString("briefcontent"))
            publishValue("projectname", doc.getValueString("projectname"))
            publishValue("projectid", doc.getValueString("projectID"))
			publishValue("status", doc.getValueString("status"))
			publishValue("dateRevoked", doc.getValueString("dateRevoked"))
            try {
                publishAttachment("rtfcontent", "rtfcontent")
            } catch (Exception e) {

            }
            try {
                publishValue("control", doc.getValueObject("control"))
            } catch (_Exception e) {
				println(e)
            }
			try{
				publishGlossaryValue("revoke_demand_reason_id", doc.getValueGlossary("revoke_demand_reason_id"));
			} catch (_Exception e) {
	
			}
			try {
				publishGlossaryValue("extend_demand_reason_id", doc.getValueGlossary("extend_demand_reason_id"));
			} catch (_Exception e) {
	
			}
            publishParentDocs(doc, session)
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
