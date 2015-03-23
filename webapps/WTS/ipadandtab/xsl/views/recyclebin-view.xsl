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
				<div style="overflow:hidden; width:99%;">&#xA0;
					<a href="{@url}" title="{@viewtext}" class="doclink">
						<xsl:attribute name="onclick">javascript:beforeOpenDocument()</xsl:attribute>
						<xsl:if test="@isread = '0'">
							<xsl:attribute name="style">font-weight:bold</xsl:attribute>
						</xsl:if>
						<xsl:value-of select="@viewtext"/>
					</a>
				</div>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="/request">
		<html>
			<head>
				<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
				<title>WTS - <xsl:value-of select="columns/column[@id = 'VIEW']/@caption"/></title>
				<link type="text/css" rel="stylesheet" href="ipadandtab/css/outline.css"/>
				<link type="text/css" rel="stylesheet" href="ipadandtab/css/main.css"/>
				<link type="text/css" rel="stylesheet" href="/SharedResources/jquery/css/smoothness/jquery-ui-1.8.20.custom.css"/>
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
			</head>			
			<body>
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
								<xsl:if test="action[.='RECOVER_RECYCLEBIN']/@enable = 'true'">
									<button title="{action[.='RECOVER_RECYCLEBIN']/@hint}" id="restore">
										<xsl:attribute name="onclick">javascript:undelGlossary("Avanti");</xsl:attribute>
										<img src="/SharedResources/img/classic/icons/page_white_database.png" class="button_img"/>
										<font style="font-size:12px; vertical-align:top"><xsl:value-of select="action[.='RECOVER_RECYCLEBIN']/@caption"/></font>
									</button>
								</xsl:if>
								<xsl:if test="action[.='CLEAR_RECYCLEBIN']/@enable = 'true'">
									<button title="{columns/column[@id = 'BTNDELETEDOCUMENT']/@hint}" id="btnDeldoc">
										<xsl:attribute name="onclick">javascript:delGlossary("Avanti","1");</xsl:attribute>
										<img src="/SharedResources/img/classic/icons/page_white_delete.png" class="button_img"/>
										<font style="font-size:12px; vertical-align:top"><xsl:value-of select="columns/column[@id = 'BTNDELETEDOCUMENT']/@caption"/></font>
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
									<td style="text-align:center; width:40px; padding:12px 5px" width="3%" class="thcell">
										<input type="checkbox" id="allchbox" onClick="checkAll(this);"  style="width:20px; height:20px"/>					
									</td>
									<td class="thcell">
										Название
									</td>
								</tr>
							</table>
						</div>
						<div id="tablecontent" style="margin-top:7px">
							<table class="viewtable" id="viewtable" width="100%">
								<xsl:choose>
									<xsl:when test="query/@ruleid='report_tasks'">
										<tr onmouseover="javascript:elemBackground(this,'EEEEEE')" onmouseout="elemBackground(this,'FFFFFF')">
											<xsl:attribute name="bgcolor">#FFFFFF</xsl:attribute>
											<td style="text-align:center; border:1px solid #dddddd;width:40px; padding:12px 5px">
												<input type="checkbox" name="chbox"/>
											</td>
											<td style="border:1px solid #ccc; padding-left:5px">
												<a href="Provider?type=document&amp;id=task_report&amp;key=" class="doclink">Задания</a>
											</td>
										</tr>
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