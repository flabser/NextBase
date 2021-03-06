<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../templates/form.xsl"/>
	<xsl:import href="../templates/sharedactions.xsl"/>
	<xsl:variable name="doctype" select="request/document/captions/doctypemultilang/@caption"/>
	<xsl:variable name="path" select="/request/@skin" />
	<xsl:variable name="threaddocid" select="document/@docid"/>
	<xsl:output method="html" encoding="utf-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" indent="yes"/>
	<xsl:variable name="skin" select="request/@skin"/>
	<xsl:variable name="editmode" select="/request/document/@editmode"/>
	<xsl:template match="/request">
		<html>
			<head>
				<title>
					<xsl:if test="document/@status != 'new'">
						<xsl:value-of select="document/@viewtext"/> - Workflow документооборот
					</xsl:if>
					<xsl:if test="document/@status = 'new'">
						Новый <xsl:value-of select="lower-case($doctype)"/> - Workflow документооборот
					</xsl:if>
				</title>
				<xsl:call-template name="cssandjs"/>
				<xsl:call-template name="markisread"/>
				<xsl:call-template name="htmlareaeditor"/>
				<xsl:call-template name="keypressactions"/>
				<xsl:if test="document/@editmode = 'edit'">
					<script>
						$(function() {
							$('#ctrldate').datepicker({
								showOn: 'button',
								buttonImage: '/SharedResources/img/iconset/calendar.png',
								buttonImageOnly: true,
								regional:['ru'],
								showAnim: ''
							});
							$('#din').datepicker({
								showOn: 'button',
								buttonImage: '/SharedResources/img/iconset/calendar.png',
								buttonImageOnly: true,
								regional:['ru'],
								showAnim: ''
							});
						});
					</script>
				</xsl:if>
			</head>
			<body>
				<xsl:variable name="status" select="@status"/>
				<div id="docwrapper">
					<xsl:call-template name="documentheader"/>	
					<div class="formwrapper">
						<div class="formtitle">
							<div style="float:left" class="title">
								<xsl:call-template name="doctitle"/>
							</div>
							<div style="float:right; padding-left:5px">
							</div>
						</div>
						<div class="button_panel">
							<span style="width:80%; vertical-align:12px; float:left">
								<xsl:call-template name="showxml"/>
								<xsl:call-template name="save"/>
								<xsl:call-template name="acquaint"/>
								<xsl:if test="document/@status !='new'">
									<button class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
										<xsl:attribute name="onclick">javascript:window.location.href="Provider?type=document&amp;id=comment&amp;key=&amp;parentdocid=<xsl:value-of select="document/@docid"/>&amp;parentdoctype=<xsl:value-of select="document/@doctype"/>"</xsl:attribute>
										<span>
											<img src="/SharedResources/img/classic/icons/comment_add.png" class="button_img"/>
											<font style="font-size:12px; vertical-align:top">Комментарий</font>
										</span>
									</button>
								</xsl:if>
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
									<a href="#tabs-4"><xsl:value-of select="document/captions/files/@caption"/></a>
								</li>
								<li class="ui-state-default ui-corner-top">
									<a href="#tabs-5"><xsl:value-of select="document/captions/additional/@caption"/></a>
								</li>
							</ul>
							<form action="Provider" name="frm" method="post" id="frm" enctype="application/x-www-form-urlencoded">
								<div class="ui-tabs-panel" id="tabs-1">
									<br/>
									<table width="100%" border="0">
										<!-- Автор резолюции -->
										<tr>
											<td class="fc" style="padding-top:3px">
												<font style="vertical-align:top">
													Автор :
												</font>
												<!-- Должно редактироваться поле или нет хз... ну пока выключим -->
												<xsl:if test="$editmode = 'edit3'">
													<a>
														<xsl:attribute name="href">javascript:dialogBoxStructure('bossandemppicklist','false','taskauthor','frm','taskauthortbl');</xsl:attribute>
														<img src="/SharedResources/img/iconset/report_magnify.png"/>
													</a>
												</xsl:if>
											</td>
											<td style="padding-top:3px">
												<table id="taskauthortbl">
													<tr>
														<td style="width:600px" class="td_editable" value="{document/fields/author}">
															<xsl:if test="$editmode != 'edit'">
																<xsl:attribute name="class">td_noteditable</xsl:attribute>
															</xsl:if>
															<xsl:value-of select="document/captions/author/@caption"/>&#xA0;
															<!-- <input id="taskauthor"  style="width:600px" class="td_editable" value="{document/fields/taskauthor}">
																<xsl:if test="$editmode != 'edit'">
																	<xsl:attribute name="class">td_noteditable</xsl:attribute>
																</xsl:if>
															</input> -->
														</td>
													</tr>
												</table>
												<input type="hidden" id="author" name="taskauthor" value="{document/fields/author/@attrval}"/>
												<input type="hidden" id="authoraption" value="{document/fields/author/@caption}"/>
											</td>
										</tr>
										<!-- поле "Тема" -->
										<tr>
											<td class="fc" style="padding-top:5px">
												Тема :
											</td>
											<td style="padding-top:5px">
												<input type="text" value="{document/fields/theme}" name="theme" class="td_editable" style="width:500px;">
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
										<!-- Дата -->
										<tr>
											<td class="fc">
												Дата регистрации :
											</td>
											<td>
												<table>
													<tr>
														<td style="width:170px;" class="td_noteditable">
															<xsl:value-of select="document/captions/dvn/@caption"/>
														</td>
													</tr>
												</table>
												<input type="hidden" name="dvn" value="{document/fields/dvn}"/>
											</td>
										</tr>
										<!-- поле "Статус" -->
										<tr>
											<td class="fc" style="padding-top:5px">
												Статус :
											</td>
											<td style="padding-top:5px">
												<input type="text" value="{document/fields/status}" name="status" class="td_editable" style="width:500px;">
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
										<!-- поле "Содержание" -->
										<tr>
											<td class="fc" style="padding-top:5px">
												<xsl:value-of select="document/captions/content/@caption"/> :
											</td>
											<td style="padding-top:5px">
												<xsl:if test="$editmode != 'edit'">
													<div id="htmlcodenoteditable" class="textarea_noteditable" style="width:760px; height:500px">
													</div>
													<script>
														$("#htmlcodenoteditable").html('<xsl:value-of select="document/fields/remark"/>');
													</script>
												</xsl:if>
												<xsl:if test="$editmode = 'edit'">
													<textarea id="txtDefaultHtmlArea" name="contentsource" cols="90" rows="25">
														<xsl:attribute name="onfocus">javascript: $(this).blur()</xsl:attribute>
														<xsl:attribute name="class">textarea_noteditable</xsl:attribute>
														<xsl:value-of select="document/captions/content/@caption"/>
													</textarea>
													<script>
														$("#txtDefaultHtmlArea").width("765px");
														$("#txtDefaultHtmlArea").height("500px");
													</script>
												</xsl:if>
											</td>
										</tr>
									</table>
								</div>
								<!-- Скрытые поля документа -->
								<input type="hidden" name="type" value="save"/>
								<input type="hidden" name="id" value="discussion"/>
								<input type="hidden" name="author" value="{document/fields/author/@attrval}"/>
								<input type="hidden" name="doctype" value="{document/@doctype}"/>
								<input type="hidden" name="key" value="{document/@docid}"/>
								<input type="hidden" name="parentdocid" value="{document/@parentdocid}"/>
								<input type="hidden" name="parentdoctype" value="{document/@parentdoctype}"/>
								<xsl:call-template name="ECPsignFields"/>
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
						</div>
						<div style="height:10px"/>
					</div>
				</div>
				<xsl:call-template name="formoutline"/>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>