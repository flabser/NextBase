<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" encoding="utf-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
	 doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" indent="yes"/>
	<xsl:variable name="skin" select="request/@skin"/>
	<xsl:template match="/request/content">
		<html>
			<head>
				<title><xsl:value-of select="content/org"/> - WTS</title>
				<link rel="stylesheet" href="{$skin}/css/start.css"/>
				<script type="text/javascript" src="classic/scripts/start.js"/>
				<script type="text/javascript" src="classic/scripts/form.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/jquery-1.4.2.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.widget.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.core.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.effects.core.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.datepicker.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.datepicker-ru.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.mouse.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.draggable.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.position.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.button.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.dialog.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/cookie/jquery.cookie.js"/>
				<link type="text/css" rel="stylesheet" href="/SharedResources/jquery/css/smoothness/jquery-ui-1.8.20.custom.css"/>
				<script type="text/javascript">
					$(document).ready(function(){
						$("button").button()
					
					});
						
<!-- 						refreshAction();  -->
				</script>
			</head>
			<body onKeyDown="key(event)">
				<div id="wrapper">
					<div id="rightdiv">
						<div id="header" style="background:#597BAF">
							<span style="background:#fff; position:absolute; top:100px; left:50px; width:70px; height:50px; border-radius:12px"></span>
							<span style="background:#fff; position:absolute; top:155px; left:50px; width:70px; height:50px; border-radius:12px"></span>
							<span style="background:#fff; position:absolute; top:155px; left:125px; width:70px; height:50px; border-radius:12px"></span>
							
							<div style="height:150px; width:450px; border:1px solid #597BAF; position:absolute; top:310px; margin:0px 10%; background:#597BAF; border-radius:15px ; text-align:center">
								<br/>
									<br/>
									<br/>
									<br/>
									<br/>
								<font style="color:#000; font-size:25px; font-family:verdana; margin-top:5px">
									
									<xsl:value-of select="captions/documentmanager/@caption"/>&#xA0;<xsl:value-of select="content/org"/>
								</font>
							</div>
							<br/>
									<br/><br/>
									<br/>
									<br/>
							<div style="height:200px; width:450px; border:1px solid #597BAF;  margin-left:55%; background:#fff; border-radius:12px ">
								<form action="Login" method="post" id="frm" name="form">
									<xsl:if test="../@userid = 'anonymous'">
										<table style="width:320px; margin:5px auto">
												<tr>
													<td style="width:140px; text-align:center; padding:20px" colspan="2">
														<font class="sh" style="font-size:22px; color:#597BAF">
															Авторизация
														</font>
													</td>
												</tr>
												<tr>
													<td style="width:140px; text-align:right">
														<font class="sh" style="font-size:10.2pt; color:#597BAF">
															<xsl:value-of select="captions/user/@caption"/> :
														</font>
													</td>
													<td>
														<input id="login"  name="login" data-dojo-type="dijit.form.TextBox"  style="width:185px; height: 16px; padding: 3px 3px 3px 5px;"/>
													</td>
												</tr>
												<tr>
													<td style="width:140px; text-align:right">
														<font class="sh" style="font-size:10.2pt; color:#597BAF">
															<xsl:value-of select="captions/password/@caption"/> :
														</font>
													</td>
													<td>
														<input type="password" id="pwd" name="pwd" data-dojo-type="dijit.form.TextBox"  style="width:185px; height: 16px; padding: 3px 3px 3px 5px;"/>
													</td>
												</tr>
												<tr>
													<td style="width:200px;">
													</td>
													<td style="padding-top:7px">
														<input dojoType="dijit.form.CheckBox" type="checkbox" id="cbx" name="noauth"/>
														<span>
															<font style="font-family:verdana; font-size:10pt; margin-left:5px; color:#597BAF"><xsl:value-of select="captions/anothercomp/@caption"/></font>
														</span>	
													</td>
												</tr>
												<tr>
													<td style="width:200px;">
													</td>
													<td style="padding: 5px auto">
														<button id="btn" type="button"  style="font-weight:bold; font-size:13px; margin-top:5px ">
			       		 									<xsl:attribute name="onclick">javascript:ourSubmit("default")</xsl:attribute>	
			       		 									<font style="vertical-align:3px">
			       		 										<xsl:value-of select="captions/login/@caption"/>
			       		 									</font>
			       		 									<img src="/SharedResources/img/classic/login.gif" style="border:none; margin-left:5px;"/>
			    										</button>
													</td>
												</tr>
										</table>
									</xsl:if>
									<xsl:if test="../@userid != 'anonymous'">
										<table style="width:320px; margin:50px auto">
												<tr>
													<td style="width:200px; text-align:center" colspan="2">
														<font style="font-size:1.2em; color:#597BAF">
															 <b><xsl:value-of select="../@username"/></b>
														</font>
													</td>
												</tr>
												<tr>
													<td style="width:350px; text-align:center; padding-top:30px">
														<button id="btn" type="button"  style="font-weight:bold; font-size:13px;">
															<xsl:attribute name="onclick">javascript:ourSubmit("auth")</xsl:attribute>												
															<font  class="button" style="margin-right:5px; font-size:13px; font-family:verdana; vertical-align:3px ">
																<xsl:value-of select="captions/login/@caption"/>
															</font>	
															<img src="/SharedResources/img/classic/login.gif" style="border:none; margin-left:5px; margin-top:2px;  "/>
														</button>
														<button id="btnlogout" type="button" style="font-weight:bold; font-size:13px; margin-left:5px; width:200px">
															<xsl:attribute name="onclick">javascript:window.location.href="Logout"</xsl:attribute>	
															<xsl:attribute name="title" select="captions/logout/@caption"/>
															<font  class="button" style="margin-right:5px;  font-size:13px; font-family:verdana; vertical-align:3px">
																<xsl:value-of select="captions/logout/@caption"/>
															</font> 
															<img src="/SharedResources/img/iconset/door_in.png" style="border:none; margin-left:5px; margin-top:1px; width:18; height:18px"/>						
														</button>
													</td>
										</tr>
										</table>
									</xsl:if>
									<input type="hidden" size="30" name="login" id="login">
											<xsl:attribute name="value" select="../@userid"/>
										</input>
										<input type="hidden" size="30" name="pwd" value="" id="pwd"/>
								</form>
							</div>
							
							</div>
							<span style="background:#fff; position:absolute; top:365px; left:0px; width:10%; height:30px; border-radius: 0px 12px 0px 0px"></span>
							<span style="background:#fff; position:absolute; top:365px; left:10%; margin-left:452px; right:0px; height:30px; border-radius: 12px 0px 0px 0px"></span>
							<span style="background:#597BAF; position:absolute; top:600px; right:50px; width:70px; height:50px; border-radius:12px"></span>
							<span style="background:#597BAF; position:absolute; top:655px; right:50px; width:70px; height:50px; border-radius:12px"></span>
							<span style="background:#597BAF; position:absolute; top:655px; right:125px; width:70px; height:50px; border-radius:12px"></span>
							<div style="width:100%; position:absolute; bottom:150px; text-align:center; display:none">
								<br/>
								<font style="color:#000; font-size:36px; font-family:Arial Cyr ">
									<xsl:value-of select="captions/documentmanager/@caption"/>&#xA0;<xsl:value-of select="content/org"/>
								</font>
							</div>
					</div>
				</div>
				<input type="hidden" name="type" value="login"/>
				<div id="footer" style="padding-top:2px">
					<span style=" float:left; margin-left:5px">
						<a class="actionlink" target="blank" href="http://4ms.kz" style="color: #444444 ; font-size:11px; "><font style="margin-left:5px;font-size:11px; color:#597BAF ">QC</font></a>  
						<font style="color:#597BAF">&#xA0;&#xA0;<xsl:value-of select="content/version"/>&#xA0;&#xA0;&#169;&#xA0;&#xA0;2012&#xA0;</font>							
						<a title="Справка" style="margin-left:1em; position:absolute; bottom:6px">
							<xsl:attribute name="href">Provider?type=static&amp;id=help_category_list</xsl:attribute>
					   		<img src="/SharedResources/img/classic/help.png"/>										
			        	</a>&#xA0;&#xA0;
					</span>		
					<span style=" float:right; margin-right:5px">
						<font style="color:#597BAF">
							<xsl:value-of select="captions/lang/@caption"/> :
						</font>	
						<select  dojoType="dijit.form.Select" id="lang" name="lang" autoComplete="false" invalidMessage="Введеного вами языка не существует"  style="font-size:8pt; width:100px">
							<xsl:variable name='chinese' select="captions/chinese/@caption"/>
							<xsl:variable name='currentlang' select="../@lang"/>
							<xsl:attribute name="onchange">javascript:changeSystemSettings(this)</xsl:attribute>
							<xsl:for-each select="glossaries/langs/entry">
								<option value="{id}">
									<xsl:if test="$currentlang = id">
										<xsl:attribute name="selected">selected</xsl:attribute>
									</xsl:if>
									<xsl:if test="id = 'CHN'">
										<xsl:value-of select="$chinese"/>
									</xsl:if>
									<xsl:if test="id != 'CHN'">
										<xsl:value-of select="name"/>
									</xsl:if>
								</option>
							</xsl:for-each>
						</select>&#xA0;
						<font style="color:#597BAF">
							<xsl:value-of select="captions/skin/@caption"/> :
						</font>
						<select  dojoType="dijit.form.Select" id="skin" name="skin" autoComplete="false" invalidMessage="Введеного вами оформлления не существует"  style="font-size:8pt; width:100px">
							<xsl:variable name='currentskin' select="../@skin"/>
							<xsl:attribute name="onchange">javascript:changeSystemSettings(this)</xsl:attribute>
							<xsl:for-each select="glossaries/skins/entry">
								<option value="{id}">
									<xsl:if test="$currentskin = id">
										<xsl:attribute name="selected">selected</xsl:attribute>
									</xsl:if>
									<xsl:value-of select="name"/>
								</option>
							</xsl:for-each>
						</select>
					</span>									
				</div>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>