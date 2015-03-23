<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:import href="../templates/form.xsl" />
	<xsl:import href="../layout.xsl" />

	<xsl:output method="html" encoding="utf-8" indent="no" />
	<xsl:variable name="editmode" select="/request/document/@editmode" />

	<xsl:template match="/request">
		<xsl:call-template name="layout">
			<xsl:with-param name="w_title" select="concat(document/captions/name/@caption, ' - ', $APP_NAME)" />
			<xsl:with-param name="active_aside_id" select="//current_outline_entry/response/content/entry/@id" />
			<xsl:with-param name="aside_collapse" select="'aside_collapse'" />
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="_content">
		<header class="form-header">
			<h3 class="doc-title">
				<xsl:value-of select="document/captions/title/@caption" />
				<em style="margin-left:1em;">
					<xsl:value-of select="document/fields/category" />
				</em>
			</h3>
			<xsl:apply-templates select="//actionbar">
				<xsl:with-param name="fixed_top" select="''" />
			</xsl:apply-templates>
		</header>
		<section class="form-content">
			<form action="Provider" name="frm" method="post" id="frm" enctype="application/x-www-form-urlencoded">
				<input type="hidden" name="last_page" value="{history/entry[@type = 'page'][last()]}" disabled="disabled" />
				<fieldset name="properties" class="fieldset">
					<xsl:if test="$editmode != 'edit'">
						<xsl:attribute name="disabled">disabled</xsl:attribute>
					</xsl:if>
					<legend class="legend">
						<div class="legend-tab">
							<xsl:value-of select="document/captions/properties/@caption" />
						</div>
					</legend>

					<div class="fieldset-container">
						<div class="control-group">
							<div class="control-label">
								<xsl:value-of select="document/captions/name/@caption" />
							</div>
							<div class="controls">
								<input type="text" value="{document/fields/name}" name="name" class="span7" required="required" />
							</div>
						</div>
						<div class="control-group">
							<div class="control-label">
								<xsl:value-of select="document/captions/category_refers_to/@caption" />
							</div>
							<div class="controls">
								<xsl:apply-templates select="document/glossaries/category_refers_to" mode="static-glossaries-input">
									<xsl:with-param name="type" select="'checkbox'" />
									<xsl:with-param name="required" select="'required'" />
									<xsl:with-param name="value" select="document/fields/category_refers_to" />
								</xsl:apply-templates>
							</div>
						</div>
						<div class="control-group">
							<div class="control-label">
								<xsl:value-of select="document/captions/typeoperation/@caption" />
							</div>
							<div class="controls">
								<xsl:apply-templates select="document/glossaries/typeoperation" mode="static-glossaries-select">
									<xsl:with-param name="required" select="'required'" />
									<xsl:with-param name="value" select="document/fields/typeoperation" />
								</xsl:apply-templates>
							</div>
						</div>
						<div class="control-group">
							<div class="controls">
								<label style="display:none;">
									<input type="checkbox" name="disable_selection" value="1">
										<xsl:attribute name="title" select="document/captions/disable_selection/@caption" />
										<xsl:if test="document/fields/disable_selection = '1'">
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:if>
									</input>
									<span class="input-label">
										<xsl:value-of select="document/captions/disable_selection/@caption" />
									</span>
								</label>
								<label class="form-control">
									<input type="checkbox" name="requiredocument" value="1">
										<xsl:attribute name="title" select="document/captions/requiredocument/@caption" />
										<xsl:if test="document/fields/requiredocument = '1'">
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:if>
									</input>
									<span class="input-label">
										<xsl:value-of select="document/captions/requiredocument/@caption" />
									</span>
								</label>
								<br />
								<label class="form-control">
									<input type="checkbox" name="requirecostcenter" value="1">
										<xsl:attribute name="title" select="document/captions/requirecostcenter/@caption" />
										<xsl:if test="document/fields/requirecostcenter = '1'">
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:if>
									</input>
									<span class="input-label">
										<xsl:value-of select="document/captions/requirecostcenter/@caption" />
									</span>
								</label>
							</div>
						</div>
						<div class="control-group">
							<div class="control-label">
								<xsl:value-of select="document/captions/accessroles/@caption" />
								<button type="button" class="btn-picklist">
									<xsl:attribute name="title" select="document/captions/accessroles/@caption" />
									<xsl:attribute name="onclick">nbApp.dialogChoiceAccessRoles(this)</xsl:attribute>
								</button>
								<button type="button" class="btn-clear">
									<xsl:attribute name="onclick">nbApp.clearFormField('accessroles');</xsl:attribute>
								</button>
							</div>
							<div class="controls">
								<xsl:call-template name="field">
									<xsl:with-param name="name" select="'accessroles'" />
									<xsl:with-param name="node" select="document/fields/accessroles" />
								</xsl:call-template>
							</div>
						</div>
						<div class="control-group">
							<div class="control-label">
								<xsl:value-of select="document/captions/comment/@caption" />
							</div>
							<div class="controls">
								<textarea name="comment" class="span7">
									<xsl:value-of select="document/fields/comment" />
								</textarea>
							</div>
						</div>
					</div>
				</fieldset>

				<input type="hidden" name="type" value="save" />
				<input type="hidden" name="id" value="subcategory" />
				<input type="hidden" name="key" value="{document/@docid}" />
				<input type="hidden" name="parentdocid" value="{document/@parentdocid}" />
				<input type="hidden" name="parentdoctype" value="{document/@parentdoctype}" />
			</form>
		</section>
	</xsl:template>

</xsl:stylesheet>
