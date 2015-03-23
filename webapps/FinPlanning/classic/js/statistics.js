nbApp.chart = {};

/*
 * chartBar
 */
nbApp.chart.chartBar = function(items) {
	var chartPane = $('#stat-pane');
	chartPane.html("");

	var chart1 = new cfx.Chart();
	chart1.setGallery(cfx.Gallery.Bar);

	if ($("[name='showSumLabel']").is(":checked")) {
		var allSeries = chart1.getAllSeries();
		var pointLabels = allSeries.getPointLabels();
		pointLabels.setVisible(true);
		pointLabels.setBackgroundVisible(true);
	}

	// chart1.getAxisX().setStep(30);
	chart1.getLegendBox().setVisible(true);
	chart1.getLegendBox().setDock(cfx.DockArea.Bottom);
	chart1.getLegendBox().setContentLayout(cfx.ContentLayout.Near);
	chart1.getToolTips().setEnabled(true);

	chart1.setDataSource(items);
	chart1.create(chartPane[0]);
};

/*
 * updateChartBar
 */
nbApp.chart.updateChartBar = function() {
	$.ajax({
		url : "Provider?" + $(document["stat-props"]).serialize(),
		dataType : "json",
		complete : function(xhr) {
			if (xhr.responseText.length === 0) {
				$('#stat-pane').html("error");
				return;
			}

			var _items = eval("(" + xhr.responseText + ")");
			nbApp.chart.chartBar(_items);
		},
		error : function() {
			$('#stat-pane').html("error");
		}
	});
};

/*
 * 
 */
nbApp.chart.chartTimetable = function(items) {
	var chartPane = $('#stat-pane');
	chartPane.empty();

	var chart1;
	chart1 = new cfx.Chart();
	chart1.setGallery(cfx.Gallery.Lines);
	chart1.getLegendBox().setVisible(true);
	chart1.getLegendBox().setDock(cfx.DockArea.Bottom);
	chart1.getToolTips().setEnabled(false);
	chart1.getAnimations().getLoad().setEnabled(true);

	$("[name='showSumLabel']").click(function() {
		if (this.checked) {
			nbChartSetVisiblePointLabel(chart1, true);
		} else {
			nbChartSetVisiblePointLabel(chart1, false);
		}
	});

	//var totalItem = items.shift();
	chart1.setDataSource(items);

	chart1.getPanes().getItem(0).getAxisY().setForceZero(true);

	if ($("[name='showSumLabel']").is(":checked")) {
		nbChartSetVisiblePointLabel(chart1, true);
	}

	chart1.create(chartPane[0]);

	// chartPane.prepend("<h4 style='padding-left:20px;'>Σ: " + totalItem.total
	// + "</h4>");
	// chart1.update();
};

nbApp.chart.updateChartTimetable = function() {
	var fieldset = $("fieldset", document["stat-props"]);
	if (fieldset.is(":disabled")) {
		return;
	}

	$.ajax({
		url : "Provider?" + $(document["stat-props"]).serialize(),
		dataType : "xml",
		beforeSend : function() {
			fieldset.attr("disabled", true);
			$(".process-data-loading").show();
		},
		complete : function(xhr) {
			$(".process-data-loading").hide();
			if (xhr.responseText.length === 0) {
				$('#stat-pane').html("error");
				return;
			}

			var _items = eval("(" + xhr.responseText + ")");
			nbApp.chart.chartTimetable(_items);

			fieldset.attr("disabled", false);
		},
		error : function() {
			$('#stat-pane').html("error");
		}
	});
};

function nbChartSetVisiblePointLabel(chart, b) {
	var allSeries = chart.getAllSeries();
	var pointLabels = allSeries.getPointLabels();
	if (!pointLabels.visible || !b) {
		pointLabels.setVisible(b);
		pointLabels.setBackgroundVisible(b);
	}
}
