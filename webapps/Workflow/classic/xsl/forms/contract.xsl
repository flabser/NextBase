<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../templates/form.xsl"/>
	<xsl:import href="../templates/sharedactions.xsl"/>
	<xsl:variable name="doctype" select="request/document/fields/title"/>
	<xsl:variable name="path" select="/request/@skin" />
	<xsl:variable name="captions" select="/request/document/captions"/>
	<xsl:variable name="fields" select="/request/document/fields"/>
	<xsl:variable name="threaddocid" select="document/@docid"/>
	<xsl:output method="html" encoding="utf-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" indent="yes"/>
	<xsl:variable name="skin" select="request/@skin"/>
	<xsl:variable name="editmode" select="/request/document/@editmode"/>
	<xsl:variable name="status" select="/request/document/@status"/>
	<xsl:template match="/request">
		<html>
			<head>
				<title>
					<xsl:value-of select="concat('Workflow документооборот - ',document/fields/title)"/>
				</title>
				<xsl:call-template name="cssandjs"/>

				<xsl:call-template name="markisread"/>
				<xsl:if test="$editmode = 'edit'">
					<xsl:call-template name="htmlareaeditor"/>
				</xsl:if>
				<script type="text/javascript">
					$(document).ready(function(){hotkeysnav()})
   					<![CDATA[
   						function hotkeysnav() {
							$(document).bind('keydown', function(e){
			 					if (e.ctrlKey) {
			 						switch (e.keyCode) {
									   case 66:
									   		<!-- клавиша b -->
									     	e.preventDefault();
									     	$("#canceldoc").click();
									      	break;
									   case 69:
									   		<!-- клавиша e -->
									     	e.preventDefault();
									     	$("#btnexecution").click();
									      	break;
									   case 71:
									  		<!-- клавиша g -->
									     	e.preventDefault();
									     	$("#btngrantaccess").click();
									      	break;
									   case 87:
									  		<!-- клавиша w -->
									     	e.preventDefault();
									     	$("#btnremind").click();
									      	break;
									   case 83:
									   		<!-- клавиша s -->
									     	e.preventDefault();
									     	$("#btnsavedoc").click();
									      	break;
									   case 84:
									   		<!-- клавиша t -->
									     	e.preventDefault();
									     	$("#btnnewkr").click();
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
									   case 73:
									   		<!-- клавиша i -->
									     	e.preventDefault();
									     	$("#btnnewish").click();
									      	break;
									   default:
									      	break;
									}
			   					}
							});
							$("#canceldoc").hotnav({keysource:function(e){ return "b"; }});
							$("#btncoordyes").hotnav({keysource:function(e){ return "y"; }});
							$("#btngrantaccess").hotnav({keysource:function(e){ return "g"; }});
							$("#btnremind").hotnav({keysource:function(e){ return "w"; }});
							$("#btnsavedoc").hotnav({keysource:function(e){ return "s"; }});
							$("#btnexecution").hotnav({keysource:function(e){ return "e"; }});
							$("#btnnewkr").hotnav({keysource:function(e){ return "t"; }});
							$("#currentuser").hotnav({ keysource:function(e){ return "u"; }});
							$("#logout").hotnav({keysource:function(e){ return "q"; }});
							$("#helpbtn").hotnav({keysource:function(e){ return "h"; }});
							$("#btnnewish").hotnav({keysource:function(e){ return "i"; }});
						}
					]]>
				</script>
				<xsl:if test="document/@editmode = 'edit'">
					<script>
						var _calendarLang = "<xsl:value-of select="/request/@lang" />";
						$(function() {
							$('#datecontractor, #din, #contracttime, #controldate').datepicker({
								showOn: 'button',
								buttonImage: '/SharedResources/img/iconset/calendar.png',
								buttonImageOnly: true,
								regional:['ru'],
								showAnim: '',
								monthNames: calendarStrings[_calendarLang].monthNames,
								monthNamesShort: calendarStrings[_calendarLang].monthNamesShort,
								dayNames: calendarStrings[_calendarLang].dayNames,
								dayNamesShort: calendarStrings[_calendarLang].dayNamesShort,
								dayNamesMin: calendarStrings[_calendarLang].dayNamesMin,
								weekHeader: calendarStrings[_calendarLang].weekHeader,
								yearSuffix: calendarStrings[_calendarLang].yearSuffix,
							});
						});
					</script>
				</xsl:if>
		</head>
		<body>
			<div id="docwrapper">
				<xsl:call-template name="documentheader"/>	
				<div class="formwrapper">
					<div class="formtitle">
						<div style="float:left" class="title">
							<xsl:call-template name="doctitle"/><span id="whichreadblock">Прочтен</span>
						</div>
						<div style="float:right; padding-left:5px">
						</div>
					</div>
					<div class="button_panel">
						<span style="width:80%; vertical-align:12px; float:left">
							<xsl:call-template name="showxml"/>
							<xsl:call-template name="get_document_accesslist"/>
							<xsl:call-template name="save"/>
							<xsl:call-template name="acquaint"/>
							<xsl:call-template name="newact"/>
							<xsl:call-template name="ECPsign"/>

						</span>
						<span style="float:right">
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
							<li class="ui-state-default ui-corner-top">
								<a href="#tabs-2"><xsl:value-of select="document/captions/content/@caption"/></a>
							</li>
							<li class="ui-state-default ui-corner-top">
								<a href="#tabs-3"><xsl:value-of select="document/captions/progress/@caption"/></a>
							</li>
							<li class="ui-state-default ui-corner-top">
								<a href="#tabs-4"><xsl:value-of select="document/captions/attachments/@caption"/></a>
								<img id="loading_attach_img" style="vertical-align:-8px; margin-left:-10px; padding-right:3px; visibility:hidden" src="/SharedResources/img/classic/ajax-loader-small.gif"></img>
							</li>
							<xsl:if test="document/fields/coordination">
								<li class="ui-state-default ui-corner-top">
									<a href="#tabs-6">
										<xsl:value-of select="$captions/coordination/@caption"/>
									</a>
								</li>
							</xsl:if>
							<li class="ui-state-default ui-corner-top">
								<a href="#tabs-5"><xsl:value-of select="document/captions/additional/@caption"/></a>
							</li>
							<xsl:call-template name="docInfo"/>
						</ul>
						
							<form action="Provider" name="frm" method="post" id="frm" enctype="application/x-www-form-urlencoded">
								<div class="ui-tabs-panel" id="tabs-1">
									<br/>
									<table width="100%" border="0">
										<xsl:if test="document/fields/link/entry !=''">
											<tr>
												<td width="30%" class="fc"><xsl:value-of select="document/captions/projectdoc/@caption"/> :</td>
							            		<td>
													<a class="doclink" href="{document/fields/link/entry/@url}">
														<xsl:value-of select="document/fields/link/entry"/>
													</a>
				                           		</td>   					
											</tr>
										</xsl:if>	
										<!-- поле "Номер договора у контрагента" -->
										<tr>
											<td class="fc" style="padding-top:5px">
												<xsl:value-of select="document/captions/numcontractor/@caption"/> :
											</td>
											<td style="padding-top:5px">
												<input type="text" value="{document/fields/numcontractor}" name="numcontractor" class="td_editable" style="width:80px; vertical-align:top">
													<xsl:if test="$editmode != 'edit'">
														<xsl:attribute name="readonly">readonly</xsl:attribute>
														<xsl:attribute name="class">td_noteditable</xsl:attribute>
														<xsl:attribute name="onfocus">javascript:$(this).blur()</xsl:attribute>
													</xsl:if>
													<xsl:if test="$editmode = 'edit'">
														<xsl:attribute name="onfocus">fieldOnFocus(this)</xsl:attribute>
														<xsl:attribute name="onblur">fieldOnBlur(this)</xsl:attribute>
													</xsl:if>
												</input>
											</td>
										</tr>
										<!-- поле "Дата договора у контрагента" -->
										<tr>
											<td class="fc" style="padding-top:5px">
												<xsl:value-of select="document/captions/datecontractor/@caption"/> :
											</td>
											<td style="padding-top:5px">
												<input type="text" value="{substring(document/fields/datecontractor,1,10)}" name="datecontractor" readonly="readonly" onfocus="javascript:$(this).blur()" style="width:80px; vertical-align:top" class="td_editable">
													<xsl:if test="$editmode != 'edit'">
														<xsl:attribute name="readonly">readonly</xsl:attribute>
														<xsl:attribute name="class">td_noteditable</xsl:attribute>
														<xsl:attribute name="onfocus">javascript:$(this).blur()</xsl:attribute>
													</xsl:if>
													<xsl:if test="$editmode = 'edit'">
														<xsl:attribute name="id">datecontractor</xsl:attribute>
													</xsl:if>
												</input>
											</td>
										</tr>
										<!-- поле "Заказчик" -->
										<tr>
											<td class="fc" style="padding-top:5px">
												<font style="vertical-align:top">
													<xsl:value-of select="document/captions/customer/@caption"/> :
												</font>
												<xsl:if test="$editmode = 'edit'">
													<img src="/SharedResources/img/iconset/report_magnify.png" style="cursor:pointer">
														<xsl:attribute name="onclick">javascript:dialogBoxStructure('corrcat','false','contractor_one','frm', 'corresptbl');</xsl:attribute>
													</img>
												</xsl:if>
											</td>
											<td style="padding-top:5px">
												<table id="corresptbl" style="border-spacing:0px 3px; margin-top:-3px">
													<tr>
														<td style="width:600px;" class="td_editable">
															<xsl:if test="$editmode != 'edit'">
																<xsl:attribute name="class">td_noteditable</xsl:attribute>
															</xsl:if>
															<xsl:value-of select="document/fields/contractor_one"/>&#xA0;
															<span style='float:right; border-left:1px solid #ccc; width:17px; padding-right:10px; padding-left:2px; padding-top:1px; color:#ccc; font-size:10.5px'><font><xsl:value-of select="document/fields/corr/@attrval"/></font></span>
														</td>
													</tr>
												</table>
												<input type="hidden" value="{document/fields/contractor_one/@attrval}" id="contractor_one" name="contractor_one"/>
												<input type="hidden" value="{document/captions/customer/@caption} 1" id="contractor_onecaption"/>

											</td>
										</tr>
										<!-- поле "Исполнитель" -->
										<tr>
											<td class="fc" style="padding-top:5px">
												<font style="vertical-align:top">
													<xsl:value-of select="document/captions/performer/@caption"/> :
												</font>
												<xsl:if test="$editmode = 'edit'">
													<img src="/SharedResources/img/iconset/report_magnify.png" style="cursor:pointer">
														<xsl:attribute name="onclick">javascript:dialogBoxStructure('corrcat','false','contractor_two','frm', 'corresptbl_two');</xsl:attribute>
													</img>
												</xsl:if>
											</td>
											<td style="padding-top:5px">
												<table id="corresptbl_two" style="border-spacing:0px 3px; margin-top:-3px">
													<tr>
														<td style="width:600px;" class="td_editable">
															<xsl:if test="$editmode != 'edit'">
																<xsl:attribute name="class">td_noteditable</xsl:attribute>
															</xsl:if>
															<xsl:value-of select="document/fields/contractor_two"/>&#xA0;
															<span style='float:right; border-left:1px solid #ccc; width:17px; padding-right:10px; padding-left:2px; padding-top:1px; color:#ccc; font-size:10.5px'><font><xsl:value-of select="document/fields/corr/@attrval"/></font></span>
														</td>
													</tr>
												</table>
												<input type="hidden" value="{document/fields/contractor_two/@attrval}" id="contractor_two" name="contractor_two"/>
												<input type="hidden" value="{document/captions/performer/@caption} 2" id="contractor_twocaption"/>

											</td>
										</tr>
										<!-- поле "Предмет договора" -->
										<tr>
											<td class="fc" style="padding-top:5px">
												<xsl:value-of select="document/captions/contractsubject/@caption"/> :
											</td>
											<td style="padding-top:5px">
												<input type="text" value="{document/fields/contractsubject}" name="contractsubject" class="td_editable" style="width:400px;">
													<xsl:if test="$editmode != 'edit'">
														<xsl:attribute name="readonly">readonly</xsl:attribute>
														<xsl:attribute name="class">td_noteditable</xsl:attribute>
													</xsl:if>
													<xsl:if test="$editmode = 'edit'">
														<xsl:attribute name="onfocus">fieldOnFocus(this)</xsl:attribute>
														<xsl:attribute name="onblur">fieldOnBlur(this)</xsl:attribute>
													</xsl:if>
												</input>
											</td>
										</tr>
										<!-- поле "Договор заключен с" -->
										<tr>
											<td class="fc">
												<xsl:value-of select="document/captions/contractsignedwith/@caption"/> :
											</td>
											<td>
												<select size="1" name="contractsignedwith" style="width:611px;" class="select_editable">
													<xsl:if test="$editmode != 'edit'">
														<xsl:attribute name="class">select_noteditable</xsl:attribute>
														<xsl:attribute name="disabled"/>
													</xsl:if>
													<option value="supplier">
														<xsl:if test="document/fields/contractsignedwith = 'supplier'">
															<xsl:attribute name="selected">selected</xsl:attribute>
														</xsl:if>
														Поставщиком
													</option>
													<option value="contractor">
														<xsl:if test="document/fields/contractsignedwith = 'contractor'">
															<xsl:attribute name="selected">selected</xsl:attribute>
														</xsl:if>
														Подрядчиком
													</option>
													<option value="customer">
														<xsl:if test="document/fields/contractsignedwith = 'customer'">
															<xsl:attribute name="selected">selected</xsl:attribute>
														</xsl:if>
														Заказчиком
													</option>
												</select>
											</td>
										</tr>
										<!-- Куратор договора -->
										<tr>
											<td class="fc">
												<font style="vertical-align:top">
													<xsl:value-of select="document/captions/curator/@caption"/> :
												</font>
												<xsl:if test="$editmode = 'edit'">
													<a href="">
														<xsl:attribute name="href">javascript:dialogBoxStructure('bossandemppicklist','false','curator','frm', 'curatortbl');</xsl:attribute>
														<img src="/SharedResources/img/iconset/report_magnify.png"/>
													</a>
												</xsl:if>
											</td>
											<td>
												<table id="curatortbl">

														<tr>
															<!--<input id="tags"/>-->
															<td style="width:600px;" class="td_editable">
																<xsl:if test="$editmode != 'edit'">
																	<xsl:attribute name="class">td_noteditable</xsl:attribute>
																</xsl:if>
																<xsl:value-of select="document/fields/curator"/>&#xA0;
															</td>
														</tr>
												</table>
												<input type="hidden" id="curatorcaption" value="{document/captions/curator/@caption}"/>
												<input type="hidden" id="curator" name="curator" value="{document/fields/curator/@attrval}"/>
											</td>
										</tr>
										<!-- поле "Общая сумма договора" -->
										<tr>
											<td class="fc" style="padding-top:5px">
												<xsl:value-of select="document/captions/totalamount/@caption"/> :
											</td>
											<td style="padding-top:5px">
												<input type="text" value="{document/fields/totalamount}" name="totalamount" class="td_editable" style="width:150px;">
													<xsl:if test="$editmode != 'edit'">
														<xsl:attribute name="readonly">readonly</xsl:attribute>
														<xsl:attribute name="class">td_noteditable</xsl:attribute>
													</xsl:if>
													<xsl:if test="$editmode = 'edit'">
														<xsl:attribute name="onfocus">fieldOnFocus(this)</xsl:attribute>
														<xsl:attribute name="onblur">fieldOnBlur(this)</xsl:attribute>
													</xsl:if>
												</input>
											</td>
										</tr>
										<!-- поле "Срок действия договора" -->
									<tr>
										<td class="fc" style="padding-top:5px;position:relative;top:0px;">
											<xsl:value-of select="document/captions/contracttime/@caption"/> :
										</td>
										<td style="padding-top:5px">
											<input type="text" name="contracttime" maxlength="10" class="td_editable" style="width:80px; vertical-align:top" readonly="readonly" onfocus="javascript:$(this).blur()" value="{substring(document/fields/contracttime,1,10)}">
												<xsl:if test="$editmode = 'edit'">
													<xsl:attribute name="id">contracttime</xsl:attribute>
												</xsl:if>
												<xsl:if test="$editmode != 'edit'">
													<xsl:attribute name="class">td_noteditable</xsl:attribute>
												</xsl:if>
											</input>
											</td>
										</tr>
										<!-- поле "Срок исполнения договора" -->
									<tr>
										<td class="fc" style="padding-top:5px;position:relative;top:0px;">
											<xsl:value-of select="document/captions/controldate/@caption"/> :
										</td>
										<td style="padding-top:5px">
											<input type="text" name="controldate" maxlength="10" class="td_editable" style="width:80px; vertical-align:top" readonly="readonly" onfocus="javascript:$(this).blur()" value="{substring(document/fields/controldate,1,10)}">
												<xsl:if test="$editmode = 'edit'">
													<xsl:attribute name="id">controldate</xsl:attribute>
												</xsl:if>
												<xsl:if test="$editmode != 'edit'">
													<xsl:attribute name="class">td_noteditable</xsl:attribute>
												</xsl:if>
											</input>
											</td>
										</tr>
										<!-- поле "Комментарии" -->
										<tr>
											<td class="fc" style="padding-top:5px">
												<xsl:value-of select="document/captions/briefcontent/@caption"/> :
											</td>
											<td style="padding-top:5px">
												<textarea name="briefcontent" rows="3" class="textarea_editable" style="width:750px">
													<xsl:if test="$editmode != 'edit'">
														<xsl:attribute name="readonly">readonly</xsl:attribute>
														<xsl:attribute name="class">textarea_noteditable</xsl:attribute>
													</xsl:if>
													<xsl:if test="$editmode = 'edit'">
														<xsl:attribute name="onfocus">fieldOnFocus(this)</xsl:attribute>
														<xsl:attribute name="onblur">fieldOnBlur(this)</xsl:attribute>
													</xsl:if>
													<xsl:value-of select="document/fields/briefcontent"/>
												</textarea>
											</td>
										</tr>
										<!-- поле "КазСодержание(Ежемесячно)" -->
										<tr>
											<td class="fc" style="padding-top:5px">
												<xsl:value-of select="document/captions/kazcontent/@caption"/> :
											</td>
											<td style="padding-top:5px">
												<select size="1" name="kazcontent" style="width:611px;" class="select_editable">
													<xsl:if test="$editmode != 'edit'">
														<xsl:attribute name="class">select_noteditable</xsl:attribute>
														<xsl:attribute name="disabled"/>
													</xsl:if>
													<option value="month">
														<xsl:if test="document/fields/kazcontent = 'month'">
															<xsl:attribute name="selected">selected</xsl:attribute>
														</xsl:if>
														Ежемесячно
													</option>
													<option value="quarter">
														<xsl:if test="document/fields/kazcontent = 'quarter'">
															<xsl:attribute name="selected">selected</xsl:attribute>
														</xsl:if>
														Поквартально
													</option>
													<option value="onetime">
														<xsl:if test="document/fields/kazcontent = 'onetime'">
															<xsl:attribute name="selected">selected</xsl:attribute>
														</xsl:if>
														Единоразово
													</option>
													<option value="withoutkazcontent">
														<xsl:if test="document/fields/kazcontent = 'withoutkazcontent'">
															<xsl:attribute name="selected">selected</xsl:attribute>
														</xsl:if>
														Без казсодержания
													</option>
												</select>
											</td>
										</tr>
									</table>
								</div>
								<div id="tabs-2" style="height:500px">
									<br/>
									<table width="100%" border="0">
										<!-- поле "Содержание" -->
										<tr>
											<td class="fc"><xsl:value-of select="document/captions/content/@caption"/> :</td>
											<td>
												<xsl:if test="$editmode = 'edit'">
													<script type="text/javascript">  
														$(document).ready(function($) {
												    		 CKEDITOR.config.width = "815px"
												    		 CKEDITOR.config.height = "450px"
												    	});
													</script>
													<textarea id="MyTextarea" name="contentsource">
														<xsl:if test="@useragent = 'ANDROID'">
															<xsl:attribute name="style">width:500px; height:300px</xsl:attribute>
														</xsl:if>
														<xsl:value-of select="document/fields/contentsource"/>
													</textarea>
												</xsl:if>
												<xsl:if test="$editmode != 'edit'">
													<div id="briefcontent">
														<xsl:attribute name="style">width:815px; height:450px; background:#EEEEEE; padding: 3px 5px; overflow-x:auto</xsl:attribute>
														<script>
															$("#briefcontent").html("<xsl:value-of select='document/fields/contentsource'/>")
														</script>
													</div>
													<input type="hidden" name="contentsource" value="{document/fields/contentsource}"/>
												</xsl:if>
											</td>
										</tr>
										<tr>
											<td colspan="2">
											<div id="textprintpreview" style="display:none; overflow:visible">
												</div>
												<script>
													$("#textprintpreview").html("<xsl:value-of select='document/fields/contentsource'/>");
												</script>
											</td>
										</tr>
									</table>
								</div>
								<div id="tabs-3" style="height:500px">
									<xsl:if test="document/@status !='new'">
										<div display="block" style="display:block; width:95%" id="execution">
											<table style="width:100%">
												<tr>
													<td class="fc"><xsl:value-of select="document/captions/progress/@caption"/> :</td>
													<td>
														<font style="font-style:arial; font-size:13px">
															<b><xsl:value-of select="document/fields/title"/> № <xsl:value-of select="document/fields/dvn"/> - <xsl:value-of select="document/fields/briefcontent"/></b>
														</font>
														<table id="executionTbl" style="width:90%"/>
														<script>
															$.ajax({
																url: 'Provider?type=view&amp;id=docthread&amp;parentdocid=<xsl:value-of select="document/@docid"/>&amp;parentdoctype=<xsl:value-of select="document/@doctype"/>',
																datatype:'html',
																async:'true',
																success: function(data) {
																	$("#executionTbl").append(data)
																	$("#executionTbl a").css("font-size","12px")
																	$("#executionTbl tr").css("width","700px")
																}
															});
														</script>
													</td>
												</tr>
											</table>
											
											<br/>
										</div>
									</xsl:if>
								</div>
								<!-- Скрытые поля документа -->
								<input type="hidden" name="type" value="save"/>
								<input type="hidden" name="id" value="contract"/>
								<input type="hidden" name="author" value="{document/fields/author/@attrval}"/>
								<input type="hidden" name="allcontrol" value="{document/fields/allcontrol}"/>
								<input type="hidden" name="doctype" value="{document/@doctype}"/>
								<input type="hidden" name="key" value="{document/@docid}"/>
								<input type="hidden" name="parentdocid" value="{document/@parentdocid}"/>
								<input type="hidden" name="parentdoctype" value="{document/@parentdoctype}"/>
<!-- 								<xsl:call-template name="ECPsignFields"/> -->
								
							</form>
							<div id="tabs-4" style="height:500px">
								<form action="Uploader" name="upload" id="upload" method="post" enctype="multipart/form-data">
									<input type="hidden" name="type" value="rtfcontent"/>
									<input type="hidden" name="formsesid" value="{formsesid}"/>
									<!-- Секция "Вложения" -->
									<div display="block" id="att">
										<br/>
										<xsl:call-template name="attach"/>
									</div>
								</form>
							</div>
							<div id="tabs-5">
								<xsl:call-template name="docinfo"/>
							</div>
							<xsl:if test="document/fields/coordination">
								<div id="tabs-6">
										<div id='printCoordTitle' style="display:none; width:100%">Ход согласования документа: <br/><br/>
										 <b style='margin-left:50px;'><xsl:value-of select="document/fields/title"/></b><br/>
										 <font style='margin-left:50px'>Краткое содержание: </font><b><xsl:value-of select="document/fields/briefcontent"/></b>
										 </div>
										 <button id="printcoord" title="Печать согласования" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only"  style="margin-right:5px" autocomplete="off">
											<xsl:attribute name="onclick">javascript:PrintCoord()</xsl:attribute>
											<span>
												<img src="/SharedResources/img/iconset/printer.png" class="button_img"/>
												<font class="button_text">Печать согласования</font>
											</span>
										</button>
										<br/>
										<br/>
										<table id="coordTableView" style="border-collapse:collapse; margin-left:3px; width:100%" class="table-border-gray">
											<tr style="text-align:center;">
												<td width="2%">№</td>
												<td width="10%">
													<xsl:value-of select="$captions/type/@caption"/>
												</td>
												<td width="61%">
													<xsl:value-of select="$captions/contributors/@caption"/>
												</td>
												<td width="9%">
													<xsl:value-of select="$captions/waittime/@caption"/>
												</td>
												<td width="10%">
													<xsl:value-of select="$captions/statuscoord/@caption"/>
												</td>
											</tr>
											<xsl:for-each select="$fields/coordination/blocks/entry">
													<tr class="trblockCoord">
														<td style="text-align:center; border-bottom: 1px solid lightgray">
															<xsl:value-of select="position()"/>
															<xsl:for-each select="coordinators/entry">
																<br/>
															</xsl:for-each>
														</td>
														<td style="border-bottom: 1px solid lightgray; text-align:center">
															<xsl:choose>
																<xsl:when test="type = 'PARALLEL_COORDINATION'">
																	<xsl:value-of select="$captions/parcoord/@caption"/>
																</xsl:when>
																<xsl:when test="type = 'SERIAL_COORDINATION'">
																	<xsl:value-of select="$captions/sercoord/@caption"/>
																</xsl:when>
																<xsl:when test="type = 'TO_SIGN'">
																	<xsl:value-of select="$captions/tosign/@caption"/>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:value-of select="$captions/typenotdefined/@caption"/>
																</xsl:otherwise>
															</xsl:choose>
															<xsl:for-each select="coordinators/entry">
																<br/>
															</xsl:for-each>
														</td>
														<td style="border-bottom: 1px solid lightgray">
															<table style="width:100%">
																<xsl:for-each select="coordinators/entry">
																	<tr>
																		<td style="border:none; padding:5px 0px !important; vertical-align:top">
																			<xsl:value-of select="employer/fullname"/>
																			<p style="margin:0px">
																				<xsl:choose>
																					<xsl:when test="decision='AGREE'">
																						<xsl:value-of select="concat(decisiondate,' ')"/>
																						<b><xsl:value-of select="$captions/agree/@caption"/></b>
																					</xsl:when>
																					<xsl:when test="decision='DISAGREE'">
																						<xsl:value-of select="concat(decisiondate,' ')"/>
																						<b><xsl:value-of select="$captions/disagree/@caption"/></b>
																					</xsl:when>
																					<xsl:when test="iscurrent='true'">
																						<xsl:value-of select="$captions/awairesponse/@caption"/>
																					</xsl:when>
																				</xsl:choose>
																			</p>
																			<div class="coord_comment_box close">
																				<div class='coord_comment_txt' style="font-style:italic">
																					<xsl:choose>
																						<xsl:when test="comment = 'null'">
																						</xsl:when>
																						<xsl:when test="string-length(comment)!= 0">
			                                                                                 комментарий: <xsl:value-of select="comment"/>
																						</xsl:when>
																					</xsl:choose>
																				</div>
																			</div>
																		</td>
																	</tr>
																</xsl:for-each>
															</table>
														</td>
														<td style="border-bottom: 1px solid lightgray; text-align:center">
															<xsl:choose>
																<xsl:when test="delaytime = 0">
																	<xsl:value-of select="$captions/unlimtimecoord/@caption"/>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:value-of select="delaytime"/>
																</xsl:otherwise>
															</xsl:choose>
															<xsl:for-each select="coordinators/entry">
																<br/>
															</xsl:for-each>
														</td>
														<td style="border-bottom: 1px solid lightgray; text-align:center">
															<xsl:if test="type !='TO_SIGN'">
																<xsl:choose>
																	<xsl:when test="status ='COORDINATING'">
																		<xsl:value-of select="$captions/oncoordinating/@caption"/>
																	</xsl:when>
																	<xsl:when test="status ='COORDINATED'">
																		<xsl:value-of select="$captions/complete/@caption"/>
																	</xsl:when>
																	<xsl:when test="status ='AWAITING'">
																		<xsl:value-of select="$captions/expectbegincoord/@caption"/>
																	</xsl:when>
																	<xsl:when test="status ='EXPIRED'">
																		<xsl:value-of select="$captions/prosrochen/@caption"/>
																	</xsl:when>
																	<xsl:when test="status ='UNDEFINED'">
																		<xsl:value-of select="$captions/undefined/@caption"/>
																	</xsl:when>
																	<xsl:otherwise>
																		<xsl:value-of select="$captions/undefined/@caption"/>
																	</xsl:otherwise>
																</xsl:choose>
															</xsl:if>
															<xsl:if test="type ='TO_SIGN'">
																<xsl:choose>
																	<xsl:when test="$fields/coordination/status = 'SIGNING'">
																		<xsl:value-of select="$captions/waitingsign/@caption"/>
																	</xsl:when>
																	<xsl:when test="$fields/coordination/status = 'SIGNED'">
																		<xsl:value-of select="$captions/signed/@caption"/>
																	</xsl:when>
																	<xsl:when test="$fields/coordination/status = 'REJECTED'">
																		<xsl:value-of select="$captions/rejected/@caption"/>
																	</xsl:when>
																</xsl:choose>
															</xsl:if>
															<xsl:for-each select="coordinators/entry">
																<br/>
																<input type="hidden" value="{employer/userid}" class="{employer/userid}"/>
															</xsl:for-each>
															<xsl:if test="type !='TO_SIGN'">
																<input type="hidden" name="coordblock">
																	<xsl:attribute name="value"><xsl:value-of select="id"/>`<xsl:choose><xsl:when test="type='PARALLEL_COORDINATION'">par</xsl:when><xsl:when
																		test="type='SERIAL_COORDINATION'">ser</xsl:when></xsl:choose>`<xsl:value-of
																		select="delaytime" />`<xsl:for-each select="coordinators/entry"><xsl:value-of
																		select="employer/userid"/><xsl:if test="following-sibling::*">^</xsl:if></xsl:for-each>`<xsl:value-of
																		select="status"/></xsl:attribute>
																</input>
															</xsl:if>
														</td>
													</tr>
											</xsl:for-each>
										</table>
										<br/>
									</div>
								</xsl:if>
						</div>
						<div style="height:10px"/>
					</div>
				</div>
				<xsl:call-template name="formoutline"/>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>