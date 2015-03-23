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
		<script type="text/javascript">
			<![CDATA[
			$(document).ready(function(){
				$("input[name=value_of_control]").number(true, 0, ".", " ");
			});]]>
		</script>
	</xsl:template>

	<xsl:template name="_content">
		<header class="form-header">
			<h3 class="doc-title">
				<xsl:value-of select="document/captions/title/@caption" />
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
								<xsl:value-of select="document/captions/value_of_control/@caption" />
							</div>
							<div class="controls">
								<input type="text" value="{document/fields/value_of_control}" name="value_of_control" class="span2" />
							</div>
						</div>
						<div class="control-group">
							<div class="control-label">
								<xsl:value-of select="document/captions/observers/@caption" />
								<button type="button" class="btn-picklist" title="{document/captions/observers/@caption}" onclick="nbApp.dialogChoiceBossAndDemp(this, 'observers')" />
							</div>
							<div class="controls">
								<xsl:call-template name="field">
									<xsl:with-param name="name" select="'observers'" />
									<xsl:with-param name="node" select="document/fields/observers" />
								</xsl:call-template>
							</div>
						</div>
					</div>
				</fieldset>

				<input type="hidden" name="type" value="save" />
				<input type="hidden" name="id" value="bank_account" />
				<input type="hidden" name="key" value="{document/@docid}" />
			</form>
		</section>
	</xsl:template>

</xsl:stylesheet>
