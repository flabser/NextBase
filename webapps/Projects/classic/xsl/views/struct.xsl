<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml"/>
	<xsl:variable name="skin" select="request/@skin"/>
	<xsl:template match="responses">
		<tr>
			<xsl:attribute name="class" select="concat('response', ../@docid)"/>
			<style type="text/css">
				div.Node * { vertical-align: middle }
			</style>
			<td style="text-align:left">
				<xsl:apply-templates mode="line"/>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="entry" mode="line">
		<div class="Node" style="cursor:pointer" title="{userid}">
			<xsl:attribute name="id" select="concat(@docid, @doctype)"/>
			<xsl:attribute name="onmouseover">javascript:entryOver(this)</xsl:attribute>
			<xsl:attribute name="onmouseout">javascript:entryOut(this)</xsl:attribute>
			<xsl:attribute name="ondblclick">javascript:pickListSingleOk(<xsl:value-of select="concat(@docid,@doctype)"/>)</xsl:attribute>
			<xsl:call-template name="graft"/>
			<xsl:apply-templates select="." mode="item"/>
		</div>
		<xsl:apply-templates mode="line"/>
	</xsl:template>

	<xsl:template match="entry" mode="item">
		<input type="checkbox" name="chbox">
			<xsl:attribute name="id" select="concat(@docid, @doctype)"/>
			<xsl:attribute name="value" select="@viewtext"/>
			<xsl:attribute name="class" select="concat(parent::*/@docid, parent::*/@doctype)"/>
			<xsl:if test="descendant::entry">
				<xsl:attribute name="onclick">javascript:checkall(this,<xsl:value-of select="concat(@docid,@doctype)"/>)</xsl:attribute>
			</xsl:if>
		</input>
		<font class="font"  style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:11px">
			<xsl:attribute name="id" select="concat('font', @docid, @doctype)"/>
			<xsl:attribute name="class"><xsl:value-of select="parent::*/@docid"/><xsl:value-of select="parent::*/@doctype"/></xsl:attribute>
			<xsl:value-of select="@viewtext"/>
		</font>
	</xsl:template>

	<xsl:template name="graft">
		<xsl:apply-templates select="ancestor::entry" mode="tree"/>
		<span style="width:12px">&#xA0;</span>
	</xsl:template>
	
	<xsl:template match="responses" mode="tree"/>

	<xsl:template match="*" mode="tree">
		<span style="width:16px">&#xA0;</span>
	</xsl:template>
	
	<xsl:template match="/request">
		<table border="0" width="100%">
			<tr bgcolor="#DFDFDF"></tr>
		</table>
		<table id="table" border="0" width="100%" bgcolor="#ffffff" style="border-collapse:collapse;">
			<xsl:for-each select="query/entry">
				<tr style="cursor:pointer">
					<td>
						<div style="margin-left:10px" title="{@form}">
							<xsl:value-of select="viewtext"/>
						</div>
					</td>
				</tr>
				<xsl:apply-templates select="responses"/>
			</xsl:for-each>
		</table>
	</xsl:template>
</xsl:stylesheet>