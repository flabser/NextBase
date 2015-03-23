package finplanning.page.stat

import kz.nextbase.script._Helper
import kz.nextbase.script._Session
import kz.nextbase.script._Tag
import kz.nextbase.script._WebFormData
import kz.nextbase.script._XMLDocument
import kz.nextbase.script.events._DoScript

class StatisticsChart extends _DoScript {

	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {

		// println(formData)

		def db = session.getCurrentDatabase()

		def dateFrom = formData.getValueSilently("date-from")
		def dateTo = formData.getValueSilently("date-to")
		def sumOf = formData.getValueSilently("sum-of")
		def sumTo = formData.getValueSilently("sum-to")
		def categorys = formData.getListOfValuesSilently("category") as List
		def typeoperations = formData.getListOfValuesSilently("typeoperation") as List
		def statGroupBy = formData.getValueSilently("stat-group-by")

		def type = formData.getValueSilently("stat_type")
		int type_expense = 1
		int type_income = 2
		def _type = 0;
		if(type == "expense"){
			_type = type_expense
		} else if(type == "income"){
			_type = type_income
		}

		def viewParam = session.createViewEntryCollectionParam()
		viewParam.setPageNum(0)
				.setPageSize(0)
				.setUseFilter(false)
				.setCheckResponse(true)

		// collect query
		String sf = "form in ('bank_operation', 'operation')"

		if(dateFrom.length() > 0){
			def _ds = _Helper.convertStringToDate(dateFrom)
			sf += " and date#datetime >= '" + _ds.format("yyyy-MM-dd") + "'"
		}
		if(dateTo.length() > 0){
			def _de = _Helper.convertStringToDate(dateTo)
			sf += " and date#datetime <= '" + _de.format("yyyy-MM-dd") + "'"
		}

		if(sumOf.length() > 0){
			sf += " and viewnumber >= " + sumOf
		}
		if(sumTo.length() > 0){
			sf += " and viewnumber <= " + sumTo
		}

		if(categorys.size() > 0 && categorys[0]){
			sf += " and category#number in (" + categorys.join(",") + ")"
		}

		if(typeoperations.size() > 0 && typeoperations[0]){
			sf += " and viewtext3 in (" + typeoperations.collect{"'$it'"}.join(",") + ")"
		}

		if(_type == type_expense){
			sf += " and viewnumber < 0"
		} else if(_type == type_income){
			sf += " and viewnumber > 0"
		}
		// /collect query

		viewParam.setQuery(sf)

		// println(viewParam.toString())

		//
		def statData = new LinkedHashMap<?, ArrayList<BigInteger>>()
		def catNameList = new HashMap <String, String> () // cache

		def coll = db.getCollectionOfDocuments(viewParam)
		coll.getEntries().each {
			def doc = it.getDocument()
			int _cat
			try {
				_cat = doc.getValueNumber("category")
			} catch(e) {
				_cat = 0
			}
			def cat = String.valueOf(_cat)

			if(catNameList.get(cat) != null){
				statData.get(catNameList.get(cat)).add(doc.getViewNumber())
			} else {
				def catName
				if(_cat != 0){
					def catDoc = db.getGlossaryDocument(_cat)
					catName = catDoc?.getName()?:"category doc null"
				} else {
					catName = "no-category"
				}
				catNameList.put(cat, catName)
				def list = [doc.getViewNumber()]
				statData.put(catName, list)
			}
		}

		def statisticsTag = new _Tag("statistics")

		statData.each { categoryName, viewNumbers ->
			def statTag = new _Tag("stat")
			statTag.setAttr("title", categoryName)

			viewNumbers.each { sum ->
				def entry = new _Tag("entry")
				if(_type == type_expense){
					entry.setAttr("sum", String.valueOf(Math.abs(sum)))
				} else {
					entry.setAttr("sum", String.valueOf(sum))
				}
				statTag.addTag(entry)
			}

			statisticsTag.addTag(statTag)
		}

		setContent(new _XMLDocument(statisticsTag))
	}
}
