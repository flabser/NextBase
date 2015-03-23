<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:import href="../templates/form.xsl" />
	<xsl:import href="../templates/attach-cert.xsl" />
	<xsl:import href="../layout.xsl" />

	<xsl:output method="html" encoding="utf-8" indent="no" />
	<xsl:variable name="editmode" select="/request/document/@editmode" />
	<xsl:variable name="doctype" select="request/document/captions/doctypemultilang/@caption" />

	<xsl:template match="/request">
		<xsl:call-template name="layout">
			<xsl:with-param name="w_title" select="concat('Сотрудник: ', document/fields/fullname)" />
			<xsl:with-param name="active_aside_id" select="document/fields/cash" />
			<xsl:with-param name="aside_collapse" select="'aside_collapse'" />
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="_content">
		<header class="form-header">
			<h3 class="doc-title">
				<xsl:value-of select="concat(document/captions/employer/@caption, ' - ', document/fields/fullname)" />
			</h3>
			<xsl:apply-templates select="//actionbar">
				<xsl:with-param name="fixed_top" select="''" />
			</xsl:apply-templates>
		</header>
		<section class="form-content">
			<div id="tabs">
				<ul class="ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-all">
					<li class="ui-state-default ui-corner-top">
						<a href="#tabs-1">
							<xsl:value-of select="document/captions/properties/@caption" />
						</a>
					</li>
					<li class="ui-state-default ui-corner-top">
						<a href="#tabs-2">
							<xsl:value-of select="document/captions/interface/@caption" />
						</a>
					</li>
					<li class="ui-state-default ui-corner-top">
						<a href="#tabs-3">
							<xsl:value-of select="document/captions/attachments_cert/@caption" />
						</a>
					</li>
				</ul>
				<form action="Provider" name="frm" method="post" id="userProfile" enctype="application/x-www-form-urlencoded">
					<div class="ui-tabs-panel" id="tabs-1">
						<fieldset name="property" class="fieldset">
							<xsl:if test="document/@editmode != 'edit'">
								<xsl:attribute name="disabled">disabled</xsl:attribute>
							</xsl:if>

							<div class="fieldset-container">
								<div class="control-group">
									<div class="control-label">
										<xsl:value-of select="document/captions/department/@caption" />
									</div>
									<div class="controls">
										<xsl:if test="document/fields/department != '0'">
											<xsl:value-of select="document/fields/department" />
										</xsl:if>
									</div>
								</div>
								<div class="control-group">
									<div class="control-label">
										<xsl:value-of select="document/captions/postid/@caption" />
									</div>
									<div class="controls">
										<xsl:value-of select="document/fields/post" />
									</div>
								</div>
								<div class="control-group">
									<div class="control-label">
										<xsl:value-of select="document/captions/shortname/@caption" />
									</div>
									<div class="controls">
										<xsl:value-of select="document/fields/shortname" />
									</div>
								</div>
								<div class="control-group">
									<div class="control-label">
										<xsl:value-of select="document/captions/fullname/@caption" />
									</div>
									<div class="controls">
										<xsl:value-of select="document/fields/fullname" />
									</div>
								</div>
								<div class="control-group">
									<div class="control-label">
										ID
									</div>
									<div class="controls">
										<input type="text" name="userid" value="{document/fields/userid}" class="span4" />
									</div>
								</div>
								<div class="control-group">
									<div class="control-label">
										<xsl:value-of select="document/captions/oldpassword/@caption" />
									</div>
									<div class="controls">
										<input name="oldpwd" type="password" class="span4" autocomplete="off" />
									</div>
								</div>
								<div class="control-group">
									<div class="control-label">
										<xsl:value-of select="document/captions/newpassword/@caption" />
									</div>
									<div class="controls">
										<input name="pwd" type="password" class="span4" autocomplete="off" />
									</div>
								</div>
								<div class="control-group">
									<div class="control-label">
										<xsl:value-of select="document/captions/repeatnewpassword/@caption" />
									</div>
									<div class="controls">
										<input name="pwd2" type="password" class="span4" autocomplete="off" />
									</div>
								</div>
								<div class="control-group">
									<div class="control-label">
										Instant Messenger address
									</div>
									<div class="controls">
										<div class="span4">
											<div style="float:left;width:80%">
												<input type="text" name="instmsgaddress" value="{document/fields/instmsgaddress}" style="width:100%" />
											</div>
											<xsl:choose>
												<xsl:when test="document/fields/instmsgstatus = 'false'">
													<img src="/SharedResources/img/iconset/bullet_red.png" title="Instant Messenger off" />
												</xsl:when>
												<xsl:when test="document/fields/instmsgstatus = 'true'">
													<img src="/SharedResources/img/iconset/bullet_gren.png" title="Instant Messenger on" />
												</xsl:when>
												<xsl:otherwise>
													<img src="/SharedResources/img/iconset/bullet_red.png" title="Instant Messenger off" />
												</xsl:otherwise>
											</xsl:choose>
										</div>
									</div>
								</div>
								<div class="control-group">
									<div class="control-label">
										E-mail
									</div>
									<div class="controls">
										<input name="email" type="text" class="span4" value="{document/fields/email}" />
									</div>
								</div>
								<div class="control-group">
									<div class="control-label">
										<xsl:value-of select="document/captions/role/@caption" />
									</div>
									<div class="controls">
										<table>
											<xsl:for-each select="document/fields/role[not(entry)]">
												<xsl:variable name="role" select="." />
												<xsl:if test="/request/document/glossaries/roles/entry[ison='ON'][name = $role]">
													<tr>
														<td style="width:500px;" class="td_noteditable">
															<xsl:if test="../../../../document/@editmode != 'edit'">
																<xsl:attribute name="class">td_noteditable</xsl:attribute>
															</xsl:if>
															<xsl:value-of select="." />

															<xsl:if test="/request/document/glossaries/roles/entry[ison='ON'][name = $role]">
																<input type="hidden" name="role" value="{.}" />
															</xsl:if>
														</td>
													</tr>
												</xsl:if>
											</xsl:for-each>
											<xsl:for-each select="document/fields/role/entry">
												<xsl:variable name="role" select="." />
												<xsl:if test="/request/document/glossaries/roles/entry[ison='ON'][name = $role]">
													<tr>
														<td style="width:500px;" class="td_noteditable">
															<xsl:if test="../../../../document/@editmode != 'edit'">
																<xsl:attribute name="class">td_noteditable</xsl:attribute>
															</xsl:if>
															<xsl:value-of select="." />

															<xsl:if test="/request/document/glossaries/roles/entry[ison='ON'][name = $role]">
																<input type="hidden" name="role" value="{.}" />
															</xsl:if>
														</td>
													</tr>
												</xsl:if>
											</xsl:for-each>
										</table>
									</div>
								</div>
								<div class="control-group">
									<div class="control-label">
										<xsl:value-of select="document/captions/group/@caption" />
									</div>
									<div class="controls">
										<table>
											<xsl:for-each select="document/fields/group/entry">
												<tr>
													<td style="width:500px" class="td_noteditable">
														<xsl:if test="../../../../document/@editmode != 'edit'">
															<xsl:attribute name="class">td_noteditable</xsl:attribute>
														</xsl:if>
														<xsl:value-of select="." />
													</td>
												</tr>
											</xsl:for-each>
										</table>
									</div>
								</div>
							</div>
						</fieldset>
					</div>
					<div id="tabs-2">
						<fieldset name="interface" class="fieldset">
							<xsl:if test="document/@editmode != 'edit'">
								<xsl:attribute name="disabled">disabled</xsl:attribute>
							</xsl:if>

							<div class="fieldset-container">
								<div class="control-group">
									<div class="control-label">
										<xsl:value-of select="document/captions/countdocinview/@caption" />
									</div>
									<div class="controls">
										<select name="pagesize" class="span2">
											<option value="10">
												<xsl:if test="document/fields/countdocinview = '10'">
													<xsl:attribute name="selected">selected</xsl:attribute>
												</xsl:if>
												10
											</option>
											<option value="20">
												<xsl:if test="document/fields/countdocinview = '20'">
													<xsl:attribute name="selected">selected</xsl:attribute>
												</xsl:if>
												20
											</option>
											<option value="30">
												<xsl:if test="document/fields/countdocinview = '30'">
													<xsl:attribute name="selected">selected</xsl:attribute>
												</xsl:if>
												30
											</option>
											<option value="50">
												<xsl:if test="document/fields/countdocinview = '50'">
													<xsl:attribute name="selected">selected</xsl:attribute>
												</xsl:if>
												50
											</option>
										</select>
									</div>
								</div>
								<div class="control-group">
									<div class="control-label">
										<xsl:value-of select="document/captions/refreshperiod/@caption" />
									</div>
									<div class="controls">
										<select name="refresh" class="span2">
											<option value="3">
												<xsl:value-of select="concat('3 ', document/captions/min/@caption, '.')" />
											</option>
											<option value="5">
												<xsl:value-of select="concat('5 ', document/captions/min/@caption, '.')" />
											</option>
											<option value="10">
												<xsl:value-of select="concat('10 ', document/captions/min/@caption, '.')" />
											</option>
											<option value="15">
												<xsl:value-of select="concat('15 ', document/captions/min/@caption, '.')" />
											</option>
											<option value="20">
												<xsl:value-of select="concat('20 ', document/captions/min/@caption, '.')" />
											</option>
											<option value="30">
												<xsl:value-of select="concat('30 ', document/captions/min/@caption, '.')" />
											</option>
										</select>
									</div>
								</div>
								<div class="control-group">
									<div class="control-label">
										<xsl:value-of select="document/captions/lang/@caption" />
									</div>
									<div class="controls">
										<select name="lang" class="span3">
											<xsl:variable name='chinese' select="document/captions/chinese/@caption" />
											<xsl:variable name='currentlang' select="../@lang" />
											<xsl:for-each select="document/glossaries/langs/entry">
												<option id="{id}" value="{id}">
													<xsl:if test="$currentlang = id">
														<xsl:attribute name="selected">selected</xsl:attribute>
													</xsl:if>
													<xsl:if test="id = 'CHN'">
														<xsl:value-of select="$chinese" />
													</xsl:if>
													<xsl:if test="id != 'CHN'">
														<xsl:value-of select="name" />
													</xsl:if>
												</option>
											</xsl:for-each>
										</select>
									</div>
								</div>
								<div class="control-group">
									<div class="control-label">
										<xsl:value-of select="document/captions/skin/@caption" />
									</div>
									<div class="controls">
										<select name="skin" class="span3">
											<xsl:variable name='currentskin' select="document/fields/skin" />
											<xsl:for-each select="document/glossaries/skins/entry">
												<option value="{id}">
													<xsl:if test="$currentskin = id">
														<xsl:attribute name="selected">selected</xsl:attribute>
													</xsl:if>
													<xsl:value-of select="name" />
												</option>
											</xsl:for-each>
										</select>
									</div>
								</div>
							</div>
						</fieldset>
					</div>
					<input type="hidden" name="id" value="userprofile" />
				</form>
				<div id="tabs-3">
					<form action="Uploader" name="upload" id="upload" method="post" enctype="multipart/form-data">
						<fieldset class="fieldset" disabled="disabled">
							<input type="hidden" name="type" value="rtfcontent" />
							<input type="hidden" name="formsesid" value="{formsesid}" />
							<xsl:call-template name="attach_cert" />
						</fieldset>
					</form>
				</div>
			</div>
		</section>
	</xsl:template>

</xsl:stylesheet>
