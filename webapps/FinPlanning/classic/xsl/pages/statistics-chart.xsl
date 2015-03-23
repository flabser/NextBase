<?xml version="1.0" ?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:import href="../templates/select-options.xsl" />
	<xsl:import href="../layout.xsl" />

	<xsl:output method="html" encoding="utf-8" indent="no" />
	<xsl:decimal-format name="df" grouping-separator=" " />

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
						}]]>
				</style>
				<script>
						<![CDATA[
						$(function() {
							$('.date').datepicker({
								showOn: 'button',
								buttonImage: '/SharedResources/img/iconset/calendar.png',
								buttonImageOnly: true,
								regional: ['ru'],
								firstDay: 1,
								isRTL: false,
								showMonthAfterYear: false
							});

							nbApp.chart.updateChartBar();
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
						<input type="hidden" name="id" value="statistics-chart-data" />
						<xsl:choose>
							<xsl:when test="@id = 'statistics-chart-income'">
								<input type="hidden" name="stat_type" value="income" />
							</xsl:when>
							<xsl:when test="@id = 'statistics-chart-expense'">
								<input type="hidden" name="stat_type" value="expense" />
							</xsl:when>
						</xsl:choose>

						<button type="button" class="btn" style="margin-left:35%;" data-role="toggle" data-toggle-class="collapse">
							свернуть/развернуть параметры
						</button>
						<div class="form-group collapsible">
							<div class="control-group">
								<div class="control-label">
									Период
								</div>
								<div class="controls">
									<input type="text" name="date-from" value="" class="date span2" />
									<xsl:text> </xsl:text>
									<input type="text" name="date-to" value="" class="date span2" />
								</div>
							</div>
							<div class="control-group">
								<div class="control-label">
									Сумма
								</div>
								<div class="controls">
									от
									<input type="number" name="sum-of" value="" class="sum span2" />
									<xsl:text> </xsl:text>
									до
									<input type="number" name="sum-to" value="" class="sum span2" />
								</div>
							</div>
							<div class="control-group">
								<div class="control-label">
									Категория
								</div>
								<div class="controls">
									<div class="form-control-tags">
										<xsl:apply-templates select="//glossaries/select[@name='category']" mode="html-select-to-checkbox" />
									</div>
								</div>
							</div>
							<div class="control-group" style="display:none;">
								<div class="control-label">
									Тип
								</div>
								<div class="controls">
									<div class="form-control-tags">
										<xsl:apply-templates select="//glossaries/select[@name='typeoperation']" mode="html-select-to-checkbox" />
									</div>
								</div>
							</div>
							<div class="control-group" style="display:none;">
								<div class="control-label">
									Группировать по
								</div>
								<div class="controls">
									<label>
										<input type="radio" name="stat-group-by" value="category" checked="true" />
										категории
									</label>
									<label>
										<input type="radio" name="stat-group-by" value="typeoperation" />
										типу операции
									</label>
								</div>
							</div>
							<div class="control-group">
								<div class="controls">
									<label>
										<input type="checkbox" name="showSumLabel" value="1" checked="true" />
										Отображать суммы в столбцах
									</label>
								</div>
							</div>
						</div>
						<div class="control-group">
							<div class="controls action-bar">
								<button type="button" class="btn" name="get-stat" onclick="nbApp.chart.updateChartBar()">Обновить</button>
								<span style="padding:0 1em;"></span>
								<button type="reset" class="btn">Сбросить параметры</button>
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
