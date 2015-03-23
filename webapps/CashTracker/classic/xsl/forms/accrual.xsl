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
			<xsl:with-param name="active_aside_id" select="//current_outline_entry/response/content/entry/@id" />
			<xsl:with-param name="aside_collapse" select="'aside_collapse'" />
		</xsl:call-template>

		<xsl:if test="document/@editmode = 'edit'">
			<!-- @see var calendarStrings in form.js -->
			<script>
				var _calendarLang = "<xsl:value-of select="/request/@lang" />";
				$(function() {
					$('#date').datepicker({
						showOn: 'button',
						buttonImage: '/SharedResources/img/iconset/calendar.png',
						buttonImageOnly: true,
						regional:['ru'],
						showAnim: '',
						monthNames: calendarStrings[_calendarLang].monthNames,
						monthNamesShort: calendarStrings[_calendarLang].monthNamesShort,
						dayNames: calendarStrings[_calendarLang].dayNames,
						dayNamesShort: calendarStrings[_calendarLang].dayNamesShort,
						dayNamesMin:
						calendarStrings[_calendarLang].dayNamesMin,
						weekHeader: calendarStrings[_calendarLang].weekHeader,
						yearSuffix:
						calendarStrings[_calendarLang].yearSuffix,
						firstDay: 1,
						isRTL: false,
						showMonthAfterYear: false,
						onSelect:
						function(dateText, inst) {
						$.cookie("lastoperationdate",
							dateText, {path:"/", expires:30});
						}
					});
				});
			</script>
		</xsl:if>
	</xsl:template>

	<xsl:template name="_content">
		<div class="form-header">
			<h3 class="doc-title">
				<xsl:value-of select="document/captions/title/@caption" />
			</h3>
			<xsl:apply-templates select="//actionbar">
				<xsl:with-param name="fixed_top" select="''" />
			</xsl:apply-templates>
		</div>
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
					</a>
				</li>
				<li class="ui-state-default ui-corner-top">
					<a href="#tabs-3">
						<xsl:value-of select="document/captions/additional/@caption" />
					</a>
				</li>
			</ul>
			<form action="Provider" name="frm" method="post" id="frm" enctype="application/x-www-form-urlencoded">
				<input type="hidden" name="last_page" value="{history/entry[@type = 'page'][last()]}" disabled="disabled" />
				<div class="ui-tabs-panel" id="tabs-1">
					<br />
					<table width="100%" border="0">
						<!--Author -->
						<tr>
							<td class="fc" style="padding-top:3px">
								<font style="vertical-align:top">
									<xsl:value-of select="document/captions/author/@caption" />
									:
								</font>
							</td>
							<td style="padding-top:3px">
								<table id="taskauthortbl">
									<tr>
										<td style="width:500px" class="td_noteditable">
											<xsl:value-of select="document/fields/author" />
											&#xA0;
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<!-- Reg date -->
						<tr>
							<td class="fc" style="padding-top:3px">
								<font style="vertical-align:top">
									<xsl:value-of select="document/captions/regdate/@caption" />
									:
								</font>
							</td>
							<td style="padding-top:3px">
								<table id="taskauthortbl">
									<tr>
										<td style="width:150px" class="td_noteditable">
											<xsl:value-of select="document/fields/regdate" />
											&#xA0;
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<!-- поле "Дата операции" -->
						<tr>
							<td class="fc" style="padding-top:5px">
								<xsl:value-of select="document/captions/date/@caption" />
								&#160; :
							</td>
							<td style="padding-top:5px">
								<input type="text" value="{substring(document/fields/date,1,10)}" id="date" name="date"
									onfocus="javascript:$(this).blur()" style="width:80px; vertical-align:top" class="td_editable">
									<xsl:if test="$editmode != 'edit'">
										<xsl:attribute name="class">td_noteditable</xsl:attribute>
									</xsl:if>
								</input>
							</td>
						</tr>
						<!-- поле "Тип операции по персоналу" -->
						<tr>
							<td class="fc">
								<font style="vertical-align:top">
									<xsl:value-of select="document/captions/typeoperationstaff/@caption" />
									:
								</font>
								<xsl:if test="$editmode = 'edit'">
									<a href="">
										<xsl:attribute name="href">javascript:dialogBoxStructure('picklist-typeoperationstaff','true','typeoperationstaff','frm', 'typeoperationstafftbl');</xsl:attribute>
										<img src="/SharedResources/img/iconset/report_magnify.png" />
									</a>
								</xsl:if>
							</td>
							<td>
								<table id="typeoperationstafftbl" style="border-spacing:0px 3px; margin-top:-3px">
									<xsl:if test="not(document/fields/typeoperationstaff/entry)">
										<tr>
											<td style="width:500px;" class="td_editable">
												<xsl:if test="$editmode != 'edit'">
													<xsl:attribute name="class">td_noteditable</xsl:attribute>
												</xsl:if>
												<xsl:value-of select="document/fields/typeoperationstaff" />
												&#xA0;
											</td>
										</tr>
									</xsl:if>
									<xsl:if test="document/fields/typeoperationstaff/@islist ='true'">
										<xsl:for-each select="document/fields/typeoperationstaff/entry">
											<tr>
												<td style="width:500px;" class="td_editable">
													<xsl:if test="$editmode != 'edit'">
														<xsl:attribute name="class">td_noteditable</xsl:attribute>
													</xsl:if>
													<xsl:value-of select="." />
													&#xA0;
												</td>
											</tr>
										</xsl:for-each>
									</xsl:if>
								</table>
								<xsl:if test="document/fields/typeoperationstaff/@islist ='true'">
									<xsl:for-each select="document/fields/typeoperationstaff/entry">
										<input type="hidden" value="{./@attrval}" name="typeoperationstaff" />
									</xsl:for-each>
								</xsl:if>
								<xsl:if test="not(document/fields/category/entry)">
									<input type="hidden" id="typeoperationstaff" name="typeoperationstaff" value="{document/fields/typeoperationstaff/@attrval}" />
								</xsl:if>
								<input type="hidden" id="typeoperationstaffcaption" value="{document/captions/typeoperationstaff/@caption}" />
							</td>
						</tr>
						<!-- поле "Сотрудник" -->
						<tr>
							<td class="fc">
								<font style="vertical-align:top">
									<xsl:value-of select="document/captions/personal/@caption" />
									:
								</font>
								<xsl:if test="$editmode = 'edit'">
									<a href="">
										<xsl:attribute name="href">javascript:dialogBoxStructure('bossandemppicklist','true','personal','frm', 'personaltbl');</xsl:attribute>
										<img src="/SharedResources/img/iconset/report_magnify.png" />
									</a>
								</xsl:if>
							</td>
							<td>
								<table id="personaltbl" style="border-spacing:0px 3px; margin-top:-3px">
									<xsl:if test="not(document/fields/personal/entry)">
										<tr>
											<td style="width:500px;" class="td_editable">
												<xsl:if test="$editmode != 'edit'">
													<xsl:attribute name="class">td_noteditable</xsl:attribute>
												</xsl:if>
												<xsl:value-of select="document/fields/personal" />
												&#xA0;
											</td>
										</tr>
									</xsl:if>
									<xsl:if test="document/fields/personal/@islist ='true'">
										<xsl:for-each select="document/fields/personal/entry">
											<tr>
												<td style="width:500px;" class="td_editable">
													<xsl:if test="$editmode != 'edit'">
														<xsl:attribute name="class">td_noteditable</xsl:attribute>
													</xsl:if>
													<xsl:value-of select="." />
													&#xA0;
												</td>
											</tr>
										</xsl:for-each>
									</xsl:if>
								</table>
								<xsl:if test="document/fields/personal/@islist ='true'">
									<xsl:for-each select="document/fields/personal/entry">
										<input type="hidden" value="{./@attrval}" name="personal" />
									</xsl:for-each>
								</xsl:if>
								<xsl:if test="not(document/fields/personal/entry)">
									<input type="hidden" id="personal" name="personal" value="{document/fields/personal/@attrval}" />
								</xsl:if>
								<input type="hidden" id="personalcaption" value="{document/fields/personal/@caption}" />
							</td>
						</tr>
						<!-- поле "Сумма" -->
						<tr>
							<td class="fc" style="padding-top:5px">
								<xsl:value-of select="document/captions/summa/@caption" />
								:
							</td>
							<td style="padding-top:5px">
								<input type="text" value="{document/fields/summa}" name="summa" class="triad_input" size="13">
									<xsl:if test="$editmode != 'edit'">
										<xsl:attribute name="readonly">readonly</xsl:attribute>
									</xsl:if>
								</input>
							</td>
						</tr>
						<!-- поле "Месяц" -->
						<tr>
							<td class="fc" style="padding-top:5px">
								<xsl:value-of select="document/captions/month/@caption" />
								:
							</td>
							<td style="padding-top:5px">
								<select id="month" name="month" class="month">
									<xsl:attribute name="title">
														<xsl:value-of select="document/fields/month/@caption" />
													</xsl:attribute>
									<xsl:if test="$editmode = 'readonly'">
										<xsl:attribute name="disabled">disabled</xsl:attribute>
									</xsl:if>
									<option></option>
									<xsl:apply-templates mode="gloss" select="//glossaries/month/entry">
										<xsl:with-param name="id">
											<xsl:value-of select="document/fields/month" />
										</xsl:with-param>
									</xsl:apply-templates>
								</select>
							</td>
						</tr>
						<!-- поле "Год" -->
						<tr>
							<td class="fc" style="padding-top:5px">
								<xsl:value-of select="document/captions/year/@caption" />
								:
							</td>
							<td style="padding-top:5px">
								<input type="text" value="{document/fields/year}" name="year" class="td_editable" onkeypress="javascript:Numeric(this)"
									style="width:80px;">
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
					</table>
				</div>

				<!-- Скрытые поля документа -->
				<input type="hidden" name="action" id="action" value="" />
				<input type="hidden" name="type" value="save" />
				<input type="hidden" name="id" value="{@id}" />
				<input type="hidden" name="key" id="key">
					<xsl:attribute name="value" select="document/@docid" />
				</input>
				<input type="hidden" name="doctype" id="doctype">
					<xsl:attribute name="value" select="document/@doctype" />
				</input>
				<input type="hidden" name="page">
					<xsl:attribute name="value" select="document/@openfrompage" />
				</input>
				<input type="hidden" name="formsesid">
					<xsl:attribute name="value" select="formsesid" />
				</input>
			</form>
			<div id="tabs-2" style="height:500px">
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
	</xsl:template>
</xsl:stylesheet>
