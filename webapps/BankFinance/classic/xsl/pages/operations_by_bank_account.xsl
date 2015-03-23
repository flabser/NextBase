<?xml version="1.0" ?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:import href="../layout.xsl" />

	<xsl:template match="/request">
		<xsl:call-template name="layout" />
	</xsl:template>

	<xsl:template name="_content">
		<div class="view">
			<div class="view-header">
				<xsl:call-template name="page-info" />
				<xsl:apply-templates select="//actionbar" />
			</div>
			<xsl:apply-templates select="//filter_operation/response/content" mode="filter-container" />
			<div class="view-table">
				<xsl:call-template name="view-table" />
			</div>
			<input type="hidden" name="page_id" id="page_id" value="{@id}" />
		</div>
	</xsl:template>

	<xsl:template name="view-table">
		<xsl:choose>
			<xsl:when test="//view_content//query/entry">
				<table>
					<xsl:apply-templates select="//view_content" mode="view-table-head" />
					<xsl:apply-templates select="//view_content//query/entry" mode="view-table-body" />
				</table>
			</xsl:when>
			<xsl:otherwise>
				<table>
					<xsl:apply-templates select="//view_content" mode="view-table-head" />
				</table>
				<div class="view-empty"></div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- filter -->
	<xsl:template match="content" mode="filter-container">
		<div class="filter">
			<div class="filter-container">
				<xsl:apply-templates select="*" mode="filter" />
			</div>
		</div>
	</xsl:template>

	<xsl:template match="*" mode="filter">
		<div class="filter-entry">
			<div class="filter-entry-title">
				<xsl:value-of select="@title" />
			</div>
			<div class="filter-entry-list-wrapper">
				<div class="filter-entry-list-title">
					<span class="filter-entry-list-toggle-btn">
						<xsl:attribute name="onclick">toggleFilterList(this)</xsl:attribute>
						<xsl:if test="//query/columns/viewtext2/filter/@mode = 'ON'">
							<xsl:value-of select="./entry[@id = //query/columns/viewtext2/filter[@mode='ON']/@keyword]" />
						</xsl:if>
						<xsl:if test="//query/columns/viewtext2/filter/@mode != 'ON'">
							все
						</xsl:if>
					</span>
				</div>
				<div class="filter-entry-list">
					<ul>
						<xsl:for-each select="./entry">
							<li>
								<xsl:attribute name="onclick">chooseFilter("<xsl:value-of select='@id' />", "viewtext2")</xsl:attribute>
								<xsl:value-of select="." />
							</li>
						</xsl:for-each>
						<li class="filter-reset">
							<xsl:attribute name="onclick">resetCurrentFilter("viewtext2")</xsl:attribute>
							все
						</li>
					</ul>
				</div>
			</div>
		</div>
		<xsl:if test="//filter/@mode = 'ON'">
			<button class="filter-reset-all" onclick="resetFilter()" title="{//captions/removefilter/@caption}">
				<img src="/SharedResources/img/iconset/054-delete.png" />
			</button>
		</xsl:if>
	</xsl:template>
	<!-- /filter -->

	<xsl:template match="view_content" mode="view-table-head">
		<tr>
			<th style="text-align:center;width:30px;">
				<input type="checkbox" data-toggle="docid" class="all" />
			</th>
			<th style="width:24px;"></th>
			<th class="wsnowrap" style="text-align:center;width:145px;max-width:145px;">
				<xsl:call-template name="sortingcell">
					<xsl:with-param name="namefield">
						<xsl:value-of select="'VIEWDATE'" />
					</xsl:with-param>
					<xsl:with-param name="sortorder" select="//query/columns/viewdate/sorting/@order" />
					<xsl:with-param name="sortmode" select="//query/columns/viewdate/sorting/@mode" />
				</xsl:call-template>
			</th>
			<th class="wsnowrap" style="text-align:center;width:120px;">
				<xsl:call-template name="sortingcell">
					<xsl:with-param name="namefield">
						<xsl:value-of select="'VIEWNUMBER'" />
					</xsl:with-param>
					<xsl:with-param name="sortorder" select="//query/columns/viewnumber/sorting/@order" />
					<xsl:with-param name="sortmode" select="//query/columns/viewnumber/sorting/@mode" />
				</xsl:call-template>
			</th>
			<th style="min-width:210px;">
				<xsl:value-of select="page/captions/viewtext/@caption" />
			</th>
		</tr>
	</xsl:template>

	<xsl:template match="entry" mode="view-table-body">
		<tr title="{viewcontent/viewtext}" data-ddbid="{@id}" class="document {@docid} js_saldo_on_date" id="{@docid}{@doctype}">
			<xsl:if test="@isread = '0'">
				<xsl:attribute name="class" select="concat('document ', @docid, ' unread')" />
			</xsl:if>
			<td style="text-align:center;">
				<input type="checkbox" name="docid" id="{@id}" value="{@id}" />
			</td>
			<td style="text-align:center;">
				<xsl:apply-templates select="current()[@hasattach &gt; 0]" mode="attach-icon" />
			</td>
			<td class="wsnowrap" style="text-align:center;">
				<a href="{@url}" class="doclink" style="width:90%">
					<xsl:value-of select="substring(viewcontent/viewdate, 0, 11)" />
				</a>
			</td>
			<td>
				<a href="{@url}" class="doclink" style="width:90%">
					<xsl:if test="viewcontent/viewnumber &lt; 0">
						<xsl:attribute name="class">doclink negative-sum</xsl:attribute>
					</xsl:if>
					<xsl:value-of select="format-number(viewcontent/viewnumber, '### ###', 'df')" />
				</a>
			</td>
			<td>
				<a href="{@url}" class="doclink viewtext">
					<xsl:call-template name="replace-string">
						<xsl:with-param name="text" select="viewcontent/viewtext" />
						<xsl:with-param name="replace" select="' -&gt; '" />
						<xsl:with-param name="with">
							<xsl:copy-of select="$VIEW_TEXT_ARROW" />
						</xsl:with-param>
					</xsl:call-template>
				</a>
			</td>
		</tr>

		<xsl:apply-templates select="responses" />
	</xsl:template>

</xsl:stylesheet>
