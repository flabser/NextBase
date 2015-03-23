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
					});
					]]>
				</script>
				<xsl:if test="document/@editmode = 'edit'">					
					<xsl:if test="/request/@lang = 'KAZ'">
						<script>
							$(function() {
								$('.eventdate').datepicker({
									showOn: 'button',
									buttonImage: '/SharedResources/img/iconset/calendar.png',
									buttonImageOnly: true,
									regional:['ru'],
									showAnim: '',
									changeYear:  true,
									yearRange: '-5:+5',
									changeMonth: true,
									monthNames: ['Қаңтар','Ақпан','Наурыз','Сәуір','Мамыр','Маусым',
									'Шілде','Тамыз','Қыркүйек','Қазан','Қараша','Желтоқсан'],
									monthNamesShort: ['Қаңтар','Ақпан','Наурыз','Сәуір','Мамыр','Маусым',
									'Шілде','Тамыз','Қыркүйек','Қазан','Қараша','Желтоқсан'],
									dayNames: ['жексебі','дүйсенбі','сейсенбі','сәрсенбі','бейсенбі','жұма','сенбі'],
									dayNamesShort: ['жек','дүй','сей','сәр','бей','жұм','сен'],
									dayNamesMin: ['Жс','Дс','Сс','Ср','Бс','Жм','Сн'],
								});
							});
						</script>
					</xsl:if>
					<xsl:if test="/request/@lang != 'KAZ'">
						<script>
							$(function() {
								$('.eventdate').datepicker({
									showOn: 'button',
									buttonImage: '/SharedResources/img/iconset/calendar.png',
									buttonImageOnly: true,
									regional:['ru'],
									showAnim: '',
									changeYear:  true,
									yearRange: '-5:+5',
									changeMonth: true
								});
							});
						</script>
					</xsl:if>
				</xsl:if>
				<xsl:if test="$editmode = 'edit'">
					<xsl:call-template name="htmlareaeditor"/>
				</xsl:if> 
				<xsl:call-template name="markisread"/>
			</head>
			<body>
				<xsl:attribute name="onbeforeprint">javascript:$("#htmlcodenoteditable").html($("#txtDefaultHtmlArea").val())</xsl:attribute>
				<xsl:variable name="status" select="@status"/>	
				<div id="docwrapper">
					<xsl:call-template name="documentheader"/>
					<div class="formwrapper">
						<div class="formtitle">
						   	<div class="title">
						   		<xsl:variable name="status" select="document/@status"/>
						   		<xsl:value-of select="document/captions/title/@caption"/>
						   		<xsl:if test="$status = 'new'"> 
						   			  <xsl:value-of select="document/captions/new/@caption"/>
						   		</xsl:if>	
							</div>
						</div>
						<!-- Сохранить и закрыть -->
						<div class="button_panel">
							<span style="float:left">	
								<xsl:call-template name="get_document_accesslist"/>							
								<xsl:call-template name="save"/>
							</span>							
							<!-- Закрыть -->
							<span style="float:right; padding-right:15px;">								
								<xsl:call-template name="cancel"/>
							</span>
						</div>
						<div style="clear:both"/>
						<div style="-moz-border-radius:0px;  width:100%;"/>
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
											<xsl:value-of select="document/captions/content/@caption"/>
										</a>
									</li> 
									<li class="ui-state-default ui-corner-top">
										<a href="#tabs-3"><xsl:value-of select="document/captions/attachments/@caption"/></a>
										<img id="loading_attach_img" style="vertical-align:-8px; margin-left:-10px; padding-right:3px; visibility:hidden" src="/SharedResources/img/classic/ajax-loader-small.gif"></img>
									</li>
									<li class="ui-state-default ui-corner-top">
										<a href="#tabs-4"><xsl:value-of select="document/captions/additional/@caption"/></a>
									</li>
									<xsl:call-template name="docInfo"/>
								</ul>	
								<div class="ui-tabs-panel" id="tabs-1">
								<div display="block"  id="property" width="100%">									 
									<table width="100%" border="0" style="margin-top:8px">
										<!-- Тема -->
										<tr>
											<td class="fc"><font style="vertical-align:top"><xsl:value-of select="document/captions/docauthor/@caption"/>: </font></td>
											<td> 											
												<div type="text" class="td_editable" style="width:490px">
													<xsl:value-of select="document/fields/docauthor"/>
													<input type="hidden" name="docauthor" value="{document/fields/docauthor/@attrval}"/>
												</div> 
											</td>
										</tr> 
										<tr>
											<td class="fc"><font style="vertical-align:top"><xsl:value-of select="document/captions/title1/@caption"/>: </font></td>
											<td> 											
												<input type="text" name="title" class="td_editable" style="width:490px">
													<xsl:if test="$editmode != 'edit'">
														<xsl:attribute name="readonly">readonly</xsl:attribute>
														<xsl:attribute name="class">td_noteditable</xsl:attribute>
													</xsl:if>
													<xsl:attribute name="title" select="document/fields/title/@caption"/>
													<xsl:attribute name="value" select="document/fields/title"/>
												</input> 
											</td>
										</tr> 
										<!-- Читатели-->
										<tr>
											<td class="fc">
												<font style="vertical-align:top"><xsl:value-of select="document/captions/readers/@caption"/>: 
													<xsl:if test="document/@editmode = 'edit'">
														<a accesskey="3" style="cursor:pointer">
															<xsl:attribute name="onclick">javascript:addMemberGroup('executers','true','readers','frm', 'readerstbl');</xsl:attribute>								
															<img src="/SharedResources/img/classic/picklist.gif"/>
														</a>
													</xsl:if>
												</font>
											</td>
											<td>
												<table id="readerstbl" width="500px">
													<xsl:for-each select="document/fields/readers/entry[@attrval != '']">
														<tr>
															<td style="border:1px solid #ccc; margin-top:2px" class="td_editable">
																<xsl:if test="$editmode != 'edit'">
																	<xsl:attribute name="class">td_noteditable</xsl:attribute>
																</xsl:if>
																<xsl:value-of select="." />&#xA0;
																<input type="hidden" id="readers" name="readers"> 
																	<xsl:attribute name="value" select="@attrval"/>
																</input>
																<img onclick="delmember(this)" src="/SharedResources/img/iconset/cross.png" style="width:15px; height:15px; margin-right:3px; margin-top:1px; float:right; cursor:pointer"/>
															</td>
														</tr>
													</xsl:for-each>
													<xsl:if test="document/@status = 'new'">
														<tr>
															<td style="border:1px solid #ccc; margin-top:2px" class="td_editable">
																&#xA0;
															</td>
														</tr>
													</xsl:if>
												</table> 
												<input type="hidden" id="readerscaption" value="{document/captions/readers/@caption}"/>
											</td>
										</tr>	
										<!-- Редакторы -->
										<tr>
											<td class="fc">
												<font style="vertical-align:top"><xsl:value-of select="document/captions/editors/@caption"/>: 
												<xsl:if test="$editmode = 'edit'">
													<a style="cursor:pointer">
														<xsl:attribute name="title" select="concat(document/captions/editors/@caption, '')" />
														<xsl:attribute name="onclick">javascript:addMemberGroup('executers','true','editors','frm', 'editorstbl');</xsl:attribute>								
														<img src="/SharedResources/img/classic/picklist.gif"/>
													</a>
												</xsl:if>
												</font>
											</td>
											<td>
												<table id="editorstbl" width="500px">
													<tr>
														<td style="border:1px solid #ccc; margin-top:2px" class="td_editable">
															<xsl:if test="$editmode != 'edit'">
																<xsl:attribute name="class">td_noteditable</xsl:attribute>
															</xsl:if>
															<xsl:value-of select="document/fields/docauthor" />&#xA0;
															<input type="hidden" id="editors" name="editors" value="{document/fields/docauthor/@attrval}"/> 
														</td>
													</tr>
													<xsl:for-each select="document/fields/editors/entry[@attrval != ''][@attrval != //document/fields/docauthor/@attrval]">
														<tr>
															<td style="border:1px solid #ccc; margin-top:2px" class="td_editable">
																<xsl:if test="$editmode != 'edit'">
																	<xsl:attribute name="class">td_noteditable</xsl:attribute>
																</xsl:if>
																<xsl:value-of select="."/>&#xA0;
																<input type="hidden" id="editors" name="editors" value="{@attrval}"/> 
																<img onclick="delmember(this)" src="/SharedResources/img/iconset/cross.png" style="width:15px; height:15px; margin-right:3px; margin-top:1px; float:right; cursor:pointer"/>
															</td>
														</tr>
													</xsl:for-each>
													<input type="hidden" id="editorscaption" value="{document/captions/editors/@caption}"/>
												</table> 
											</td>
										</tr>	
																			
										</table>
										<input type="hidden" name="type" value="save"/>
										<input type="hidden" name="id" value="{@id}"/>
										<input type="hidden" name="key" value="{document/@docid}"/>
										<input type="hidden" name="doctype" value="{document/@doctype}"/>
										<input type="hidden" name="parentdocid" value="{document/@parentdocid}"/>
										<input type="hidden" name="parentdoctype" value="{document/@parentdoctype}"/>
									</div>
								</div>
								<div class="ui-tabs-panel" id="tabs-2" >
									<div display="block"  id="property" width="100%">									 
										<table width="80%" border="0" style="margin-top:20px">
											<!-- Содержание -->
											<tr>
												<td style="padding-left:30px;">
													<xsl:if test="$editmode = 'edit'">
														<script>
															$(document).ready(function($){
												       			CKEDITOR.config.width = "800px"
												       			CKEDITOR.config.height = "420px"
												    		});
											    		</script>
														<textarea id="MyTextarea" name="briefcontent">
															<xsl:if test="@useragent = 'ANDROID'">
																<xsl:attribute name="style">width:500px; height:300px</xsl:attribute>
															</xsl:if>
															<xsl:value-of select="document/fields/briefcontent"/>
														</textarea>
													</xsl:if>
													<xsl:if test="$editmode != 'edit'">
														<div id="briefcontent">
															<xsl:attribute name="style">width:500px; height:300px; background:#EEEEEE; padding: 3px 5px; overflow-x:auto</xsl:attribute>
															<script>
																$("#briefcontent").html("<xsl:value-of select='document/fields/briefcontent'/>")
															</script>
														</div>
														<input type="hidden" name="briefcontent" value="{document/fields/briefcontent}"/>
													</xsl:if>
												</td>
											</tr>
										</table>
									</div>
								</div>	
								<div id="tabs-4">
									<xsl:call-template name="docinfo"/>
								</div>
							</form>	
							<div class="ui-tabs-panel" id="tabs-3">
								<form action="Uploader" name="upload" id="upload" method="post" enctype="multipart/form-data">
									<input type="hidden" name="type" value="rtfcontent" />
									<input type="hidden" name="formsesid" value="{formsesid}"/>
									<!-- Секция "Вложения" -->
									<div display="block" id="att">
										<br/>	
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
		<xsl:param name="param"/>&#xA0;
		<xsl:variable name="kaz_part" select="substring-before($param, '/*')" /> 
   		<xsl:variable name="rus_part" select="substring-after($param, '/*')" /> 
		<xsl:choose>
			<xsl:when test="$lang = 'KAZ'">
				<xsl:value-of select="$kaz_part" />
			</xsl:when>
			<xsl:otherwise>
			 	<xsl:value-of select="$rus_part" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>