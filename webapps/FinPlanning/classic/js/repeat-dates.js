nbApp.getPeriodDates = function(periodType, date) {
	return nb.ajax({
		method : "GET",
		url : "Provider?type=page&id=period-dates&periodType=" + periodType + "&date=" + date
	});
};

nbApp.showRepeatDates = function(periodType, displayEl, sumFieldSelector) {
	var el = $(displayEl);

	if (periodType === "once-only") {
		// $("[name=date]").datepicker("option", "disabled", false);
		el.html("");
		return;
	}

	//
	nbApp.getPeriodDates(periodType, $("[name=date]").val()).then(function(result) {
		el.html(result);

		// $("[name=date]").val("").datepicker("option", "disabled", true);

		if (result.length === 0) {
			return result;
		}

		var sum = $(sumFieldSelector).val().replace(/\s/g, "");
		if (sum === "" || sum == 0) {
			return result;
		}

		var triadNumPattern = /(\d)(?=(\d\d\d)+([^\d]|$))/g;
		var periodDatesEl = $(".period-date-sum", el);
		var cc = (sum / periodDatesEl.length).toFixed(2);

		periodDatesEl.each(function() {
			$(this).html(("" + cc).replace(triadNumPattern, '$1 '));
		});

		return result;
	});
};
