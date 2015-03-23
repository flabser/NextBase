<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" encoding="utf-8"/>
	<xsl:variable name="useragent" select="request/@useragent"/>
	<xsl:variable name="skin" select="request/@skin"/>
	<xsl:variable name="rid" select="request/@id"/>
	<xsl:template match="request/history"/>
	<xsl:variable name="ruleid"  select="request/query/responses/entry/@id"/>
	<xsl:template match="responses[$rid = 'docthread']">
		<tr name="child" class="response{entry/@docid}" id="{entry/@docid}{@doctype}">
			<td/>			
			<td/> 	
			<td/> 	
			<td/> 	
			<td nowrap="true" id="parentdoccell">
				<script>				
					parentTrCountCell=$("#parentdoccell").parent("tr").prev("tr").children("td").length;
					$("#parentdoccell").attr("colspan",parentTrCountCell - 4);
				</script> 	
				<xsl:apply-templates mode="line"/>
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="responses[$rid = 'docthread_project']">
		<tr name="child" class="response{entry/@docid}" id="{entry/@docid}{@doctype}">
			<td/>			
			<td nowrap="true" id="parentdoccell">
				<script>				
					parentTrCountCell=$("#parentdoccell").parent("tr").prev("tr").children("td").length;
					$("#parentdoccell").attr("colspan",parentTrCountCell - 3);
				</script> 	
				<xsl:apply-templates mode="line"/>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="viewtext" mode="line"/>
	<xsl:template match="sorting"/>
	
	<xsl:template match="entry" mode="line">
		<xsl:variable name="formname" select="@form"/>
		<xsl:if test="(/request/@id = 'docthread_project' and @form = 'milestone') or (/request/@id = 'docthread_project' and @form = 'projectDoc')">
			<div class="Node" style="overflow:hidden; width:100%; height:22px" id="{@docid}{@doctype}">
				<xsl:if test="$formname = 'milestone'">
					<xsl:attribute name="style">overflow:hidden; height:22px;background-color:#F8F8FF</xsl:attribute>
				</xsl:if>
				<xsl:call-template name="graft"/>
				<xsl:apply-templates select="." mode="item"/>				
			</div>
			<xsl:apply-templates mode="line"/>
			<script>
				form = '<xsl:value-of select="$formname" />';
				docid = '<xsl:value-of select="@docid" />';
				doctype = '<xsl:value-of select="@doctype" />'
				parid = '<xsl:value-of select="../../@docid" />'				
				$("#"+form+"list"+parid).append($("#"+docid+doctype));
			</script>
		 </xsl:if>
		<xsl:if test="/request/@id != 'docthread_project' and @form != 'projectDoc'">
			<div class="Node" style="overflow:hidden; width:100%; height:22px" id="{@docid}{@doctype}">
				<xsl:if test="$formname = 'milestone'">
					<xsl:attribute name="style">overflow:hidden; height:22px;background-color:#F8F8FF</xsl:attribute>
				</xsl:if>
				<xsl:call-template name="graft"/>
				<xsl:apply-templates select="." mode="item"/>				
			</div>
			<xsl:apply-templates mode="line"/>
			<script>
				form = '<xsl:value-of select="$formname" />';
				docid = '<xsl:value-of select="@docid" />';
				doctype = '<xsl:value-of select="@doctype" />'
				parid = '<xsl:value-of select="../../@docid" />'				
				$("#"+form+"list"+parid).append($("#"+docid+doctype));
			</script>
		 </xsl:if>
	</xsl:template>
	<xsl:template match="viewcontent" mode="line">
	
	</xsl:template>
	<xsl:template match="entry" mode="item">
		<!-- <xsl:if test="@form = 'projectDoc'">				
			<span style="width:15px;">
				<input type="checkbox" name="chbox" id="{@docid}" value="{@doctype}"/>
			</span>
		</xsl:if> -->
		<a  href="{@url}&amp;page={/request/query/@currentpage}" title="{viewcontent/viewtext}" class="doclink" style="font-style:Verdana,​Arial,​Helvetica,​sans-serif; width:100%; font-size:97%; margin-left:2px">
			<xsl:attribute name="onclick">javascript:beforeOpenDocument()</xsl:attribute>
			<xsl:if test="@isread = 0">
				<xsl:attribute name="style">font-weight:bold</xsl:attribute>
			</xsl:if> 
<!-- 			<xsl:if test="viewcontent/viewtext1 = 'reset'"> -->
<!-- 				<img id="control" height="14" title="Документ снят с контроля" src="/SharedResources/img/classic/icons/tick.png" border="0" style="margin-left:3px"/>&#xA0; -->
<!-- 			</xsl:if> -->
			<xsl:if test="@hasattach != 0">
				<img id="atach" src="/SharedResources/img/classic/icons/attach.png" border="0" style="vertical-align:top; margin-left:2px; margin-right:4px">
					<xsl:attribute name="title">Вложений в документе: <xsl:value-of select="@hasattach"/></xsl:attribute>
				</img> 
			</xsl:if>
			<xsl:variable name='simbol'>'</xsl:variable>
			<xsl:variable name='ecr1' select="replace(viewcontent/viewtext,$simbol ,'&quot;')"/>
			<xsl:variable name='ecr2' select="replace($ecr1, '&#34;' ,'&quot;')"/>
			<font class="font{@docid}{@doctype}" style="line-height:19px">
				<!-- <xsl:if test="@form = 'milestone'and /request/@id = 'docthread_project'">
					<xsl:attribute name="style">color:#333333;font-size:1.1em</xsl:attribute>
						<a href="Provider?type=edit&amp;element=document&amp;id=demand&amp;parentdocid={@docid}&amp;parentdoctype=896&amp;key=" title="Новая заявка">
						<xsl:attribute name="style">margin-left:15px;margin-top:2px</xsl:attribute>
						<img src="/SharedResources/img/iconset/sheduled_task.png" style="vertical-align:-3px" height="14px"/>
					</a>
				</xsl:if> -->
				<script>
					control = '<xsl:value-of select = "viewcontent/viewtext1" />'
					text='<xsl:value-of select="$ecr2"/>';
					symcount= <xsl:value-of select="string-length(@viewtext)"/>;
					ids="font<xsl:value-of select="@docid"/><xsl:value-of select="@doctype"/>";
 						replaceVal='<img class="arrow"/>';
						text=text.replace("->",replaceVal); 
						
						if(control == 'reset'){
						//text = $(text).find(":").first().after('<img class="control" />')
						replaceControl =': <img height="14" class="control"/>';
							text=text.replace(":",replaceControl); 
					} 
					
					$("."+ids).html(text);
					$("."+ids+" > .arrow").attr("src","/SharedResources/img/classic/arrow_blue.gif");
					$("."+ids+" > .arrow").attr("style","vertical-align:middle");
					$("."+ids+" > .control").attr("src","/SharedResources/img/classic/icons/tick.png");
					$("."+ids+" > .control").attr("style","vertical-align:top");
					
						
				</script>
			</font>
		</a>
	</xsl:template>
<xsl:template name="graft">
		<xsl:apply-templates select="ancestor::entry" mode="tree"/>
		<xsl:choose>
			<xsl:when test="following-sibling::entry">
				<img style="vertical-align:top;" src="/SharedResources/img/classic/tree_tee.gif"/>
			</xsl:when>
			<xsl:otherwise>
				<img style="vertical-align:top;" src="/SharedResources/img/classic/tree_corner.gif"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="responses" mode="tree"/>

	<xsl:template match="*" mode="tree">
		<xsl:choose>
			<xsl:when test="following-sibling::entry and entry[@url]">
				<img style="vertical-align:top;" src="/SharedResources/img/classic/tree_bar.gif"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="parent::responses">
					<img style="vertical-align:top;" src="/SharedResources/img/classic/tree_spacer.gif"/>
				</xsl:if>
				<xsl:if test="parent::entry">
					<img style="vertical-align:top;" src="/SharedResources/img/classic/tree_spacer.gif"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>