<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../templates/form.xsl"/>
	<xsl:import href="../templates/sharedactions.xsl"/>
	<xsl:variable name="doctype">Отчет</xsl:variable>
	<xsl:variable name="path" select="/request/@skin"/>
	<xsl:variable name="editmode" select="/request/document/@editmode"/>
	<xsl:variable name="threaddocid" select="document/@granddocid"/>
	<xsl:output method="html" encoding="utf-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" indent="yes"/>
	<xsl:variable name="skin" select="request/@skin"/>
	<xsl:template match="/request">
		<html>
			<head>
				<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
				<title>
					<xsl:if test="document/@status != 'new'">
						<xsl:value-of select="document/@viewtext"/> - Web Technical Supervision 
					</xsl:if>
					<xsl:if test="document/@status = 'new'">
						новый <xsl:value-of select="lower-case($doctype)"/>  - Web Technical Supervision
					</xsl:if>
				</title>
				<xsl:call-template name="cssandjs"/>
				<xsl:call-template name="htmlareaeditor"/>
				<style>
				.ui-autocomplete {
					max-height: 190px;
					overflow-y: auto;
					overflow-x: hidden;
					width:605px !important;
					color:black !important;
					border-radius:0px;
					border-style:outset;
					border-color:black;
					border-left-width:2px;
					margin-left:2px;
				}
				.ui-menu-item {
					width:590px !important;
					font-size:0.9em !important;
					clear:both;
					padding:0px;
				}
				.ui-menu-item a {
					height:16px !important;
					line-height:16px;
				}
				#ui-active-menuitem{
					border-radius:0px;
					height:15px !important;
					line-height:15px;
					background:#3399FF;
					color:white;
					padding-left:6px;
					border:0px;
				}
				.ui-autocomplete-loading {
					 background: white url('/SharedResources/jquery/css/base/images/ui-anim_basic_16x16.gif') right center no-repeat; 
				}
			</style>
				<xsl:if test="document/@editmode= 'edit'">
					<script>
						$(document).ready(function(){
							SuggestionContractor()   			
   						})
						$(function() {
							var dates = $( "#remarkdatefrom, #remarkdateto" ).datepicker({
							defaultDate: "+1w",
							changeMonth: true,
							numberOfMonths: 1,
							showOn: "button",
							buttonImage: '/SharedResources/img/iconset/calendar.png',
							buttonImageOnly: true,
							onSelect: function( selectedDate ) {
								var option = this.id == "remarkdatefrom" ? "minDate" : "maxDate",
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
			</head>
			<body>
				
				<xsl:if test="@status!='new'">
					<xsl:attribute name="onLoad">javascript:onLoadActions()</xsl:attribute>
				</xsl:if>
				<div id="docwrapper">
					<xsl:call-template name="documentheader"/>	
					<div class="formwrapper">
						<div class="formtitle">
							<div style="float:left" class="title">
								Отчет
							</div>
							<div style="float:right; padding-right:5px">
							</div>
						</div>
						<div class="button_panel">
							<span style=" vertical-align:12px; float:left">
								<xsl:call-template name="showxml"/>
								<xsl:if test="document/@editmode ='edit'">
									<button class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" title="{document/actions/action [.='SAVE']/@hint}">
										<xsl:attribute name="onclick">javascript:fillingReport("status_report")</xsl:attribute>
										<span >
											<img src="/SharedResources/img/iconset/disk.png" class="button_img"/>
											<font style="font-size:12px; vertical-align:top"><xsl:value-of select="document/actions/action [.='SAVE']/@caption"/></font>
										</span>
									</button>
								</xsl:if>
							</span>
							<span style="float:right" class="bar_right_panel">
								<xsl:call-template name="cancel"/>
							</span>
						</div>
						<div style="clear:both"/>
						<div style="-moz-border-radius:0px;height:1px; width:100%; margin-top:10px;"/>
						<div style="clear:both"/>
						<div id="tabs">
							<ul class="ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-all">
								<li class="ui-state-default ui-corner-top">
									<a href="#tabs-1"><xsl:value-of select="document/captions/properties/@caption"/></a>
								</li> 
							</ul>
							<form action="Provider" name="frm" method="post" id="frm" enctype="application/x-www-form-urlencoded">
								<div class="ui-tabs-panel" id="tabs-1">
									<br/>
									<table width="100%" border="0">
										<!-- <tr>
											<td class="fc">Номер замечания:</td>
											<td>
												<input type="text" id="number" value="{document/fields/number}" size="7" name="number" style="background:#fff; padding:3px 3px 3px 5px; width:80px; border:1px solid #ccc">
												</input>
											</td>
										</tr>
										<tr>
											<td class="fc">Дата замечания :</td>
											<td>
												&#xA0;<label for="from">c</label>&#xA0;
												<input type="text" id="remarkdatefrom" size="7" name="remarkdatefrom" value="{document/fields/taskdatefrom}" style="background:#fff; padding:3px 3px 3px 5px; width:80px; border:1px solid #ccc; vertical-align:top">
													<xsl:if test="document/@editmode != 'edit'">
														<xsl:attribute name="readonly">readonly</xsl:attribute>
														<xsl:attribute name="style">background:none; padding:3px 3px 3px 5px; width:80px; border:1px solid #ccc</xsl:attribute>
													</xsl:if>
												</input>
												&#xA0;<label for="to">по</label>&#xA0;
												<input type="text" id="remarkdateto" value="{document/fields/remarkdateto}" size="7" name="remarkdateto" style="background:#fff; padding:3px 3px 3px 5px; width:80px; border:1px solid #ccc; vertical-align:top">
													<xsl:if test="document/@editmode != 'edit'">
														<xsl:attribute name="readonly">readonly</xsl:attribute>
														<xsl:attribute name="style">background:none; padding:3px 3px 3px 5px; width:80px; border:1px solid #ccc</xsl:attribute>
													</xsl:if>
												</input>
											</td>
										</tr>
										<tr>
											<td class="fc" style="padding-top:5px">Контрагент :</td>
											<td style="padding-top:5px">
												<input type="text" id="contractor" value="{document/fields/contragent}" class="td_editable" style="width:600px; vertical-align:top" onblur="javascript:contractorFieldUpdate()">
													<xsl:if test="$editmode != 'edit'">
														<xsl:attribute name="class">td_noteditable</xsl:attribute>
													</xsl:if>
												</input>
												<input type="hidden" id="contractorid" name="contragent" value="{document/fields/contragent/@attrval}">
												</input>
												<input type="hidden" id="contractorviewtext" value="{document/fields/contragent}">
												</input>
											</td>
										</tr>
										<tr>
											<td class="fc">Проект :</td>
											<td>
												<xsl:variable name="project" select="document/fields/project/@attrval"/>
												<select size="1" name="project" style="background:#fff; padding:3px 3px 3px 5px; width:610px; border:1px solid #ccc">
													<xsl:if test="document/@editmode != 'edit'">
														<xsl:attribute name="style">background:none; padding:3px 3px 3px 5px; width:610px; border:1px solid #ccc</xsl:attribute>
														<xsl:attribute name="disabled"></xsl:attribute>
													</xsl:if>
													<option value=" ">
														<xsl:attribute name="selected">selected</xsl:attribute>
														&#xA0;
													</option>
													<xsl:for-each select="document/glossaries/projectsprav/query/entry">
														<option value="{@docid}">
															<xsl:if test="$project = @docid">
																<xsl:attribute name="selected">selected</xsl:attribute>
															</xsl:if>
															<xsl:value-of select="@viewtext"/>
														</option>
													</xsl:for-each>
												</select>
											</td>
										</tr>
										<tr>
											<td class="fc">Текст замечания:</td>
											<td>
												<input type="text" id="viewtextremark" value="{document/fields/viewtextremark}"  name="viewtextremark" style="background:#fff; padding:3px 3px 3px 5px; width:279px; border:1px solid #ccc">
												</input>
											</td>
										</tr> -->
										<tr>
											<td class="fc">Статус :</td>
											<td>
												<select size="1" name="remarkstatus" style="background:#fff; padding:3px 3px 3px 5px; width:288px; border:1px solid #ccc">
													<xsl:if test="document/@editmode != 'edit'">
														<xsl:attribute name="style">background:none; padding:3px 3px 3px 5px; width:288px; border:1px solid #ccc</xsl:attribute>
														<xsl:attribute name="disabled"></xsl:attribute>
													</xsl:if>
														<option value="">
															
														</option>
														<option value="362">
															Замечание устранено
														</option>
														<option value="361">
															На исполнении
														</option>
														<option value="351">
															Черновик
														</option>
														<option value="352">
															На согласовании
														</option>
														<option value="354">
															Отклонено ответственным участка
														</option>
														<option value="355">
															На ревизии исполнения
														</option>
												</select>
											</td>
										</tr>
										 <tr>
											<td class="fc">Тип файла отчета :</td>
											<td>
												<table>
													<tr>
														<td>
															<input type="radio" name="typefilereport" value="1">
																<xsl:attribute name="onclick">javascript: reportsTypeCheck(this)</xsl:attribute>
																<xsl:if test="document/@editmode !='edit'">
																	<xsl:attribute name="disabled">disabled</xsl:attribute>
																</xsl:if>
																<xsl:if test="document/fields/typefilereport  = '1'">
																	<xsl:attribute name="checked">checked</xsl:attribute>
																</xsl:if>
																<xsl:if test="document/@status  = 'new'">
																	<xsl:attribute name="checked">checked</xsl:attribute>
																</xsl:if>
																PDF
															</input>
														</td>
														<td>
															<input type="radio" name="typefilereport" value="2">
																<xsl:attribute name="onclick">javascript: reportsTypeCheck(this)</xsl:attribute>
																<xsl:if test="document/@editmode !='edit'">
																	<xsl:attribute name="disabled">disabled</xsl:attribute>
																</xsl:if>
																<xsl:if test="document/fields/typefilereport  = '2'">
																	<xsl:attribute name="checked">checked</xsl:attribute>
																</xsl:if>
																XLS
															</input>
														</td>
														<!-- <td>
															<input type="radio" name="typefilereport" value="3">
																<xsl:attribute name="onclick">javascript: reportsTypeCheck(this)</xsl:attribute>
																<xsl:if test="document/@editmode !='edit'">
																	<xsl:attribute name="disabled">disabled</xsl:attribute>
																</xsl:if>
																<xsl:if test="document/fields/typefilereport  = '3'">
																	<xsl:attribute name="checked">checked</xsl:attribute>
																</xsl:if>
																HTML
															</input>
														</td> -->
													</tr>
												</table>
											</td>
										</tr>
										  <!-- <tr>
											<td class="fc">Открыть отчет :</td>
											<td>
												<table>
													<tr>
														<td> 
															<input type="radio" name="disposition" value="attachment">
																<xsl:if test="document/@editmode='noaccess'">
																	<xsl:attribute name="disabled">disabled</xsl:attribute>
																</xsl:if>
																<xsl:if test="document/fields/disposition  = 'attachment'">
																	<xsl:attribute name="checked">checked</xsl:attribute>
																</xsl:if>
																<xsl:if test="document/@status  = 'new'">
																	<xsl:attribute name="checked">checked</xsl:attribute>
																</xsl:if>
																в программе по умолчанию
															</input>
														</td>
														<td>
															<input type="radio" name="disposition" value="inline">
																<xsl:if test="document/@editmode='noaccess'">
																	<xsl:attribute name="disabled">disabled</xsl:attribute>
																</xsl:if>
																<xsl:if test="document/fields/disposition  = 'inline'">
																	<xsl:attribute name="checked">checked</xsl:attribute>
																</xsl:if>
																в окне браузера
															</input>
														</td>
													</tr>
												</table>
											</td>
										</tr>  -->
									</table>
								</div>
								<!-- Скрытые поля -->
								<input type="hidden" name="isresol" value="{isresol}"/>
								<input type="hidden" name="type" value="save"/>
								<input type="hidden" name="id" value="status_report"/>
								<input type="hidden" name="author" value="{document/fields/author/@attrval}"/>
								<input type="hidden" name="allcontrol" value="{document/fields/allcontrol}"/>
								<input type="hidden" name="tasktype">
									<xsl:choose>
										<xsl:when test="document/fields/tasktype = 'RESOLUTION'">
											<xsl:attribute name="value">RESOLUTION</xsl:attribute>
										</xsl:when>
										<xsl:when test="document/fields/parenttasktype=''">
											<xsl:attribute name="value">RESOLUTION</xsl:attribute>
										</xsl:when>
										<xsl:otherwise>
											<xsl:attribute name="value">CONSIGN</xsl:attribute>
										</xsl:otherwise>
									</xsl:choose>
								</input>
								<input type="hidden" name="doctype" value="{document/@doctype}"/>
								<input type="hidden" name="key" value="{document/@docid}"/>
								<input type="hidden" name="parentdocid" value="{document/@parentdocid}"/>
								<input type="hidden" name="parentdoctype" value="{document/@parentdoctype}"/>
								<input type="hidden" name="page" value="{document/@openfrompage}"/>
								<xsl:for-each select="extexecid/item">
									<input type="hidden" name="extexecid" id="extexecid" value="{.}"/>
								</xsl:for-each>
							</form>
							<div id="executers" style="display:none">
								<table style="width:100%">
									<xsl:for-each select="document/fields/executors/entry">
											<tr>
												<td>
													<input type="checkbox" name="chbox" value="{user}" id="{user/@attrval}">
														<xsl:if test="user/@attrval =''">
															<xsl:attribute name="disabled">disabled</xsl:attribute>
														</xsl:if>
													</input>	
												</td>
												<td>
													<font class="font"  style="font-family:verdana; font-size:13px; margin-left:2px">
														<xsl:if test="user/@attrval =''">
															<xsl:attribute name="color">gray</xsl:attribute>
														</xsl:if>
														<xsl:value-of select="user"/> 
													</font>
												</td>
											</tr>
									</xsl:for-each>
								</table>
							</div>
							<input type="hidden" id="currentuser" value="{@userid}"/>
							<input type="hidden" id="localusername" value="{@username}"/>
						</div>
						<div style="height:10px"/>
					</div>
				</div>
				<xsl:call-template name="outline_form"/>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>