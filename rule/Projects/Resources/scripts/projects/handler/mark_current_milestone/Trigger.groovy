package projects.handler.mark_current_milestone

import kz.nextbase.script._Session
import kz.nextbase.script.events._DoScheduledHandler


class Trigger extends _DoScheduledHandler {
    @Override
    int doHandler(_Session session) {
        def nowDate = new Date()
        def db = session.getCurrentDatabase()
        def docs = db.getDocsCollection("form = 'milestone'", 0, 0)
        for (int i = 0; i < docs.getCount(); i++) {
            def doc = docs.getNthDocument(i)
            if ((doc.getValueDate("startdate") <= nowDate) && (doc.getValueDate("duedate") >= nowDate)) {
                doc.setValueString("current", 'on')
            } else {
                doc.setValueString("current", '')
            }
            doc.save("[supervisor]")
        }
        return 0;
    }
    /*
    Date().format(...)
    ERROR : java.lang.ClassCastException: java.lang.String cannot be cast to java.util.Date
	a,,t handler.mark_current_milestone.Trigger.doHandler(Trigger.groovy:15)
    */

	
}
