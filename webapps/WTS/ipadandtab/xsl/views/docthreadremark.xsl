<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" encoding="utf-8"/>
	<xsl:variable name="useragent" select="request/@useragent"/>
	<xsl:variable name="skin" select="request/@skin"/>
	<xsl:template match="request/history"/>
	<xsl:template match="responses">
		<tr name="child" class="response{entry/@docid}" id="{entry/@docid}{@doctype}">
			<td id="parentdoccell">
				<script>
					parentTrCountCell=$("#parentdoccell").parent("tr").prev("tr").children("td").length;
					$("#parentdoccell").attr("colspan",parentTrCountCell - 2);
				</script>
				<xsl:apply-templates mode="line"/>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="viewtext" mode="line"/>
	<xsl:template match="sorting"/>
	
	<xsl:template match="entry" mode="line">
			<xsl:apply-templates select="." mode="item"/>
	</xsl:template>

	<xsl:template match="entry" mode="item">
		<a href="{@url}" title="{@viewtext}" class="doclink" style="font-style:arial; font-size:99%">
			<xsl:attribute name="onclick">javascript:beforeOpenDocument()</xsl:attribute>
			<xsl:if test="@isread = '0'">
				<xsl:attribute name="style">font-weight:bold</xsl:attribute>
			</xsl:if>
			<xsl:if test="@allcontrol = 0">
				<img id="control" title="Документ снят с контроля" src="/SharedResources/img/classic/icons/tick.png" border="0" style="margin-left:3px"/>&#xA0;
			</xsl:if>
			<xsl:if test="@hasattach != 0">
				<img id="atach" src="/SharedResources/img/classic/icons/attach.png" border="0" title="Вложений в документе: {@hasattach}"/>
			</xsl:if>
			<xsl:variable name='simbol'>'</xsl:variable>
			<xsl:variable name='ecr1'><xsl:value-of select="replace(@viewtext,$simbol ,'&quot;')"/></xsl:variable>	
			<xsl:variable name='ecr2'><xsl:value-of select="replace($ecr1, '&#34;' ,'&quot;')"/></xsl:variable>	
			<font id="font{@docid}{@doctype}">
				<script>
					text='<xsl:value-of select="$ecr2"/>';
					symcount= <xsl:value-of select="string-length(@viewtext)"/>;
					ids="font<xsl:value-of select="@docid"/><xsl:value-of select="@doctype"/>";
					replaceVal="<img/>";
					text=text.replace("-->",replaceVal);
					$("#"+ids).html(text);
					$("#"+ids+" > img").attr("src","/SharedResources/img/classic/arrow_blue.gif");
					$("#"+ids+" > img").attr("style","vertical-align:middle");
				</script>
			</font>
		</a>
	</xsl:template>

	
</xsl:stylesheet>