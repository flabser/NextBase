package finplanning.page.stat

import kz.nextbase.script._Document
import kz.nextbase.script._Helper
import kz.nextbase.script._Session
import kz.nextbase.script._Tag
import kz.nextbase.script._ViewEntryCollection
import kz.nextbase.script._WebFormData
import kz.nextbase.script._XMLDocument
import kz.nextbase.script.constants._PeriodType
import kz.nextbase.script.events._DoScript

class TimetableData extends _DoScript {

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
		def db = session.getCurrentDatabase()
		def viewParam = session.createViewEntryCollectionParam()
		viewParam.setPageNum(0)
				.setPageSize(0)
				.setUseFilter(false)
				.setCheckResponse(false)
				.setQuery("form in ('income', 'expense')")

		timetable = new Timetable(param.periodDatesYear)

		def preparedColl = prepareCollection(db.getCollectionOfDocuments(viewParam))

		preparedColl.each { TEntry it ->

			switch (it.repeat) {
				case REPEAT_END_WEEK:
					def countOfDay = countOfDayFrom(param.periodDatesWeek, it.date.time)
					addToEveryLastWorkDayWeek(it.date, it.sum / countOfDay, it.type)
					break
				case REPEAT_END_MONTH:
					def countOfDay = countOfDayFrom(param.periodDatesMonth, it.date.time)
					addToEveryLastWorkDayMonth(it.date, it.sum / countOfDay, it.type)
					break
				case REPEAT_END_QUARTER:
					def countOfDay = countOfDayFrom(param.periodDatesQuarter, it.date.time)
					addToEveryLastWorkDayQuarter(it.date, it.sum / countOfDay, it.type)
					break
				case REPEAT_END_YEAR:
					addToLastWorkDayYear(it.date, it.sum, it.type)
					break
				default:
					timetable.addEvent(it.date.time, it.sum, it.type)
			}
		}

		//
		def rootTag = new _Tag("timetable")
		def prevIncome = 0
		def prevExpense = 0

		timetable.list.each { date, listEventsForDay ->
			if(listEventsForDay.hasEvent()){
				def i = prevIncome + listEventsForDay.income
				def e = prevExpense + listEventsForDay.expense
				def b = i - e
				//
				if(listEventsForDay.date in param.periodDatesSelected){
					def tag = new _Tag("item")
					tag.setAttr("date", _Helper.getDateAsString(date))
					tag.setAttr("balance", "$b")
					tag.setAttr("income", "$i")
					tag.setAttr("expense", "-$e")
					tag.setAttr("incomeDay", "$listEventsForDay.income")
					tag.setAttr("expenseDay", "-$listEventsForDay.expense")
					tag.setAttr("prevIncome", "$prevIncome")
					tag.setAttr("prevExpense", "-$prevExpense")
					rootTag.addTag(tag)
				}
				//
				prevIncome = i
				prevExpense = e
			}
		}

		setContent(new _XMLDocument(rootTag))
	}

	// пробегаемся по графику, добавляем сумму на последний рабочей день недели
	def addToEveryLastWorkDayWeek(Calendar startDate, def sum, int type){
		def calendar = Calendar.instance

		timetable.list.each { date, listEventsForDay ->
			calendar.setTime(date)
			if(dateIsStarted(startDate, calendar) && isLastWorkDay(calendar)){
				listEventsForDay.add(sum, type)
			}
		}
	}

	// пробегаемся по графику, добавляем сумму на последний рабочий день месяца
	def addToEveryLastWorkDayMonth(Calendar startDate, def sum, int type){
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
	def addToEveryLastWorkDayQuarter(Calendar startDate, def sum, int type){
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
	def addToLastWorkDayYear(Calendar startDate, def sum, int type){
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

	public List <TEntry> prepareCollection(_ViewEntryCollection coll){
		def result = new ArrayList <TEntry> ()
		coll.getEntries().each {
			result.add(new TEntry(it.getDocument()))
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

		public TEntry (_Document doc){
			def _repeat = doc.getValueString("repeat")

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

			sum = doc.getValueNumber("summa")
			date = Calendar.instance
			date.setTime(doc.getValueDate("date"))
			date.clearTime()

			if(doc.getDocumentForm() == "income"){
				type = INCOME
			} else {
				type = EXPENSE
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
}
