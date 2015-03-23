<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../templates/form.xsl"/>
	<xsl:import href="../templates/sharedactions.xsl"/>
	<xsl:variable name="doctype" select="request/document/captions/doctypemultilang/@caption"/>
	<xsl:variable name="path" select="/request/@skin"/>
	<xsl:variable name="threaddocid" select="document/@granddocid"/>
	<xsl:variable name="editmode" select="/request/document/@editmode"/>
	<xsl:output method="html" encoding="utf-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" indent="yes"/>
	<xsl:variable name="skin" select="request/@skin"/>
	<xsl:template match="/request">
	<html>
		<head>
			<title>
				<xsl:value-of select="concat('Projects - ', document/@viewtext)"/>
			</title>
			<xsl:call-template name="cssandjs"/>
   			<xsl:call-template name="markisread"/>
   			<script>
   				$(document).ready(function(){
	   				topicid=<xsl:value-of select='document/@topicid'/>
					$.ajax({
						url: 'Provider?type=forum&amp;id=topic&amp;key=<xsl:value-of select='document/@topicid'/>&amp;onlyxml',
						datatype:'xml',
						async:'true',
						success: function(data) {
							$("#headerTheme").append('<font>'+ $(data).find("document").find("fields").find("theme").text()+"</font>")
							$("#infoTheme").append('<font>Автор: '+ $(data).find("document").find("fields").find("author").text()+', '+  $(data).find("document").find("fields").find("topicdate").text()+"</font>")
						}
					});
					$.ajax({
						url: 'Provider?type=view&amp;id=forum_thread&amp;parentdocid=<xsl:value-of select='document/@topicid'/>&amp;parentdoctype=904&amp;command=expand`<xsl:value-of select='document/@topicid'/>`904&amp;onlyxml',
						datatype:'xml',
						async:'true',
						success: function(data){
							$("#CountMsgTheme").append(comment_on_discussion+": " + $(data).find("query").attr("count"))
							$(data).find("query").find("entry").each(function(index, element){
								$("#msgWrapper").append('<div id="msgEntry'+ index +'"/>')
								$("#msgEntry"+index).append('<div class="headermsg" id="headermsg'+ index +'"/>')
								$("#headermsg"+index).append('<div class="authormsg">'+$(this).find("author").text()+'</div>')
								$("#headermsg"+index).append('<div class="msgdate">отправлено:'+$(this).find("viewcontent").find("viewdate").text()+'</div>')
								$("#msgEntry"+index).append('<div class="bodymsg" id="bodymsg'+ index +'">'+$(this).find("viewtext").text()+'</div>')
								$("#msgEntry"+index).append('<div class="buttonpanemsg" id="buttonpanemsg'+ index +'"/>')
							});
						}
					});
				})
			</script>
			<xsl:call-template name="htmlareaeditor"/>
		</head>
		<body>
			<div id="docwrapper">
				<xsl:call-template name="documentheader"/>	
				<div class="formwrapper">
					<div class="formtitle">
						<!-- заголовок -->					
						<div class="title" style="float:left">
							<xsl:call-template name="doctitleprj"/>	
						</div>
					</div>	
					<div class="button_panel">
						<span style="vertical-align:12px; float:left">
							<xsl:call-template name="showxml"/>
						</span>
						<span style="float:right">
					       	<!-- кнопка "закрыть" -->
				    		<xsl:call-template name="cancel"/>
					    </span>
					</div>				
					<div style="clear:both"/>
					<div id="forumWrapper" style="width:98%; margin:40px auto">
						<form action="Provider" name="frm" method="post" id="frm" enctype="application/x-www-form-urlencoded">
							<table width="100%" border="0">
								<tr>
									<td class="fc">
										<xsl:value-of select="//captions/commenttext/@caption"/> :
									</td>
									<td>
										<xsl:if test="$editmode != 'edit'">
											<div id="htmlcodenoteditable" class="textarea_noteditable" style="width:754px; height:426px"/>
											<script>
												$("#htmlcodenoteditable").html('<xsl:value-of select="document/fields/contentsource"/>');
											</script>
										</xsl:if>
										<xsl:if test="$editmode = 'edit'">
											<textarea id="txtDefaultHtmlArea" name="contentsource" cols="93" rows="25">
												<xsl:attribute name="onfocus">javascript: $(this).blur()</xsl:attribute>
												<xsl:attribute name="class">textarea_noteditable</xsl:attribute>
												<xsl:value-of select="document/fields/contentsource"/>
											</textarea>
											<script>
												if($(window).width() >1200){
													$("#txtDefaultHtmlArea").width("670px");
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
								<tr>
									<td class="fc"></td>
									<td>
										<button type="button" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" title="{//captions/write_discussion/@caption}">
											<xsl:attribute name="onclick">javascript:SaveFormJquery('frm','frm','<xsl:value-of select="history/entry[@type eq 'outline'][last()]"/>')</xsl:attribute>
											<span>
												<font class="button_text"><xsl:value-of select="//captions/write_discussion/@caption"/></font>
											</span>
										</button>
									</td>
								</tr>
							</table>
							<br/>
							<!-- Скрытые поля -->					
							<input type="hidden" name="type" value="save"/>  
							<input type="hidden" name="id" value="comment"/>
							<input type="hidden" name="key" value="{document/@docid}"/>
							<input type="hidden" name="postdate" value="{document/fields/postdate}"/>
							<input type="hidden" name="parentdocid" value="{document/@parentdocid}"/>
							<input type="hidden" name="parentdoctype" value="{document/@parentdoctype}"/>
							<input type="hidden" name="action" id="action"/> 
						</form>
					</div>
					<div style="height:10px"/>
				</div>
			</div>
			<xsl:call-template name="formoutline"/>
		</body>
	</html>
</xsl:template>
</xsl:stylesheet>