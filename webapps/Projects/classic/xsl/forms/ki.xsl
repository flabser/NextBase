<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../templates/form.xsl"/>
	<xsl:import href="../templates/sharedactions.xsl"/>
	<xsl:variable name="doctype"></xsl:variable>
	<xsl:variable name="threaddocid" select="document/@docid"/>
	<xsl:output method="html" encoding="utf-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" indent="yes"/>
	<xsl:variable name="skin" select="request/@skin"/>
	<xsl:variable name="lang" select="request/@lang"/>
	<xsl:variable name="editmode" select="/request/document/@editmode"/>
    <xsl:variable name="status" select="/request/document/@status"/>
	
	<xsl:template match="/request">
		<html>		
			<head>	
				<title>
					<xsl:value-of select="concat('Projects - ', document/captions/title/@caption)"/>
				</title>
				<xsl:call-template name="cssandjs"/>
				<script type="text/javascript">
					$(document).bind('keydown', function(e){
	 					if (e.ctrlKey) {
	 						switch (e.keyCode) {
							   case 66:
							   		<!-- клавиша b -->
							     	e.preventDefault();
							     	$("#canceldoc").click();
							      	break;
							   case 83:
							   		<!-- клавиша s -->
							     	e.preventDefault();
							     	$("#btnsavedoc").click();
							      	break;
							    case 78:
							   		<!-- клавиша n -->
							     	e.preventDefault();
							     	$("#new_demand").click();
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
						<![CDATA[
							$(document).ready(function(){
							$("#canceldoc").hotnav({keysource:function(e){ return "b"; }});
							$("#btnsavedoc").hotnav({keysource:function(e){ return "s"; }});
							$("#currentuser").hotnav({ keysource:function(e){ return "u"; }});
							$("#logout").hotnav({keysource:function(e){ return "q"; }});
							$("#helpbtn").hotnav({keysource:function(e){ return "h"; }});
							$("#new_demand").hotnav({keysource:function(e){ return "n"; }});
						});
					]]>
				</script>
				<xsl:call-template name="markisread"/>
			</head>
			<body>
				<div id="docwrapper">
					<xsl:call-template name="documentheader"/>
					<div class="formwrapper">
						<div class="formtitle">
						   	<div class="title">
					   			<xsl:value-of select="document/captions/title/@caption"/>
							</div>
						</div>
						<!-- New demand -->
						<div class="button_panel">
							<span style="float:left">	
								<xsl:call-template name="get_document_accesslist"/>						
								<xsl:call-template name="save"/>
								<xsl:if test="//actionbar/action[@id='NEW_DOCUMENT']/@mode= 'ON'" >
									<button style="margin-right:5px; margin-bottom:5px" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" title="{//actionbar/action[@id='NEW_DOCUMENT']/@title}" id="new_demand">
										<xsl:attribute name="title" select="//actionbar/action[@id='NEW_DOCUMENT']/@caption"/>
										<xsl:attribute name="onclick">location.href='Provider?type=edit&amp;element=document&amp;id=demand&amp;docid=&amp;parentdocid=<xsl:value-of select="document/fields/parentdocid"/>&amp;parentdoctype=<xsl:value-of select="document/fields/parentdoctype"/>'</xsl:attribute>
										<span>
											<img src="/SharedResources/img/iconset/page_white_add.png" class="button_img"/>
											<font class="button_text">
												<xsl:value-of select="//actionbar/action[@id='NEW_DOCUMENT']/@caption"/>
											</font>
										</span>
									</button>
								</xsl:if>
							</span>
							<!-- Закрыть -->
							<span style="float:right; padding-right:15px;">								
								<xsl:call-template name="cancel"/>
							</span>
						</div>
						<div style="clear:both"/>
						<div style="-moz-border-radius:0px;height:1px; width:100%;"/>
						<div style="clear:both"/>
						<div id="tabs">
							<form action="Provider" name="frm" method="post" id="frm" enctype="application/x-www-form-urlencoded"> 
								<ul class="ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-all">
									<li class="ui-state-default ui-corner-top">
										<a href="#tabs-1">
											<xsl:value-of select="document/captions/properties/@caption"/>
										</a>
									</li> 
									<li class="ui-state-default ui-corner-top">
										<a href="#tabs-2">
											<xsl:value-of select="document/captions/attachments/@caption"/>
										</a>
										<img id="loading_attach_img" style="vertical-align:-8px; margin-left:-10px; padding-right:3px; visibility:hidden" src="/SharedResources/img/classic/ajax-loader-small.gif"></img>
									</li> 
									<li class="ui-state-default ui-corner-top">
										<a href="#tabs-3">
											<xsl:value-of select="document/captions/additional/@caption"/>
										</a>
									</li> 
									<xsl:call-template name="docInfo"/>
								</ul>							
								<div class="ui-tabs-panel" id="tabs-1" >
									<div display="block"  id="property" width="100%">									 
										<table width="80%" border="0" style="margin-top:8px">		
											<!-- Kratkoe soderzhanie -->
											<tr>
												<td class="fc">
													<xsl:value-of select="document/captions/report/@caption"/> : 
												</td>
												<td>
													<textarea id="report" name="report" cols="93" rows="25" style="width:610px; height:150px;">														
														<xsl:if test="$editmode = 'edit' and $status != 'new'">
															<xsl:attribute name="class">textarea_noteditable</xsl:attribute>
															<xsl:attribute name="readonly">true</xsl:attribute>
														</xsl:if>
														<xsl:if test="$editmode = 'edit' and $status = 'new'">
															<xsl:attribute name="onkeydown">javascript:resetquickanswerbutton()</xsl:attribute>
														</xsl:if>	
														<xsl:value-of select="document/fields/report"/>
													</textarea>
													<xsl:if test="$editmode = 'edit' and $status = 'new'">
														<br/>
														<br/>
														<a href="javascript:$.noop()" class="button-auto-value" title="{document/captions/executed/@caption}">
															<xsl:attribute name="onclick">javascript:addquickanswer('report','<xsl:value-of select ="document/captions/executed/@caption"/>',this)</xsl:attribute>
															<xsl:attribute name="onmouseover">javascript:previewquickanswer('report','<xsl:value-of select ="document/captions/executed/@caption"/>',this)</xsl:attribute>
															<xsl:attribute name="onmouseout">javascript:endpreviewquickanswer('report','<xsl:value-of select ="document/captions/executed/@caption"/>',this)</xsl:attribute>
															<xsl:value-of select ="document/captions/executed/@caption"/>
														</a>
														<a href="javascript:$.noop()" class="button-auto-value" style="margin-left:10px" title="{document/captions/noted/@caption}">
															<xsl:attribute name="onclick">javascript:addquickanswer('report','<xsl:value-of select ="document/captions/noted/@caption"/>',this)</xsl:attribute>
															<xsl:attribute name="onmouseover">javascript:previewquickanswer('report','<xsl:value-of select ="document/captions/noted/@caption"/>',this)</xsl:attribute>
															<xsl:attribute name="onmouseout">javascript:endpreviewquickanswer('report','<xsl:value-of select ="document/captions/noted/@caption"/>',this)</xsl:attribute>
															<xsl:value-of select ="document/captions/noted/@caption"/>
														</a>					
													</xsl:if>	
												</td>
											</tr>
											<!-- 	Ссылка на заявку	-->
											<xsl:if test="document/@status != 'new'">
											 <tr>
												<td class="fc">
													<xsl:value-of select="document/captions/parentdocurl/@caption"/> : 
												</td>
												<td>
													<a href="{document/fields/link_to_demand}" style="color:blue"><xsl:value-of select="document/fields/viewtext_parentdemand"/></a>
												</td>
											</tr>	
											</xsl:if>							
										</table>
										<input type="hidden" name="type" value="save"/>
										<input type="hidden" name="id" value="{@id}"/>
										<input type="hidden" name="key" value="{document/@docid}"/>
										<input type="hidden" name="parentdocid" value="{document/@parentdocid}"/>
										<input type="hidden" name="parentdoctype" value="{document/@parentdoctype}"/>
										<input type="hidden" name="doctype" value="{document/@doctype}"/>
									</div>
								</div>
								<div id="tabs-3">
									<xsl:call-template name="docinfo"/>
								</div>
							</form>	
							<div id="tabs-2">
								<form action="Uploader" name="upload" id="upload" method="post" enctype="multipart/form-data">
									<input type="hidden" name="type" value="rtfcontent"/> 
									<input type="hidden" name="formsesid" value="{formsesid}"/>
									<!-- Секция "Вложения" -->
									<div display="block" id="att">
										<xsl:call-template name="attach"/>
									</div>
								</form>
							</div>							 		 
						</div>
					</div>
				</div>
				<!-- Outline -->
				 <xsl:call-template name="formoutline"/>
			</body>
		</html>
	</xsl:template>
	<xsl:template name="lang_splitter">
		<xsl:param name="param"/>
		&#xA0;
		<xsl:variable name="kaz_part" select="substring-before($param, '/*')"/> 
   		<xsl:variable name="rus_part" select="substring-after($param, '/*')"/> 
		<xsl:choose>
			<xsl:when test="$lang = 'KAZ'">
				<xsl:value-of select="$kaz_part"/>
			</xsl:when>
			<xsl:otherwise>
			 	<xsl:value-of select="$rus_part"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>