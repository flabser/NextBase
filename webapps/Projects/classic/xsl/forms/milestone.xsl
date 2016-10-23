<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../templates/form.xsl"/>
	<xsl:import href="../templates/sharedactions.xsl"/>
	<xsl:variable name="doctype"></xsl:variable>
	<xsl:variable name="threaddocid" select="document/@docid"/>
	<xsl:output method="html" encoding="utf-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" indent="yes"/>
	<xsl:variable name="skin" select="request/@skin"/>
	<xsl:variable name="lang" select="request/@lang"/>
	<xsl:variable name="editmode" select="/request/document/@editmode"/>
	<xsl:variable name="status" select="/request/document/@status"/>	
	<xsl:template match="/request">
		<html>		
			<head>	
				<title>
					<xsl:value-of select="concat('Projects - ', document/captions/title/@caption)"/>
				</title>
				<xsl:call-template name="cssandjs"/>
				<script type="text/javascript">
					$(document).bind('keydown', function(e){
 						if (e.ctrlKey){
 							switch (e.keyCode) {
						  		case 66:
						   			<!-- клавиша b -->
							     	e.preventDefault();
							     	$("#canceldoc").click();
							      	break;
							   case 83:
							   		<!-- клавиша s -->
							     	e.preventDefault();
							     	$("#btnsavedoc").click();
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
							   case 78:
							   		<!-- клавиша n -->
							     	e.preventDefault();
							     	$("#newdemand").click()
							      	break;
							   default:
							      	break;
							}
		   				}
					});
					<![CDATA[
						$(document).ready(function(){
							$("#canceldoc").hotnav({keysource:function(e){ return "b"; }});
							$("#btnsavedoc").hotnav({keysource:function(e){ return "s"; }});
							$("#currentuser").hotnav({ keysource:function(e){ return "u"; }});
							$("#logout").hotnav({keysource:function(e){ return "q"; }});
							$("#helpbtn").hotnav({keysource:function(e){ return "h"; }});
							$("#newdemand").hotnav({keysource:function(e){ return "n"; }});
						});
					]]>
				</script>
				<xsl:if test="document/@editmode = 'edit'">					
					<script>
						var _calendarLang = "<xsl:value-of select="/request/@lang"/>";
						$(function() {
							var dates = $( "#startdate, #duedate").datepicker({
								showOn: 'button',
								buttonImage: '/SharedResources/img/iconset/calendar.png',
								buttonImageOnly: true,
								regional:['ru'],
								showAnim: '',
								changeYear:  true,
								yearRange: '-5:+5',
								changeMonth: true,
								firstDay: 1,
								isRTL: false,
								showMonthAfterYear: false,
								regional:['ru'],
								monthNames: calendarStrings[_calendarLang].monthNames,
								monthNamesShort: calendarStrings[_calendarLang].monthNamesShort,
								dayNames: calendarStrings[_calendarLang].dayNames,
								dayNamesShort: calendarStrings[_calendarLang].dayNamesShort,
								dayNamesMin: calendarStrings[_calendarLang].dayNamesMin,
								weekHeader: calendarStrings[_calendarLang].weekHeader,
								yearSuffix: calendarStrings[_calendarLang].yearSuffix,
								onSelect: function( selectedDate ) {
									var option = this.id == "startdate" ? "minDate" : "maxDate",
									instance = $( this ).data( "datepicker" ),
									date = $.datepicker.parseDate(
									instance.settings.dateFormat ||
									$.datepicker._defaults.dateFormat,
									selectedDate, instance.settings );
									dates.not( this ).datepicker( "option", option, date );
								}
							});
						});
					</script>
				</xsl:if>
				<xsl:call-template name="markisread"/>
			</head>
			<body>
				
				<div id="docwrapper">
					<xsl:call-template name="documentheader"/>
					<div class="formwrapper">
						<div class="formtitle">
						   	<div class="title">
					   			<xsl:value-of select="document/captions/title/@caption"/>
							</div>
						</div>
						<!-- Сохранить и закрыть -->
						<div class="button_panel">
							<span style="float:left">
								<xsl:call-template name="get_document_accesslist"/>								
								<xsl:call-template name="save"/>
								<xsl:if test="$status != 'new'">
									<!-- Заявка -->
									<xsl:if test="//actionbar/action[@id='NEW_DOCUMENT']/@mode= 'ON'" >
										<button style="margin-right:5px; margin-bottom:5px" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" title="{//actionbar/action[@id='NEW_DOCUMENT']/@title}" id="new_demand">
											<xsl:attribute name="title" select="//actionbar/action[@id='NEW_DOCUMENT']"/>
											<xsl:attribute name="onclick">javascript:infoDialog("В связи с переходом на новую систему учета заявок регистрация новых заявок закрыта. Для перехода в новую систему перейдите по адресу http://poema.exponentus.com . По всем вопросам обращаться к Падалко П.")</xsl:attribute>
											<span>
												<img src="/SharedResources/img/iconset/page_white_add.png" class="button_img"/>
												<font class="button_text">
													<xsl:value-of select="//actionbar/action[@id='NEW_DOCUMENT']/@caption"/>
												</font>
											</span>
										</button>
									</xsl:if>
								</xsl:if> 
							</span>
							<!-- Закрыть -->
							<span style="float:right; padding-right:15px;">								
								<xsl:call-template name="cancel"/>
							</span>
						</div>
						<div style="clear:both"/>
						<div style="-moz-border-radius:0px;height:1px; width:100%;"/>
						<div style="clear:both"/>
						<div id="tabs">
							<form action="Provider" name="frm" method="post" id="frm" enctype="application/x-www-form-urlencoded"> 
								<ul class="ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-all">
									<li class="ui-state-default ui-corner-top">
										<a href="#tabs-1">
											<xsl:value-of select="document/captions/properties/@caption"/>
										</a>
									</li> 
									<li class="ui-state-default ui-corner-top">
										<a href="#tabs-2"><xsl:value-of select="document/captions/additional/@caption"/></a>
									</li>
									<xsl:call-template name="docInfo"/>
								</ul>							
								<div class="ui-tabs-panel" id="tabs-1" >
									<div display="block"  id="property" width="100%">									 
										<table width="80%" border="0" style="margin-top:8px">																				
											<!--Описание -->
											<tr>
												<td class="fc"><font style="vertical-align:top"><xsl:value-of select="document/captions/description/@caption"/>: </font></td>
												<td style="width:70%"> 											
												<input type="text" required="required" id="description" name="description" class="td_editable" style="width:490px">
													<xsl:if test="$editmode != 'edit'">
														<xsl:attribute name="readonly">readonly</xsl:attribute>
														<xsl:attribute name="class">td_noteditable</xsl:attribute>
													</xsl:if>
													<xsl:attribute name="title" select="document/fields/description/@caption"/>
													<xsl:attribute name="value" select="document/fields/description"/>
												</input> 
												</td>
											</tr> 
											<!-- % Исполнения -->
											<tr>
												<td  class="fc"><font style="vertical-align:top"><xsl:value-of select="document/captions/percentage_of_completion/@caption"/>: </font></td>
												<td>
													<input type="text" required="required" id="percentage_of_completion" name="percentage_of_completion" class="td_editable" style="width:180px">
														<xsl:if test="$editmode != 'edit'">
															<xsl:attribute name="readonly">readonly</xsl:attribute>
															<xsl:attribute name="class">td_noteditable</xsl:attribute>
														</xsl:if>
														<xsl:attribute name="title" select="document/fields/percentage_of_completion/@caption"/>
														<xsl:attribute name="value" select="document/fields/percentage_of_completion"/>
														<xsl:attribute name="onKeydown">javascript:integerwithdot(this)</xsl:attribute>
													</input> 
												</td>
											</tr>
											<!-- Текущая -->										 
											<tr>
												<td class="fc"><font style="vertical-align:top"><xsl:value-of select="document/captions/current/@caption"/>:</font></td>
												<td>
													<input type="checkbox" id="current" name="current">
														<xsl:if test="document/fields/current ='on'">
															<xsl:attribute name="checked">checked</xsl:attribute>
														</xsl:if>
														<xsl:if test="$editmode != 'edit'">
															<xsl:attribute name="disabled">disabled</xsl:attribute>
														</xsl:if> 
													</input> 
												</td> 
											</tr>
											<!-- Дата начала -->
											<tr>
												<td  class="fc"><font style="vertical-align:top"><xsl:value-of select="document/captions/startdate/@caption"/>: </font></td>
												<td>
													<input readonly="readonly" required="required" type="text" id="startdate"  name="startdate" onfocus="javascript:$(this).blur()" class="td_noteditable" style="width:100px; vertical-align:top">
														<xsl:attribute name="title" select="document/captions/startdate/@caption"/>
														<xsl:attribute name="value" select="substring(document/fields/startdate,1,10)"/>
														<xsl:if test="$editmode = 'edit'">
															<xsl:attribute name="class">eventdate td_editable</xsl:attribute>
														</xsl:if> 
													</input> 
												</td>
											</tr>
											<!-- Дата завершения -->
											<tr>
												<td  class="fc"><xsl:value-of select="document/captions/duedate/@caption"/>: </td>
												<td>
													 <input readonly="readonly" required="required" type="text" id="duedate" name="duedate" onfocus="javascript:$(this).blur()" class="td_noteditable" style="width:100px; vertical-align:top">
														<xsl:attribute name="title" select="document/captions/duedate/@caption"/>
														<xsl:attribute name="value" select="substring(document/fields/duedate,1,10)"/>
														<xsl:if test="$editmode = 'edit'">
															<xsl:attribute name="class">eventdate td_editable</xsl:attribute>
														</xsl:if> 
													</input>  
												</td>
											</tr>										
										</table>
										<input type="hidden" name="type" value="save"/>
										<input type="hidden" name="id" value="{@id}"/>
										<input type="hidden" name="key" value="{document/@docid}"/>
										<input type="hidden" name="parentdocid" value="{document/@parentdocid}"/>
										<input type="hidden" name="parentdoctype" value="{document/@parentdoctype}"/>
										<input type="hidden" name="doctype" value="{document/@doctype}"/>
									</div>
								</div>
								<div id="tabs-2">
									<xsl:call-template name="docinfo"/>
								</div>
							</form>	
						</div>
					</div>
				</div>
				<!-- Outline -->
				 <xsl:call-template name="formoutline"/>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>