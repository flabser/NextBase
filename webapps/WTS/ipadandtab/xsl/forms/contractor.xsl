<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../templates/form.xsl"/>
	<xsl:import href="../templates/sharedactions.xsl"/>
	<xsl:variable name="doctype" select="request/document/captions/name/@caption"/>
	<xsl:variable name="threaddocid" select="document/@docid"/>
	<xsl:variable name="editmode" select="/request/document/@editmode"/>
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
				<!-- 	$(function(){
						$("#code").tipTip({'activation':'click', "field" : "code", "defaultPosition": "right","content":"Поле может содержать только числовые значения"} );
					}); -->
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
								<form action="Provider" name="frm" method="post" id="frm" enctype="application/x-www-form-urlencoded">
									<div display="block" id="property">
										<br/>
										<table width="80%" border="0">
											<tr>
												<td width="30%" class="fc"><xsl:value-of select="document/captions/name/@caption"/> :</td>
												<td>
													<input type="text" name="name" value="{document/fields/name}" size="30" class="td_editable" style="width:500px">
														<xsl:if test="$editmode != 'edit'">
															<xsl:attribute name="readonly">readonly</xsl:attribute>
															<xsl:attribute name="class">td_noteditable</xsl:attribute>
														</xsl:if>
													</input>
												</td>
											</tr>
											<tr>
												<td width="30%" class="fc">e-mail :</td>
												<td>
													<input type="text" name="email" value="{document/fields/email}" size="30" class="td_editable" style="width:300px">
														<xsl:if test="$editmode != 'edit'">
															<xsl:attribute name="readonly">readonly</xsl:attribute>
															<xsl:attribute name="class">td_noteditable</xsl:attribute>
														</xsl:if>
													</input>
												</td>
											</tr>
											<tr>
												<td class="fc"><xsl:value-of select="document/captions/rnn/@caption"/> :</td>
												<td>
													<input type="text" name="rnn" size="10" value="{document/fields/rnn}" class="td_editable" style="width:300px">
														<xsl:if test="$editmode != 'edit'">
															<xsl:attribute name="readonly">readonly</xsl:attribute>
															<xsl:attribute name="class">td_noteditable</xsl:attribute>
														</xsl:if>
														<xsl:attribute name="onkeydown">javascript:Numeric(this)</xsl:attribute>
													</input>
												</td>
											</tr>
											<tr>
												<td class="fc"><xsl:value-of select="document/captions/bin/@caption"/> :</td>
												<td>
													<input type="text" name="bin" size="10" value="{document/fields/bin}" class="td_editable" style="width:300px">
														<xsl:if test="$editmode != 'edit'">
															<xsl:attribute name="readonly">readonly</xsl:attribute>
															<xsl:attribute name="class">td_noteditable</xsl:attribute>
														</xsl:if>
														<xsl:attribute name="onkeydown">javascript:Numeric(this)</xsl:attribute>
													</input>
												</td>
											</tr>
											<tr>
												<td class="fc"><xsl:value-of select="document/captions/code/@caption"/> :</td>
												<td>
													<input type="text" name="code" id="code" size="10" value="{document/fields/code}" class="td_editable" style="width:300px">
														<xsl:if test="$editmode != 'edit'">
															<xsl:attribute name="readonly">readonly</xsl:attribute>
															<xsl:attribute name="class">td_noteditable</xsl:attribute>
														</xsl:if>
<!-- 														<xsl:attribute name="onkeydown">javascript:numericfield(this)</xsl:attribute> -->
													</input>
												</td>
											</tr>
											<tr>
												<td width="30%" class="fc"><xsl:value-of select="document/captions/category/@caption"/> :</td>
												<td>
													<select name="contractorcat" class="select_editable" style="width:310px">
														<xsl:attribute name="onchange">javascript:setValHiddenFields(this)</xsl:attribute>
														<xsl:if test="$editmode != 'edit'">
															<xsl:attribute name="class">select_noteditable</xsl:attribute>
															<xsl:attribute name="disabled">disabled</xsl:attribute>
														</xsl:if>
														<script>
															$(document).ready(function(){
																setValHiddenFields($("[name=contractorcat]"))
															});
														</script>
														<xsl:variable name="contractorcat" select="document/fields/contractorcat/@attrval"/>
														<xsl:if test="$editmode != 'edit'">
															<option value="{document/fields/contractorcat/@attrval}">
																<xsl:value-of select="document/fields/contractorcat"/>
															</option>
														</xsl:if>
														<xsl:for-each select="document/glossaries/contractorcatlist/query/entry">
															<option value="{@docid}">
																<xsl:if test="$contractorcat=@docid">
																	<xsl:attribute name="selected">selected</xsl:attribute>
																</xsl:if>
																<xsl:value-of select="viewcontent/viewtext1"/>
															</option>
														</xsl:for-each>
													</select>
												</td>
											</tr>
											<tr> 
												<td class="fc">
													 <input type="checkbox" name="isbadperformer" value="true"> 
<!-- 													 		<xsl:if test="document/@editmode != 'edit'"> -->
												 			<xsl:if test="document/fields/isbadperformer = 'true'">
												 				<xsl:attribute name="checked">checked</xsl:attribute>
												 			</xsl:if>
<!-- 													 		</xsl:if> -->
													 </input> 
												 </td>
												<td><xsl:value-of select="document/captions/badperformer/@caption"/></td>
											</tr>
										</table>
									</div>
									<input type="hidden" name="type" value="save"/>
									<input type="hidden" name="id" value="contractor"/>
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
				<div style="position:absolute; bottom:0px;left:0px; right:0px; background:#898989; width:auto; height:3.2em; border-top:1px solid #aaa; padding:0.5em 1em">
						<button  id="btnuserprf">
							<xsl:attribute name="onclick">javascript:openuserpanel()</xsl:attribute>
							<font style="font-size:14px; vertical-align:top"><xsl:value-of select="@username"/>&#xA0;&#xA0;</font>
						</button>
						<button  id="btnviewlist" style="float:right">
							<xsl:attribute name="onclick">javascript:openoutlinenavigation()</xsl:attribute>
							<img src="/SharedResources/img/classic/icons/list_bullets.png"/>
						</button>
						<script type="text/javascript">    
					       		$(function() {
									$("#btnuserprf").button({
										icons: {
	                						secondary: "ui-icon-triangle-1-n",
	            						}
            						});
									$("#btnviewlist, .mnbtn").button();
			        			});
    						</script>
					</div>
					<div id="userpanel" style="position:absolute; z-index:999; width:300px; height:170px; border-radius:5px; background:#fff; border:2px solid #999; bottom:-215px;left:20px; padding:20px; text-align:center; display:none;">
						<button  class="mnbtn" style="width:100%">
							<xsl:attribute name="onclick">javascript:window.location.href="Provider?type=edit&amp;element=userprofile&amp;id=userprofile"</xsl:attribute>
							<font>Профиль пользователя</font>
						</button>
						<button  class="mnbtn" style="width:100%">
							<xsl:attribute name="onclick">javascript:window.location.href="Provider?type=static&amp;id=help_summary"</xsl:attribute>
							<font><xsl:value-of select="document/captions/help/@caption"/></font>
						</button>
						<div style="width:100%; height:2px; background:#787878; margin-top:15px"></div>
						<button  class="mnbtn" style="width:100%; margin-top:20px">
							<xsl:attribute name="onclick">javascript:window.location.href="Logout"</xsl:attribute>
							<font><xsl:value-of select="document/captions/logout/@caption"/></font>
						</button>
					</div>
					<div id="outlinelist" style="position:absolute; top: 0px; bottom: 4.2em; left:-100%; width:100%; background:#fff; display:none; overflow:auto">
							<ul style="margin-left: auto; padding: 0; list-style: none;	text-align: center; line-height: 0; zoom:1;">
								<xsl:for-each select="document/outline/entry/entry">
									<li style="width:100px; height:120px; list-style:none; display: inline-block; line-height: normal; font-size:13px; vertical-align: top;	margin-bottom:30px; margin-left:30px; ">
										<a href="{@url}" style="text-decoration:none; color:#999">
											<div style="width:100px; height:100px; border:1px solid #999; border-radius:8px; text-align:center; background:#efefef;">
												<br/>
												<br/>
												<font style="font-size:11px; line-height:25px">
													<xsl:value-of select="../@caption"/>
												</font>
											</div>
										</a>
										<div style="text-align:center; margin-top:5px; font-size:10px; margin-bottom:10px">
											<xsl:value-of select="@caption"/>
										</div>
									
									</li>
							</xsl:for-each>
							</ul>
					</div>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>