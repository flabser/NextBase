<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../templates/form.xsl"/>
	<xsl:import href="../templates/sharedactions.xsl"/>
	<xsl:variable name="doctype" select="request/document/captions/doctypemultilang/@caption"/>
	<xsl:variable name="editmode" select="/request/document/@editmode"/>
	<xsl:output method="html" encoding="utf-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" indent="no"/>
	<xsl:variable name="skin" select="request/@skin"/>
	<xsl:template match="/request">
	<html>
		<head>
			<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
			<title>
				<xsl:if test="document/@status != 'new'">
					<xsl:value-of select="document/@viewtext"/> -  Web Technical Supervision
				</xsl:if>
				<xsl:if test="document/@status = 'new'">
					Новое &#xA0;<xsl:value-of select="lower-case($doctype)" />  - Web Technical Supervision
				</xsl:if>
			</title>
			<link rel="stylesheet" media="print" href="classic/css/print.css"/>
			<xsl:call-template name="cssandjs"/>
   			<xsl:call-template name="markisread"/>
			<xsl:call-template name="htmlareaeditor"/>
			<script>$(document).ready(function(){$("#countAtt").html($(".test").length)})</script>
			<script>$(document).ready(function(){
				updateheader('<xsl:value-of select="document/fields/project/@attrval"/>')
			})</script>
	</head>
	<body>
		<div id="docwrapper">
				<div class="button_panel">
					<button class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" id="btntocoordinate" style="margin-left:5px" title="Распечатать документ">
									<xsl:attribute name="onclick">javascript:window.print()</xsl:attribute>
									<span>
										<img src="/SharedResources/img/classic/icons/printer.png" class="button_img"/>
										<font style="font-size:12px; vertical-align:top">Распечатать документ</font>
									</span>
								</button>
					<span style="float:right"><xsl:call-template name="cancel"/></span>
				</div>
				<div style="position:absolute; top:40px; left:50px; right:50px; height:250px;">
					<img id="imgformheader" src="classic/img/image001.png" style="width:100%"/>
				</div>
				<div style="position:absolute; top:290px; width:100%; text-align:right; right:50px">
					<font style="font-size:14px"><b>“<ins>&#xA0;&#xA0;<xsl:value-of select="substring(document/fields/projectdate, 1,2)"/>&#xA0;&#xA0;</ins>” <ins>&#xA0;&#xA0;&#xA0;&#xA0;<xsl:value-of select="substring(document/fields/projectdate, 4,2)"/>&#xA0;&#xA0;&#xA0;&#xA0;</ins> &#xA0;&#xA0;<xsl:value-of select="substring(document/fields/projectdate, 7,4)"/>г.</b></font>
				</div>
				<div style="position:absolute; top:350px; width:100%; text-align:center">
					<font style="font-size:14px"><b>ПРЕДПИСАНИЕ № <ins>&#xA0;<xsl:value-of select="document/fields/vnnumber"/>&#xA0;</ins></b></font>
				</div>
				<div style="position:absolute; top:380px; width:100%; text-align:center">
					<table style="width:80%; margin-left:10%; margin-top:50px">
						<tr>
							<td style="text-align:left">
								<b>Объект : </b> <xsl:value-of select="document/fields/project"/>
							</td>
						</tr>
						<tr>
							<td style="text-align:left">
								<b>Ответственное лицо заказчика : </b> <xsl:value-of select="document/fields/responsible"/> - <xsl:value-of select="document/fields/respost"/>
							</td>
						</tr>
						<tr>
							<td style="text-align:left">
								<b>Контрагент : </b> <xsl:value-of select="document/fields/contragent"/>
							</td>
						</tr>
					</table>
					<table style="width:90%; margin-left:5%; margin-top:50px; border-collapse:collapse">
						<tr>
							<td style="text-align:left; border:1px solid black; text-align:center">
								<b>Содержание</b>
							</td>
							<td style="text-align:left; border:1px solid black; text-align:center">
								<b>Срок  выполнения</b>
							</td>
							<td style="text-align:left; border:1px solid black; text-align:center">
								<b>Отметка об устранении</b>
							</td>
						</tr>
						<tr>
							<td style="text-align:left; border:1px solid black; padding:7px">
								 Место возникновения : <xsl:if test="document/fields/origin !=''"><xsl:value-of select="document/fields/origin"/></xsl:if>
								  <xsl:if test="document/fields/origin =''">коорд.:<xsl:value-of select="document/fields/coordinats"/>,город:<xsl:value-of select="document/fields/city"/>, улица: <xsl:value-of select="document/fields/street"/>, д.: <xsl:value-of select="document/fields/house"/>,под.: <xsl:value-of select="document/fields/porch"/>, этаж: <xsl:value-of select="document/fields/floor"/>, кв. :<xsl:value-of select="document/fields/apartment"/></xsl:if>
								  <br/>
								 Вид работ : <xsl:value-of select="document/fields/category"/> - <xsl:value-of select="document/fields/subcategory"/><br/>
								 <xsl:value-of select="document/fields/contentsource"/> 
							</td>
							<td style="text-align:center; border:1px solid black">
								<xsl:value-of select="substring(document/fields/ctrldate, 0,11)"/>
							</td>
							<td style="text-align:left; border:1px solid black">
								
							</td>
						</tr>
					</table>
					<table style="width:90%; margin-left:5%; margin-top:40px; border-collapse:collapse">
						<tr>
							<td style="text-align:left;"><b>Приложение: в количестве <font id="countAtt"></font>  шт.</b></td>
						</tr>
					</table>
					<table style="width:90%; margin-left:5%; margin-top:40px; border-collapse:collapse">
						<tr>
							<td style="text-align:left;"><b>Выдал :  </b></td>
							<td style="text-align:left;"><ins>&#xA0;&#xA0;<xsl:value-of select="document/fields/author"/> - <xsl:value-of select="document/fields/position"/>&#xA0;&#xA0;</ins></td>
							<td style="text-align:left;"><font style="margin-left:50px"> ____________________________</font></td>
						</tr>
						<tr>
							<td style="text-align:left;"></td>
							<td style="text-align:left; text-align:center"> <sup>(ФИО, должность)</sup></td>
							<td style="text-align:left; text-align:center"><sup> (Подпись, дата)</sup></td>
						</tr>
						<tr>
							<td style="text-align:left;" colspan="3"><b> Принял</b> </td>
						</tr>
						<tr>
							<td style="text-align:left;"><b>Отв. лицо  заказчика:</b></td>
							<td style="text-align:left;"><ins>&#xA0;&#xA0;<xsl:value-of select="document/fields/responsible"/> - <xsl:value-of select="document/fields/respost"/>&#xA0;&#xA0;</ins></td>
							<td style="text-align:left;"><font style="margin-left:50px"> ____________________________</font></td>
						</tr>
						<tr>
							<td style="text-align:left;"></td> 
							<td style="text-align:left; text-align:center"><sup> (ФИО,  должность)  </sup></td>
							 <td style="text-align:left; text-align:center"><sup>  (Подпись, дата)</sup></td>
						</tr>
						<tr>
							<td style="text-align:left;" colspan="3"><b>Принял</b></td>
						</tr>
						<tr>
							<td style="text-align:left;"><b>Отв.лицо Контрагента:</b> </td>
							<td style="text-align:left;"> _________________________________</td>
							<td style="text-align:left;"><font style="margin-left:50px"> ____________________________</font></td>
						</tr>
						<tr>
							<td style="text-align:left;"></td>
							<td style="text-align:left; text-align:center"><sup> (ФИО,  должность)  </sup></td>
							<td style="text-align:left; text-align:center"><sup> (Подпись, дата)</sup></td>
						</tr>
					</table>
					<table style="width:90%; margin-left:5%; margin-top:40px; border-collapse:collapse">
						<xsl:variable name='docid' select="document/@docid"/>
						<xsl:variable name='doctype' select="document/@doctype"/>
						<xsl:variable name='formsesid' select="formsesid"/>
						<xsl:for-each select="document/fields/rtfcontent/entry">
							<xsl:variable name='id' select='position()'/>
							<xsl:variable name='filename' select='@filename'/>
							<xsl:variable name="extension" select="tokenize(lower-case($filename), '\.')[last()]"/>
							<xsl:variable name="resolution">
								<script>
									return $(document).width();
								</script>
							</xsl:variable>
							<xsl:if test="$extension = 'jpg' or $extension = 'jpeg' or $extension = 'gif' or $extension = 'bmp' or $extension = 'png' or $extension = 'tif'">
							<tr>
								<xsl:attribute name='id'><xsl:value-of select='$id'/></xsl:attribute>
								<td class="fc"></td>
								<td colspan="2">
									<div class="test" style="width:100%;  display:block">
										<img class="imgAtt" title="{$filename}" style="border:1px solid lightgray; max-width:700px; max-height:600px; margin-right:25%">
												<xsl:attribute name="style">border:1px solid lightgray; max-width:630px; max-height:600px; margin-right:30%</xsl:attribute>
											<xsl:attribute name="onload">checkImage(this)</xsl:attribute>
											<xsl:attribute name='src'>Provider?type=getattach&amp;formsesid=<xsl:value-of select="$formsesid"/>&amp;doctype=<xsl:value-of select="$doctype"/>&amp;key=<xsl:value-of select="$docid"/>&amp;field=rtfcontent&amp;file=<xsl:value-of select='$filename'/></xsl:attribute>
										</img>
										<br/>
										<xsl:value-of select="$filename"/>
										<br/>
										<xsl:if test="comment !=''">
											<div style=" max-width:800px; color:#777; font-size:12px; text-align:left; ">комментарий : <xsl:value-of select="comment"/></div>
										</xsl:if>	
									</div>
								</td>
							</tr>
						</xsl:if>
					</xsl:for-each>
						<!-- <xsl:choose>
							<xsl:when test="document/fields/rtfcontent/@islist = 'true'">
								<xsl:for-each select="document/fields/rtfcontent/entry">
									<tr>
										<xsl:variable name='id' select='position()'/>
										<xsl:variable name='filename' select='.'/>
										<xsl:variable name="extension" select="tokenize(lower-case($filename), '\.')[last()]"/>
										<xsl:variable name="resolution">
											<script>
												return $(document).width();
											</script>
										</xsl:variable>
										<xsl:attribute name='id'>
											<xsl:value-of select='$id'/>
										</xsl:attribute>
										<td>
											<br/>
											<div class="test" style="width:90%;  display:block">
												<xsl:if test="$extension = 'jpg' or $extension = 'jpeg' or $extension = 'gif'
												 or $extension = 'bmp' or $extension = 'png' or $extension = 'tif'">
													<img class="imgAtt" title="{$filename}" style="border:1px solid lightgray; max-width:800px; max-height:600px;">
														<xsl:if test="/request/@useragent = 'IE'">
															<xsl:attribute name="style">border:1px solid lightgray; max-width:800px; max-height:600px; margin-right:10%</xsl:attribute>
														</xsl:if>
														<xsl:attribute name="onload">checkImage(this)</xsl:attribute>
														<xsl:attribute name='src'>Provider?type=getattach&amp;formsesid=<xsl:value-of select="$formsesid"/>&amp;doctype=<xsl:value-of select="$doctype"/>&amp;key=<xsl:value-of select="$docid"/>&amp;field=rtfcontent&amp;file=<xsl:value-of select='$filename'/></xsl:attribute>
													</img>
													<br/>
													<xsl:value-of select="$filename"/>
													<br/>
													<xsl:if test="@attrval !=''">
										<div style=" max-width:800px; color:#777; font-size:12px; text-align:left; ">комментарий : <xsl:value-of select="@attrval"/></div>
									</xsl:if>
												</xsl:if>
											</div>
										</td>
									</tr>
									
								</xsl:for-each>
							</xsl:when>
							<xsl:when test="document/fields/rtfcontent !=''">
								<xsl:variable name="filename" select="document/fields/rtfcontent" />
								<tr>
									<xsl:variable name='id' select='position()' />
									<xsl:attribute name='id'><xsl:value-of select='$id' /></xsl:attribute>
									<xsl:variable name="extension" select="tokenize(lower-case($filename), '\.')[last()]"/>
									<td><br/>
										<div class="test" style="width:90%;  display:inline-block;">
											<xsl:if test="$extension = 'jpg' or $extension = 'jpeg' or $extension = 'gif'
											 or $extension = 'bmp' or $extension = 'png' or $extension = 'tif'">
												<img style="border:1px solid lightgray; ; max-width:800px; max-height:600px" title="{$filename}">
													<xsl:if test="/request/@useragent = 'IE'">
															<xsl:attribute name="style">border:1px solid lightgray; max-width:800px; max-height:600px; margin-right:10%</xsl:attribute>
														</xsl:if>
													<xsl:attribute name="onload">checkImage(this)</xsl:attribute>
													<xsl:attribute name='src'>Provider?type=getattach&amp;formsesid=<xsl:value-of select="$formsesid"/>&amp;doctype=<xsl:value-of select="$doctype"/>&amp;key=<xsl:value-of select="$docid"/>&amp;field=rtfcontent&amp;file=<xsl:value-of select='$filename'/></xsl:attribute>
												</img>
											</xsl:if>
										</div>
									</td>
								</tr>
								<xsl:if test="document/fields/rtfcontent/@attrval !=''">
									<tr>
										<td style="color:#777; font-size:12px; text-align:left"><div style="width:90%">комментарий : <xsl:value-of select="document/fields/rtfcontent/@attrval"/></div></td>
									</tr>
								</xsl:if>
							</xsl:when>
						</xsl:choose> -->
						</table>
						<br/>	
						<br/>
					</div>
				</div>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>