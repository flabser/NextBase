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
				</ul>
				<div class="ui-tabs-panel" id="tabs-1">
					<form action="Provider" name="frm" method="post" id="frm" enctype="application/x-www-form-urlencoded">
						<input type="hidden" name="last_page" value="{history/entry[@type = 'page'][last()]}" disabled="disabled" />
						<div display="block" id="property">
							<br />
							<table width="100%" border="0">
								<tr>
									<td class="fc">
										<xsl:value-of select="document/captions/name/@caption" />
										:
									</td>
									<td>
										<input type="text" value="{document/fields/name}" name="name" size="30" class="td_editable" style="width:300px">
											<xsl:if test="$editmode != 'edit'">
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="class">td_noteditable</xsl:attribute>
											</xsl:if>
										</input>
									</td>
								</tr>
								<tr>
									<td class="fc">
										<xsl:value-of select="document/captions/typeoperation/@caption" />
										:
									</td>
									<td>
										<select name="typeoperation" required="required">
											<xsl:attribute name="title">
												<xsl:value-of select="document/fields/typeoperation/@caption" />
											</xsl:attribute>
											<xsl:if test="$editmode = 'readonly'">
												<xsl:attribute name="readonly">readonly</xsl:attribute>
											</xsl:if>
											<option></option>
											<xsl:variable name="typeoperation" select="document/fields/typeoperation" />
											<option value="charge">
												<xsl:if test="$typeoperation = 'charge'">
													<xsl:attribute name="selected">selected</xsl:attribute>
												</xsl:if>
												начисление
											</option>
											<option value="holddebt">
												<xsl:if test="$typeoperation = 'holddebt'">
													<xsl:attribute name="selected">selected</xsl:attribute>
												</xsl:if>
												удержание
											</option>
										</select>
									</td>
								</tr>
							</table>
						</div>
						<input type="hidden" name="type" value="save" />
						<input type="hidden" name="id" value="{@id}" />
						<input type="hidden" name="key" value="{document/@docid}" />
					</form>
				</div>
			</div>
		</section>
	</xsl:template>

</xsl:stylesheet>
