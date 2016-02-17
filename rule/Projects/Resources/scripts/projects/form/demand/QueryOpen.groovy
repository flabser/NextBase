package projects.form.demand

import kz.nextbase.script.*
import kz.nextbase.script.actions.*
import kz.nextbase.script.events.*
import kz.nextbase.script.task._Control

class QueryOpen extends _FormQueryOpen {

	@Override
	public void doQueryOpen(_Session session, _WebFormData webFormData, String lang) {
        publishElement("current_userid", session.getCurrentUserID());
		def actionBar = session.createActionBar();
		actionBar.addAction(new _Action(getLocalizedWord("Сохранить и закрыть", lang), getLocalizedWord("Сохранить и закрыть", lang), _ActionType.SAVE_AND_CLOSE))
		actionBar.addAction(new _Action(getLocalizedWord("Закрыть", lang), getLocalizedWord("Закрыть без сохранения", lang), _ActionType.CLOSE))
		publishElement(actionBar)
		publishElement(getGlossariesList(session, "demand_type"));
		def nav = session.getPage("outline", webFormData)
		publishElement(nav)
		publishValue("title", getLocalizedWord("Заявка", lang))
		publishEmployer("docauthor", session.currentUserID)
		publishValue("docdate", session.getCurrentDateAsString())
        publishValue("startdate", session.getCurrentDateAsString())
		publishValue("version", 1)
        publishValue("publishforcustomer", "1");

		if (webFormData.containsField("parentdocid") && webFormData.containsField("parentdoctype")) {
			int pdocid = Integer.parseInt(webFormData.getValueSilently("parentdocid"))
			int pdoctype = Integer.parseInt(webFormData.getValueSilently("parentdoctype"))
			def pdoc = session.getCurrentDatabase().getDocumentByComplexID(pdoctype, pdocid);
			publishParentDocs(pdoc, session, "new")
		} else{
            def control = new _Control(session, new Date(), false, 6.3, 2)
            publishValue("control", control)
            publishValue("ctrlDateInJsFormat", control.getCtrlDate().format("MM/dd/yyyy"))
        }
	}

	def getRespProgress(_Document doc, _Session session) {
		String progress = "";
		doc.getResponses().each {
			progress += "<entry url='" + it.getFullURL().replace("&", "&amp;") + "'>" +"<viewtext>" +it.getViewText().replace("<", "&lt;").replace(">", "&gt;").replace("&", "&amp;") +"</viewtext>" +"<responses>" + getRespProgress(it, session) + "</responses>" + "</entry>"
		};
		return progress;
	}


	def publishParentDocs(_Document mdoc, _Session session, String status) {
		String progress = getRespProgress(mdoc, session);

        try{
            /* If parent demand checked as error, inherit it.  */
            if(mdoc.getDocumentForm() == "demand" && status == "new"){
                publishValue("iserror", mdoc.getValueString("iserror"));
				publishGlossaryValue("demand_type", mdoc.getValueString("demand_type"));
                def control = (_Control)mdoc.getValueObject("control")
				if (!control.getStartDate()) {
					control.setStartDate(mdoc.getRegDate())
				}
				publishValue("control",new _Control(session,new Date(), false, control.getBaseObject().priority,
                        control.getBaseObject().complication) )
            }else if(status == "new"){
                def control = new _Control(session,new Date(), false, 6.3, 2)
                publishValue("control", control)
            }
        }catch(Exception e){}

		while (true) {
			if (mdoc == null) {
				break;
			}

			progress = "<entry url='" + mdoc.getFullURL().replace("&", "&amp;") + "'>" + "<viewtext>"+mdoc.getViewText().replace("<", "&lt;").replace(">", "&gt;").replace("&", "&amp;") + "</viewtext>"+"<responses>" + progress + "</responses></entry>";
			if (mdoc.getDocumentForm() == "milestone")
				break;
			else
				mdoc = mdoc.getParentDocument();
		}

		publishValue("parentMilestone", mdoc.getValueString("description"));
		publishValue("parentMilestoneUrl", mdoc.getFullURL())

		// project
		def pdoc = mdoc.getParentDocument();
		publishValue("parentProject", pdoc.getValueString("project_name"));
		publishValue("parentProjectUrl", pdoc.getFullURL())
		publishValue("projectDocID", pdoc.getDocID())
		publishValue("projectDocType", pdoc.getDocType());
		publishValue("projectID", pdoc.getID());
		progress = "<entry url='" + pdoc.getFullURL().replace("&", "&amp;") + "'>" +"<viewtext>" +pdoc.getViewText().replace("<", "&lt;").replace(">", "&gt;").replace("&", "&amp;") +"</viewtext>"+ "<responses>" + progress + "</responses></entry>";
		// Ход исполнения
		publishValue(true, "demandProgress", progress);
	}

	@Override
	public void doQueryOpen(_Session session, _Document doc, _WebFormData webFormData, String lang) {
		def actionBar = session.createActionBar();
		def cuserID = session.getCurrentAppUser().getUserID();
        publishElement("current_userid", cuserID);
		def control = (_Control)doc.getValueObject("control")
		if (!control.getStartDate()) {
			control.setStartDate(doc.getRegDate())
		}
		if (cuserID == doc.getAuthorID() && control.allControl.value != 0) {
			actionBar.addAction(new _Action("Снять с контроля", "Снять с контроля", "RESET_CONTROL"))
			actionBar.addAction(new _Action("Отметить как не актуальное", "Отметить как не актуальное", "STOP_DOCUMENT"))
			actionBar.addAction(new _Action("Отменить заявку", "Отменить заявку", "REVOKE_DEMAND"))
			actionBar.addAction(new _Action("Продлить заявку", "Продлить заявку", "EXTEND_DEMAND"))
			actionBar.addAction(new _Action("Напомнить", "Напомнить", "REMIND_DEMAND"))
			if(doc.getResponses().size() == 0){
				actionBar.addAction(new _Action(getLocalizedWord("Изменить содержание документа", lang), getLocalizedWord("Изменить содержание документа", lang), "EDITCONTENT_DEMAND"))
			}
		}
		def executers = doc.getValueList("executer");
		if (executers.contains(cuserID) && control.allControl.value != 0) {
			actionBar.addAction(new _Action("Отметить исполнение", "Отметить исполнение", "COMPOSE_EXECUTION"))
		}
		def user = session.getCurrentAppUser();
		if (doc.isNewDoc == false && user.hasRole("registrator_demand") && control.allControl.value != 0) {
			actionBar.addAction(new _Action("Новая заявка", "Новая заявка", "NEW_DOCUMENT"))
		}
		if(user.hasRole("supervisor")){
			actionBar.addAction(new _Action(_ActionType.GET_DOCUMENT_ACCESSLIST))
		}
		actionBar.addAction(new _Action(getLocalizedWord("Закрыть", lang), getLocalizedWord("Закрыть без сохранения", lang), _ActionType.CLOSE))
		publishElement(actionBar)

		def nav = session.getPage("outline", webFormData)
		publishElement(nav)
		publishEmployer("docauthor", doc.getAuthorID());
		if(doc.getField("remind_demand")){
			publishValue("remind_demand", doc.getValueNumber("remind_demand"))
			publishValue("lastRemindDemand",doc.getValueString("lastRemindDemand"))
		}

		publishValue("docdate", doc.getValueString("docdate"))
		publishValue("responsible", doc.getValueString("responsible"))
		publishValue("responsible", doc.getValueString("responsible"))
		publishValue("vn", doc.getValueString("vn"))
		publishValue("regDate", doc.getRegDate().format("dd.MM.yyyy HH:mm"))
		publishValue("version", doc.getValueNumber("version"))
		publishValue("briefcontent", doc.getValueString("briefcontent"))
		//publishValue("projectname", doc.getValueString("projectname"))
		publishValue("iserror", doc.getValueString("iserror"))
		publishValue("publishforcustomer", doc.getValueString("publishforcustomer"))
		publishEmployer("executer", doc.getValueList("executer"))
		publishValue("dateRevoked", doc.getValueString("dateRevoked"))
		publishValue("status", doc.getValueString("status"))
		try {
			publishAttachment("rtfcontent", "rtfcontent")
		} catch (Exception e) {

		}
		try {
			publishValue("control", control)
		} catch (_Exception e) {
			println(e)
		}

		try {
			publishValue("docthread", doc.getAncestry())
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

		publishParentDocs(doc, session, "existing");
		publishElement(getGlossariesList(session, "demand_type"));


		def topcoll = session.getCurrentDatabase().getCollectionOfTopics("parentdocid = $doc.docID", 0, 0)
		publishValue("topics", topcoll);
		try {
			publishGlossaryValue("demand_type", doc.getValueString("demand_type"))
		} catch (_Exception e) {
			println(e)
		}

        try{
           // publishValue("startdate", _Helper.getDateAsString(doc.getValueDate("startdate")))
        }catch (Exception e){e.printStackTrace()}
	}
	
	def getGlossariesList(_Session ses, String gloss_form){
		
		def cdb = ses.getCurrentDatabase();
		def glist = cdb.getGlossaryDocs(gloss_form, "form='$gloss_form'");
		def glossaries = new _Tag("glossaries", "");
		def rootTag = new _Tag(gloss_form, "");
		
		for(def gdoc in glist){			
			def etag = new _Tag("entry", gdoc.getViewText());
			etag.setAttr("docid", gdoc.getDocID());			
			etag.setAttr("id", gdoc.getID());
			rootTag.addTag(etag);
		}
		glossaries.addTag(rootTag);
		def xml = new _XMLDocument(glossaries);
		return xml;
	}
}
