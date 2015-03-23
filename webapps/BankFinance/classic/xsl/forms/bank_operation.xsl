<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:import href="../templates/form.xsl" />
	<xsl:import href="../templates/doc-info.xsl" />
	<xsl:import href="../templates/attach.xsl" />
	<xsl:import href="../layout.xsl" />

	<xsl:output method="html" encoding="utf-8" indent="no" />
	<xsl:variable name="editmode" select="/request/document/@editmode" />

	<xsl:template match="/request">
		<xsl:call-template name="layout">
			<xsl:with-param name="w_title">
				<xsl:choose>
					<xsl:when test="document/@status = 'new'">
						<xsl:value-of select="concat(document/captions/new/@caption, ' - ', document/captions/title/@caption, ' - ', $APP_NAME)" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="concat(document/captions/title/@caption, ' - ', $APP_NAME)" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
			<xsl:with-param name="active_aside_id" select="document/fields/bank_account" />
			<xsl:with-param name="aside_collapse" select="'aside_collapse'" />
			<xsl:with-param name="include">
				<script src="/SharedResources/jquery/js/jquery-fileupload/js/jquery.fileupload.js"></script>
				<script src="/SharedResources/jquery/js/jquery-fileupload/js/vendor/jquery.ui.widget.js"></script>
				<script type="text/javascript">
					var ddbid = '<xsl:value-of select="document/@id" />';
					<![CDATA[
						$(document).ready(function(){
							$("input[name=summa]").number(true, 2, ".", " ");
							$("#saldo").load("Provider?type=page&id=saldo&ddbid=" + ddbid);
						});]]>
				</script>
				<xsl:if test="$editmode = 'edit'">
					<script>
						<![CDATA[
						$(function() {
							$('#date').datepicker({
								showOn: 'focus',
								regional: ['ru'],
								showAnim: 'fadeIn',
								firstDay: 1,
								isRTL: false,
								showMonthAfterYear: false,
								onSelect: function(dateText, inst) {
									$.cookie("lastoperationdate", dateText, { path:"/", expires:30 });
								}
							});
						});]]>
					</script>
				</xsl:if>
				<xsl:if test="document/@status = 'new'">
					<script>
						<![CDATA[
						if($.cookie("lastoperationdate")){
							$("#date").val($.cookie("lastoperationdate"));
						}]]>
					</script>
				</xsl:if>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="_content">
		<header class="form-header">
			<h3>
				<small id="saldo" class="pull-right" title="Сальдо"></small>
				<div class="doc-title">
					<xsl:value-of select="document/captions/title/@caption" />
					<xsl:if test="document/fields/vn and document/fields/vn!=''">
						<xsl:value-of select="concat('&#xA0;№', document/fields/vn)" />
					</xsl:if>
					<xsl:value-of select="concat(' ', document/captions/from/@caption, ' ', document/fields/date)" />
				</div>
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
							<xsl:value-of select="document/captions/attachments/@caption" />
							<xsl:if test="count(//document/fields/rtfcontent/entry) gt 0">
								<span>
									(<xsl:value-of select="count(//document/fields/rtfcontent/entry)" />)
								</span>
							</xsl:if>
						</a>
					</li>
					<li class="ui-state-default ui-corner-top">
						<a href="#tabs-3">
							<xsl:value-of select="document/captions/additional/@caption" />
						</a>
					</li>
					<span style="float:right; font-size:.8em">
						<xsl:value-of select="//document/captions/author/@caption" />
						:
						<span style="font-weight:normal;">
							<xsl:value-of select="document/fields/author" />
						</span>
					</span>
				</ul>
				<div class="ui-tabs-panel" id="tabs-1">
					<form action="Provider" name="frm" method="post" id="frm" enctype="application/x-www-form-urlencoded">
						<input type="hidden" name="last_page" value="{history/entry[@type = 'page'][last()]}" disabled="disabled" />
						<fieldset name="property" class="fieldset">
							<xsl:if test="$editmode != 'edit'">
								<xsl:attribute name="disabled">disabled</xsl:attribute>
							</xsl:if>
							<div class="fieldset-container">
								<!-- Дата операции -->
								<div class="control-group">
									<div class="control-label">
										<xsl:value-of select="document/captions/date/@caption" />
									</div>
									<div class="controls">
										<input type="text" value="{substring(document/fields/date, 1, 10)}" id="date" name="date" class="span2"
											readonly="readonly" />
									</div>
								</div>
								<!-- Расчетный счет -->
								<div class="control-group">
									<div class="control-label">
										<xsl:value-of select="document/captions/bank_account/@caption" />
									</div>
									<div class="controls">
										<xsl:apply-templates select="document/glossaries/bank_account" mode="glossaries-select">
											<xsl:with-param name="required" select="'required'" />
											<xsl:with-param name="value" select="document/fields/bank_account/@attrval" />
										</xsl:apply-templates>
									</div>
								</div>
								<!-- category -->
								<div class="control-group">
									<div class="control-label">
										<xsl:value-of select="document/captions/category/@caption" />
										<xsl:if test="$editmode = 'edit'">
											<button type="button" class="btn-picklist" onclick="nbApp.dialogChoiceCategory(this)">
												<xsl:attribute name="title" select="document/captions/category/@caption" />
											</button>
										</xsl:if>
									</div>
									<div class="controls">
										<div class="span7">
											<input type="hidden" name="category" value="{document/fields/category/@attrval}" />
											<input type="hidden" name="subcategory" value="{document/fields/subcategory/@attrval}" />

											<span id="typeoperationtbl">
												<xsl:attribute name="class" select="concat('operation-type-icon-', document/fields/typeoperation)" />
											</span>
											<span id="categorytbl">
												<xsl:value-of select="document/fields/category" />
											</span>
											<span id="subcategorytbl">
												<xsl:if test="document/fields/subcategory">
													<xsl:text> / </xsl:text>
													<xsl:value-of select="document/fields/subcategory" />
												</xsl:if>
											</span>
										</div>
									</div>
								</div>
								<!-- Организация получатель -->
								<div class="control-group">
									<div class="control-label">
										<xsl:value-of select="document/captions/recipient/@caption" />
										<xsl:if test="document/@editmode = 'edit'">
											<button type="button" class="btn-picklist">
												<xsl:attribute name="title" select="document/captions/recipient/@caption" />
												<xsl:attribute name="onclick">nbApp.dialogChoiceOrg(this, 'recipient', false)</xsl:attribute>
											</button>
										</xsl:if>
									</div>
									<div class="controls">
										<xsl:call-template name="field">
											<xsl:with-param name="name" select="'recipient'" />
											<xsl:with-param name="node" select="document/fields/recipient" />
										</xsl:call-template>
									</div>
								</div>
								<!-- Сумма -->
								<div class="control-group">
									<div class="control-label">
										<xsl:value-of select="document/captions/summa/@caption" />
									</div>
									<div class="controls">
										<input type="text" name="summa" value="{document/fields/summa}" required="required" class="span2" />
									</div>
								</div>
								<!-- Место возникновения -->
								<div class="control-group">
									<div class="control-label">
										<xsl:value-of select="document/captions/costcenter/@caption" />
										<xsl:if test="$editmode = 'edit'">
											<button type="button" class="btn-picklist">
												<xsl:if test="document/fields/typeoperation ='transfer'  and document/@status != 'new'">
													<xsl:attribute name="style">display:none</xsl:attribute>
												</xsl:if>
												<xsl:attribute name="title" select="document/captions/costcenter/@caption" />
												<xsl:attribute name="onclick">nbApp.dialogChoiceCostCenter(this)</xsl:attribute>
											</button>
										</xsl:if>
									</div>
									<div class="controls">
										<xsl:call-template name="field">
											<xsl:with-param name="name" select="'costcenter'" />
											<xsl:with-param name="node" select="document/fields/costcenter" />
										</xsl:call-template>
									</div>
								</div>
								<!-- requisites -->
								<div class="control-group">
									<div class="control-label">
										<xsl:value-of select="document/captions/requisites/@caption" />
									</div>
									<div class="controls">
										<textarea name="requisites" maxlength="50" class="span7">
											<xsl:attribute name="title" select="document/fields/requisites/@caption" />
											<xsl:value-of select="document/fields/requisites" />
										</textarea>
									</div>
								</div>
								<!-- Основание -->
								<div class="control-group">
									<div class="control-label">
										<xsl:value-of select="document/captions/basis/@caption" />
									</div>
									<div class="controls">
										<textarea name="basis" id="basis" class="span7">
											<xsl:attribute name="title" select="document/fields/basis/@caption" />
											<xsl:value-of select="document/fields/basis" />
										</textarea>
									</div>
								</div>
							</div>
						</fieldset>

						<input type="hidden" name="action" id="action" value="" />
						<input type="hidden" name="type" value="save" />
						<input type="hidden" name="id" value="{@id}" />
						<input type="hidden" name="key" id="key" value="{document/@docid}" />
						<input type="hidden" name="doctype" id="doctype" value="{document/@doctype}" />
						<input type="hidden" name="author" value="{document/fields/author/@attrval}" disabled="disabled" />
						<input type="hidden" name="page" value="{document/@openfrompage}" />
						<input type="hidden" name="formsesid" value="{formsesid}" />
					</form>
				</div>
				<div id="tabs-2">
					<form action="Uploader" name="upload" id="upload" method="post" enctype="multipart/form-data">
						<input type="hidden" name="type" value="rtfcontent" />
						<input type="hidden" name="formsesid" value="{formsesid}" />
						<!-- Секция "Вложения" -->
						<div display="block" id="att">
							<br />
							<xsl:call-template name="attach" />
						</div>
					</form>
				</div>
				<div id="tabs-3">
					<xsl:call-template name="doc-info" />
				</div>
			</div>
		</section>
	</xsl:template>

</xsl:stylesheet>
