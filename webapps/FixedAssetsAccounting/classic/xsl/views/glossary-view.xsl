﻿<?xml version="1.0" ?>
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
			<td style="text-align:center; border:1px solid #ccc" width="3%" >
				<input type="checkbox" name="chbox" id="{@docid}" value="{@doctype}"/>
			</td>
			<td nowrap="nowrap" style="border:1px solid #ccc">
				<div style="display:block; overflow:hidden; width:93%;">&#xA0;
					<a href="{@url}" title="{@viewtext}" class="doclink">
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
	</xsl:template>
	
	<xsl:template match="/request">
		<html>
			<head>
				<title>
					4MS Workflow - <xsl:value-of select="columns/column[@id='VIEWNAMECAPTION']/@caption"/>
				</title>
				<link type="text/css" rel="stylesheet" href="classic/css/outline.css"/>
				<link type="text/css" rel="stylesheet" href="classic/css/main.css"/>
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
				<script type="text/javascript" src="classic/scripts/outline.js"/>
				<script type="text/javascript" src="classic/scripts/view.js"/>
				<script type="text/javascript" src="classic/scripts/form.js"/>
				<script type="text/javascript">
					$(document).ready(function(){
						$(document).bind('keydown', function(e){
 							if (e.ctrlKey) {
 								switch (e.keyCode) {
								   case 78:
										<!-- клавиша n -->
								     	e.preventDefault();
								     	$("#btnNewdoc").click();
								     	break;
								   case 68:
								   		<!-- клавиша d -->
								     	e.preventDefault();
								     	$("#btnDeldoc").click();
								      	break;
								   case 85:
								   		<!-- клавиша u -->
								     	e.preventDefault();
								     	window.location.href=$("#currentuser").attr("href")
								      	break;
								   case 81:
								   		<!-- клавиша q -->
								     	e.preventDefault();
								     	window.location.href=$("#logout").attr("href")
								      	break;
								   case 72:
								   		<!-- клавиша h -->
								     	e.preventDefault();
								     	window.location.href=$("#helpbtn").attr("href")
								      	break;
								   default:
								      	break;
								}
	    					}
    					});
    					outline.type = '<xsl:value-of select="@type"/>'; 
						outline.viewid = '<xsl:value-of select="@id"/>';
						outline.element = 'project';
						outline.command='<xsl:value-of select="current/@command"/>';
						outline.curPage = '<xsl:value-of select="current/@page"/>'; 
						outline.category = '';
						outline.filterid = '<xsl:value-of select="@id"/>';
						refresher();  
    					$("#btnNewdoc").hotnav({keysource:function(e){return "n";}});
						$("#btnDeldoc").hotnav({keysource:function(e){return "d";}});
						$("#currentuser").hotnav({ keysource:function(e){return "u";}});
						$("#logout").hotnav({keysource:function(e){return "q";}});
						$("#helpbtn").hotnav({keysource:function(e){return "h";}});
					});
				</script>
			</head>			
			<body>
				<xsl:call-template name="flashentry"/>
				<div id="blockWindow" style="display:none"/>
				<div id="wrapper">
					<xsl:call-template name="loadingpage"/>
					<xsl:call-template name="header-view"/>
					<xsl:call-template name="outline-menu-view"/>
					<span id="view" class="viewframe">
						<div id="viewcontent" style="margin-left:12px;">
							<div id="viewcontent-header" style="height:73px;">
						<xsl:call-template name="viewinfo"/>
						<div class="button_panel" style="margin-top:8px">
							<script type="text/javascript">    
					       		$(function() {$(".button_panel button" ).button();});
    						</script>
							<span style="float:left; margin-left:3px; margin-top:2px">
								<xsl:if test="action[.='NEW_DOCUMENT']/@enable = 'true'">
									<button title="{action[.='NEW_DOCUMENT']/@hint}" id="btnNewdoc">
										<xsl:attribute name="onclick">javascript:window.location.href="<xsl:value-of select="newDocURL"/>"; beforeOpenDocument()</xsl:attribute>
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
							</span>
						</div>
						<div style="clear:both"/>
						<div style="clear:both"/>
						
					</div>
					<div id="viewtablediv">
						<div id="tableheader">
							<table class="viewtable" id="viewtable" width="100%">
								<tr class="th">
									<td style="text-align:center; height:30px" width="3%" class="thcell">
										<input type="checkbox" id="allchbox" onClick="checkAll(this);"/>					
									</td>
									<td class="thcell">
										<xsl:call-template name="sortingcell">
											<xsl:with-param name="namefield">VIEWTEXT1</xsl:with-param>
											<xsl:with-param name="sortfield" select="query/sorting/field"/>
											<xsl:with-param name="sortorder" select="query/sorting/order"/>
										</xsl:call-template>
									</td>
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
												<input type="checkbox" name="chbox"/>
											</td>
											<td style="border:1px solid #ccc; padding-left:5px">
												<a href="Provider?type=document&amp;id=task_report&amp;key=" class="doclink">Задания</a>
											</td>
										</tr>
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
															<a href="{@url}" title="{@viewtext}" class="doclink">
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
										
										
										<!-- Recently added -->
										<xsl:for-each select ="query/entry">
										<tr class="{@docid}" id="{@docid}{@doctype}" onmouseover="javascript:elemBackground(this,'EEEEEE')" onmouseout="elemBackground(this,'FFFFFF')">
												<xsl:attribute name="bgcolor">#FFFFFF</xsl:attribute>
												
												<td style="text-align:center;border:1px solid #ccc" width="3%" >
														<input type="checkbox" name="chbox" id="{@docid}" value="{@doctype}"/>
													</td>
												<td nowrap="nowrap" style=" padding-left:8px;border:1px solid #ccc; border-left:none ">
												
															<a href="{@url}" title="{@viewtext}" class="doclink">
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
												</td>
											</tr>
										</xsl:for-each>
									</xsl:when>
									<xsl:otherwise>
										<xsl:apply-templates select="query/entry"/>
									</xsl:otherwise>
									
								</xsl:choose>
							</table>
							<div style="clear:both; width:100%">&#xA0; </div>
						</div>
					</div>
		 		</div>
					</span>
				</div>				
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>