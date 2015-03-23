package finplanning.page.stat

import kz.nextbase.script._Session
import kz.nextbase.script._Tag
import kz.nextbase.script._WebFormData
import kz.nextbase.script._XMLDocument
import kz.nextbase.script.events._DoScript

class Statistics extends _DoScript {

	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {

		//println(formData);

		def db = session.getCurrentDatabase()

		def pageId = formData.getValue("id")
		def startDate = formData.getValueSilently("startdate")
		def endDate = formData.getValueSilently("enddate")

		def viewParam = session.createViewEntryCollectionParam()
		viewParam.setPageNum(0)
				.setPageSize(0)
				.setUseFilter(false)
				.setCheckResponse(true)

		//
		def bank_account_stat = new HashMap<String, BigInteger[]>()
		def bank_account_docs = session.currentDatabase.getCollectionOfGlossaries("form='bank_account'", 0, 0)
		bank_account_docs.getEntries().each {
			def document = it.getDocument()
			String sf = "form = 'bank_operation' and bank_account = '" + document.getID() + "'"
			def col = session.getCurrentDatabase().getCollectionOfDocuments(viewParam.setQuery(sf))
			bank_account_stat.put(document.getValueString("name"), col.getViewNumberTotal())
		}
		bank_account_docs = null

		//
		def cash_stat = new HashMap<String, BigInteger[]>()
		def cash_docs = session.currentDatabase.getCollectionOfGlossaries("form='cash'", 0, 0)
		cash_docs.getEntries().each {
			def document = it.getDocument()
			String sf = "form = 'operation' and cash#number = " + document.getDocID()
			def col = session.getCurrentDatabase().getCollectionOfDocuments(viewParam.setQuery(sf))
			cash_stat.put(document.getValueString("name"), col.getViewNumberTotal())
		}
		cash_docs = null

		//
		viewParam = null

		int _total = 0
		int _plus = 1
		int _minus = 2

		def statisticsTag = new _Tag("statistics")
		def statTag = statisticsTag.addTag("stat")
		// -------------------------------------------------
		def _max = new BigDecimal(0)
		def _min = new BigDecimal(0)

		def saldoBank = [
			new BigDecimal(0),
			new BigDecimal(0),
			new BigDecimal(0)
		]

		//def bankStatTag = statisticsTag.addTag("stat")
		//bankStatTag.setAttr("title", "Bank Finance")
		bank_account_stat.each { k, v ->
			def entry = new _Tag("stat_entry")
			entry.setAttr("title", k)
			entry.addTag("sum", v[_total].setScale(2, BigDecimal.ROUND_DOWN))
			entry.addTag("plus", v[_plus].setScale(2, BigDecimal.ROUND_DOWN))
			entry.addTag("minus", v[_minus].setScale(2, BigDecimal.ROUND_DOWN))
			statTag.addTag(entry)

			_max = _max.max(v[_plus])
			_min = _min.min(v[_minus])

			saldoBank[_plus] = saldoBank[_plus] + v[_plus]
			saldoBank[_minus] = saldoBank[_minus] + v[_minus]
		}
		saldoBank[_total] = saldoBank[_plus] + saldoBank[_minus]
		//bankStatTag.setAttr("sum", saldoBank[_total].setScale(2).toString())
		//bankStatTag.setAttr("plus", saldoBank[_plus].setScale(2).toString())
		//bankStatTag.setAttr("minus", saldoBank[_minus].setScale(2).toString())

		// -------------------------------------------------
		_max = new BigDecimal(0)
		_min = new BigDecimal(0)

		def saldoCash = [
			new BigDecimal(0),
			new BigDecimal(0),
			new BigDecimal(0)
		]

		//def cashStatTag = statisticsTag.addTag("stat")
		//cashStatTag.setAttr("title", "Cash Tracker")
		cash_stat.each { k, v ->
			def entry = new _Tag("stat_entry")
			entry.setAttr("title", k)
			entry.addTag("sum", v[_total].setScale(2, BigDecimal.ROUND_DOWN))
			entry.addTag("plus", v[_plus].setScale(2, BigDecimal.ROUND_DOWN))
			entry.addTag("minus", v[_minus].setScale(2, BigDecimal.ROUND_DOWN))
			statTag.addTag(entry)

			_max = _max.max(v[_plus])
			_min = _min.min(v[_minus])

			saldoCash[_plus] = saldoCash[_plus] + v[_plus]
			saldoCash[_minus] = saldoCash[_minus] + v[_minus]
		}
		saldoCash[_total] = saldoCash[_plus] + saldoCash[_minus]
		//cashStatTag.setAttr("sum", saldoCash[_total].setScale(2).toString())
		//cashStatTag.setAttr("plus", saldoCash[_plus].setScale(2).toString())
		//cashStatTag.setAttr("minus", saldoCash[_minus].setScale(2).toString())

		//
		statisticsTag.setAttr("max", _max.setScale(2, BigDecimal.ROUND_DOWN).toString())
		statisticsTag.setAttr("min", _min.setScale(2, BigDecimal.ROUND_DOWN).toString())

		// -------------------------------------------------
		def saldo = [
			saldoBank[_total] + saldoCash[_total],
			saldoBank[_plus] + saldoCash[_plus],
			saldoBank[_minus] + saldoCash[_minus]
		]

		def saldoTag = new _Tag("saldo")
		saldoTag.addTag("sum", saldo[_total].setScale(2, BigDecimal.ROUND_DOWN))
		saldoTag.addTag("plus", saldo[_plus].setScale(2, BigDecimal.ROUND_DOWN))
		saldoTag.addTag("minus", saldo[_minus].setScale(2, BigDecimal.ROUND_DOWN))
		statisticsTag.addTag(saldoTag)

		setContent(new _XMLDocument(statisticsTag))
	}
}
