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
 						if(e.ctrlKey){
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
				<xsl:call-template name="htmlareaeditor"/>
			</head>
			<body>
				<xsl:attribute name="onbeforeprint">javascript:$("#htmlcodenoteditable").html($("#txtDefaultHtmlArea").val())</xsl:attribute>
				<div id="docwrapper">
				<xsl:call-template name="documentheader"/>
					<div class="formwrapper">
						<div class="formtitle">
						   	<div class="title">
						   		<xsl:value-of select="document/captions/title/@caption"/>
						   		<xsl:if test="$status = 'new'"> 
						   			 - <xsl:value-of select="document/captions/new/@caption"/>
						   		</xsl:if>	
							</div>
						</div>
						<!-- Сохранить и закрыть -->
						<div class="button_panel">
							<span style="float:left">
								<xsl:call-template name="showxml"/>		
								<xsl:if test="$editmode = 'edit'">												
									<button class="formButtons">
										<xsl:attribute name="onclick">javascript:SaveFormJquery('frm','frm',&quot;<xsl:value-of select="history/entry[@type='outline'][last()]"/>&quot;)</xsl:attribute>
										<span>						
											<img src="/SharedResources/img/classic/icons/disk.png" height="15px"/>											
											<font class="button_text"><xsl:value-of select="document/captions/save/@caption"/></font>									
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
						<div style="-moz-border-radius:0px;height:1px; width:100%; margin-top:10px;"/>
						<div style="clear:both"/>
						<div id="tabs">
							<ul class="ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-all">
								<li class="ui-state-default ui-corner-top">
									<a href="#tabs-1">
										<xsl:value-of select="document/captions/properties/@caption"/>
									</a>
								</li>
								<li class="ui-state-default ui-corner-top">
									<a href="#tabs-2">
										<xsl:value-of select="document/captions/files/@caption"/>
									</a>
								</li>
							</ul>
							<div class="ui-tabs-panel" id="tabs-1">
							<form action="Provider" name="frm" method="post" id="frm" enctype="application/x-www-form-urlencoded">
								<br/>
								<br/>
								<table>
									<!-- Автор записи-->
									<tr><td class="fc"><xsl:value-of select="document/captions/docauthor/@caption"/> : </td>
										<td>
											<input type="text" class="td_noteditable" name="docauthor" id = "docauthor" style="width:180px;" size="300" value="{document/currentuser}" readonly="true">
												<xsl:if test="$status != 'new'"> 
													<xsl:attribute name="value" select="document/fields/docauthor"/>
												</xsl:if>
											</input>
										</td>
									</tr>
									<!-- Дата -->
									<tr>
									    <td class="fc"><font style="vertical-align:top"><xsl:value-of select="document/captions/docdate/@caption" /> : </font></td>
										<td>
											<input type="text" class="td_noteditable" name="docdate" style="width:180px;" value="{document/fields/curr_date}" readonly="true">
												<xsl:if test="$status != 'new'"> 
													<xsl:attribute name="value" select="document/fields/docdate"/>
												</xsl:if>
											</input>
										</td>										
									</tr>	
									<!-- Zagolovok --> 
									<tr>
										<td  class="fc"><xsl:value-of select="document/captions/ptitle/@caption" /> : </td>
										<td>
											<input type="text" name="title" style="width:600px;" width="300" value="{document/fields/title}">						 
												<xsl:if test="$editmode != 'edit'">
													<xsl:attribute name="readonly">readonly</xsl:attribute>
													<xsl:attribute name="class">td_noteditable</xsl:attribute>
												</xsl:if>											
											</input>
										</td>
									</tr> 	
									<!-- Kratkoe soderzhanie -->
									<tr>
										<td class="fc"><xsl:value-of select="document/captions/content/@caption" /> : </td>
										<td>
											<div id="htmlcodenoteditable" class="textarea_noteditable" style="width:654px; height:426px; display:block">
												<!--	<xsl:attribute name="onbeforeprint">$("#htmlcodenoteditable").html($(".jHtmlArea").html())</xsl:attribute> -->
												<xsl:if test="$editmode = 'edit'">
													<xsl:attribute name="style">width:654px; height:426px; display:none</xsl:attribute>
												</xsl:if>
											</div>
											<script>
												$("#htmlcodenoteditable").html('<xsl:value-of select="document/fields/content"/>');
											</script>
											<xsl:if test="$editmode = 'edit'">
												<textarea id="txtDefaultHtmlArea" name="content" cols="93" rows="25">
													<xsl:attribute name="onfocus">javascript: $(this).blur()</xsl:attribute>
													<xsl:attribute name="class">textarea_noteditable</xsl:attribute>
													<xsl:value-of select="document/fields/content"/>
												</textarea>
												<script>
													if($(window).width() >1200){
														$("#txtDefaultHtmlArea").width("610px");
														$("#txtDefaultHtmlArea").height("300px");
													}else{
														$("#txtDefaultHtmlArea").width("457px");
														$("#htmlcodenoteditable").width("457px");
														$("#txtDefaultHtmlArea").height("300px");
													}
												</script>
											</xsl:if>
										</td>
									</tr>
								</table>
								<input type="hidden" name="type" value="save"/>
								<input type="hidden" name="id" value="{@id}"/>
								<input type="hidden" name="key" value="{document/@docid}"/>
								<input type="hidden" name="doctype" value="{document/@doctype}"/>	
							</form>	
						</div>
						<!-- Форма "Вложения" -->
						<table style="display:none" id="extraCoordTable"/>
						<table style="display:none" id="notesTable">
							<tr></tr>
						</table>		
						<div class="ui-tabs-panel" id="tabs-2">
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