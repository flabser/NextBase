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
				<xsl:if test="document/@editmode= 'edit'">
					<script>
						$(function() {
							var dates = $( "#remarkctrldatefrom, #remarkctrldateto" ).datepicker({
							defaultDate: "+1w",
							showOn: "button",
							buttonImage: '/SharedResources/img/iconset/calendar.png',
							buttonImageOnly: true,
							changeMonth: true,
							numberOfMonths: 1,
							onSelect: function( selectedDate ) {
								var option = this.id == "remarkctrldatefrom" ? "minDate" : "maxDate",
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
								<xsl:if test="document/fields/allcontrol != '0' and document/@editmode ='edit'">
									<xsl:if test="document/@editmode ='edit'">
									<button class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" title="{document/actions/action [.='SAVE']/@hint}">
										<xsl:attribute name="onclick">javascript:fillingReport("originplace_report")</xsl:attribute>
										<span >
											<img src="/SharedResources/img/iconset/disk.png" class="button_img"/>
											<font style="font-size:12px; vertical-align:top"><xsl:value-of select="document/actions/action [.='SAVE']/@caption"/></font>
										</span>
									</button>
								</xsl:if>
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
															<xsl:value-of select="viewcontent/viewtext1"/>
														</option>
													</xsl:for-each>
												</select>
											</td>
										</tr>
										<!-- <tr>
											<td class="fc">
												<font style="vertical-align:top">
													Начальник участка : 
												</font>
												<xsl:if test="$editmode = 'edit'">
													<a>
														<xsl:attribute name="href">javascript:dialogBoxStructure('responsiblesection','false','responsible','frm', 'responsiblesectiontbl');</xsl:attribute>
														<img src="/SharedResources/img/iconset/report_magnify.png"/>
													</a>
												</xsl:if>
												</td>
												<td>
													<xsl:if test="document/@status='new'">
														<table id="responsiblesectiontbl" style="border-spacing:0px 3px;">
															<tr>
																<td class="td_editable" style="width:600px;">
																	<xsl:if test="$editmode != 'edit'">
																		<xsl:attribute name="class">td_noteditable</xsl:attribute>
																	</xsl:if>
																	<xsl:value-of select="document/fields/responsible"/>&#xA0;
																</td>
															</tr>
														</table>
													</xsl:if>
													<xsl:if test="document/@status != 'new'">
														<table id="responsiblesectiontbl" style="border-spacing:0px 3px;">
																<tr>
																	<td class="td_editable" style="width:600px;">
																		<xsl:if test="$editmode != 'edit'">
																			<xsl:attribute name="class">td_noteditable</xsl:attribute>
																		</xsl:if>
																		<xsl:value-of select="document/fields/responsible"/>&#xA0;
																	</td>
																</tr>
														</table>
													</xsl:if>
													<input type="hidden" id="responsiblecaption" value="Ответственный участка"/>
													<script>
														if ($("#signertbl tr").length &lt; 1){
															$("#signertbl").append("<tr><td>&#xA0;</td></tr>");
					 									}
													</script>
												</td>
											</tr>
										<tr>
											<td class="fc">Срок исполнения :</td>
											<td>
												&#xA0;<label for="from">c</label>&#xA0;
												<input type="text" id="remarkctrldatefrom" size="7" name="remarkctrldatefrom" value="{document/fields/remarkctrldatefrom}" style="background:#fff; padding:3px 3px 3px 5px; width:80px; border:1px solid #ccc; vertical-align:top">
													<xsl:if test="document/@editmode != 'edit'">
														<xsl:attribute name="readonly">readonly</xsl:attribute>
														<xsl:attribute name="style">background:none; padding:3px 3px 3px 5px; width:80px; border:1px solid #ccc</xsl:attribute>
													</xsl:if>
												</input>
												&#xA0;<label for="to">по</label>&#xA0;
												<input type="text" id="remarkctrldateto" value="{document/fields/remarkctrldateto}" size="7" name="remarkctrldateto" style="background:#fff; padding:3px 3px 3px 5px; width:80px; border:1px solid #ccc; vertical-align:top">
													<xsl:if test="document/@editmode != 'edit'">
														<xsl:attribute name="readonly">readonly</xsl:attribute>
														<xsl:attribute name="style">background:none; padding:3px 3px 3px 5px; width:80px; border:1px solid #ccc</xsl:attribute>
													</xsl:if>
												</input>
											</td>
										</tr> -->
										
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
										 <!--  <tr>
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
								<input type="hidden" name="id" value="originplace_report"/>
								<input type="hidden" name="author" value="{document/fields/author/@attrval}"/>
								<input type="hidden" name="allcontrol" value="{document/fields/allcontrol}"/>
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
				<div style="position:absolute; bottom:0px;left:0px; right:0px; background:#898989; width:auto; height:3.2em; border-top:1px solid #aaa; padding:0.5em 1em">
						<button  id="btnuserprf">
							<xsl:attribute name="onclick">javascript:openuserpanel()</xsl:attribute>
							<font style="font-size:14px; vertical-align:top"><xsl:value-of select="@username"/>&#xA0;&#xA0;</font>
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
							<font><xsl:value-of select="document/captions/help/@caption"/></font>
						</button>
						<div style="width:100%; height:2px; background:#787878; margin-top:15px"></div>
						<button  class="mnbtn" style="width:100%; margin-top:20px">
							<xsl:attribute name="onclick">javascript:window.location.href="Logout"</xsl:attribute>
							<font><xsl:value-of select="document/captions/logout/@caption"/></font>
						</button>
					</div>
					<div id="outlinelist" style="position:absolute; top:0px; bottom: 4.2em; left:-100%; width:100%; background:#fff; display:none; overflow:auto">
							<ul style="margin-left: auto; padding: 0; list-style: none;	text-align: center; line-height: 0; zoom:1;">
								<xsl:for-each select="document/outline/entry/entry">
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