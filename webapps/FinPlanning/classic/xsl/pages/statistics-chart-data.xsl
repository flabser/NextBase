<?xml version="1.0" ?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="text" encoding="utf-8" indent="no" />

	<xsl:template match="/request">
		<xsl:apply-templates select="//view_content/response/content/statistics" />
	</xsl:template>

	<xsl:template match="statistics">
		<xsl:text>[{</xsl:text>
		<xsl:apply-templates />
		<xsl:text>}]</xsl:text>
	</xsl:template>

	<xsl:template match="stat">
		<xsl:text>"</xsl:text>
		<xsl:value-of select="@title" />
		<xsl:text>":</xsl:text>
		<xsl:value-of select="sum(entry/@sum)" />
		<xsl:if test="following-sibling::node()">
			<xsl:text>,</xsl:text>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
