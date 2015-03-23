<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:variable name="doctype">structure</xsl:variable>
	<xsl:output method="html" encoding="utf-8"/>	
	<xsl:variable name="skin" select="request/@skin"/>
	<xsl:template match="/request/history"/>	
	
	<xsl:template name="indivperson">
		
	</xsl:template>	
		
	<xsl:template match="/request/query[@ruleid = 'customers']">	
		<xsl:variable name="queryid" select="/request/@id"/>
		<xsl:for-each select="descendant::entry">				
			<xsl:sort select="@viewtext"/>
			<div style="cursor:pointer; text-align:left" name="itemStruct">
				<xsl:attribute name="onmouseover">javascript:entryOver(this)</xsl:attribute>
				<xsl:attribute name="onmouseout">javascript:entryOut(this)</xsl:attribute>
				<xsl:attribute name="onclick">javascript:selectItemPicklist(this,event)</xsl:attribute>
			    <xsl:choose>
			    	<xsl:when test="$queryid = 'executers'">
			    		<xsl:attribute name="ondblclick">javascript:pickListSingleOk('<xsl:value-of select="userid"/>')</xsl:attribute>
			    	</xsl:when>
			    	<xsl:otherwise>
			    		<xsl:attribute name="ondblclick">javascript:pickListSingleOk('<xsl:value-of select="@docid"/>')</xsl:attribute>
			    	</xsl:otherwise>
			    </xsl:choose>						
				<input type="checkbox" name="chbox" id="{@docid}" value="{viewcontent/viewtext1}">
					<xsl:if test="userid =''">
						<xsl:attribute name="disabled">disabled</xsl:attribute>
					</xsl:if>	
					<xsl:if test="$queryid = 'executers'" >
						 <xsl:attribute name="id" select="userid"/>
					</xsl:if>						
					<font class="font" title="{viewcontent/viewtext1}" style="font-family:verdana; font-size:13px; margin-left:2px">
						<xsl:if test="docid =''">
							<xsl:attribute name="color">gray</xsl:attribute>
						</xsl:if> 
						<xsl:value-of select="viewcontent/viewtext1"/>
					</font>
				</input>
			</div>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="/request/query[@ruleid != 'customers']">	
		<xsl:variable name="queryid" select="/request/@id"/>
		<xsl:for-each select="descendant::entry">				
			<xsl:sort select="viewcontent/viewtext"/>
			<div style="cursor:pointer; text-align:left" name="itemStruct">
				<xsl:attribute name="onmouseover">javascript:entryOver(this)</xsl:attribute>
				<xsl:attribute name="onmouseout">javascript:entryOut(this)</xsl:attribute>
				<xsl:attribute name="onclick">javascript:selectItemPicklist(this,event)</xsl:attribute>
			    <xsl:choose>
			    	<xsl:when test="$queryid = 'executers'">
			    		<xsl:attribute name="ondblclick">javascript:pickListSingleOk('<xsl:value-of select="userid"/>')</xsl:attribute>
			    	</xsl:when>
			    	<xsl:otherwise>
			    		<xsl:attribute name="ondblclick">javascript:pickListSingleOk('<xsl:value-of select="@docid"/>')</xsl:attribute>
			    	</xsl:otherwise>
			    </xsl:choose>						
				<input type="checkbox" name="chbox" id="{@docid}" value="{viewcontent/viewtext}">
					<xsl:if test="userid =''">
						<xsl:attribute name="disabled">disabled</xsl:attribute>
					</xsl:if>	
					<xsl:if test="$queryid = 'executers'" >
						 <xsl:attribute name="id" select="userid"/>
					</xsl:if>						
					<font class="font" title="{@viewtext}" style="font-family:verdana; font-size:13px; margin-left:2px">
						<xsl:if test="docid =''">
							<xsl:attribute name="color">gray</xsl:attribute>
						</xsl:if> 
						<xsl:value-of select="viewcontent/viewtext"/>
					</font>
				</input>
			</div>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>