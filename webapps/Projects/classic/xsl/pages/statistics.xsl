<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../templates/page.xsl"/>
	<xsl:variable name="viewtype">Вид</xsl:variable>
	<xsl:variable name="query" select="//query"/>
	<xsl:variable name="captions" select="/request/page/captions/page/captions"/>
	<xsl:output method="html" encoding="utf-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" indent="no"/>
	<xsl:variable name="skin" select="request/@skin"/>
	<xsl:variable name="useragent" select="request/@useragent"/>
	<xsl:variable name="lang" select="request/@lang"/>
	<xsl:template match="/request">
		<html style="overflow:hidden">
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
				
				<!-- vizualize -->
				<script type="text/javascript" src="/SharedResources/jquery/js/visualize/js/visualize.jQuery.js"/>
				<link type="text/css" rel="stylesheet" href="/SharedResources/jquery/js/visualize/css/visualize.css"/>
				<link type="text/css" rel="stylesheet" href="/SharedResources/jquery/js/visualize/css/basic.css"/>
				
				<!-- jchartfx -->
				<link rel="stylesheet" type="text/css" href="/SharedResources/jquery/js/jChartFX/styles/jchartfx.css" />
			    <script type="text/javascript" src="/SharedResources/jquery/js/jChartFX/js/jchartfx.system.js"></script>
			    <script type="text/javascript" src="/SharedResources/jquery/js/jChartFX/js/jchartfx.coreVector.js"></script>
				<script type="text/javascript" src="/SharedResources/jquery/js/jChartFX/js/jchartfx.animation.js"></script>
				<script type="text/javascript" src="/SharedResources/jquery/js/jChartFX/js/jchartfx.advanced.js"></script>
				 
				<xsl:call-template name="hotkeys"/>	
				<xsl:call-template name="calendar"/>
				<style>
					table{
						min-width:20px;
						border:none;
					}
					table tr td{
						border:none;
						margin:0;
						padding:0;
					}
				</style>
			</head>
			<body>
				<xsl:call-template name="flashentry"/>
				<div id="blockWindow" style="display:none"/>
				<div id="wrapper">	
					<xsl:call-template name="loadingpage"/>
					<xsl:call-template name="header-view"/>			
					<xsl:call-template name="outline-menu-view"/> 
					<span id="view" class="viewframe" style="overflow:auto">						 
						<div id="viewcontent" style="margin:10px 0 0 20px; text-align:center"> 
							<table style="width:100%;">
								<tr style="height:14px">
									<td style="text-align:left;">					 
										<font class="time" style="font-size:14px; padding-right:10px; font-weight:bold;">										
											<xsl:call-template name="pagetitle"/>
								    	</font>
									</td>
								</tr>
							</table> 
							<div style="width:100%;  display:inline-block;">
							<xsl:if test="@id = 'statistics_staff_workload'">
								<table style="width:100%">	
									<tr>	 
									 	<td style="text-align:left">
									 		<font style=" font-size:13px;color: #444444;vertical-align:top">
												<xsl:value-of select="$captions/startdate/@caption"/>: 
											</font>
											<input readonly="readonly" class="eventdate" type="text" id="startdate" name="startdate" style="width:100px; vertical-align:top"/>
											<font style=" font-size:13px;color: #444444;padding-left:20px;vertical-align:top">
												<xsl:value-of select="$captions/enddate/@caption"/>: 
											</font>								 
											<input readonly="readonly"  type="text" id="enddate" name="enddate" onfocus="javascript:$(this).blur()" style="width:100px; vertical-align:top">
												<xsl:attribute name="title" select="$captions/duedate/@caption"/>
												<xsl:attribute name="class">eventdate</xsl:attribute>
											</input> 
										</td> 
									</tr>
								 
									<tr> 
									<td style="text-align:left">
										<font style=" font-size:13px;color: #444444;vertical-align:top">
											<xsl:value-of select="$captions/executor/@caption"/>:
										</font>
										<div style="width:100%; height:160px; overflow:auto">
											<table id="executorsList" style="width:100%">													
												<xsl:for-each select="page/executors/query/entry">
													<tr>
														<td style="vertical-align:top; text-align:left; font-size:12px; white-space:nowrap">
															<input type="checkbox" id="org{@docid}" value="org{@docid}" name="org" onClick="checkAllOrgMembers(this)"/>	
															<b>
																<label for="org{@docid}">
																	<xsl:value-of select="viewtext"/>
																</label>
															</b>
														</td>
														<td style="vertical-align:top; text-align:left;font-size:12px">
															<xsl:variable name="orgid" select="concat('org',@docid)"/> 
															<xsl:for-each select="responses/entry">
																<xsl:if test="@doctype='889'"> 
																	<span>
																		<input type="checkbox" class="{$orgid}" id="{userid}" value="{userid}" name="chbox"/>															
																		<label for="{userid}"><xsl:value-of select="viewtext"/></label>
																	</span>&#xA0;
																</xsl:if>
																<xsl:apply-templates select="entry">
																	<xsl:with-param name="orgid" select="$orgid"/>
																</xsl:apply-templates>
															</xsl:for-each>
														</td>
													</tr>
												</xsl:for-each>
											</table>
										</div>
									</td></tr>
								</table>	 
								</xsl:if>	
								<xsl:if test="@id = 'statistics_projects_activity'">
									<table style="width:100%">
									<tr>	 
									 	<td style="text-align:left">
									 		<font style=" font-size:13px; color:#444444; vertical-align:top">
												<xsl:value-of select="$captions/startdate/@caption"/>: 
											</font>
										</td> 
										<td style="text-align:left">
											<input readonly="readonly" type="text" id="startdate"  name="startdate" style="width:100px; vertical-align:top">
												<xsl:attribute name="class">eventdate</xsl:attribute>
											</input> 
											 <font style=" font-size:13px;color: #444444;padding-left:20px;vertical-align:top">
												<xsl:value-of select="$captions/enddate/@caption"/>: 
											</font>								 
											<input readonly="readonly"  type="text" id="enddate" name="enddate" onfocus="javascript:$(this).blur()" style="width:100px; vertical-align:top">
												<xsl:attribute name="title" select="$captions/duedate/@caption"/>
												<xsl:attribute name="class">eventdate</xsl:attribute>
											</input> 
										</td>
									</tr>	
									<tr>	 
									 	<td style="width:85px; vertical-align:top">
									 		<font style=" font-size:13px;color: #444444;vertical-align:top">
												<xsl:value-of select="$captions/projects/@caption"/>: 
											</font>
										</td>
										<td style="vertical-align:top; text-align:left;font-size:12px;">
											<div style=" height:160px; overflow:auto;margin-top:5px">
											<xsl:for-each select="page/projects/response/content/statistics/entry">
												<span>
													<xsl:if test="/request/@useragent != 'IE'">
														<xsl:attribute name="style">white-space:nowrap</xsl:attribute>
													</xsl:if>
													<input type="checkbox" id="{@docid}" value="{@project_name}" name="chproject"/>															
													<label for="{@docid}"><xsl:value-of select="@project_name"/></label>
												</span>&#xA0;&#xA0;
											</xsl:for-each>
											</div>
										</td>
									</tr>
									</table>
								</xsl:if>
								<div class="button_panel" style="vertical-align:top;">
									<button class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
										<xsl:attribute name="onclick">javascript:calcStatistics('<xsl:value-of select="@id" />')</xsl:attribute>
										<span  style="white-space:nowrap">
											<!-- <img src="/SharedResources/img/iconset/page_code.png" class="button_img"/> -->
											<font style="font-size:12px; vertical-align:top"><xsl:value-of select="$captions/showstat/@caption"/></font>
										</span>
									</button>
								</div>
								<div style="clear:both"/>
							</div>
							<div id="barStat" style="width:95%;height:400px; margin-top:20px;  background-color:#E9E9E2; display:block; vertical-align:middle">
								<xsl:if test="@id='statistics_projects_activity'">
									<xsl:attribute name="style">width:95%;height:450px; margin-top:20px; background-color:#E9E9E2; display:block; vertical-align:middle</xsl:attribute>
								</xsl:if>
							</div> 
						</div>
					</span>
				</div>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="entry">
		<xsl:param name="orgid"/>				 
		<xsl:for-each select=".">
			<xsl:if test="@doctype='889'">&#xA0;
				<span>
					<xsl:if test="/request/@useragent != 'IE'">
						<xsl:attribute name="style">white-space:nowrap</xsl:attribute>
					</xsl:if>
					<input type="checkbox" class="{$orgid}" id="{userid}" value="{userid}" name="chbox"/>															
					<label for="{userid}"><xsl:value-of select="viewtext"/></label>
				</span>
			</xsl:if>
			<xsl:apply-templates select="entry">
				<xsl:with-param name="orgid" select="$orgid"/>
			</xsl:apply-templates>
			
		</xsl:for-each>
	</xsl:template> 
</xsl:stylesheet>