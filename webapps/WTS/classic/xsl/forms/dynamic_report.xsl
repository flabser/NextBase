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
				<script>
					$(document).ready(function(){
						$("#contractor , #amountdamage").tipTip({'activation':'click',"field":"contractor","defaultPosition":"right"});
						SuggestionContractor()
   					})
				</script>
				<xsl:if test="document/@editmode= 'edit'">
					<script>
						$(function() {
							var dates = $( "#datefrom, #dateto" ).datepicker({
							defaultDate: "+1w",
							showOn: "button",
							buttonImage: '/SharedResources/img/iconset/calendar.png',
							buttonImageOnly: true,
							changeMonth: true,
							numberOfMonths: 1,
							onSelect: function( selectedDate ) {
								var option = this.id == "datefrom" ? "minDate" : "maxDate",
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
				<div id='loadingpage' style='position:absolute; display:none; z-index:1'>
				<script>
					lt = ($(document).height())/2;
					ll = ($(window).width() - 80 )/2;
					$("#loadingpage").css("top",lt).css("left",ll );
				</script>
				<img src='/SharedResources/img/classic/4(4).gif'/>
			</div>	
				<xsl:if test="@status!='new'">
					<xsl:attribute name="onLoad">javascript:onLoadActions()</xsl:attribute>
				</xsl:if>
				<div id="docwrapper">
					<xsl:call-template name="documentheader"/>	
					<div class="formwrapper">
						<div class="formtitle">
							<div style="float:left" class="title">Отчет</div>
							<div style="float:right; padding-right:5px"></div>
						</div>
						<div class="button_panel">
							<span style=" vertical-align:12px; float:left">
								<xsl:call-template name="showxml"/>
								<xsl:if test="document/@editmode ='edit'">
									<button class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" title="{document/actions/action [.='SAVE']/@hint}">
										<xsl:attribute name="onclick">javascript:fillingReport("dynamic_report")</xsl:attribute>
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
									<!-- Автор резолюции -->
									<table width="100%" border="0">
										<!-- Контрагент -->
										<tr>
											<td class="fc" style="padding-top:5px">Контрагент :</td>
											<td style="padding-top:5px">
												<input type="text" id="contractor" value="{document/fields/contragent}" title="Для поиска контрагента необходимо ввести минимум 4 символа" class="td_editable" style="width:600px; vertical-align:top" onblur="javascript:contractorFieldUpdate()">
													<xsl:if test="$editmode != 'edit'">
														<xsl:attribute name="class">td_noteditable</xsl:attribute>
													</xsl:if>
												</input>
												<input type="hidden" id="contractorid" name="contragent" value="{document/fields/contragent/@attrval}"/>
												<input type="hidden" id="contractorviewtext" value="{document/fields/contragent}"/>
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
														Все
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
										<tr>
											<td class="fc" style="padding-top:5px">Вид работ  :</td>
											<td style="padding-top:5px">
												<xsl:variable name="category" select="document/fields/category/@attrval" />
												<xsl:variable name="parentcategory" select="document/fields/parentcategory"/>
												<select size="1" id="category" name="category" style="width:610px;" class="select_editable" onchange="javascript:addSubCatGloss(this); $('#subcategory').attr('style','width:610px')">
													<xsl:if test="$editmode != 'edit'">
														<xsl:attribute name="disabled">true</xsl:attribute>
														<xsl:attribute name="class">select_noteditable</xsl:attribute>
														<option value=" ">
															<xsl:attribute name="selected">selected</xsl:attribute>
															<xsl:value-of select="document/fields/category"/>
														</option>
													</xsl:if>
													<xsl:if test="$editmode = 'edit'">
														<option value=" ">
															<xsl:attribute name="selected">selected</xsl:attribute>Все
														</option>
															</xsl:if>
														<script>
															$(document).ready(function(){
																if ($("#category").val() != ' '){
																	$('#subcategory').attr('style','width:610px')
																	$.ajax({
																		url: 'Provider?type=query&amp;id=glossresponses&amp;parentdocid='+$("#category").val()+'&amp;parentdoctype=894',
																		datatype:'xml',
																		success: function(data) {
																			$("#subcategory option").remove();
																			if ($("#subcategory > option").length == 0){
																				<![CDATA[$("#subcategory").append("<option value=''>Все</option>")]]>
																			}
																			$(data).find("entry[doctype=894]").each(function(index, element){
																				<![CDATA[ $("#subcategory").append("<option value='"+ $(element).attr("docid")+"'>"+ $(element).attr("viewtext") +"</option>")]]>
																			});
																			if ($("#subcategory > option").length == 1){
																				$("#subcategory > option").remove()
																				<![CDATA[$("#subcategory").append("<option value=''>Подвидов нет</option>")]]>
																			}
																		}
																	});	
																}
															});
														</script>
														<!-- <xsl:if test="$parentcategory != ''">
															<xsl:attribute name="class">select_noteditable</xsl:attribute>
															<xsl:attribute name="disabled"/>
														</xsl:if> -->
														<xsl:for-each select="document/glossaries/docscat/query/entry">
															<option value="{@docid}" >
																<xsl:if test="$category = @docid">
																	<xsl:attribute name="selected">selected</xsl:attribute>
																</xsl:if>
																<xsl:if test="$parentcategory = @docid">
																	<xsl:attribute name="selected">selected</xsl:attribute>
																</xsl:if>
																<xsl:value-of select="viewcontent/viewtext1"/>
															</option>
														</xsl:for-each>
													</select>
												</td>
											</tr>
											<tr>
												<td class="fc" style="padding-top:5px">Подвид работ  :</td>
												<td style="padding-top:5px">
													<xsl:variable name="subcategory" select="document/fields/subcategory/@attrval" />
													<xsl:variable name="parentcategory" select="document/fields/parentsubcategory"/>
													<select size="1" name="subcategory" id="subcategory" style="width:610px; " class="select_editable">
														<xsl:if test="document/fields/subcategory = '0' or not(document/fields/subcategory)">
															<xsl:attribute name="style">width:610px; font-style:italic; color:#555</xsl:attribute> 
														</xsl:if>
														<xsl:if test="$editmode != 'edit'">
															<xsl:attribute name="class">select_noteditable</xsl:attribute>
															<xsl:attribute name="disabled"/>
															<option value=" ">
																<xsl:attribute name="selected">selected</xsl:attribute>
																<xsl:value-of select="document/fields/subcategory"/>
															</option>
														</xsl:if>
														<xsl:if test="$editmode = 'edit'">
															<option value=" " style="font-style:italic; color:#bbb">
																<xsl:attribute name="selected">selected</xsl:attribute>
																<i>Выберите вид работ</i>
															</option>
														</xsl:if>
														<!-- <xsl:if test="$parentcategory != ''">
															<xsl:attribute name="class">select_noteditable</xsl:attribute>
															<xsl:attribute name="disabled"/>
														</xsl:if> -->
														<!-- <xsl:for-each select="document/glossaries/subcat/query/entry">
															<option value="{@docid}">
																<xsl:if test="$subcategory = @docid">
																	<xsl:attribute name="selected">selected</xsl:attribute>
																</xsl:if>
																<xsl:if test="$parentcategory = @docid">
																	<xsl:attribute name="selected">selected</xsl:attribute>
																</xsl:if>
																<xsl:value-of select="@viewtext"/>
															</option>
														</xsl:for-each> -->
													</select>
												</td>
											</tr>
											<tr>
												<td class="fc">Интервал :</td>
												<td>
													&#xA0;<label for="from">c</label>&#xA0;
													<input type="text" id="datefrom" size="7" name="datefrom" value="{document/fields/datefrom}" style="background:#fff; padding:3px 3px 3px 5px; width:80px; border:1px solid #ccc">
														<xsl:if test="document/@editmode != 'edit'">
															<xsl:attribute name="readonly">readonly</xsl:attribute>
															<xsl:attribute name="style">background:none; padding:3px 3px 3px 5px; width:80px; border:1px solid #ccc</xsl:attribute>
														</xsl:if>
													</input>
													&#xA0;<label for="to">по</label>&#xA0;
													<input type="text" id="dateto" value="{document/fields/taskdateto}" size="7" name="dateto" style="background:#fff; padding:3px 3px 3px 5px; width:80px; border:1px solid #ccc">
														<xsl:if test="document/@editmode != 'edit'">
															<xsl:attribute name="readonly">readonly</xsl:attribute>
															<xsl:attribute name="style">background:none; padding:3px 3px 3px 5px; width:80px; border:1px solid #ccc</xsl:attribute>
														</xsl:if>
													</input>
												</td>
										</tr>
										<tr>
											<td class="fc">Статус :</td>
											<td>
												<select size="1" name="coordstatus" style="background:#fff; padding:3px 3px 3px 5px; width:288px; border:1px solid #ccc">
													<xsl:if test="document/@editmode != 'edit'">
														<xsl:attribute name="style">background:none; padding:3px 3px 3px 5px; width:288px; border:1px solid #ccc</xsl:attribute>
														<xsl:attribute name="disabled"></xsl:attribute>
													</xsl:if>
														<option value="0">
															Все 
														</option>
														<option value="1">
															Замечание устранено
														</option>
														<option value="2">
															На исполнении
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
														<td>
															<input type="radio" name="typefilereport" value="3">
																<xsl:attribute name="onclick">javascript: reportsTypeCheck(this)</xsl:attribute>
																<xsl:if test="document/@editmode !='edit'">
																	<xsl:attribute name="disabled">disabled</xsl:attribute>
																</xsl:if>
																<xsl:if test="document/fields/typefilereport  = '3'">
																	<xsl:attribute name="checked">checked</xsl:attribute>
																</xsl:if>
																Browser
															</input>
														</td>
													</tr>
												</table>
											</td>
										</tr>
									</table>
									
									<div id="report_info_place" style="margin-top:20px">
										
									</div>
									<div id="report_place" style="margin-top:20px">
										
									</div>
								</div>
								<!-- Скрытые поля -->
								<input type="hidden" name="isresol" value="{isresol}"/>
								<input type="hidden" name="type" value="save"/>
								<input type="hidden" name="id" value="dynamic_report"/>
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
				<xsl:call-template name="outline_form"/>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>