<?xml version="1.0" ?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:import href="../layout.xsl" />

	<xsl:output method="html" encoding="utf-8" indent="no" />

	<xsl:template match="/request">
		<xsl:call-template name="layout">
			<xsl:with-param name="widescreen" select="'layout_fullscreen'" />
			<xsl:with-param name="include">
				<script type="text/javascript" src="classic/js/statistics.js" />
				<script type="text/javascript" src="/SharedResources/jquery/js/ui/minified/i18n/jquery.ui.datepicker-ru.min.js" />

				<!-- vizualize -->
				<script type="text/javascript" src="/SharedResources/jquery/js/visualize/js/visualize.jQuery.js" />
				<!-- jchartfx -->
				<link rel="stylesheet" type="text/css" href="/SharedResources/jquery/js/jChartFX/styles/jchartfx.css" />
				<script type="text/javascript" src="/SharedResources/jquery/js/jChartFX/js/jchartfx.system.js"></script>
				<script type="text/javascript" src="/SharedResources/jquery/js/jChartFX/js/jchartfx.coreVector.js"></script>
				<script type="text/javascript" src="/SharedResources/jquery/js/jChartFX/js/jchartfx.animation.js"></script>
				<script type="text/javascript" src="/SharedResources/jquery/js/jChartFX/js/jchartfx.advanced.js"></script>

				<style>
					<![CDATA[
					.statistics {
						font-size: .9em;
						padding: 10px;
					}
					.stat-props {
						margin: 1em;
					}
					.stat-bar-container {
						height: 560px;
						min-height: 500px;
						width: 98%;
					}
					.jchartfx .PointLabel {
						fill: #222222;
					}
					.jchartfx .PointLabelBorder {
						/*fill: #DDDDDD;*/
					}]]>
				</style>
				<script>
					<![CDATA[
					var _calendarLang = "RUS";
					$(function() {
						var date = new Date();
						var n_month = date.getMonth();
						//
						var month = n_month < 10 ? "0" + n_month : n_month;
						//$("[name='date-from']").val(date.getDate() + "." + month + "." + date.getFullYear());
						$("[name='date-from']").datepicker({
							changeMonth : true,
							numberOfMonths : 1,
							regional : ['ru'],
							onClose : function(selectedDate) {
								$("[name='date-to']").datepicker("option", "minDate", selectedDate);
							}
						});
						//
						var month2 = (n_month + 1) < 10 ? "0" + (n_month + 1) : n_month + 1;
						//$("[name='date-to']").val(date.getDate() + "." + month2 + "." + date.getFullYear());
						$("[name='date-to']").datepicker({
							changeMonth : true,
							numberOfMonths : 1,
							regional : ['ru'],
							onClose : function(selectedDate) {
								$("[name='date-from']").datepicker("option", "maxDate", selectedDate);
							}
						});

						nbApp.chart.updateChartTimetable();
					});]]>
				</script>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="_content">
		<div class="statistics">
			<h3>
				<xsl:value-of select="page/captions/viewnamecaption/@caption" />
			</h3>
			<div class="stat-props">
				<form name="stat-props" action="Provider" method="GET" class="fieldset">
					<fieldset name="property" class="fieldset">
						<input type="hidden" name="type" value="page" />
						<input type="hidden" name="id" value="statistics-timetable-funds-data-ajax" />

						<div class="form-group collapsible">
							<div class="control-group">
								<div class="control-label">
									Период
								</div>
								<div class="controls">
									<input type="text" name="date-from" value="" class="date span2" />
									<xsl:text> - </xsl:text>
									<input type="text" name="date-to" value="" class="date span2" />
									<xsl:text> </xsl:text>
									<button type="reset" class="btn">x</button>
									<button type="button" class="btn" name="get-stat" onclick="nbApp.chart.updateChartTimetable()">Обновить</button>
									<div class="process-data-loading" style="display:inline-block">
										<img src="classic/img/loading-mini.gif" />
									</div>
								</div>
							</div>
							<div class="control-group">
								<div class="controls">
									<label style="display:none">
										<input type="checkbox" name="hide-zero" value="true" checked="true" />
										не показывать даты с суммой = 0
									</label>
									<label>
										<input type="checkbox" name="showSumLabel" value="1" />
										Показывать суммы в вершинах
									</label>
								</div>
							</div>
						</div>
					</fieldset>
				</form>
			</div>
			<div class="stat-bar-container" id="stat-pane">
				<div style="text-align:center">
					<img src="classic/img/loading-large.gif" />
				</div>
			</div>
		</div>
	</xsl:template>

</xsl:stylesheet>
