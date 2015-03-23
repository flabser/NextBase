<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<xsl:import href="../templates/page.xsl"/>
	<xsl:variable name="viewtype">Вид</xsl:variable>
	<xsl:variable name="actionbar" select="//actionbar"/>
	<xsl:variable name="query" select="//query"/>
	<xsl:variable name="captions" select="/request/page/captions"/>
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
				<link type="text/css" rel="stylesheet" href="classic/css/print_page.css" media="print"/>
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
				<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.datepicker.js" charset="UTF-8"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.datepicker-ru.js" charset="UTF-8"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/hotnav/jquery.hotkeys.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/hotnav/jquery.hotnav.js"/>
				<script type="text/javascript" src="classic/scripts/outline.js"/>
				<script type="text/javascript" src="classic/scripts/view.js"/>
				<script type="text/javascript" src="classic/scripts/page.js"/>
				<script>
					$(function() {
						var dates = $( "#startdate, #enddate").datepicker({
						showOn: "button",
						buttonImage: '/SharedResources/img/iconset/calendar.png',
						buttonImageOnly: true,
						changeMonth: true,
						changeYear : true,
						yearRange: '-5y:+5y',
						numberOfMonths: 1,
						onSelect: function( selectedDate ) {
							var option = this.id == "startdate" ? "minDate" : "maxDate",
							instance = $( this ).data( "datepicker" ),
							date = $.datepicker.parseDate(
							instance.settings.dateFormat ||
							$.datepicker._defaults.dateFormat,
							selectedDate, instance.settings );
							dates.not( this ).datepicker( "option", option, date );
						}
					}).keyup(function(e) {
					    if(e.keyCode == 8 || e.keyCode == 46) {
					        $.datepicker._clearDate(this);
					    }
					});
					});
				</script>
				<script type="text/javascript">
					$(document).ready(function(){
						outline.viewid = '<xsl:value-of select="@id"/>';
						outline.element = 'project';
						outline.command='<xsl:value-of select="current/@command"/>';
						outline.curPage = '<xsl:value-of select="current/@page"/>'; 
						outline.category = '';
						outline.filterid = '<xsl:value-of select="@id"/>';
						refresher(); 
						$(".button_panel button").button();
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
    					<![CDATA[
						$("#btnNewdoc").hotnav({keysource:function(e){ return "n"; }});
						$("#btnDeldoc").hotnav({keysource:function(e){ return "d"; }});
						$("#currentuser").hotnav({ keysource:function(e){ return "u"; }});
						$("#btnQFilter").hotnav({keysource:function(e){ return "f"; }});
						$("#logout").hotnav({keysource:function(e){ return "q"; }});
						$("#helpbtn").hotnav({keysource:function(e){ return "h"; }});
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
						<div id="viewcontent-header" style="height:48px; position:relative;">
							<table style="width:100%;">
								<tr style="height:34px">
									<td style="text-align:left; padding-left:15px; width:350px; max-width:400px">					 
										<font class="time" style="font-size:14px; padding-right:10px; font-weight:bold;">
											<xsl:if test="@id = 'demand-unexecuted-view-by-executor'">
												<xsl:value-of select ="$captions/executor/@caption"/> :
											</xsl:if>
											<xsl:if test="@id = 'demand-unexecuted-view-by-author'">
												<xsl:value-of select ="$captions/author/@caption"/> :
											</xsl:if>
											<xsl:call-template name="pagetitle"/>
								    	</font>
									</td>  
									<td>
										<center>
											<xsl:call-template name="prepagelist"/>
										</center>
									</td>
								</tr>
							</table>
							<div class="button_panel" style="top:15px; position:absolute; left:0px; right:0px">
							</div>							
							<div style="clear:both"/>
							<div id="QFilter" style="width:auto; background: #eeeeee; border:1px solid #ccc; border-bottom:none; height:27px; margin-top:5px; margin-left:2px; display:block; position:absolute; top:51px; right:0px; left:12px">
								<xsl:if test="@useragent != 'IE'">
									<xsl:attribute name="style">width:auto; background: #eeeeee; border:1px solid #ccc; border-bottom:none; height:29px; margin-top:5px; margin-left:2px; display:block; position:absolute; top:49px; right:0px; left:12px</xsl:attribute>
								</xsl:if>
		        				<font style="font-size:11px; line-height:25px; margin-left:5px"><xsl:value-of select="//captions/executor/@caption"/> :</font>
								<select style="width:250px; height:23px;" id="exec" name="emp">
									<xsl:for-each select="//filter_elements/response/content/executers/entry">
										<option value="{@id}">
											<xsl:value-of select="."/>
										</option>
									</xsl:for-each>
								</select>
		        				<font style="font-size:11px; line-height:25px; margin-left:10px"><xsl:value-of select="//captions/startdate/@caption"/> :</font>
								<input id="startdate" name="startdate" style="width:70px" autocomplete="off" readonly="true"/>								
		        				<font style="font-size:11px; line-height:25px; margin-left:10px"><xsl:value-of select="//captions/enddate/@caption"/> :</font>
								<input id="enddate" name="enddate" style="width:70px" autocomplete="off"  readonly="true"/>	
								
				        		<img class="filter_button" src="/SharedResources/img/iconset/document_inspector.png" style="margin-left:10px; cursor:pointer; vertical-align:-9px; border:1px solid #cdcdcd; padding:2px 2px; border-radius:3px; height:19px; width:20px">
		        					<xsl:attribute name="title" select="//captions/find/@caption"/>
		        					<xsl:attribute name="onclick">javascript:searchCompleteDemands()</xsl:attribute>
			        			</img>
				        		<img class="filter_button" src="/SharedResources/img/iconset/printer_empty.png" style="margin-left:10px; cursor:pointer; vertical-align:-9px; border:1px solid #cdcdcd; padding:2px 2px; border-radius:3px; height:19px; width:20px">
		        					<xsl:attribute name="title" select="//captions/print/@caption"/>
		        					<xsl:attribute name="onclick">javascript:window.print()</xsl:attribute>
			        			</img>
				        		<img class="filter_button" src="/SharedResources/img/iconset/054-delete.png" style="margin-left:10px; cursor:pointer; vertical-align:-8px; border:1px solid #cdcdcd; padding:3px 4px; border-radius:3px">
		        					<xsl:attribute name="title" select="//captions/resetfilter/@caption"/>
		        					<xsl:attribute name="onclick">javascript:resetFilter()</xsl:attribute>
			        			</img>
							</div>						
						</div>
						<div id="viewtablediv" style ="top:20px">
							<div id="tableheader" style="top:84px">
								<table class="viewtable" width="100%">
									<tr class="th">
										<td style="text-align:center;height:30px;width:35px;" class="thcell hasattach_td">
										</td>
										<td style="text-align:center;height:30px;width:45px;" class="thcell">
											<xsl:value-of select="//captions/viewnumber/@caption"/>
										</td>
										<td style="text-align:center; height:30px; width:150px;" class="thcell">
											<xsl:value-of select="//captions/viewtext1/@caption"/>
										</td>
										<td style="min-width:160px; width:55%" class="thcell">
											<xsl:value-of select ="//captions/viewtext/@caption"/>
										</td>
										<td style="width:200px;" class="thcell">
											<xsl:value-of select="//captions/viewdate/@caption"/>
										</td>
										<td style="width:30px;" class="thcell fav_td"/>
                                        <td style="width:42px;" class="thcell discussion_td" />
									</tr>
								</table>
							</div>
							<div id="tablecontent" autocomplete="off" style="top:119px">
								<table class="viewtable" id="viewtable" width="100%">	
								</table>
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