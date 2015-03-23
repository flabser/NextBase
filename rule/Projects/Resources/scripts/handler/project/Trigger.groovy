package handler.project;

import kz.nextbase.script.events._DoHandler;
import kz.nextbase.script.*;

public class Trigger extends _DoHandler {
   

	@Override
	public void doHandler(_Session session, _WebFormData formData) {
		def db = session.getCurrentDatabase();
        def docs = db.getDocsCollection("form='demand' ");
        for (int i = 0; i < docs.getCount(); i++) {
            def doc = docs.getNthDocument(i);
            def parentDoc = doc.getGrandParentDocument();
            if ("project".equalsIgnoreCase(parentDoc.getDocumentForm())){
                String vtext = parentDoc.getViewText();
                doc.setValueString("projectname", vtext);
                doc.save("observer");
            }
        }
		
	}
}
