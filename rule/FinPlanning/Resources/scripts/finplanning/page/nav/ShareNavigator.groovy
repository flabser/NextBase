package finplanning.page.nav

import kz.nextbase.script.*
import kz.nextbase.script.events._DoScript
import kz.nextbase.script.outline.*

class ShareNavigator extends _DoScript {

	@Override
	public void doProcess(_Session session, _WebFormData formData, String lang) {
		def list = []
		def user = session. getCurrentAppUser()
		def outline = new _Outline("", "", "outline")

		def all_outline = new _Outline("Planning", "Planning", "plans")

		def allPlans = new _OutlineEntry(getLocalizedWord("Planned events", lang),
				getLocalizedWord("Planned events", lang), "all-plans", "Provider?type=page&id=all-plans&page=0")

		allPlans.addEntry(new _OutlineEntry(getLocalizedWord("Receiving", lang),
				getLocalizedWord("Receiving", lang), "all-income", "Provider?type=page&id=all-income&page=0"))
		allPlans.addEntry(new _OutlineEntry(getLocalizedWord("Expenses", lang),
				getLocalizedWord("Expenses", lang), "all-expense", "Provider?type=page&id=all-expense&page=0"))

		all_outline.addEntry(allPlans)
		outline.addOutline(all_outline)
		list.add(all_outline)

		// stat
		def stat_outline = new _Outline(getLocalizedWord("Statistics", lang),	getLocalizedWord("Statistics", lang), "stat")
		def statRootEntry = new _OutlineEntry(getLocalizedWord("Statistics", lang),
				getLocalizedWord("Statistics", lang), "statistics", "Provider?type=page&id=statistics")
		stat_outline.addEntry(statRootEntry)
		statRootEntry.addEntry(new _OutlineEntry(getLocalizedWord("Actual receiving", lang),
				getLocalizedWord("Actual receiving", lang), "statistics-chart-income", "Provider?type=page&id=statistics-chart-income"))
		statRootEntry.addEntry(new _OutlineEntry(getLocalizedWord("Actual expenses", lang),
				getLocalizedWord("Actual expenses", lang), "statistics-chart-expense", "Provider?type=page&id=statistics-chart-expense"))
		statRootEntry.addEntry(new _OutlineEntry(getLocalizedWord("Timetable of funds", lang),
				getLocalizedWord("Timetable of funds", lang), "statistics-timetable-funds", "Provider?type=page&id=statistics-timetable-funds"))
		outline.addOutline(stat_outline)
		list.add(stat_outline)

		setContent(list)
	}
}
