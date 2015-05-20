package projects.page.getDocsListDemandUnexecuted

import kz.nextbase.script._Helper
import kz.nextbase.script.task._Control
import kz.nextbase.script._Session
import kz.nextbase.script._WebFormData
import kz.nextbase.script.events._DoScript

/**
 * @author Bekzat
 * Возвращает все неисполненные заявки
 */

class DoScript extends _DoScript {

    @Override
    public void doProcess(_Session session, _WebFormData formData, String lang) {

        def page = 1;
        if (formData.containsField("page") && formData.getValue("page")){
            page = Integer.parseInt(formData.getValue("page"))
        }

        def formula = "form='demand' and viewtext4 = '1'";
        def db = session.getCurrentDatabase();
        def col = db.getCollectionOfDocuments(formula, page, true, true);

        try{
            col.getEntries().each {
                def control = new _Control(session, new Date(), false, _Helper.convertStringToDate(it.getViewText(9)));
                it.addViewText(control.getDiffBetweenDays(new Date()).toString(), "leftdays");
            }
        }catch(Exception e) {}
        setContent(col)
    }
}