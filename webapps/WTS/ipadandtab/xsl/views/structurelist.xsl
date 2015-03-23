<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../templates/view.xsl"/>	
	<xsl:variable name="viewtype">Структура</xsl:variable>
	<xsl:output method="html" encoding="utf-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" indent="no"/>
	<xsl:variable name="skin" select="request/@skin"/>
	<xsl:template match="responses">
		<tr>
			<xsl:attribute name="class">response<xsl:value-of select="../@docid"/></xsl:attribute>
			<script>
				color=$(".response"+<xsl:value-of select="../@docid"/>).prev().attr("bgcolor");
				$(".response"+<xsl:value-of select="../@docid"/>).css("background",color);
			</script>
			<style type="text/css">
				div.Node * { vertical-align: middle }
			</style>
			<td>
			</td>
			<td colspan="4">
				<xsl:apply-templates mode="line"/>
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="viewtext" mode="line">
	</xsl:template>
		<xsl:template match="*" mode="line">
			<xsl:if test="name(.) != 'userid'">	
				<div class="Node" style="height:100%; padding:2px 3px">
					<xsl:attribute name="id"><xsl:value-of select="@docid"/><xsl:value-of select="@doctype"/></xsl:attribute>
					<xsl:call-template name="graft"/>
					<xsl:apply-templates select="." mode="item"/>
				</div>
				<xsl:apply-templates mode="line"/>
			</xsl:if>
		</xsl:template>

		<xsl:template match="entry" mode="item">
			<input type="checkbox" name="chbox" style="margin-left:10px; padding:0px; height:20px; width:20px" >
				<xsl:attribute name="id" select="@docid"/>
				<xsl:attribute name="value" select="@doctype"/>
			</input>
			<a  href="" style="font-style:arial; font-size:15px; margin:0px 2px; margin-left:10px" class="doclink">
				<xsl:attribute name="href" select="@url"/>
				<xsl:attribute name="onclick">javascript:beforeOpenDocument()</xsl:attribute>
				<xsl:attribute name="title" select="userid"/>
				<xsl:value-of select="replace(@viewtext,'&amp;quot;','&#34;')"/>	
			</a>
		</xsl:template>

		<xsl:template name="graft">
			<xsl:apply-templates select="ancestor::entry" mode="tree"/>
			<xsl:choose>
				<xsl:when test="following-sibling::*">
					<img style="vertical-align:top;" src="/SharedResources/img/classic/tree_spacer.gif"/>
				</xsl:when>
				<xsl:otherwise>
					<img style="vertical-align:top;" src="/SharedResources/img/classic/tree_spacer.gif"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:template>
		
		<xsl:template match="responses" mode="tree"/>

		<xsl:template match="*" mode="tree">
			<xsl:choose>
				<xsl:when test="following-sibling::* and *[@url]">
					<img style="vertical-align:top;" src="/SharedResources/img/classic/tree_spacer.gif"/>
				</xsl:when>
				<xsl:otherwise>
					<img style="vertical-align:top;" src="/SharedResources/img/classic/tree_spacer.gif"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:template>
	
	<xsl:template match="/request">
		<html>
			<head>
				<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
				<title>QC - <xsl:value-of select="/request/@title"/></title>
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
				<div id="wrapper">
					<xsl:call-template name="header-view"/>
					<span id="view" class="viewframe{outline/category[entry[@current=1]]/@id}">
						<div id="viewcontent" style="margin-left:12px;">
							<div id="viewcontent-header" style="height:30px;">
						<div class="button_panel">
							<script type="text/javascript">    
				       			$(function(){$(".button_panel button").button();});
		    				</script>
							<span style="float:left; margin-left:3px;">
								<button title="{columns/column[@id = 'BTNNEWDOCUMENT']/@hint}" id="btnNewdoc">
									<xsl:attribute name="onclick">javascript:window.location.href="Provider?type=structure&amp;id=organization&amp;key="; beforeOpenDocument()</xsl:attribute>
									<img src="/SharedResources/img/classic/icons/page_white.png" class="button_img"/>
									<font style="font-size:12px; vertical-align:top"><xsl:value-of select="columns/column[@id = 'BTNNEWDOCUMENT']/@caption"/></font>
								</button>
								<button style="margin-left:5px" title="{columns/column[@id = 'BTNDELETE']/@hint}" id="btnDeldoc">
									<xsl:attribute name="onclick">javascript:delGlossary("Avanti","1");</xsl:attribute>
									<img src="/SharedResources/img/classic/icons/page_white_delete.png" class="button_img"/>
									<font style="font-size:12px; vertical-align:top"><xsl:value-of select="columns/column[@id = 'BTNDELETE']/@caption"/></font>
								</button>
							</span>
						</div>
					</div>
						<div id="viewtablediv">
						
						<div id="tablecontent-for-structurelist">
							<div>
							<xsl:for-each select="query/entry">
								<input type="checkbox" name="chbox" style="width:20px ; height:20px; margin-left:18px">
									<xsl:attribute name="id" select="@docid"/>
									<xsl:attribute name="value" select="@doctype"/>
								</input>
								<font style="font-family:Verdana,Arial,Helvetica,sans-serif; font-size:1.1em; margin-left:8px">
									<a href="{@url}" class="doclink">
										<xsl:value-of select="replace(@viewtext,'&amp;quot;','&#34;')"/>	
									</a>
								</font>
								<table id="viewtable" style="border-collapse:collapse; border:0; font-size:0.85em">
									<xsl:apply-templates select="responses"/>
								</table>
								<br/>
							</xsl:for-each>
						</div>
							<div style="clear:both; width:100%">&#xA0;</div>
						</div>
					</div>
		 		</div>
					</span>
				</div>
				<div id="viewcontent" style="margin-left:15px;">
					<div id="viewcontent-header" style="height:50px">
						<font class="viewtitle">
							<xsl:value-of select="columns/column[@id = 'CATEGORY']/@caption"/> - <xsl:value-of select="columns/column[@id = 'VIEW']/@caption"/>
						</font>
						<br/>
						<br/>
						
					</div>
					<br/>
					<br/>
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