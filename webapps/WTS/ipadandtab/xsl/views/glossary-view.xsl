<?xml version="1.0" ?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"> 
	<xsl:import href="../templates/view.xsl"/>	
	<xsl:variable name="viewtype">Вид</xsl:variable>
	<xsl:output method="html" encoding="utf-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" indent="no"/>
	<xsl:variable name="useragent" select="request/@useragent"/>
	<xsl:template match="query/entry">
		<xsl:variable name="num" select="position()"/>
		<tr class="{@docid}" id="{@docid}{@doctype}" onmouseover="javascript:elemBackground(this,'EEEEEE')" onmouseout="elemBackground(this,'FFFFFF')">
			<xsl:attribute name="bgcolor">#FFFFFF</xsl:attribute>
			<xsl:if test="@isread = '0'">
				<xsl:attribute name="style">font-weight:bold</xsl:attribute>
			</xsl:if>
			<xsl:call-template name="viewtable_dblclick_open"/>
			<td style="text-align:center; border:1px solid #dddddd;width:40px; padding:12px 5px">
				<input type="checkbox" name="chbox" id="{@docid}" value="{@doctype}" style="width:20px; height:20px"/>
			</td>
			<td nowrap="nowrap" style="border:1px solid #ccc">
				<div style="display:block; overflow:hidden; width:93%;">&#xA0;
					<xsl:if test="hasresponse='true' and //request/@id!='toconsider'">
          				<xsl:choose>
          					<xsl:when test=".[responses]">
								<a href="" style="vertical-align:top; margin-left:3px" id="a{@docid}">
									<xsl:attribute name='href'>javascript:closeGlossResponses(<xsl:value-of select="@docid"/>, <xsl:value-of select="@doctype"/>,<xsl:value-of select="position()"/>,1)</xsl:attribute>
									<img border='0' src="/SharedResources/img/classic/minus.gif" id="img{@docid}"/>
								</a>
							</xsl:when>
							<xsl:otherwise>
								<a href="" style="vertical-align:top; margin-left:3px" id="a{@docid}">
									<xsl:attribute name='href'>javascript:openParentGlossView(<xsl:value-of select="@docid"/>, <xsl:value-of select="@doctype"/>,<xsl:value-of select="position()"/>,1)</xsl:attribute>
									<img border='0' src="/SharedResources/img/classic/plus.gif" id="img{@docid}"/>
								</a>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
					<xsl:if test="not(hasresponse)">
						<span style="width:11px; display:inline-block"></span>
					</xsl:if>
					<a href="{@url}&amp;page={/request/query/@currentpage}" style="padding-left:5px;" title="{@viewtext}" class="doclink">
						<xsl:attribute name="onclick">javascript:beforeOpenDocument()</xsl:attribute>
						<xsl:if test="@isread = '0'">
							<xsl:attribute name="style">font-weight:bold</xsl:attribute>
						</xsl:if>
						<xsl:if test="../@ruleid != 'favdocs'">
							<xsl:value-of select="viewcontent/viewtext1"/>
						</xsl:if>
						<xsl:if test="../@ruleid = 'favdocs'">
							<xsl:value-of select="@viewtext"/>
						</xsl:if>
					</a>
				</div>
			</td>
			<xsl:if test="../@ruleid = 'contractor'">
				<td  nowrap="nowrap" style="border:1px solid #ccc; border-left:none; width:200px; text-align:center">
					<xsl:value-of select="viewcontent/viewtext2"/>
				</td>
			</xsl:if>
			<xsl:if test="../@ruleid = 'favdocs'">
				<td  nowrap="nowrap" style="border:1px solid #ccc; border-left:none; width:30px; text-align:center">
					<img class="favicon" style="cursor:pointer; width:19px; height:19px" src="/SharedResources/img/iconset/star_empty.png">
						<xsl:if test="@favourites = 1">
							<xsl:attribute name="onclick">javascript:removeDocFromFav(this,<xsl:value-of select="@docid"/>,<xsl:value-of select="@doctype"/>)</xsl:attribute> 
							<xsl:attribute name="src">/SharedResources/img/iconset/star_full.png</xsl:attribute> 
						</xsl:if>
						<xsl:if test="@favourites = 0"> 
							<xsl:attribute name="onclick">javascript:addDocToFav(this,<xsl:value-of select="@docid"/>,<xsl:value-of select="@doctype"/>)</xsl:attribute>
							<xsl:attribute name="src">/SharedResources/img/iconset/star_empty.png</xsl:attribute> 
						</xsl:if>
					</img>
				</td>
			</xsl:if>
		</tr>
		<xsl:apply-templates select="responses"/>
	</xsl:template>
	
	<xsl:template match="responses">
		<tr class="response{../@docid}" >
			<xsl:attribute name="bgcolor">#FFFFFF</xsl:attribute>
			<td style="width:3%"/>
			<td nowrap="true" style="padding-left:9px">
				<xsl:apply-templates mode="line"/>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template match="viewtext" mode="line"/>
	
	<xsl:template match="entry" mode="line">
		<div class="Node" style="overflow:hidden;" id="{@docid}{@doctype}">
			<xsl:call-template name="graft"/>
			<xsl:apply-templates select="." mode="item"/>
		</div>
		<xsl:apply-templates mode="line"/>
	</xsl:template>

	<xsl:template match="entry" mode="item">
		<a  href="{@url}&amp;page={/request/query/@currentpage}" title="{@viewtext}" class="doclink" style="font-style:arial; width:100%; font-size:99%">
			<xsl:attribute name="onclick">javascript:beforeOpenDocument()</xsl:attribute>
			<xsl:if test="@isread = 0">
				<xsl:attribute name="style">font-weight:bold</xsl:attribute>
			</xsl:if>
			<xsl:if test="@allcontrol = 0">
				<img id="control" title="Документ снят с контроля" src="/SharedResources/img/classic/icons/tick.png" border="0" style="margin-left:3px"/>&#xA0;
			</xsl:if>
			<xsl:if test="@hasattach != 0">
				<img id="atach" src="/SharedResources/img/classic/icons/attach.png" border="0" style="vertical-align:top">
					<xsl:attribute name="title">Вложений в документе: <xsl:value-of select="@hasattach"/></xsl:attribute>
				</img> 
			</xsl:if>
			<xsl:variable name='simbol'>'</xsl:variable>
			<xsl:variable name='ecr1' select="replace(viewtext,$simbol ,'&quot;')"/>
			<xsl:variable name='ecr2' select="replace($ecr1, '&#34;' ,'&quot;')"/>
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
	
	<xsl:template match="/request">
		<html>
			<head>
				<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
				<title>WTS - <xsl:value-of select="columns/column[@id = 'VIEW']/@caption"/></title>
				<link type="text/css" rel="stylesheet" href="ipadandtab/css/outline.css"/>
				<link type="text/css" rel="stylesheet" href="ipadandtab/css/main.css"/>
				<link type="text/css" rel="stylesheet" href="/SharedResources/jquery/css/smoothness/jquery-ui-1.8.20.custom.css"/>
				<link type="text/css" rel="stylesheet" href="/SharedResources/jquery/js/hotnav/jquery.hotnav.css"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/jquery-1.4.2.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.widget.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.core.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.effects.core.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.datepicker.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.datepicker-ru.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.mouse.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.draggable.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.position.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.button.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.dialog.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/cookie/jquery.cookie.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/hotnav/jquery.hotkeys.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/hotnav/jquery.hotnav.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/scrollTo/scrollTo.js"/>
				<script type="text/javascript" src="ipadandtab/scripts/outline.js"/>
				<script type="text/javascript" src="ipadandtab/scripts/view.js"/>
				<script type="text/javascript" src="ipadandtab/scripts/form.js"/>
				<script type="text/javascript">
					$(document).ready(function(){
						outline.type = '<xsl:value-of select="@type" />'; 
						outline.viewid = '<xsl:value-of select="@id" />';
						outline.element = 'project';
						outline.command='<xsl:value-of select="current/@command" />';
						outline.curPage = '<xsl:value-of select="current/@page" />'; 
						outline.category = '';
						outline.filterid = '<xsl:value-of select="@id"/>';
						refresher();  
					});
				</script>		
			</head>			
			<body>
				<xsl:call-template name="flashentry"/>
				<div id="wrapper">
					<xsl:call-template name="header-view"/>
						<span id="view" class="viewframe">
						<div id="viewcontent" style="margin-left:12px;">
							<div id="viewcontent-header" style="height:73px;">
						<xsl:call-template name="viewinfo"/>
						<div class="button_panel" style="margin-top:8px">
							<script type="text/javascript">    
					       		$(function() {
									$( ".button_panel button" ).button();
			        			});
    						</script>
							<span style="float:left; margin-left:3px; margin-top:2px">
								<xsl:if test="action[.='NEW_DOCUMENT']/@enable = 'true'">
									<button title="{action[.='NEW_DOCUMENT']/@hint}" id="btnNewdoc">
										<xsl:attribute name="onclick">javascript:window.location.href="<xsl:value-of select="newDocURL"/>&amp;page=0"; beforeOpenDocument()</xsl:attribute>
										<img src="/SharedResources/img/classic/icons/page_white.png" class="button_img"/>
										<font style="font-size:12px; vertical-align:top"><xsl:value-of select="action[.='NEW_DOCUMENT']/@caption"/></font>
									</button>
								</xsl:if>
								<xsl:if test="action[.='DELETE_DOCUMENT']/@enable = 'true'">
									<button title="{columns/column[@id = 'BTNDELETEDOCUMENT']/@hint}" style="margin-left:5px">
										<xsl:attribute name="onclick">javascript:delGlossary("Avanti","0");</xsl:attribute>
										<img src="/SharedResources/img/classic/icons/page_white_delete.png" class="button_img"/>
										<font style="font-size:12px; vertical-align:top"><xsl:value-of select="columns/column[@id = 'BTNDELETEDOCUMENT']/@caption"/></font>
									</button>
								</xsl:if>
								<xsl:if test="action[.='DELETE_GLOSSARY']/@enable = 'true'">
									<button title="{columns/column[@id = 'BTNDELETE']/@hint}" id="btnDeldoc" style="margin-left:5px">
										<xsl:attribute name="onclick">javascript:delGlossary("Avanti","0");</xsl:attribute>
										<img src="/SharedResources/img/classic/icons/page_white_delete.png" class="button_img"/>
										<font style="font-size:12px; vertical-align:top"><xsl:value-of select="columns/column[@id = 'BTNDELETE']/@caption"/></font>
									</button>
								</xsl:if>
							</span>
							<span style="float:right; padding-right:10px;">
								<xsl:variable name="curpage" select="query/@currentpage"/>
								<xsl:variable name="prevpage" select="$curpage -1 "/>
								<xsl:variable name="maxpage" select="query/@maxpage"/>
  								<xsl:variable name="nextpage" select="$curpage + 1"/>
								<xsl:if test="query/@maxpage !=1">
									<xsl:if test="$curpage !=1">
										<button style="margin-left:4px" title="{columns/column[@id = 'FASTFILTERCAPTION']/@caption}" id="btnQFilter">
											<xsl:attribute name="onclick">javascript:window.location.href='Provider?type=view&amp;id=<xsl:value-of select='@id'/>&amp;page=1'</xsl:attribute>
											<font style="font-size:14px; vertical-align:top">&lt;&lt;</font>
										</button>
										<button style="margin-left:4px" title="{columns/column[@id = 'FASTFILTERCAPTION']/@caption}" id="btnQFilter">
											<xsl:attribute name="onclick">javascript:window.location.href='Provider?type=view&amp;id=<xsl:value-of select='@id'/>&amp;page=<xsl:value-of select='$prevpage'/>'</xsl:attribute>
											<font style="font-size:14px; vertical-align:top">&lt;</font>
										</button>
									</xsl:if>
									<select style="height:41px;width:60px; vertical-align:-13px; margin-left:4px; padding-left:15px">
										<xsl:attribute name="onChange">jjavascript:window.location.href="Provider?type=view&amp;id=<xsl:value-of select='@id'/>&amp;page="+this.value</xsl:attribute>
					 					<xsl:call-template name="combobox"/>
			 						</select>
			 						<xsl:if test="$curpage != $maxpage">
				 						<button style="margin-left:4px" title="{columns/column[@id = 'FASTFILTERCAPTION']/@caption}" id="btnQFilter">
											<xsl:attribute name="onclick">javascript:window.location.href='Provider?type=view&amp;id=<xsl:value-of select='@id'/>&amp;page=<xsl:value-of select='$nextpage'/>'</xsl:attribute>
											<font style="font-size:14px; vertical-align:top">&gt;</font>
										</button>
										<button style="margin-left:4px" title="{columns/column[@id = 'FASTFILTERCAPTION']/@caption}" id="btnQFilter">
											<xsl:attribute name="onclick">javascript:window.location.href='Provider?type=view&amp;id=<xsl:value-of select='@id'/>&amp;page=<xsl:value-of select='$maxpage'/>'</xsl:attribute>
											<font style="font-size:14px; vertical-align:top">&gt;&gt;</font>
										</button>
									</xsl:if>
								</xsl:if>
							</span>
						</div>
						<div style="clear:both"/>
						<div style="clear:both"/>
						
					</div>
					<div id="viewtablediv">
						<div id="tableheader">
							<table class="viewtable" id="viewtable" width="100%" style="margin-top:20px">
								<tr class="th">
									<td style="text-align:center;width:40px; padding:12px 5px" class="thcell">
										<input type="checkbox" id="allchbox" onClick="checkAll(this)" style="width:20px; height:20px"/>						
									</td>
									<td class="thcell">
										<xsl:call-template name="sortingcell">
											<xsl:with-param name="namefield">VIEWTEXT1</xsl:with-param>
											<xsl:with-param name="sortfield" select="query/sorting/field"/>
											<xsl:with-param name="sortorder" select="query/sorting/order"/>
										</xsl:call-template>
									</td>
									<xsl:if test="query/@ruleid = 'contractor'">
										<td class="thcell" width="200px">
											<xsl:call-template name="sortingcell">
												<xsl:with-param name="namefield">VIEWTEXT2</xsl:with-param>
												<xsl:with-param name="sortfield" select="query/sorting/field"/>
												<xsl:with-param name="sortorder" select="query/sorting/order"/>
											</xsl:call-template>
										</td>
									</xsl:if>
								</tr>
							</table>
						</div>
						<div id="tablecontent" style="margin-top:6px">
							<table class="viewtable" id="viewtable" width="100%">
								<xsl:choose>
									<xsl:when test="query/@ruleid='report_tasks'">
										<tr onmouseover="javascript:elemBackground(this,'EEEEEE')" onmouseout="elemBackground(this,'FFFFFF')">
											<xsl:attribute name="bgcolor">#FFFFFF</xsl:attribute>
											<td style="text-align:center;border:1px solid #ccc;width:20px;">
												<input type="checkbox" name="chbox" style="width:20px; height:20px"/>
											</td>
											<td style="border:1px solid #ccc; padding-left:5px">
												<a href="Provider?type=document&amp;id=task_report&amp;key=" class="doclink">Задания</a>
											</td>
										</tr>
									</xsl:when>
									<xsl:when test="query/@ruleid ='city'">
										<xsl:for-each select="query/entry">
								         		<xsl:variable name="num" select="position()"/>
												<tr class="{@docid}" id="{@docid}{@doctype}" onmouseover="javascript:elemBackground(this,'EEEEEE')" onmouseout="elemBackground(this,'FFFFFF')" style="height:40px">
													<xsl:attribute name="bgcolor">#FFFFFF</xsl:attribute>
													<xsl:if test="@isread = '0'">
														<xsl:attribute name="style">font-weight:bold; height:40px</xsl:attribute>
													</xsl:if>
													<xsl:call-template name="viewtable_dblclick_open"/>
													<td style="text-align:center; border:1px solid #ccc" width="3%" >
														<input type="checkbox" name="chbox" id="{@docid}" value="{@doctype}"/>
													</td>
													<td nowrap="nowrap" style="border:1px solid #ccc">
														<div style="display:block; overflow:hidden; width:93%;">&#xA0;
															<xsl:if test="hasresponse='true' and //request/@id!='toconsider'">
										          				<xsl:choose>
										          					<xsl:when test=".[responses]">
																		<a href="" style="vertical-align:top; margin-left:3px" id="a{@docid}">
																			<xsl:attribute name='href'>javascript:closeGlossResponses(<xsl:value-of select="@docid"/>, <xsl:value-of select="@doctype"/>,<xsl:value-of select="position()"/>,1)</xsl:attribute>
																			<img border='0' src="/SharedResources/img/classic/minus.gif" id="img{@docid}"/>
																		</a>
																	</xsl:when>
																	<xsl:otherwise>
																		<a href="" style="vertical-align:top; margin-left:3px" id="a{@docid}">
																			<xsl:attribute name='href'>javascript:openParentGlossView(<xsl:value-of select="@docid"/>, <xsl:value-of select="@doctype"/>,<xsl:value-of select="position()"/>,1)</xsl:attribute>
																			<img border='0' src="/SharedResources/img/classic/plus.gif" id="img{@docid}"/>
																		</a>
																	</xsl:otherwise>
																</xsl:choose>
															</xsl:if>
															<xsl:if test="not(hasresponse)">
																<span style="width:11px; display:inline-block"></span>
															</xsl:if>
															<a href="{@url}&amp;page={/request/query/@currentpage}" style="padding-left:5px;" title="{@viewtext}" class="doclink">
																<xsl:attribute name="onclick">javascript:beforeOpenDocument()</xsl:attribute>
																<xsl:if test="@isread = '0'">
																	<xsl:attribute name="style">font-weight:bold</xsl:attribute>
																</xsl:if>
																<xsl:if test="../@ruleid != 'favdocs'">
																	<xsl:value-of select="viewcontent/viewtext1"/>
																</xsl:if>
																<xsl:if test="../@ruleid = 'favdocs'">
																	<xsl:value-of select="@viewtext"/>
																</xsl:if>
															</a>
														</div>
													</td>
													<xsl:if test="../@ruleid = 'contractor'">
														<td  nowrap="nowrap" style="border:1px solid #ccc; border-left:none; width:200px; text-align:center">
															<xsl:value-of select="viewcontent/viewtext2"/>
														</td>
													</xsl:if>
													<xsl:if test="../@ruleid = 'favdocs'">
														<td  nowrap="nowrap" style="border:1px solid #ccc; border-left:none; width:30px; text-align:center">
															<img class="favicon" style="cursor:pointer; width:19px; height:19px" src="/SharedResources/img/iconset/star_empty.png">
																<xsl:if test="@favourites = 1">
																	<xsl:attribute name="onclick">javascript:removeDocFromFav(this,<xsl:value-of select="@docid"/>,<xsl:value-of select="@doctype"/>)</xsl:attribute> 
																	<xsl:attribute name="src">/SharedResources/img/iconset/star_full.png</xsl:attribute> 
																</xsl:if>
																<xsl:if test="@favourites = 0"> 
																	<xsl:attribute name="onclick">javascript:addDocToFav(this,<xsl:value-of select="@docid"/>,<xsl:value-of select="@doctype"/>)</xsl:attribute>
																	<xsl:attribute name="src">/SharedResources/img/iconset/star_empty.png</xsl:attribute> 
																</xsl:if>
															</img>
														</td>
													</xsl:if>
												</tr>
								       	 	</xsl:for-each>
										<!-- <xsl:for-each-group select="query/entry" group-by="country">
											<xsl:variable name="num" select="position()"/>
											<tr class="{@docid}" id="{@docid}{@doctype}" onmouseover="javascript:elemBackground(this,'EEEEEE')" onmouseout="elemBackground(this,'FFFFFF')">
												<xsl:attribute name="bgcolor">#FFFFFF</xsl:attribute>
												<td style="text-align:center; border:1px solid #ccc; border-right:none " width="3%" >
												</td>
												<td nowrap="nowrap" style="border:1px solid #ccc; border-left:none ">
													<div style="display:block; overflow:hidden; width:93%;">&#xA0;
														<a href="" style="vertical-align:top; margin-right:5px" id="a{@docid}">
															<xsl:attribute name='href'>javascript:openregioncity(<xsl:value-of select="@docid"/>, '<xsl:value-of select="current-grouping-key()"/>') </xsl:attribute>
															<img border='0' src="/SharedResources/img/classic/plus.gif" id="img{@docid}"/>
														</a>
														<xsl:value-of select="current-grouping-key()"/>
													</div>
												</td>
											</tr>
											<xsl:for-each select="current-group()">
								         		<xsl:variable name="num" select="position()"/>
												<tr class="{current-grouping-key()}" id="{@docid}{@doctype}" onmouseover="javascript:elemBackground(this,'EEEEEE')" style="display:none" onmouseout="elemBackground(this,'FFFFFF')">
													<xsl:attribute name="bgcolor">#FFFFFF</xsl:attribute>
													<xsl:if test="@isread = '0'">
														<xsl:attribute name="style">font-weight:bold</xsl:attribute>
													</xsl:if>
													<xsl:call-template name="viewtable_dblclick_open"/>
													<td style="text-align:center; border:1px solid #ccc" width="3%" >
														<input type="checkbox" name="chbox" id="{@docid}" value="{@doctype}"/>
													</td>
													<td nowrap="nowrap" style="border:1px solid #ccc">
														<div style="display:block; overflow:hidden; width:93%;">&#xA0;
															<a href="{@url}&amp;page={/request/query/@currentpage}" title="{@viewtext}" class="doclink">
																<xsl:attribute name="onclick">javascript:beforeOpenDocument()</xsl:attribute>
																<xsl:if test="@isread = '0'">
																	<xsl:attribute name="style">font-weight:bold</xsl:attribute>
																</xsl:if>
																<xsl:if test="../@ruleid != 'favdocs'">
																	<xsl:value-of select="viewcontent/viewtext1"/>
																</xsl:if>
																<xsl:if test="../@ruleid = 'favdocs'">
																	<xsl:value-of select="@viewtext"/>
																</xsl:if>
															</a>
														</div>
													</td>
													<xsl:if test="../@ruleid = 'favdocs'">
														<td  nowrap="nowrap" style="border:1px solid #ccc; border-left:none; width:30px; text-align:center">
															<img class="favicon" style="cursor:pointer; width:19px; height:19px" src="/SharedResources/img/iconset/star_empty.png">
																<xsl:if test="@favourites = 1">
																	<xsl:attribute name="onclick">javascript:removeDocFromFav(this,<xsl:value-of select="@docid"/>,<xsl:value-of select="@doctype"/>)</xsl:attribute> 
																	<xsl:attribute name="src">/SharedResources/img/iconset/star_full.png</xsl:attribute> 
																</xsl:if>
																<xsl:if test="@favourites = 0"> 
																	<xsl:attribute name="onclick">javascript:addDocToFav(this,<xsl:value-of select="@docid"/>,<xsl:value-of select="@doctype"/>)</xsl:attribute>
																	<xsl:attribute name="src">/SharedResources/img/iconset/star_empty.png</xsl:attribute> 
																</xsl:if>
															</img>
														</td>
													</xsl:if>
												</tr>
								       	 	</xsl:for-each>
										</xsl:for-each-group> -->
									</xsl:when>
									<xsl:when test="query/@ruleid ='city'">
										<xsl:for-each-group select="query/entry" group-by="country">
											<xsl:variable name="num" select="position()"/>
											<tr class="{@docid}" id="{@docid}{@doctype}" onmouseover="javascript:elemBackground(this,'EEEEEE')" onmouseout="elemBackground(this,'FFFFFF')">
												<xsl:attribute name="bgcolor">#FFFFFF</xsl:attribute>
												<td style="text-align:center; border:1px solid #ccc; border-right:none " width="3%" >
												</td>
												<td nowrap="nowrap" style="border:1px solid #ccc; border-left:none ">
													<div style="display:block; overflow:hidden; width:93%;">&#xA0;
														<a href="" style="vertical-align:top; margin-right:5px" id="a{@docid}">
															<xsl:attribute name='href'>javascript:openregioncity(<xsl:value-of select="@docid"/>, '<xsl:value-of select="current-grouping-key()"/>') </xsl:attribute>
															<img border='0' src="/SharedResources/img/classic/plus.gif" id="img{@docid}"/>
														</a>
														<xsl:value-of select="current-grouping-key()"/>
													</div>
												</td>
											</tr>
											<xsl:for-each select="current-group()">
								         		<xsl:variable name="num" select="position()"/>
												<tr class="{current-grouping-key()}" id="{@docid}{@doctype}" onmouseover="javascript:elemBackground(this,'EEEEEE')" style="display:none" onmouseout="elemBackground(this,'FFFFFF')">
													<xsl:attribute name="bgcolor">#FFFFFF</xsl:attribute>
													<xsl:if test="@isread = '0'">
														<xsl:attribute name="style">font-weight:bold</xsl:attribute>
													</xsl:if>
													<xsl:call-template name="viewtable_dblclick_open"/>
													<td style="text-align:center; border:1px solid #ccc" width="3%" >
														<input type="checkbox" name="chbox" id="{@docid}" value="{@doctype}"/>
													</td>
													<td nowrap="nowrap" style="border:1px solid #ccc">
														<div style="display:block; overflow:hidden; width:93%;">&#xA0;
															<a href="{@url}&amp;page={/request/query/@currentpage}" title="{@viewtext}" class="doclink">
																<xsl:attribute name="onclick">javascript:beforeOpenDocument()</xsl:attribute>
																<xsl:if test="@isread = '0'">
																	<xsl:attribute name="style">font-weight:bold</xsl:attribute>
																</xsl:if>
																<xsl:if test="../@ruleid != 'favdocs'">
																	<xsl:value-of select="viewcontent/viewtext1"/>
																</xsl:if>
																<xsl:if test="../@ruleid = 'favdocs'">
																	<xsl:value-of select="@viewtext"/>
																</xsl:if>
															</a>
														</div>
													</td>
													<xsl:if test="../@ruleid = 'favdocs'">
														<td  nowrap="nowrap" style="border:1px solid #ccc; border-left:none; width:30px; text-align:center">
															<img class="favicon" style="cursor:pointer; width:19px; height:19px" src="/SharedResources/img/iconset/star_empty.png">
																<xsl:if test="@favourites = 1">
																	<xsl:attribute name="onclick">javascript:removeDocFromFav(this,<xsl:value-of select="@docid"/>,<xsl:value-of select="@doctype"/>)</xsl:attribute> 
																	<xsl:attribute name="src">/SharedResources/img/iconset/star_full.png</xsl:attribute> 
																</xsl:if>
																<xsl:if test="@favourites = 0"> 
																	<xsl:attribute name="onclick">javascript:addDocToFav(this,<xsl:value-of select="@docid"/>,<xsl:value-of select="@doctype"/>)</xsl:attribute>
																	<xsl:attribute name="src">/SharedResources/img/iconset/star_empty.png</xsl:attribute> 
																</xsl:if>
															</img>
														</td>
													</xsl:if>
												</tr>
								       	 	</xsl:for-each>
										</xsl:for-each-group>
									</xsl:when>
									<xsl:otherwise>
										<xsl:apply-templates select="query/entry"/>
									</xsl:otherwise>
								</xsl:choose>
							</table>
							<div style="clear:both; width:100%">&#xA0;</div>
						</div>
					</div>
		 		</div>
					</span>
				</div>	
					<div style="position:absolute; bottom:0px;left:0px; right:0px; background:#898989; width:auto; height:3.2em; border-top:1px solid #aaa; padding:0.5em 1em">
						<button  id="btnuserprf">
							<xsl:attribute name="onclick">javascript:openuserpanel()</xsl:attribute>
							<font style="font-size:14px; vertical-align:top"><xsl:value-of select="/request/@username"/>&#xA0;&#xA0;</font>
						</button>
						<button  id="btnviewlist" style="float:right">
							<xsl:attribute name="onclick">javascript:openoutlinenavigation()</xsl:attribute>
							<img src="/SharedResources/img/classic/icons/list_bullets.png"/>
						</button>
						<script type="text/javascript">    
					       		$(function() {
									$("#btnuserprf").button({
										icons: {
	                						secondary: "ui-icon-triangle-1-n",
	            						}
            						});
									$("#btnviewlist, .mnbtn").button();
			        			});
    						</script>
					</div>
					<div id="userpanel" style="position:absolute; z-index:999; width:300px; height:170px; border-radius:5px; background:#fff; border:2px solid #999; bottom:-215px;left:20px; padding:20px; text-align:center; display:none;">
						<button  class="mnbtn" style="width:100%">
							<xsl:attribute name="onclick">javascript:window.location.href="Provider?type=edit&amp;element=userprofile&amp;id=userprofile"</xsl:attribute>
							<font>Профиль пользователя</font>
						</button>
						<button  class="mnbtn" style="width:100%">
							<xsl:attribute name="onclick">javascript:window.location.href="Provider?type=static&amp;id=help_summary"</xsl:attribute>
							<font><xsl:value-of select="columns/column[@id = 'HELPCAPTION']/@caption"/></font>
						</button>
						<div style="width:100%; height:2px; background:#787878; margin-top:15px"></div>
						<button  class="mnbtn" style="width:100%; margin-top:20px">
							<xsl:attribute name="onclick">javascript:window.location.href="Logout"</xsl:attribute>
							<font><xsl:value-of select="outline/fields/logout/@caption"/></font>
						</button>
					</div>
					<div id="outlinelist" style="position:absolute; top: 80px; bottom: 4.2em; left:-100%; width:100%; background:#fff; display:none; overflow:auto">
							<ul style="margin-left: auto; padding: 0; list-style: none;	text-align: center; line-height: 0; zoom:1;">
								<xsl:for-each select="outline/entry/entry">
									<li style="width:100px; height:120px; list-style:none; display: inline-block; line-height: normal; font-size:13px; vertical-align: top;	margin-bottom:30px; margin-left:30px; ">
										<a href="{@url}" style="text-decoration:none; color:#999">
											<div style="width:100px; height:100px; border:1px solid #999; border-radius:8px; text-align:center; background:#efefef;">
												<br/>
												<br/>
												<font style="font-size:11px; line-height:25px">
													<xsl:value-of select="../@caption"/>
												</font>
											</div>
										</a>
										<div style="text-align:center; margin-top:5px; font-size:10px; margin-bottom:10px">
											<xsl:value-of select="@caption"/>
										</div>
									</li>
								</xsl:for-each>
							</ul>
					</div>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>