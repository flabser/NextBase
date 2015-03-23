<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="html" encoding="utf-8" indent="no" />

	<xsl:template match="/request/history" />

	<xsl:template match="/request">
		<ul class="dialog-list highlight-selected">
			<xsl:apply-templates select="query/entry">
				<xsl:sort select="@viewtext"></xsl:sort>
			</xsl:apply-templates>
		</ul>
	</xsl:template>

	<xsl:template match="entry">
		<li class="tree-entry">
			<label class="dialog-list-item" ondblclick="nb.dialog.execute(this)">
				<input type="checkbox" name="org-picklist" value="{@docid}" data-type="select" data-text="{@viewtext}" />
				<span class="input-label">
					<xsl:value-of select="@viewtext" />
				</span>
			</label>
		</li>
	</xsl:template>

</xsl:stylesheet>
