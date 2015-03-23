<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output
		method="html"
		encoding="utf-8"  
		indent="no" />

	<xsl:template match="/request/content">
<xsl:text disable-output-escaping="yes">&lt;</xsl:text>!DOCTYPE html<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
<html>
	<head>
		<title>Bank Finance&#xA0;-<xsl:value-of select="org"/></title>

		<link type="text/css" rel="stylesheet" href="/SharedResources/jquery/css/jquery-ui-1.10.4.custom/css/smoothness/jquery-ui-1.10.4.custom.min.css" />
		<link type="text/css" rel="stylesheet" href="classic/css/all.min.css"/>

		<script type="text/javascript" src="/SharedResources/jquery/js/jquery.min.js"></script>
		<script type="text/javascript" src="/SharedResources/jquery/js/jquery.ui.min.js"></script>
		<script type="text/javascript" src="/SharedResources/jquery/js/jquery-1.4.2.js"></script>
		<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.core.js"></script>
		<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.widget.js"></script>
		<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.mouse.js"></script>
		<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.button.js"></script>
		<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.draggable.js"></script>
		<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.position.js"></script>
		<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.dialog.js"></script>
		<script type="text/javascript" src="/SharedResources/jquery/js/cookie/jquery.cookie.js"></script>
		<script type="text/javascript" src="/SharedResources/jquery/js/jquery.hotkeys-0.7.9.js"></script>
		<script type="text/javascript" src="/SharedResources/scripts/common.js?vers=1"></script>
		<script type="text/javascript" src="/SharedResources/scripts/start.js?vers=1"></script>
		<script type="text/javascript">
		$(function() {
			$( ".button" ).button({
         		text: true
     		})
    	});
		</script>
	</head>
	<body onLoad="getCookie('smart')" onKeyDown="key(event)">
		<noscript><h1 style="text-align:center;">Приложение требует поддержки javascript</h1></noscript>
		<div style="display:none;">AuthorizationPage</div>
		<br />
		<br />
		<form action="Login" method="post" id="sign-frm" name="form" onsubmit="ourSubmit();return false;">

		<table width="100%" style="margin-top:10%;margin-bottom:25px;" border="0">
			<tr style="text-align:center">
				<td>
					<font class="sh" style="font-family:arial; font-size:40px;">Bank Finance 2013</font>
					<div style="margin-top:1%; font-family:verdana; font-size:10pt">
						F-labs v 1.0 2011
						 <a title="Справка" style="margin-left:1em">
						     <xsl:attribute name="href">Provider?type=static&amp;id=help</xsl:attribute>
						     <img src="/SharedResources/img/classic/help.gif" style="border:none" />										
		                  </a>
						<br />
						<xsl:value-of select="year" />	
					</div>
					<br />
					<br />
					<div style="margin-left:30%;width:40%; height:3px; background-color:#d1d1d1;"></div>
				</td>
			</tr>
			<tr>
				<td align="center">
					<div style="margin-top:5%; text-align:right; width:27%">
						<table>
							<tr>
								<td style="text-align:right">
									<font style="font-family:arial; font-size:16px;">
										Пользователь&#xA0;:
									</font>
								</td>
								<td> 
									<input type="text" size="30" name="login" id="login" value="" style="border: 1px solid #d1d1d1;" />
								</td>
							</tr>
							<tr>
								<td style="text-align:right">	
									<font style="font-family:arial; font-size:16px; ">Пароль&#xA0;:</font>
						 		</td>
						 		<td>
						 			<input type="password" size="30" name="pwd" id="pwd" value="" style="border: 1px solid #d1d1d1;" />
								</td>
							</tr>
							<tr>
								<td></td>
								<td align="left">
									<label class="float-left" style="margin-top:4px;">
										<input type="checkbox" id="noauth" name="noauth" value="1" /> Чужой компьютер
									</label>
								</td>
							</tr>
							<tr>
								<td> </td>
								<td align="left">
									<input type="button" class="button" value="Вход" style="width:60px" onClick='javascript:ourSubmit()'/>
								</td>
							</tr>
						</table>
					</div>
				</td>
			</tr>
			</table>

			<input type="hidden" name="type" value="login" />
		</form>
		<div id="foooter" style="width:99%; margin:auto; font-size:0.9em; border-top:1px solid #ccc; position:absolute; bottom:20px; padding-top:7px;">
			<div class="float-left">
				&#169; 2011 <a href="http://www.flabs.kz" target="_blank">Flabs</a>
				Версия 2.0
				<a title="Справка" style="margin-left:1em">
					<xsl:attribute name="href">Provider?type=static&amp;id=help</xsl:attribute>
					<img src="/SharedResources/img/classic/help.gif" />
				</a>
			</div>
			<div class="float-right">
				Язык&#xA0;:
				<select name="lang" id="lang">
					<xsl:variable name='currentlang' select="../@lang" />
					<xsl:attribute name="onchange">javascript:changeSystemSettings(this)</xsl:attribute>
					<xsl:for-each select="glossaries/langs/entry">
						<option>
							<xsl:attribute name="value"><xsl:value-of select="id" /></xsl:attribute>
							<xsl:if test="$currentlang = id">
								<xsl:attribute name="selected">selected</xsl:attribute>
							</xsl:if>
							<xsl:value-of select="name" />
						</option>
					</xsl:for-each>
				</select>
				&#xA0;
				Оформление&#xA0;:
				<select name="skin" id="skin">
					<xsl:variable name='currentskin' select="../@skin" />
					<xsl:attribute name="onchange">javascript:changeSystemSettings(this)</xsl:attribute>
					<xsl:for-each select="glossaries/skins/entry">
						<option>
							<xsl:attribute name="value"><xsl:value-of select="id" /></xsl:attribute>
							<xsl:if test="$currentskin = id">
								<xsl:attribute name="selected">selected</xsl:attribute>
							</xsl:if>
							<xsl:value-of select="name" />
						</option>
					</xsl:for-each>
				</select>
			</div>
		</div>
		<div id="dialog-message" title="Предупреждение" style="display:none;">
			<br/>
			<center class="message_dialog" style="height:40px"></center>
		</div>
	</body>
</html>
	</xsl:template>
</xsl:stylesheet>