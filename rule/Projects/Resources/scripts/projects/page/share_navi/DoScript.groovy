package projects.page.share_navi

import kz.nextbase.script._Session;
import kz.nextbase.script._WebFormData
import kz.nextbase.script.*;
import kz.nextbase.script.events._DoScript
import kz.nextbase.script.outline.*;

class DoScript extends _DoScript {

	public void doProcess(_Session session, _WebFormData formData, String lang) {

		def user = session.getCurrentAppUser()
		def outline = new _Outline("", "", "outline")

		def mydoc_outline = new _Outline(getLocalizedWord("Мои документы",lang), getLocalizedWord("Мои документы",lang), "mydocs")
		mydoc_outline.addEntry(new _OutlineEntry(getLocalizedWord("Мои задания",lang), getLocalizedWord("Мои задания",lang), "mytasks", "Provider?type=page&id=mytasks&page=0"))
		mydoc_outline.addEntry(new _OutlineEntry(getLocalizedWord("Поручено мне",lang), getLocalizedWord("Поручено мне",lang), "tasksforme", "Provider?type=page&id=tasksforme&page=0"))
		mydoc_outline.addEntry(new _OutlineEntry(getLocalizedWord("Необработанные мной",lang), getLocalizedWord("Необработанные мной",lang), "tasksforme-unprocessed", "Provider?type=page&id=tasksforme-unprocessed&page=0"))
		mydoc_outline.addEntry(new _OutlineEntry(getLocalizedWord("Готовые к проверке",lang), getLocalizedWord("Готовые к проверке",lang), "tasksforme-readytocheck", "Provider?type=page&id=tasksforme-readytocheck&page=0"))
		mydoc_outline.addEntry(new _OutlineEntry(getLocalizedWord("Исполненные",lang), getLocalizedWord("Исполненные",lang), "completetasks", "Provider?type=page&id=completetasks&page=0"))
		mydoc_outline.addEntry(new _OutlineEntry(getLocalizedWord("Избранные",lang), getLocalizedWord("Избранные",lang), "favdocs", "Provider?type=page&id=favdocs&page=0"))
		
		//mydoc_outline.addEntry(new _OutlineEntry(getLocalizedWord("Проекты",lang), getLocalizedWord("Проекты",lang), "project", "Provider?type=page&id=project&page=0"))
		//mydoc_outline.addEntry(new _OutlineEntry(getLocalizedWord("Заявки",lang), getLocalizedWord("Заявки",lang), "demand-view", "Provider?type=page&id=demand-view&page=0"))
		outline.addOutline(mydoc_outline)

		def shareddocs_outline = new _Outline(getLocalizedWord("Общие документы",lang), getLocalizedWord("Общие документы",lang), "shareddocs")
		shareddocs_outline.addEntry(new _OutlineEntry(getLocalizedWord("Проекты",lang), getLocalizedWord("Проекты",lang), "projects", "Provider?type=page&id=projects&page=0"))
		shareddocs_outline.addEntry(new _OutlineEntry(getLocalizedWord("Текущие вехи",lang), getLocalizedWord("Текущие вехи",lang), "current_milestone", "Provider?type=page&id=current_milestone&page=0"))
		def demands = new _OutlineEntry(getLocalizedWord("Заявки",lang), getLocalizedWord("Заявки",lang), "demands", "Provider?type=page&id=demands&page=0")
		def col = session.currentDatabase.getGroupedEntries("projectID",1,100)
		col.each{
			def viewEntry = (_ViewEntry)it;
			try{
				def doc = session.currentDatabase.getDocumentByID(viewEntry.getViewText(0));
				def status = doc.getValueNumber("status")
				if(status != 3 && status != 4){
					def outlineEntry = new _OutlineEntry(doc.getViewText(), doc.getViewText(), viewEntry.getViewText(1), "Provider?type=page&id=demandsbyproject&prjid=" + viewEntry.getViewText(0) + "&page=0")
					outlineEntry.setValue(viewEntry.getViewText(1))
					demands.addEntry(outlineEntry)
				}
			}catch(_Exception e){

			}
		}


		/*def documents = session.currentDatabase.getAllDocuments(896, user.getListOfGroups(), session.currentUserID, 1, 1000)
		 documents.each{
		 if(it.getValueString("form")=="project"){
		 demands.addEntry(new _OutlineEntry(it.getValueString("viewtext"), it.getValueString("viewtext"), it.getValueString("viewtext"), "Provider?type=page&id=demandsbyproject&prjid="+it.getID()+"&page=0"))
		 }
		 }*/
		shareddocs_outline.addEntry(demands)
		def expired_demands = new _OutlineEntry(getLocalizedWord("Просроченные заявки",lang), getLocalizedWord("Просроченные заявки",lang), "expired-demands", "Provider?type=page&id=expired-demands&page=0")
		/*def fav_docs = new _OutlineEntry(getLocalizedWord("Избранные",lang), getLocalizedWord("Избранные",lang), "favdocs", "Provider?type=page&id=favdocs&page=0");
		 outline.addEntry(fav_docs);*/
		shareddocs_outline.addEntry(expired_demands)
		shareddocs_outline.addEntry(new _OutlineEntry(getLocalizedWord("Исполненные",lang), getLocalizedWord("Исполненные",lang), "completetasks-all", "Provider?type=page&id=completetasks-all&page=0"))
        shareddocs_outline.addEntry(new _OutlineEntry(getLocalizedWord("Неисполненные",lang), getLocalizedWord("Неисполненные",lang), "demand-unexecuted", "Provider?type=page&id=demand-unexecuted&page=0"))
        shareddocs_outline.addEntry(new _OutlineEntry(getLocalizedWord("Необработанные",lang), getLocalizedWord("Необработанные",lang), "demand-unprocessed", "Provider?type=page&id=demand-unprocessed&page=0"))
		outline.addOutline(shareddocs_outline)

		if (user.hasRole("statistics_viewer")){
			def statistics_outline = new _Outline(getLocalizedWord("Статистика",lang), getLocalizedWord("Статистика",lang), "stat_folder")
			statistics_outline.addEntry(new _OutlineEntry(getLocalizedWord("Степень занятости",lang), getLocalizedWord("Степень занятости",lang), "statistics_staff_workload", "Provider?type=page&id=statistics_staff_workload"))
			statistics_outline.addEntry(new _OutlineEntry(getLocalizedWord("Активность проектов",lang), getLocalizedWord("Активность проектов",lang), "statistics_projects_activity", "Provider?type=page&id=statistics_projects_activity"))
			statistics_outline.addEntry(new _OutlineEntry(getLocalizedWord("Исполненные заявки",lang), getLocalizedWord("Исполненные заявки",lang), "statistics_complete_demand", "Provider?type=page&id=statistics_complete_demand"))
			outline.addOutline(statistics_outline)
		}
		if (user.hasRole("administrator")){
			def glossary_outline = new _Outline(getLocalizedWord("Справочники",lang), getLocalizedWord("Справочники",lang), "glossary")
			/*glossary_outline.addEntry(new _OutlineEntry(getLocalizedWord("Заказчики",lang), getLocalizedWord("Заказчики",lang), "customers", "Provider?type=page&id=customers"))
			glossary_outline.addEntry(new _OutlineEntry(getLocalizedWord("Должность",lang), getLocalizedWord("Должность",lang), "post", "Provider?type=page&id=post"))*/
			glossary_outline.addEntry(new _OutlineEntry(getLocalizedWord("Причины отмены заявки",lang), getLocalizedWord("Причины отмены заявки",lang), "demand_revoke_reason", "Provider?type=page&id=demand_revoke_reason&page=1"))
			glossary_outline.addEntry(new _OutlineEntry(getLocalizedWord("Причины продления заявки",lang), getLocalizedWord("Причины продления заявки",lang), "demand_extend_reason", "Provider?type=page&id=demand_extend_reason&page=1"))
			glossary_outline.addEntry(new _OutlineEntry(getLocalizedWord("Типы заявок",lang), getLocalizedWord("Типы заявок",lang), "demand_type", "Provider?type=page&id=demand_type&page=1"))
			outline.addOutline(glossary_outline)

		}

		setContent(outline)
	}
}
