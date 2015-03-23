package finplanning.page.stat

import kz.nextbase.script._Helper
import kz.nextbase.script._Session
import kz.nextbase.script._Tag
import kz.nextbase.script._ViewEntry
import kz.nextbase.script._ViewEntryCollection
import kz.nextbase.script._WebFormData
import kz.nextbase.script._XMLDocument
import kz.nextbase.script.concurrency._AJAXHandler
import kz.nextbase.script.constants._JSONTemplate
import kz.nextbase.script.constants._PeriodType
import kz.nextbase.script.events._DoScript

class TimetableDataAjax extends _DoScript {

	private Timetable timetable

	private static final int INCOME = 0
	private static final int EXPENSE = 1

	private static final int REPEAT_ONCE_ONLY = 0
	private static final int REPEAT_END_WEEK = 1
	private static final int REPEAT_END_MONTH = 2
	private static final int REPEAT_END_QUARTER = 3
	private static final int REPEAT_END_YEAR = 4

	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {

		def param = new Param(session, formData)
		timetable = new Timetable(param.periodDatesYear)

		def data = new _Data()
		data.session = session
		data.param = param
		data.timetable = timetable
		data.tEntryList = prepareCollection(getDocsCollection(session))

		publishElement("", "", new ChartDataHandler(data), true, _JSONTemplate.URL)
		publishElement("", "", new DocCountChangeHandler(data), true, _JSONTemplate.URL)

		data.tEntryList.each { TEntry it ->
			switch (it.repeat) {
				case REPEAT_END_WEEK:
					def countOfDay = countOfDayFrom(param.periodDatesWeek, it.date.time)
					addToEveryLastWorkDayWeek(timetable, it.date, it.sum / countOfDay, it.type)
					break
				case REPEAT_END_MONTH:
					def countOfDay = countOfDayFrom(param.periodDatesMonth, it.date.time)
					addToEveryLastWorkDayMonth(timetable, it.date, it.sum / countOfDay, it.type)
					break
				case REPEAT_END_QUARTER:
					def countOfDay = countOfDayFrom(param.periodDatesQuarter, it.date.time)
					addToEveryLastWorkDayQuarter(timetable, it.date, it.sum / countOfDay, it.type)
					break
				case REPEAT_END_YEAR:
					addToLastWorkDayYear(timetable, it.date, it.sum, it.type)
					break
				default:
					addEvent(timetable, it.date, it.sum, it.type)
			}
		}

		setContent(new _XMLDocument(timetable.toXML(param.periodDatesSelected)))
	}

	//
	public static void addEvent(Timetable timetable, Calendar startDate, def sum, int type){
		timetable.addEvent(startDate.time, sum, type)
	}

	// пробегаемся по графику, добавляем сумму на последний рабочей день недели
	public static void addToEveryLastWorkDayWeek(Timetable timetable, Calendar startDate, def sum, int type){
		def calendar = Calendar.instance

		timetable.list.each { date, listEventsForDay ->
			calendar.setTime(date)
			if(dateIsStarted(startDate, calendar) && isLastWorkDay(calendar)){
				listEventsForDay.add(sum, type)
			}
		}
	}

	// пробегаемся по графику, добавляем сумму на последний рабочий день месяца
	public static void addToEveryLastWorkDayMonth(Timetable timetable, Calendar startDate, def sum, int type){
		def calendar = Calendar.instance
		int addedMonth = -1

		timetable.list.each { date, listEventsForDay ->
			calendar.setTime(date)

			if(dateIsStarted(startDate, calendar)){
				int month = calendar.get(Calendar.MONTH)
				int calendarDay = calendar.time.date

				if(addedMonth != month && calendarDay > 25){
					def lastDayOfMonth = calendar.getActualMaximum(Calendar.DAY_OF_MONTH)

					def lastDate = Calendar.instance
					lastDate.setTime(date)
					lastDate.set(Calendar.DATE, lastDayOfMonth)

					if(!isWeekend(lastDate) && calendarDay == lastDayOfMonth){
						listEventsForDay.add(sum, type)
						addedMonth = month
					} else if(isWeekend(lastDate) && isLastWorkDay(calendar)) {
						listEventsForDay.add(sum, type)
						addedMonth = month
					}
				}
			}
		}
	}

	// пробегаемся по графику, добавляем сумму на последний рабочий день квартального месяца
	public static void addToEveryLastWorkDayQuarter(Timetable timetable, Calendar startDate, def sum, int type){
		def calendar = Calendar.instance
		int addedMonth = -1

		timetable.list.each { date, listEventsForDay ->
			calendar.setTime(date)

			if(dateIsStarted(startDate, calendar)){
				int month = calendar.get(Calendar.MONTH) + 1
				int calendarDay = calendar.time.date

				if(addedMonth != month && isQuarterMonth(month)){
					def lastDayOfMonth = calendar.getActualMaximum(Calendar.DAY_OF_MONTH)

					def lastDate = Calendar.instance
					lastDate.setTime(date)
					lastDate.set(Calendar.DATE, lastDayOfMonth)

					if(!isWeekend(lastDate) && calendarDay == lastDayOfMonth){
						listEventsForDay.add(sum, type)
						addedMonth = month
					} else if(isWeekend(lastDate) && isLastWorkDay(calendar)) {
						listEventsForDay.add(sum, type)
						addedMonth = month
					}
				}
			}
		}
	}

	//
	public static void addToLastWorkDayYear(Timetable timetable, Calendar startDate, def sum, int type){
		def calendar = Calendar.instance
		calendar.setTime(timetable.list.keySet().last())
		if(calendar.get(Calendar.MONTH) != Calendar.DECEMBER){
			return
		}

		int addedMonth = -1

		timetable.list.each { date, listEventsForDay ->
			calendar.setTime(date)

			if(dateIsStarted(startDate, calendar)){
				int month = calendar.get(Calendar.MONTH)

				if(addedMonth != month && month == Calendar.DECEMBER){
					int calendarDay = calendar.time.date
					def lastDayOfMonth = calendar.getActualMaximum(Calendar.DAY_OF_MONTH)

					def lastDate = Calendar.instance
					lastDate.setTime(date)
					lastDate.set(Calendar.DATE, lastDayOfMonth)

					if(!isWeekend(lastDate) && calendarDay == lastDayOfMonth){
						listEventsForDay.add(sum, type)
						addedMonth = month
					} else if(isWeekend(lastDate) && isLastWorkDay(calendar)) {
						listEventsForDay.add(sum, type)
						addedMonth = month
					}
				}
			}
		}
	}

	public static def getDocsCollection(_Session session){
		def viewParam = session.createViewEntryCollectionParam()
		viewParam.setPageNum(0)
				.setPageSize(0)
				.setUseFilter(false)
				.setCheckResponse(false)
				.setQuery("form in ('income', 'expense')")

		return session.getCurrentDatabase().getCollectionOfDocuments(viewParam)
	}

	public List <TEntry> prepareCollection(_ViewEntryCollection coll){
		def result = new ArrayList <TEntry> ()
		coll.getEntries().each {
			result.add(new TEntry(it))
		}
		return result
	}

	public static int countOfDayFrom(def periodList, def startDate){
		return periodList.findAll{ it >= startDate }.size()
	}

	public static boolean isLastWorkDay(Calendar gc){
		return Calendar.FRIDAY == gc.get(Calendar.DAY_OF_WEEK)
	}

	public static boolean isWeekend(Calendar gc){
		return Calendar.SATURDAY == gc.get(Calendar.DAY_OF_WEEK) || Calendar.SUNDAY == gc.get(Calendar.DAY_OF_WEEK)
	}

	public static boolean isQuarterMonth(int month){
		return month.mod(3) == 0
	}

	// проверка даты начала
	public static boolean dateIsStarted(Calendar startDate, Calendar calendarDate){
		int r = startDate.compareTo(calendarDate)
		return r <= 0
	}

	// ---

	class Timetable {
		private Map <Date, TListEventsForDay> list

		public Timetable(def periodDates){
			list = new LinkedHashMap <Date, TListEventsForDay> ()

			periodDates.each {
				def date = it.clearTime()
				list.put(date, new TListEventsForDay(date))
			}
		}

		def addEvent(Date date, def sum, int type){
			list.get(date)?.add(sum, type)
		}

		def toJSON(def periodDates){
			def sb = []
			def prevIncome = 0
			def prevExpense = 0

			list.each { date, listEventsForDay ->
				if(listEventsForDay.hasEvent()){
					def i = prevIncome + listEventsForDay.income
					def e = prevExpense + listEventsForDay.expense
					def b = i - e

					if(listEventsForDay.date in periodDates){
						sb << "{\"date\":\"${_Helper.getDateAsString(date)}\",\"Поступления\":\"${scale(i)}\",\"Расходы\":\"${scale(e)}\",\"Баланс\":\"${scale(b)}\"}"
					}

					prevIncome = i
					prevExpense = e
				}
			}

			return "[" + sb.join(",\n") + "]"
		}

		def toXML(def periodDates){
			def rootTag = new _Tag("timetable")
			def prevIncome = 0
			def prevExpense = 0

			list.each { date, listEventsForDay ->
				if(listEventsForDay.hasEvent()){
					def i = prevIncome + listEventsForDay.income
					def e = prevExpense + listEventsForDay.expense
					def b = i - e

					if(listEventsForDay.date in periodDates){
						def tag = new _Tag("item")
						tag.setAttr("date", _Helper.getDateAsString(date))
						tag.setAttr("balance", scale(b))
						tag.setAttr("income", scale(i))
						tag.setAttr("expense", "-${scale(e)}")
						//tag.setAttr("incomeDay", scale(listEventsForDay.income))
						//tag.setAttr("expenseDay", "-${scale(listEventsForDay.expense)}")
						//tag.setAttr("prevIncome", "$prevIncome")
						//tag.setAttr("prevExpense", "-$prevExpense")
						rootTag.addTag(tag)
					}

					prevIncome = i
					prevExpense = e
				}
			}

			return rootTag
		}

		private String scale(BigDecimal n){
			return n.setScale(2, BigDecimal.ROUND_DOWN)
		}

		@Override
		public String toString(){
			return "$list.size"
		}
	}

	class TListEventsForDay {
		private Date date
		//private List <TEvent> incomeList = []
		//private List <TEvent> expenseList = []
		private def income = 0
		private def expense = 0

		public TListEventsForDay(Date date){
			this.date = date
		}

		def add(def sum, int type){
			if(type == INCOME){
				//incomeList << new TEvent(sum, type)
				income += sum
			} else {
				//expenseList << new TEvent(sum, type)
				expense += sum
			}
		}

		boolean hasEvent(){
			return income > 0 || expense > 0
		}

		def getBalance(){
			return income - expense
		}

		@Override
		public String toString(){
			return "$date: $income, $expense"
		}
	}

	class TEvent {
		private int type //INCOME || EXPENSE
		private def sum

		public TEvent(def sum, int type){
			this.sum = sum
			this.type = type
		}

		@Override
		public String toString(){
			return "$sum, $type"
		}
	}

	// ---

	class TEntry {

		private int type
		private int repeat
		private int sum
		private Calendar date

		public TEntry (_ViewEntry viewEntry){
			def _repeat = viewEntry.getViewText(5)

			if(_repeat == "end-week") {
				repeat = REPEAT_END_WEEK
			} else if(_repeat == "end-month") {
				repeat = REPEAT_END_MONTH
			} else if(_repeat == "end-quarter") {
				repeat = REPEAT_END_QUARTER
			} else if(_repeat == "end-year") {
				repeat = REPEAT_END_YEAR
			} else {
				repeat = REPEAT_ONCE_ONLY
			}

			sum = viewEntry.getViewNumberValue()
			date = Calendar.instance
			date.setTime(Date.parse("dd.MM.yyyy", viewEntry.getViewText(9).split(" ")[0]))
			date.clearTime()

			if(sum > 0){
				type = INCOME
			} else {
				type = EXPENSE
				sum = Math.abs(sum)
			}
		}

		@Override
		public String toString(){
			return "$date.time : $repeat, $sum, $type"
		}
	}

	// ---

	class Param {

		def dateFrom = null
		def dateTo = null
		public def periodDatesSelected = []
		public def periodDatesYear = []
		public def periodDatesWeek = []
		public def periodDatesMonth = []
		public def periodDatesQuarter = []
		public boolean hideZero

		public Param(_Session session, _WebFormData formData){
			def paramDateFrom = formData.getValueSilently("date-from")
			def paramDateTo = formData.getValueSilently("date-to")
			hideZero = formData.getValueSilently("hide-zero") == "true"

			if(paramDateFrom.length() > 0){
				dateFrom = _Helper.convertStringToDate(paramDateFrom).clearTime()
			}
			if(paramDateTo.length() > 0){
				dateTo = _Helper.convertStringToDate(paramDateTo).clearTime()
			}

			periodDatesWeek = _Helper.getPeriodDates(_PeriodType.END_OF_WEEK, false, session.getCurrentYear()) as List
			periodDatesWeek.each { Date it -> it.clearTime() }
			periodDatesMonth = _Helper.getPeriodDates(_PeriodType.END_OF_MONTH, false, session.getCurrentYear()) as List
			periodDatesMonth.each { Date it -> it.clearTime() }
			periodDatesQuarter = _Helper.getPeriodDates(_PeriodType.END_OF_QUARTER, false, session.getCurrentYear()) as List
			periodDatesQuarter.each { Date it -> it.clearTime() }

			periodDatesYear = _Helper.getPeriodDates(_PeriodType.WORKDAYS, false, session.getCurrentYear()) as List
			periodDatesYear.each { Date it ->
				def date = it.clearTime()

				if(dateFrom == null && dateTo == null){
					periodDatesSelected << date
				} else if(dateFrom != null && dateTo != null){
					if(dateFrom <= date && date <= dateTo){
						periodDatesSelected << date
					}
				} else if(dateFrom != null && dateFrom <= date){
					periodDatesSelected << date
				} else if(dateTo != null && date <= dateTo){
					periodDatesSelected << date
				}
			}
		}
	}

	//
	class _Data {
		def session
		private Timetable timetable
		private List <TEntry> tEntryList
		private Param param

		@Override
		public String toString(){
			return "$timetable,\n$param,\n$tEntryList,\n$session"
		}
	}

	class ChartDataHandler extends _AJAXHandler {
		def data

		public ChartDataHandler(_Data data){
			this.data = data
		}

		@Override
		public void doProcess()
		{
			clearPublish()
			publishJSON(data.timetable.toJSON(data.param.periodDatesSelected))

			println data
		}
	}

	class DocCountChangeHandler extends _AJAXHandler {
		def data

		public DocCountChangeHandler(_Data data){
			this.data = data
		}

		@Override
		public void doProcess()
		{
			def docs = TimetableDataAjax.getDocsCollection(data.session)

			clearPublish()
			publishJSON("{\"doc_count_change\" : ${data.tEntryList.size != docs.count}}")
		}
	}
}
