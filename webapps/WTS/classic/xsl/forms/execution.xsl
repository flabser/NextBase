<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../templates/form.xsl"/>
	<xsl:import href="../templates/sharedactions.xsl"/>
	<xsl:variable name="doctype"><xsl:value-of select="request/document/captions/doctypemultilang/@caption"/></xsl:variable>
	<xsl:variable name="threaddocid" select="document/@granddocid"/>
	<xsl:variable name="path" select="/request/@skin"/>
	<xsl:output method="html" encoding="utf-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" indent="yes"/>
	<xsl:variable name="skin" select="request/@skin"/>
	<xsl:template match="/request">
	<xsl:variable name="filename" select="document/fields/pdocrtfcontent"/>
		<html>
			<head>
				<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
				<title>
					<xsl:if test="document/@status != 'new'">
						<xsl:value-of select="document/@viewtext"/> - Web Technical Supervision
					</xsl:if>
					<xsl:if test="document/@status = 'new'">
						Новая &#xA0;<xsl:value-of select="lower-case($doctype)"/>  - Web Technical Supervision
					</xsl:if>
				</title>
				<xsl:call-template name="cssandjs"/>
				<xsl:if test="document/@editmode= 'edit'">
					<script>
						$(function() {
							$('#dateisp').datepicker({
								showOn: 'button',
								buttonImage: '/SharedResources/img/iconset/calendar.png',
								buttonImageOnly: true,
								regional:['ru']
							});
						});
					</script>
				</xsl:if>
				<xsl:call-template name="markisread"/>
				<script type="text/javascript">
					$(document).ready(function(){hotkeysnav()})
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
									   case 71:
									  		<!-- клавиша g -->
									     	e.preventDefault();
									     	$("#btngrantaccess").click();
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
							$("#btngrantaccess").hotnav({keysource:function(e){ return "g"; }});
							$("#btnsavedoc").hotnav({keysource:function(e){ return "s"; }});
							$("#currentuser").hotnav({ keysource:function(e){ return "u"; }});
							$("#logout").hotnav({keysource:function(e){ return "q"; }});
							$("#helpbtn").hotnav({keysource:function(e){ return "h"; }});
						}
					]]>
				</script>
			</head>
			<body>
				<div id="docwrapper">
					<xsl:call-template name="documentheader"/>	
					<div class="formwrapper">
						<div class="formtitle">
							<div style="float:left" class="title">
								<xsl:value-of select="$doctype"/>&#xA0;<xsl:value-of select="document/captions/createdate/@caption"/>&#xA0;<xsl:value-of select="document/fields/finishdate"/>
							</div>
						</div>	
						<div class="button_panel">
							<span style="vertical-align:12px; float:left">
								<xsl:call-template name="showxml"/>
								<xsl:call-template name="saveKI"/>
							</span>
							<span style="float:right">
				            	<xsl:call-template name="cancel"/>
				            </span>
		           		</div>
						<div style="clear:both"/>
						<div style="-moz-border-radius:0px;height:1px; width:100%; margin-top:10px;"/>
						<div style="clear:both"/>
							<div id="tabs">
								<ul class="ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-all">
									<li class="ui-state-default ui-corner-top">
										<a href="#tabs-1"><xsl:value-of select="document/captions/properties/@caption"/></a>
									</li>
									<li class="ui-state-default ui-corner-top">
										<a href="#tabs-2"><xsl:value-of select="document/captions/files/@caption"/></a>
									</li>
									<li class="ui-state-default ui-corner-top">
										<a href="#tabs-3"><xsl:value-of select="document/captions/additional/@caption"/></a>
									</li>
								</ul>
								<div class="ui-tabs-panel" id="tabs-1">
									<form action="Provider" name="frm" method="post" id="frm" enctype="application/x-www-form-urlencoded"> 				
										<div display="block"  id="property">
											<br/>
											<table width="100%" border="0">
											<xsl:if test="document/fields/grandpardocid !=''">
												<tr>
													<td class="fc">
														<font style="vertical-align:top"><xsl:value-of select="document/captions/parentdocument/@caption"/> :</font>
													</td>
													<td>
														<a href="" class="doclink">
															<xsl:attribute name="href">Provider?type=document&amp;id=<xsl:value-of select="document/fields/grandparform"/>&amp;key=<xsl:value-of select="document/fields/grandpardocid"/></xsl:attribute>
															<font>
																<xsl:value-of select="document/fields/pdocviewtext"/>
															</font>
														</a>
														<xsl:if test="$filename!=''">
															<a href="">
																<xsl:attribute name="href">Provider?type=getattach&amp;formsesid=<xsl:value-of select="formsesid"/>&amp;key=<xsl:value-of select="document/fields/grandpardocid"/>&amp;field=rtfcontent&amp;file=<xsl:value-of select='$filename'/></xsl:attribute>
																<img src="/SharedResources/img/classic/icons/attach.png" style="margin-left:5px"/>
															</a>
														</xsl:if>
													</td>
												</tr>
											</xsl:if>
											<tr>
												<td class="fc">
													<font style="vertical-align:top"><xsl:value-of select="document/captions/executor/@caption"/> :</font>
													<!-- <xsl:if test="document/@editmode ='edit'">
														<a href="">
															<xsl:attribute name="href">javascript:dialogBoxStructure('bossandemppicklist','false','intexecut','frm', 'intexecuttbl');</xsl:attribute>								
															<img src="/SharedResources/img/iconset/report_magnify.png"/>
														</a>
													</xsl:if> -->
												</td>
												<td>
													<table id="intexecuttbl">
														<tr>
															<td class="td_editable" style="width:600px;">
																<xsl:if test="document/@editmode != 'edit'">
																	<xsl:attribute name="class">td_noteditable</xsl:attribute>
																</xsl:if>
																<xsl:value-of select="document/fields/executor"/>&#xA0;
															</td>
														</tr>
													</table>
													<input type="hidden" id="executor" name="executor" value="{document/fields/executor/@attrval}"/>					
													<input type="hidden" id="intexecutcaption" value="{document/fields/executor/@caption}"/>					
												</td>
											</tr>
											<!-- Дата исполнения -->
											<tr>
												<td class="fc"><xsl:value-of select="document/captions/finishdate/@caption"/> :</td>
												<td>
													<input type="text" name="finishdate" value="{document/fields/finishdate}" readonly="readonly" id="finishdate" class="td_noteditable" style="width:150px;"/>
												</td>
											</tr>
											<!-- Содержание отчета -->
											<tr>
												<td class="fc">
													<xsl:value-of select="document/captions/report/@caption"/> :
												</td>							
												<td>
													<div>
														<textarea name="report" id="report" style="width:760px; margin-top:8px; margin-bottom:15px" rows="15" onfocus="fieldOnFocus(this)" onblur="fieldOnBlur(this)" tabindex="1" class="textarea_editable">
															<xsl:if test="document/@editmode != 'edit'">
																<xsl:attribute name="onfocus">javascript:$(this).blur()</xsl:attribute>
																<xsl:attribute name="class">textarea_noteditable</xsl:attribute>
															</xsl:if>	
															<xsl:if test="document/@editmode = 'edit'">
																<xsl:attribute name="onfocus">javascript:fieldOnFocus(this)</xsl:attribute>
																<xsl:attribute name="onblur">javascript:fieldOnBlur(this)</xsl:attribute>
																<xsl:attribute name="onkeydown">javascript:resetquickanswerbutton()</xsl:attribute>
															</xsl:if>	
															<xsl:value-of select="document/fields/report"/>
														</textarea>	
														<xsl:if test="document/@editmode = 'edit'">	
															<br/>
															<a href="javascript:$.noop()" title="Исполнено" class="button-auto-value">
																<xsl:attribute name="onclick">javascript:addquickanswer('report','Исполнено',this)</xsl:attribute>
																<xsl:attribute name="onmouseover">javascript:previewquickanswer('report','Исполнено',this)</xsl:attribute>
																<xsl:attribute name="onmouseout">javascript:endpreviewquickanswer('report','Исполнено',this)</xsl:attribute>
																Исполнено
															</a>
															<a href="javascript:$.noop()" class="button-auto-value" title="Принято к сведению" style="margin-left:10px">
																<xsl:attribute name="onclick">javascript:addquickanswer('report','Принято к сведению',this)</xsl:attribute>
																<xsl:attribute name="onmouseover">javascript:previewquickanswer('report','Принято к сведению',this)</xsl:attribute>
																<xsl:attribute name="onmouseout">javascript:endpreviewquickanswer('report','Принято к сведению',this)</xsl:attribute>
																Принято к сведению
															</a>					
														</xsl:if>							
													</div>
												</td>
											</tr>
						 				</table>
						 				<br/>
									</div>
									<input type="hidden" name="author" value="{document/fields/author/@attrval}"/> 
									<input type="hidden" name="type" value="save"/>  
									<input type="hidden" name="id" value="execution"/>
									<input type="hidden" name="key" value="{document/@docid}"/>
									<input type="hidden" name="doctype" value="{document/@doctype}"/>
									<input type="hidden" name="parentdocid" value="{document/@parentdocid}"/>
									<input type="hidden" name="parentdoctype" value="{document/@parentdoctype}"/>
									<input type="hidden" name="page" value="{document/@openfrompage}"/>
								</form>
							</div>
							<div id="tabs-2">
								<form action="Uploader" name="upload" id="upload" method="post" enctype="multipart/form-data">
									<input type="hidden" name="type" value="rtfcontent"/>
									<input type="hidden" name="formsesid" value="{formsesid}"/>
									<div display="block" id="att">
										<br/>	
										<xsl:call-template name="attach"/>
									</div>
								</form>
					        </div>
			         		<div id="tabs-3">
								<xsl:call-template name="docinfo"/>
							</div>
           				</div>
           				<div style="height:10px"/>
			  		</div>
				</div>
				<xsl:call-template name="outline_form"/>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>