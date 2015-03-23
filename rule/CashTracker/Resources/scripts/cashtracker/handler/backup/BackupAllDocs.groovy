package cashtracker.handler.backup

import kz.nextbase.script._Helper
import kz.nextbase.script._Session
import kz.nextbase.script._ViewEntry
import kz.nextbase.script.events._DoScheduledHandler
import kz.pchelka.env.Environment

class BackupAllDocs extends _DoScheduledHandler {

	@Override
	public int doHandler(_Session session) {
		def docCollection = session.getCurrentDatabase().getCollectionOfDocuments("", true).getEntries()
		if (docCollection.size() > 0) {
			File backupPath = new File(Environment.backupDir)
			File path = new File(backupPath.getAbsolutePath() + File.separator + "Backup_" + _Helper.getDateAsString())
			if (!path.exists()){
				path.mkdirs()
			}

			docCollection.each { _ViewEntry entry ->
				def doc = entry.getDocument()
				File docPath = new File(path.getAbsolutePath() + File.separator + "doc_" + String.valueOf(doc.getDocID()))
				docPath.mkdirs()

				File flt = new File(docPath.getAbsolutePath() + File.separator + "Doc.xml")
				PrintWriter out = null
				try {
					out = new PrintWriter(new BufferedWriter(new FileWriter(flt)))
					out.print(doc.toXML())
				} catch (IOException e) {
					e.printStackTrace()
				} finally {
					if(out != null){
						out.flush()
						out.close()
					}
				}

				doc.getAttachments("rtfcontent", docPath.getAbsolutePath())
			}
		}

		return 0
	}
}
