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
			<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
			<title>
				<xsl:if test="document/@status != 'new'">
					<xsl:value-of select="document/@viewtext"/> - Web Technical Supervision
				</xsl:if>
				<xsl:if test="document/@status = 'new'">
					Новое &#xA0;<xsl:value-of select="lower-case($doctype)" />  - Web Technical Supervision
				</xsl:if>
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
							$("#CountMsgTheme").append("Комментариев в теме: " + $(data).find("query").attr("count"))
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
												Текст комментария :
											</td>
											<td>
												<xsl:if test="$editmode != 'edit'">
													<div id="htmlcodenoteditable" class="textarea_noteditable" style="width:754px; height:426px">
													</div>
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
											<td class="fc">
											</td>
											<td>
												<button type="button" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" title="Отправить сообщение">
													<xsl:attribute name="onclick">javascript:SaveFormJquery('frm','frm','<xsl:value-of select="history/entry[@type eq 'outline'][last()]"/>')</xsl:attribute>
													<span>
														<font style="font-size:12px; vertical-align:top">Добавить комментарий</font>
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
									<xsl:call-template name="ECPsignFields"/> 				
								</form>
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