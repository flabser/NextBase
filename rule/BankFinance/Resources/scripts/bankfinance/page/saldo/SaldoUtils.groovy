package bankfinance.page.saldo

import kz.nextbase.script._Database
import kz.nextbase.script._ViewEntryCollectionParam

class SaldoUtils {

	public static BigDecimal[] getViewNumberTotal(_Database db, _ViewEntryCollectionParam viewParam) {
		return db.getCollectionOfDocuments(viewParam).getViewNumberTotal()
	}
}
