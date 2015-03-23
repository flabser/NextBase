package finplanning.page.oth

import kz.nextbase.script._Helper
import kz.nextbase.script._Session
import kz.nextbase.script._Tag
import kz.nextbase.script._WebFormData
import kz.nextbase.script._XMLDocument
import kz.nextbase.script.constants._PeriodType
import kz.nextbase.script.events._DoScript

class PeriodDates extends _DoScript {

	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {

		def param = new Param(session, formData)
		def dateNow = new Date()
		def calendar = Calendar.getInstance()

		def prevDate
		def nextDate = param.periodDates.find {
			if(it > dateNow){
				return it
			}

			prevDate = it
			return false
		}

		def rootTag = new _Tag("period-dates")
		rootTag.setAttr("period-type", param.periodTypeName)

		param.periodDates.each {
			calendar.setTime(it)
			def tag = new _Tag("date", _Helper.getDateAsString(it))
			tag.setAttr("week-day", calendar.get(Calendar.DAY_OF_WEEK) - 1)
			if(prevDate > it){
				tag.setAttr("prev", "period-date-prev")
			}
			if(nextDate == it){
				tag.setAttr("next", "period-date-next")
			}
			rootTag.addTag(tag)
		}
		setContent(new _XMLDocument(rootTag))
	}

	class Param {

		def dateFrom = null
		def periodDates = []
		def periodType
		String periodTypeName

		public Param(_Session session, _WebFormData formData){

			def paramDate = formData.getValueSilently("date")
			dateFrom = _Helper.convertStringToDate(paramDate).clearTime()

			periodTypeName = formData.getValue("periodType")
			if(periodTypeName == "end-week"){
				periodType = _PeriodType.END_OF_WEEK
			} else if(periodTypeName == "end-month"){
				periodType = _PeriodType.END_OF_MONTH
			} else if(periodTypeName == "end-quarter"){
				periodType = _PeriodType.END_OF_QUARTER
			} else if(periodTypeName == "end-year"){
				periodType = _PeriodType.END_OF_YEAR
			}

			def pd = _Helper.getPeriodDates(periodType, false, session.getCurrentYear()) as List
			pd.each { Date it ->
				def date = it.clearTime()

				if(dateFrom <= date){
					periodDates << date
				}
			}
		}
	}
}
