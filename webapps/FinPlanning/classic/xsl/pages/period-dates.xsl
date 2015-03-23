<?xml version="1.0" ?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="html" encoding="utf-8" indent="no" />

	<xsl:template match="/request">
		<xsl:apply-templates select="//period-dates" />
	</xsl:template>

	<xsl:template match="period-dates">
		<div class="period-dates {@period-type}">
			<xsl:apply-templates mode="period-dates" />
		</div>
	</xsl:template>

	<xsl:template match="date" mode="period-dates">
		<span class="period-date {@prev} {@next}">
			<span class="period-date-header">
				<xsl:if test="../@period-type != 'end-week'">
					<span class="period-date-week-day">
						<xsl:choose>
							<xsl:when test="@week-day = 1">Пн</xsl:when>
							<xsl:when test="@week-day = 2">Вт</xsl:when>
							<xsl:when test="@week-day = 3">Ср</xsl:when>
							<xsl:when test="@week-day = 4">Чт</xsl:when>
							<xsl:when test="@week-day = 5">Пт</xsl:when>
							<xsl:when test="@week-day = 6">Сб</xsl:when>
							<xsl:when test="@week-day = 7">Вс</xsl:when>
						</xsl:choose>
					</span>
				</xsl:if>
				<span class="period-date-day">
					<xsl:value-of select="substring(., 1, 2)" />
				</span>
			</span>
			<span class="period-date-month-year">
				<xsl:value-of select="substring(., 4)" />
			</span>
			<span class="period-date-sum"></span>
		</span>
	</xsl:template>

</xsl:stylesheet>
