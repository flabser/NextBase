package form.topic

import kz.nextbase.script._Document
import kz.nextbase.script._Helper
import kz.nextbase.script._Session
import kz.nextbase.script.events._FormPostSave
import kz.nextbase.script.mail._Memo

class PostSave extends _FormPostSave{
    public void doPostSave(_Session ses, _Document doc) {
		def db = ses.getCurrentDatabase();
		int docID = doc.getDocID();
		int pDocID = doc.getParentDocID();
		int pDocType = doc.getParentDocType();
		def pDoc = doc.getParentDocument();
		pDoc.addNumberField("topicid", doc.getDocID());
		println(docID);
		println(pDocID);
		println(pDocType);
		if (pDocID != 0 && pDocType != 890) {
			db.setTopic(docID, pDocID, pDocType);
			println("Yes");
		}
	}
}
