<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../templates/page.xsl"/>
	<xsl:variable name="viewtype">Вид</xsl:variable>
	<xsl:variable name="actionbar" select="//actionbar"/>
	<xsl:variable name="captions" select="/request/page/captions/page/captions"/>
	<xsl:variable name="query" select="//query"/>
	<xsl:output method="html" encoding="utf-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" indent="no"/>
	<xsl:variable name="skin" select="request/@skin"/>
	<xsl:variable name="useragent" select="request/@useragent"/>
	<xsl:variable name="lang" select="request/@lang"/>
	<xsl:template match="/request">
		<html>
			<head>
				<title>Projects - <xsl:call-template name="pagetitle"/></title>
				<link type="text/css" rel="stylesheet" href="classic/css/outline.css"/>
				<link type="text/css" rel="stylesheet" href="classic/css/main.css"/>
				<link type="text/css" rel="stylesheet" href="/SharedResources/jquery/css/smoothness/jquery-ui-1.8.20.custom.css"/>
				<link type="text/css" rel="stylesheet" href="/SharedResources/jquery/js/hotnav/jquery.hotnav.css"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/jquery-1.4.2.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/ui/minified/jquery.ui.core.min.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/ui/minified/jquery.effects.core.min.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/ui/minified/jquery.ui.widget.min.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.datepicker.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.datepicker-ru.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/ui/minified/jquery.ui.mouse.min.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/ui/minified/jquery.ui.draggable.min.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/ui/minified/jquery.ui.position.min.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/ui/minified/jquery.ui.button.min.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/ui/minified/jquery.ui.dialog.min.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/cookie/jquery.cookie.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/hotnav/jquery.hotkeys.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/hotnav/jquery.hotnav.js"/>
				<script type="text/javascript" src="classic/scripts/outline.js"/>
				<script type="text/javascript" src="classic/scripts/view.js"/>
				<script type="text/javascript" src="classic/scripts/page.js"/>
				<script type="text/javascript">
					$(document).ready(function(){
						$(".button_panel button").button();
						$(document).bind('keydown', function(e){
 							if (e.ctrlKey){
 								switch (e.keyCode){
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
								   case 70:
								   		<!-- клавиша f -->
								     	e.preventDefault();
								     	$("#btnQFilter").click();
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
    					outline.viewid='<xsl:value-of select="@id"/>';
						outline.element='project';
						outline.command='<xsl:value-of select="current/@command"/>';
						outline.curPage='<xsl:value-of select="current/@page"/>'; 
						outline.category='';
						outline.filterid='<xsl:value-of select="@id"/>';
						refresher();
    					<![CDATA[
							$("#btnNewdoc").hotnav({keysource:function(e){return "n";}});
							$("#btnDeldoc").hotnav({keysource:function(e){return "d";}});
							$("#currentuser").hotnav({ keysource:function(e){return "u";}});
							$("#btnQFilter").hotnav({keysource:function(e){return "f";}});
							$("#logout").hotnav({keysource:function(e){return "q";}});
							$("#helpbtn").hotnav({keysource:function(e){return "h";}});
						]]>
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
						<div id="viewcontent">
							<div id="viewcontent-header" style="height:68px; position:relative;">
								<xsl:call-template name="pageinfo"/>
								<div class="button_panel" style="top:15px; position:absolute; left:0px; right:0px">
									<table style="width:100%; top:30px; position:absolute">
		    							<tr>
		    								<td style="width:40%; padding-left:13px">
												<button id="btnDeldoc" title="{$captions/removefromfavsbutton/@caption}" style="margin-right:5px">
													<xsl:attribute name="onclick">javascript:removeFromFavs()</xsl:attribute>
													<img src="/SharedResources/img/classic/icons/page_white_delete.png" class="button_img"/>
													<font style="font-size:12px; vertical-align:top"><xsl:value-of select="$captions/removefromfavsbutton/@caption"/></font>
												</button>
											</td>
											<td style="width:50%">
		    								</td>   								
		    							</tr>
		    						</table>	    						
								</div>							
								<div style="clear:both"/>							
							</div>
							<div id="viewtablediv" style ="top:10px">
								<div id="tableheader">
									<table class="viewtable" id="viewtable" width="100%" style="">
										<tr class="th">
											 <td style="text-align:center; height:30px; width:35px;" class="thcell">
												<input type="checkbox" id="allchbox" autocomplete="off" onClick="checkAll(this)"/>					
											</td> 
											<td style="min-width:160px;" class="thcell">
												<xsl:value-of select ="$captions/viewtext/@caption"/>
											</td>
										</tr>
									</table>
								</div>
								<div id="tablecontent" autocomplete="off">							
									<table class="viewtable" id="viewtable" width="100%">								
										<xsl:for-each select="$query/entry">
											<xsl:variable name="num" select="position()"/>
											<tr title="{@viewtext}" class="{@docid}" id="{@docid}{@doctype}">
												 <td style="text-align:center; border:1px solid #ccc; width:35px;">
													<input type="checkbox" name="chbox" id="{@id}" autocomplete="off" value="{@doctype}"/>
												</td>	 
												<td style="border:1px solid #ccc; min-width:160px;">
													<a href="{@url}" class="doclink" style="margin-left:25px;">
														<xsl:if test="@isread = 0">
															<xsl:attribute name="style">font-weight:bold; padding-left:25px;</xsl:attribute>
														</xsl:if> 
														<xsl:value-of select="viewcontent/viewtext"/>
													</a>
												</td>
												<td style="border:1px solid #ccc; border-left:none; width:30px; text-align:center">
													<img class="favicon" style="cursor:pointer; width:18px; height:18px" src="/SharedResources/img/iconset/star_empty.png">
														<xsl:attribute name="title" select="$captions/addtofav/@caption"/>
														<xsl:attribute name="onclick">javascript:addDocToFav(this,<xsl:value-of select="@docid"/>,<xsl:value-of select="@doctype"/>)</xsl:attribute>
														<xsl:if test="@favourites = 1">
															<xsl:attribute name="title" select="$captions/removefromfav/@caption"/>
															<xsl:attribute name="onclick">javascript:removeDocFromFav(this,<xsl:value-of select="@docid"/>,<xsl:value-of select="@doctype"/>)</xsl:attribute> 
															<xsl:attribute name="src">/SharedResources/img/iconset/star_full.png</xsl:attribute>
														</xsl:if>
													</img>
												</td>
											</tr>
										</xsl:for-each>									
									</table>
									<div style="clear:both; width:100%">&#xA0;</div>
								</div>
								<div style="clear:both"/>	
							</div>
						</div>
					</span>
				</div>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>