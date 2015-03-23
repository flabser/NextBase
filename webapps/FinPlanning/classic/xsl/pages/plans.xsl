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
			<xsl:apply-templates select="//filter" mode="filter-container" />
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
							<xsl:value-of select="//captions/filter_reset/@caption" />
						</xsl:if>
					</span>
				</div>
				<div class="filter-entry-list">
					<ul>
						<xsl:for-each select="./entry">
							<li>
								<xsl:attribute name="onclick">nbApp.filterChoose("<xsl:value-of select='@id' />", "viewtext2")</xsl:attribute>
								<xsl:value-of select="." />
							</li>
						</xsl:for-each>
						<li class="filter-reset">
							<xsl:attribute name="onclick">nbApp.filterResetCurrent("viewtext2")</xsl:attribute>
							все
						</li>
					</ul>
				</div>
			</div>
		</div>
		<xsl:if test="//filter/@mode = 'ON'">
			<button class="filter-reset-all" onclick="nbApp.filterReset()" title="{//captions/removefilter/@caption}">
				<img src="/SharedResources/img/iconset/054-delete.png" />
			</button>
		</xsl:if>
	</xsl:template>
	<!-- /filter -->

	<xsl:template match="view_content" mode="view-table-head">
		<tr>
			<th style="text-align:center;width:26px;">
				<input type="checkbox" data-toggle="docid" class="all" />
			</th>
			<th style="text-align:center;width:24px;"></th>
			<th class="wsnowrap" style="text-align:center;width:95px;max-width:95px;">
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
			<th style="width:115px;">
				<xsl:value-of select="//page/captions/viewtext5/@caption" />
			</th>
			<th style="width:125px;">
				<xsl:value-of select="//page/captions/viewtext4/@caption" />
			</th>
			<th style="width:135px;">
				<xsl:value-of select="//page/captions/viewtext6/@caption" />
			</th>
			<th style="min-width:210px;">
				<xsl:value-of select="//page/captions/viewtext/@caption" />
			</th>
		</tr>
	</xsl:template>

	<xsl:template match="entry" mode="view-table-body">
		<tr title="{viewcontent/viewtext}" class="{@docid}" id="{@docid}{@doctype}">
			<xsl:if test="@isread = '0'">
				<xsl:attribute name="class">{@docid} unread</xsl:attribute>
			</xsl:if>
			<td style="text-align:center;width:26px;">
				<input type="checkbox" name="docid" id="{@id}" value="{@id}" />
			</td>
			<td style="width:24px;">
				<xsl:apply-templates select=".[@hasattach &gt; 0]" mode="attach-icon" />
			</td>
			<td style="text-align:center;width:95px;">
				<a href="{@url}" class="doclink">
					<xsl:value-of select="substring(viewcontent/viewdate, 0, 11)" />
				</a>
			</td>
			<td style="width:120px;">
				<a href="{@url}" class="doclink">
					<xsl:if test="viewcontent/viewnumber &lt; 0">
						<xsl:attribute name="class">doclink negative-sum</xsl:attribute>
					</xsl:if>
					<xsl:value-of select="format-number(viewcontent/viewnumber, '### ###', 'df')" />
				</a>
			</td>
			<td style="width:115px;">
				<a href="{@url}" class="doclink">
					<xsl:call-template name="repeatName">
						<xsl:with-param name="repeat" select="viewcontent/viewtext5" />
					</xsl:call-template>
				</a>
			</td>
			<td style="width:125px;">
				<a href="{@url}" class="doclink">
					<xsl:value-of select="viewcontent/viewtext4" />
				</a>
			</td>
			<td style="width:135px;">
				<a href="{@url}" class="doclink">
					<xsl:value-of select="viewcontent/viewtext6" />
				</a>
			</td>
			<td style="min-width:210px;">
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

	<xsl:template name="repeatName">
		<xsl:param name="repeat" />

		<xsl:choose>
			<xsl:when test="$repeat = 'once-only'">
				разово
			</xsl:when>
			<xsl:when test="$repeat = 'end-week'">
				в конце недели
			</xsl:when>
			<xsl:when test="$repeat = 'end-month'">
				в конце месяца
			</xsl:when>
			<xsl:when test="$repeat = 'end-quarter'">
				в конце квартала
			</xsl:when>
			<xsl:when test="$repeat = 'end-year'">
				в конце года
			</xsl:when>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
