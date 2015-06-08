package projects.handler.prjs_recalculator

import kz.nextbase.script._Session
import kz.nextbase.script._ViewEntry
import kz.nextbase.script.events._DoScheduledHandler
import kz.nextbase.script.task._Control

class Trigger extends _DoScheduledHandler {

	@Override
	public int doHandler(_Session session) {

		def db = session.getCurrentDatabase()
		def col = db.getCollectionOfDocuments("form='demand' and viewtext4='1'", true).getEntries()
		col.each { _ViewEntry entry ->
			def doc = entry.getDocument()
            def control = (_Control) doc.getValueObject("control")
            //doc.setViewNumber((control.getDiffBetweenDays()))
            if (control) {
                int diffdays = control.getDiffBetweenDays();
                control.addMarkOfExpiration(diffdays);
                doc.addField("control", control)
                doc.setValueNumber("duedatedif", diffdays)
                doc.replaceViewText(diffdays as String, 2)
                doc.setViewDate(control.getCtrlDate())
                doc.save("[supervisor]")
            }
		}

		return 0;
	}


}