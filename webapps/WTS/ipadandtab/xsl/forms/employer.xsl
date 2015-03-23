<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../templates/form.xsl"/>
	<xsl:import href="../templates/sharedactions.xsl"/>
	<xsl:variable name="doctype"><xsl:value-of select="/request/document/captions/employer/@caption"/></xsl:variable>
	<xsl:variable name="threaddocid" select="document/@docid"/>
	<xsl:variable name="editmode" select="/request/document/@editmode"/>
	<xsl:output method="html" encoding="utf-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" indent="yes"/>
	<xsl:variable name="skin" select="request/@skin"/>
	<xsl:template match="/request">
		<html>
			<head>
				<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
				<title><xsl:value-of select="document/captions/employer/@caption"/> - Web Technical Supervision</title>
				<xsl:call-template name="cssandjs"/>
				<script type="text/javascript">
					$(document).ready(function(){
						hotkeysnav()  
   					})
   					<![CDATA[
   						function hotkeysnav() {
							$(document).bind('keydown', function(e){
			 					if (e.ctrlKey) {
			 						switch (e.keyCode) {
									   case 66:
									   		<!-- клавиша b -->
									     	e.preventDefault();
									     	$("#canceldoc").click();
									      	break;
									   case 68:
									   		<!-- клавиша d -->
									     	e.preventDefault();
									     	$("#btnnewdep").click();
									      	break;
									   case 69:
									   		<!-- клавиша e -->
									     	e.preventDefault();
									     	$("#btnnewemp").click();
									      	break;
									   case 83:
									   		<!-- клавиша s -->
									     	e.preventDefault();
									     	$("#btnsavedoc").click();
									      	break;
									   case 85:
									   		<!-- клавиша u -->
									     	e.preventDefault();
									     	window.location.href=$("#currentuser").attr("href")
									      	break;
									   case 81:
									   		<!-- клавиша q -->
									     	e.preventDefault();
									     	window.location.href=$("#logout").attr("href")
									      	break;
									   case 72:
									   		<!-- клавиша h -->
									     	e.preventDefault();
									     	window.location.href=$("#helpbtn").attr("href")
									      	break;
									   default:
									      	break;
									}
			   					}
							});
							$("#canceldoc").hotnav({keysource:function(e){ return "b"; }});
							$("#btnsavedoc").hotnav({keysource:function(e){ return "s"; }});
							$("#btnnewdep").hotnav({keysource:function(e){ return "d"; }});
							$("#btnnewemp").hotnav({keysource:function(e){ return "e"; }});
							$("#currentuser").hotnav({ keysource:function(e){ return "u"; }});
							$("#logout").hotnav({keysource:function(e){ return "q"; }});
							$("#helpbtn").hotnav({keysource:function(e){ return "h"; }});
						}
					]]>
				</script>
			</head>
			<body>
				<div id="docwrapper">
					<xsl:variable name="status" select="@status"/>
					<xsl:call-template name="documentheader"/>	
					<div class="formwrapper">
						<div class="formtitle">
							<div class="title">
								<xsl:call-template name="doctitleBoss"/>
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
								<xsl:if test="document/@status !='new'">
									<button class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" id="btnnewdep" style="margin-left:5px" title="Зарегистрировать новый департамент">
										<xsl:attribute name="onclick">javascript:window.location.href="Provider?type=structure&amp;id=department&amp;key=&amp;parentdocid=<xsl:value-of select="document/@docid"/>&amp;parentdoctype=<xsl:value-of select="document/@doctype"/>"</xsl:attribute>
										<span>
											<img src="/SharedResources/img/classic/icons/package_add.png" class="button_img"/>
											<font style="font-size:12px; vertical-align:top"><xsl:value-of select="document/captions/newdept/@caption"/></font>
										</span>
									</button>
									<button class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" id="btnnewemp" title="Зарегистрировать нового сотрудника" style="margin-left:5px">
										<xsl:attribute name="onclick">javascript:window.location.href="Provider?type=structure&amp;id=employer&amp;key=&amp;parentdocid=<xsl:value-of select="document/@docid"/>&amp;parentdoctype=<xsl:value-of select="document/@doctype"/>"</xsl:attribute>
										<span>
											<img src="/SharedResources/img/classic/icons/user_add.png" class="button_img"/>
											<font style="font-size:12px; vertical-align:top"><xsl:value-of select="document/captions/newemp/@caption"/></font>
										</span>
									</button>
								</xsl:if>
							</span>
							<span style="float:right; margin-right:5px">
								<xsl:call-template name="cancel"/>
							</span>
						</div>
						<div style="clear:both"/>
						<div style="-moz-border-radius:0px;height:1px; width:100%; margin-top:10px;"/>
						<div style="clear:both"/>
						<div id="tabs">
							<ul
								class="ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-all">
								<li class="ui-state-default ui-corner-top">
									<a href="#tabs-1">
										<xsl:value-of select="document/captions/properties/@caption"/>
									</a>
								</li>
							</ul>
							<div class="ui-tabs-panel" id="tabs-1" style="height:800px">
								<form action="Provider" name="frm" method="post" id="frm" enctype="application/x-www-form-urlencoded">
									<div display="block" id="property">
										<br/>
										<table width="100%" border="0">
											<tr>
												<td class="fc"><xsl:value-of select="document/captions/fullname/@caption"/> :</td>
												<td>
													<input type="text" name="fullname" value="{document/fields/fullname}" size="45" class="td_editable" style="width:600px">
														<xsl:if test="$editmode != 'edit'">
															<xsl:attribute name="readonly">readonly</xsl:attribute>
															<xsl:attribute name="class">td_noteditable</xsl:attribute>
														</xsl:if>
													</input>
												</td>
											</tr>
											<tr>
												<td class="fc"><xsl:value-of select="document/captions/shortname/@caption"/> :</td>
												<td>
													<input type="text" name="shortname" value="{document/fields/shortname}" style="width:400px" class="td_editable">
														<xsl:if test="$editmode != 'edit'">
															<xsl:attribute name="readonly">readonly</xsl:attribute>
															<xsl:attribute name="class">td_noteditable</xsl:attribute>
														</xsl:if>
													</input>
												</td>
											</tr>
											<tr>
												<td class="fc">UserID :</td>
												<td>
													<input type="text" name="userid" value="{document/fields/userid}" class="td_editable" style="width:400px">
														<xsl:if test="$editmode != 'edit'">
															<xsl:attribute name="readonly">readonly</xsl:attribute>
															<xsl:attribute name="class">td_noteditable</xsl:attribute>
														</xsl:if>
													</input>
												</td>
											</tr>
											<tr>
												<td class="fc">e-mail :</td>
												<td>
													<input type="text" name="email" value="{document/fields/email}" class="td_editable" style="width:400px">
														<xsl:if test="$editmode != 'edit'">
															<xsl:attribute name="readonly">readonly</xsl:attribute>
															<xsl:attribute name="class">td_noteditable</xsl:attribute>
														</xsl:if>
													</input>
												</td>
											</tr>
											<tr>
												<td class="fc">Instant Messenger address :</td>
												<td>
													<input style="width:300px" name="instmsgaddress" type="text" class="td_editable" value="{document/fields/instmsgaddress}">
														<xsl:if test="$editmode != 'edit'">
															<xsl:attribute name="class">td_noteditable</xsl:attribute>
														</xsl:if>
													</input>
													<span style="vertical-align:middle;">
														<xsl:choose>
															<xsl:when test="document/fields/instmsgstatus = 'false'">
																<img src="/SharedResources/img/iconset/bullet_red.png" title="Instant Messenger off"/>
															</xsl:when>
															<xsl:when test="document/fields/instmsgstatus = 'true'">
																<img src="/SharedResources/img/iconset/bullet_gren.png" title="Instant Messenger on"/>
															</xsl:when>
															<xsl:otherwise>
																<img src="/SharedResources/img/iconset/bullet_red.png" title="Instant Messenger off"/>
															</xsl:otherwise>
														</xsl:choose>
													</span>
												</td>
											</tr>		
											<tr>
												<td class="fc"><xsl:value-of select="document/captions/password/@caption"/> :</td>
												<td>
													<input type="password" value="" name="password" style="width:300px" class="td_editable">
														<xsl:if test="$editmode != 'edit'">
															<xsl:attribute name="readonly">readonly</xsl:attribute>
															<xsl:attribute name="class">td_noteditable</xsl:attribute>
														</xsl:if>
													</input>
												</td>
											</tr>
											<tr>
												<td class="fc"><xsl:value-of select="document/captions/repeatpassword/@caption"/> :</td>
												<td>
													<input type="password" value="" name="password" style="width:300px" class="td_editable">
														<xsl:if test="$editmode != 'edit'">
															<xsl:attribute name="readonly">readonly</xsl:attribute>
															<xsl:attribute name="class">td_noteditable</xsl:attribute>
														</xsl:if>
													</input>
												</td>
											</tr>
											<xsl:if test="document/@status !='new'">
												<tr>
													<td class="fc"><xsl:value-of select="document/captions/organization/@caption"/> :
													</td>
													<td>
														<table id="orgtable">
															<tr>
																<td class="td_editable" style="width:300px;">
																	<xsl:if test="$editmode != 'edit'">
																		<xsl:attribute name="readonly">readonly</xsl:attribute>
																		<xsl:attribute name="class">td_noteditable</xsl:attribute>
																	</xsl:if>
																	<xsl:value-of select="document/fields/organization"/>
																	&#xA0;
																</td>
															</tr>
														</table>
														<input type="hidden" name="organization" value="{document/fields/organization/@attrval}" size="30"/>
													</td>
												</tr>
											</xsl:if>
											<tr>
												<td class="fc"><xsl:value-of select="document/captions/department/@caption"/> :
													<a href="">
														<xsl:attribute name="href">javascript:dialogBoxStructure('deptpicklist','false','depid','frm', 'depttable');</xsl:attribute>
														<img src="/SharedResources/img/iconset/report_magnify.png"/>
													</a>
												</td>

												<td>
													<table id="depttable">
														<tr>
															<td class="td_editable" style="width:300px;">
																<xsl:if test="document/@editmode != 'edit'">
																	<xsl:attribute name="readonly">readonly</xsl:attribute>
																	<xsl:attribute name="class">td_noteditable</xsl:attribute>
																</xsl:if>
																<xsl:value-of select="document/fields/depid"/>&#xA0;
															</td>
														</tr>
													</table>
													<input type="hidden" name="depid" size="30" value="{document/fields/depid/@attrval}"/>
													<input type="hidden" id="depidcaption" size="30" value="Департамент"/>
												</td>
											</tr>
											<tr>
												<td class="fc"><xsl:value-of select="document/captions/post/@caption"/> :</td>
												<td>
													<select name="post" class="select_editable" style="width:312px;">
														<xsl:if test="$editmode != 'edit'">
															<xsl:attribute name="disabled">disabled</xsl:attribute>
															<xsl:attribute name="class">select_noteditable</xsl:attribute>
															<option value=" ">
																<xsl:value-of select="document/fields/post "/>
															</option>
														</xsl:if>
														<xsl:variable name="post" select="document/fields/post/@attrval"/>
														<xsl:if test="$editmode = 'edit'">
															<option value="">
																<xsl:attribute name="selected">selected</xsl:attribute>
															</option>
														</xsl:if>
														<xsl:for-each select="document/glossaries/post/query/entry">
															<option value="{@docid}">
																<xsl:if test="$post=@docid">
																	<xsl:attribute name="selected">selected</xsl:attribute>
																</xsl:if>
																<xsl:value-of select="viewcontent/viewtext1"/>
															</option>
														</xsl:for-each>
													</select>
												</td>
											</tr>
											<tr>
												<td class="fc"><xsl:value-of select="document/captions/phone/@caption"/> :</td>
												<td>
													<input type="text" name="phone" value="{document/fields/phone}" size="20" class="td_editable" style="width:301px;">
														<xsl:if test="$editmode != 'edit'">
															<xsl:attribute name="readonly">readonly</xsl:attribute>
															<xsl:attribute name="class">td_noteditable</xsl:attribute>
														</xsl:if>
													</input>
												</td>
											</tr>
											<!-- <tr>
												<td class="fc">Ранг :</td>
												<td>
													<input type="text" name="rank" value="{document/fields/rank}" size="20" class="td_editable" style="width:301px;">
														<xsl:if test="document/@editmode != 'edit'">
															<xsl:attribute name="readonly">readonly</xsl:attribute>
															<xsl:attribute name="class">td_noteditable</xsl:attribute>
														</xsl:if>
														<xsl:attribute name="onkeydown">javascript:Numeric(this)</xsl:attribute>
													</input>
												</td>
											</tr>
											<tr>
												<td class="fc">Индекс :</td>
												<td>
													<input type="text" name="index" value="{document/fields/index}" size="20" class="td_editable" style="width:301px;">
														<xsl:if test="document/@editmode != 'edit'">
															<xsl:attribute name="readonly">readonly</xsl:attribute>
															<xsl:attribute name="class">td_noteditable</xsl:attribute>
														</xsl:if>
													</input>
												</td>
											</tr> -->
											<tr>
												<td class="fc"><xsl:value-of select="document/captions/mailing/@caption"/> :</td>
												<td>
													<select name="sendto" class="select_editable" style="width:311px;">
														<xsl:if test="$editmode != 'edit'">
															<xsl:attribute name="disabled">disabled</xsl:attribute>
															<xsl:attribute name="class">select_noteditable</xsl:attribute>
														</xsl:if>
														<option value="1">
															<xsl:if test="document/fields/sendto =1">
																<xsl:attribute name="selected">selected</xsl:attribute>
															</xsl:if>
															Пользователю и замещающему
														</option>
														<option value="2">
															<xsl:if test="document/fields/sendto =2">
																<xsl:attribute name="selected">selected</xsl:attribute>
															</xsl:if>
															Только пользователю
														</option>
														<option value="3">
															<xsl:if test="document/fields/sendto =3">
																<xsl:attribute name="selected">selected</xsl:attribute>
															</xsl:if>
															Только замещающему
														</option>
														<option value="4">
															<xsl:if test="document/fields/sendto =4">
																<xsl:attribute name="selected">selected</xsl:attribute>
															</xsl:if>
															Отключить
														</option>
													</select>
												</td>
											</tr>
											<tr>
												<td class="fc"><xsl:value-of select="document/captions/comment/@caption"/> :</td>
												<td>
													<textarea class="textarea_editable" rows="4" value="{document/fields/comment}" name="comment" cols="45" style="width:301px;">
														<xsl:if test="$editmode != 'edit'">
															<xsl:attribute name="readonly">readonly</xsl:attribute>
															<xsl:attribute name="class">textarea_noteditable</xsl:attribute>
														</xsl:if>
														<xsl:value-of select="document/fields/comment"/>
													</textarea>
												</td>
											</tr>
											<tr>
												<td class="fc"><xsl:value-of select="document/captions/role/@caption"/> :</td>
												<td>
													<xsl:for-each select="document/glossaries/roles/entry">
														<xsl:variable name="role" select="name"/>
														<input type="checkbox" name="role" value="{name}">
															<xsl:if test="/request/document/fields/role[entry = $role]">
																<xsl:attribute name="checked">checked</xsl:attribute>
															</xsl:if>
															<xsl:if test="/request/document/fields[role = $role]">
																<xsl:attribute name="checked">checked</xsl:attribute>
															</xsl:if>
															<xsl:value-of select="name"/>&#xA0;
															<br/>
														</input>
													</xsl:for-each>
												</td>
											</tr>
											<xsl:if test = "document/fields/group/@islist = 'true' or document/fields/group/@attrval !=''">
												<tr>
													<td class="fc"></td>
													<td>
														<xsl:if test = "document/fields/group/@islist = 'true'">
															<xsl:for-each select="document/fields/group/entry">
																<input type="hidden" name="group" value="{@attrval}"/>
															</xsl:for-each>
														</xsl:if>
														<xsl:if test = "not(document/fields/group/@islist)">
															<input type="hidden" name="group" value="{document/fields/group/@attrval}"/>
														</xsl:if>
													</td>
												</tr>
											</xsl:if>
										</table>
									</div>
									<input type="hidden" name="type" value="save"/>
									<input type="hidden" name="id" value="employer"/>
									<input type="hidden" name="key" value="{document/@docid}"/>
									<input type="hidden" name="doctype" value="{document/@doctype}"/>
									<input type="hidden" name="parentdoctype" id="parentdoctype" value="{document/@parentdoctype}"/>
									<input type="hidden" name="parentdocid" id="parentdocid" value="{document/@parentdocid}"/>
									<input type="hidden" name="currentuser" value="{/request/@userid}"/>
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