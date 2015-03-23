<?xml version="1.0" ?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="text" encoding="utf-8" indent="no" />

	<xsl:template match="/request">
		<xsl:apply-templates select="//timetable" />
	</xsl:template>

	<xsl:template match="timetable">
		<xsl:text>[</xsl:text>
		<xsl:apply-templates />
		<xsl:text>]</xsl:text>
	</xsl:template>

	<xsl:template match="item">
		<xsl:text>{"date":"</xsl:text>
		<xsl:value-of select="@date" />
		<xsl:text>",</xsl:text>
		<xsl:if test="@income">
			<xsl:text>"Поступления":</xsl:text>
			<xsl:value-of select="@income" />
			<xsl:if test="@expense">
				<xsl:text>,</xsl:text>
			</xsl:if>
			<!-- <xsl:text>"поступление за день":</xsl:text>
			<xsl:value-of select="@incomeDay" />
			<xsl:if test="@expense">
				<xsl:text>,</xsl:text>
			</xsl:if> -->
		</xsl:if>
		<xsl:if test="@expense">
			<xsl:text>"Расходы":</xsl:text>
			<xsl:value-of select="@expense" />
			<!-- <xsl:text>,"расходы за день":</xsl:text>
			<xsl:value-of select="@expenseDay" /> -->
		</xsl:if>
		<xsl:if test="@balance">
			<xsl:text>,"Баланс":</xsl:text>
			<xsl:value-of select="@balance" />
		</xsl:if>
		<xsl:text>}</xsl:text>
		<xsl:if test="following-sibling::node()">
			<xsl:text>,</xsl:text>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
