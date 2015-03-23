<?xml version="1.0" ?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:import href="../layout.xsl" />

	<xsl:output method="html" encoding="utf-8" indent="no" />
	<xsl:decimal-format name="df" grouping-separator=" " />

	<xsl:template match="/request">
		<xsl:call-template name="layout">
			<xsl:with-param name="include">
				<style><![CDATA[
					.statistics {
						padding: 20px;
						overflow: auto;
					}
					.statistics .stat-header {
						background-color: #EEE;
						color: #333;
						padding: .3em;
						margin: 0;
					}
					.statistics .stat {
						background-color: #FFF;
						display: inline-block;
						margin: 20px;
						vertical-align: top;
					}
					.statistics .stat-content {
						font-size: 1em;
					}
					.statistics .stat-table {
						border-collapse: collapse;
					}
					.statistics .stat-table th {
						background-color: #EFF0F2;
						border: 1px solid #DDD;
						padding: .5em;
					}
					.statistics .stat-table td {
						border: 1px solid #DDD;
						padding: .4em 1em;
					}
					.statistics .stat-table tbody td:empty {
						background-color: #FAFCFC;
					}
					.statistics .title {
						font-size: 1em;
						font-weight: bold;
					}
					.statistics .plus {
						color: blue;
					}
					.statistics .minus {
						color: red;
					}
					.statistics th.sum {
						font-size: 1.3em;
					}
					.statistics tfoot {
						background-color: #EFF0F2;
					}
					.statistics tfoot .title {
						text-align: right;
					}
					.statistics .saldo {
						border-bottom: 1px solid #CCC;
						font-size: 1.5em;
						font-weight: normal;
						padding: 20px;
					}
					.statistics .max {
						background-color: #FFE6E6;
					}
					.statistics .min {
						background-color: #D7EBF8;
					}
					.statistics .saldo {
						float: none;
						font-weight: bold;
					}]]></style>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="_content">
		<div class="statistics">
			<h3>
				<xsl:value-of select="//page/captions/viewnamecaption/@caption" />
			</h3>
			<div class="stat-content">
				<xsl:apply-templates select="//page/view_content/response/content/statistics" />
			</div>
		</div>
	</xsl:template>

	<xsl:template match="statistics">
		<xsl:apply-templates select="saldo" />
		<xsl:apply-templates select="stat" />
	</xsl:template>

	<xsl:template match="stat">
		<div class="stat">
			<table class="stat-table">
				<thead>
					<tr>
						<th class="title">
							<xsl:value-of select="@title" />
						</th>
						<th class="plus">+</th>
						<th class="minus">-</th>
						<th class="sum">&#931;</th>
					</tr>
				</thead>
				<tbody>
					<xsl:apply-templates />
				</tbody>
			</table>
		</div>
	</xsl:template>

	<xsl:template match="stat_entry">
		<tr>
			<td class="title">
				<xsl:value-of select="@title" />
			</td>
			<td class="plus">
				<xsl:if test="plus = ../../@max">
					<xsl:attribute name="class">plus max</xsl:attribute>
					<xsl:attribute name="title">max</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="format-number(plus, '### ###.##', 'decimal-format')" />
			</td>
			<td class="minus">
				<xsl:if test="minus = ../../@min">
					<xsl:attribute name="class">minus min</xsl:attribute>
					<xsl:attribute name="title">min</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="format-number(minus, '### ###.##', 'decimal-format')" />
			</td>
			<td class="sum">
				<xsl:value-of select="format-number(sum, '### ###.##', 'decimal-format')" />
			</td>
		</tr>
	</xsl:template>

</xsl:stylesheet>
