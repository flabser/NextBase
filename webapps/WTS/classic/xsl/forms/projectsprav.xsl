<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../templates/form.xsl"/>
	<xsl:import href="../templates/sharedactions.xsl"/>
	<xsl:variable name="doctype" select="request/document/captions/name/@caption"/>
	<xsl:variable name="editmode" select="/request/document/@editmode"/>
	<xsl:variable name="threaddocid" select="document/@docid"/>
	<xsl:output method="html" encoding="utf-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" indent="yes" />
	<xsl:variable name="skin" select="request/@skin"/>
	<xsl:template match="/request">
		<html>
			<head>
				<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
				<title><xsl:value-of select="$doctype"/> - Web Technical Supervision</title>
				<xsl:call-template name="cssandjs"/>
				<script type="text/javascript">
					$(function(){
						$("#code").tipTip({'activation':'click', "field" : "code", "defaultPosition": "right","content":"Поле может содержать только числовые значения"} );
					});
					<xsl:call-template name="hotkeys_glossary_form"/>
				</script>
			</head>
			<body>
				<xsl:variable name="status" select="@status"/>
				<div id="docwrapper">
					<xsl:call-template name="documentheader"/>	
					<div class="formwrapper">
						<div class="formtitle">
							<div class="title">
								<xsl:call-template name="doctitleGlossary"/>
							</div>
						</div>
						<div class="button_panel">
							<span style="float:left">
								<xsl:call-template name="showxml"/>
								<button class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" title="Сохранить и закрыть" id="btnsavedoc">
									<xsl:attribute name="onclick">javascript:SaveFormJquery('frm','frm',&quot;<xsl:value-of select="history/entry[@type='outline'][last()]"/>&quot;)</xsl:attribute>
									<span>
										<img src="/SharedResources/img/classic/icons/disk.png" class="button_img"/>
										<font style="font-size:12px; vertical-align:top"><xsl:value-of select="document/captions/saveclose/@caption"/></font>
									</span>
								</button>
							</span>
							<span style="float:right; margin-right:5px">
								<xsl:call-template name="cancel"/>
							</span>
						</div>
						<div style="clear:both"/>
						<div
							style="-moz-border-radius:0px;height:1px; width:100%; margin-top:10px;"/>
						<div style="clear:both"/>
						<div id="tabs">
							<ul class="ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-all">
								<li class="ui-state-default ui-corner-top">
									<a href="#tabs-1">
										<xsl:value-of select="document/captions/properties/@caption"/>
									</a>
								</li>
							</ul>
							<div class="ui-tabs-panel" id="tabs-1">
								<form action="Provider" name="frm" method="post" id="frm"
									enctype="application/x-www-form-urlencoded">
									<div display="block" id="property">
										<br/>
										<table width="80%" border="0">
											<tr>
												<td width="30%" class="fc"><xsl:value-of select="document/captions/name/@caption"/> :</td>
												<td>
													<input type="text" name="name" value="{document/fields/name}" size="30" class="td_editable" style="width:500px">
														<xsl:if test="$editmode != 'edit'">
															<xsl:attribute name="class">td_noteditable</xsl:attribute>
															<xsl:attribute name="readonly">readonly</xsl:attribute>
														</xsl:if>
													</input>
												</td>
											</tr>
											<tr>
												<td class="fc"><xsl:value-of select="document/captions/code/@caption"/> :</td>
												<td>
													<input type="text" name="code" id="code" size="10" value="{document/fields/code}" class="td_editable" style="width:300px">
														<xsl:if test="$editmode != 'edit'">
															<xsl:attribute name="class">td_noteditable</xsl:attribute>
															<xsl:attribute name="readonly">readonly</xsl:attribute>
														</xsl:if>
														<xsl:attribute name="onkeydown">javascript:numericfield(this)</xsl:attribute>
													</input>
												</td>
											</tr>
											<tr>
												<td class="fc"><xsl:value-of select="document/captions/prefix/@caption"/> :</td>
												<td>
													<input type="text" name="prefix" id="prefix" size="10" value="{document/fields/prefix}" class="td_editable" style="width:300px">
														<xsl:if test="$editmode != 'edit'">
															<xsl:attribute name="class">td_noteditable</xsl:attribute>
															<xsl:attribute name="readonly">readonly</xsl:attribute>
														</xsl:if>
													</input>
												</td>
											</tr>
											<tr>
												<td class="fc">
													<font style="vertical-align:top">
														<xsl:value-of select="document/captions/rukproject/@caption"/> : 
													</font>
													<xsl:if test="$editmode = 'edit'">
														<a href="">
															<xsl:attribute name="href">javascript:dialogBoxStructure('structurefullpicklist','false','projectmanager','frm', 'projectmanagertbl');</xsl:attribute>								
															<img src="/SharedResources/img/iconset/report_magnify.png"/>	
														</a>
													</xsl:if>
												</td>
												<td>
													<table id="projectmanagertbl" style="border-spacing:0px 3px;">
														<tr>
															<td class="td_editable" style="width:500px;">
																<xsl:if test="$editmode != 'edit'">
																	<xsl:attribute name="class">td_noteditable</xsl:attribute>
																</xsl:if>
																<xsl:value-of select="document/fields/projectmanager"/>&#xA0;
															</td>
														</tr>
													</table>
													<input type="hidden" id="projectmanager" name="projectmanager" value="{document/fields/projectmanager/@attrval}"/>
													<input type="hidden" id="projectmanagercaption" value="Руководитель проекта"/>
												</td>
											</tr>
											<tr>
												<td class="fc">
													<font style="vertical-align:top">
														<xsl:value-of select="document/captions/zamrukproject/@caption"/> : 
													</font>
													<xsl:if test="$editmode = 'edit'">
														<a href="">
															<xsl:attribute name="href">javascript:dialogBoxStructure('structurefullpicklist','false','zamprojectmanager','frm', 'zamprojectmanagertbl');</xsl:attribute>								
															<img src="/SharedResources/img/iconset/report_magnify.png"/>	
														</a>
													</xsl:if>
												</td>
												<td>
													<table id="zamprojectmanagertbl" style="border-spacing:0px 3px;">
														<tr>
															<td class="td_editable" style="width:500px;">
																<xsl:if test="$editmode != 'edit'">
																	<xsl:attribute name="class">td_noteditable</xsl:attribute>
																</xsl:if>
																<xsl:value-of select="document/fields/zamprojectmanager"/>&#xA0;
															</td>
														</tr>
													</table>
													<input type="hidden" id="zamprojectmanager" name="zamprojectmanager" value="{document/fields/zamprojectmanager/@attrval}"/>
													<input type="hidden" id="zamprojectmanagercaption" value="Заместитель руководителя проекта"/>
												</td>
											</tr>
											<tr>
												<td class="fc">
													<font style="vertical-align:top">
														<xsl:value-of select="document/captions/tehnadzor/@caption"/> : 
													</font>
													<xsl:if test="$editmode = 'edit'">
														<a href="">
															<xsl:attribute name="href">javascript:addSupervisor('tech_supervisor','true','techsupervision','frm', 'techsupervisiontbl');</xsl:attribute>								
															<img src="/SharedResources/img/iconset/report_magnify.png"/>	
														</a>
													</xsl:if>
												</td>
												<td>
													<table id="techsupervisiontbl" style="border-spacing:0px 3px;">
														<xsl:if test="document/fields/techsupervision/@islist"> 
															<xsl:for-each select="document/fields/techsupervision/entry">
																<tr>
																	<td class="td_editable" style="width:500px;">
																		<xsl:if test="$editmode != 'edit'">
																			<xsl:attribute name="class">td_noteditable</xsl:attribute>
																		</xsl:if>
																		<xsl:value-of select="."/>
																		<img onclick="removeTableElement(this)" src="/SharedResources/img/iconset/cross.png" style="width:15px; height:15px; margin-right:3px; margin-top:1px; float:right; cursor:pointer"/>&#xA0;
																		<input type="hidden" id="techsupervision" name="techsupervision" value="{@attrval}"/>
																	</td>
																</tr>
															</xsl:for-each>
														</xsl:if>
														<xsl:if test="not(document/fields/techsupervision/@islist)"> 
															<tr>
																<td class="td_editable" style="width:500px;">
																	<xsl:if test="$editmode != 'edit'">
																		<xsl:attribute name="class">td_noteditable</xsl:attribute>
																	</xsl:if>
																	<xsl:value-of select="document/fields/techsupervision"/><img onclick="removeTableElement(this)" src="/SharedResources/img/iconset/cross.png" style="width:15px; height:15px; margin-right:3px; margin-top:1px; float:right; cursor:pointer"/>&#xA0;
																	<input type="hidden" id="techsupervision" name="techsupervision" value="{document/fields/techsupervision/@attrval}"/>
																</td>
															</tr>
														</xsl:if>
													</table>
													<input type="hidden" id="techsupervisioncaption" value="Технический надзор"/>
												</td>
											</tr>
										</table>
									</div>
									<input type="hidden" name="type" value="save"/>
									<input type="hidden" name="id" value="projectsprav"/>
									<input type="hidden" name="key" value="{document/@docid}"/>
								</form>
								<form action="Uploader" name="upload" id="upload" method="post" enctype="multipart/form-data">
									<input type="hidden" name="type" value="rtfcontent"/>
									
									<input type="hidden" name="formsesid" value="{formsesid}"/>
									<xsl:call-template name="attach"/>
								</form>
							</div>
						</div>
						<div style="height:10px"/>
					</div>
				</div>
				<xsl:call-template name="outline_form"/>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>