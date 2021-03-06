<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../templates/form.xsl"/>
	<xsl:import href="../templates/sharedactions.xsl"/>
	<xsl:variable name="doctype">Тема обсуждения</xsl:variable>
	<xsl:variable name="threaddocid" select="document/@docid"/>
	<xsl:output method="html" encoding="utf-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" indent="yes"/>
	<xsl:variable name="skin" select="request/@skin"/>
	<xsl:template match="/request">
		<html>
			<head>
				<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
				<title>Тема обсуждения - Web Technical Supervision</title>
				<xsl:call-template name="cssandjs"/>
				<script>
					<xsl:if test="document/@status != 'new'">
						$(document).ready(function(){
							topicid=<xsl:value-of select='document/@topicid'/>
							$.ajax({
								url: 'Provider?type=forum&amp;id=topic&amp;key=<xsl:value-of select='document/@docid'/>&amp;onlyxml',
								datatype:'xml',
								async:'true',
								success: function(data) {
									$("#headerTheme").append('<font>'+ $(data).find("document").find("fields").find("theme").text()+"</font>")
									$("#infoTheme").append('<font>Автор: '+ $(data).find("document").find("fields").find("author").text()+', '+  $(data).find("document").find("fields").find("topicdate").text()+"</font>")
								}
							});
							$.ajax({
								url: 'Provider?type=view&amp;id=forum_thread&amp;parentdocid=<xsl:value-of select='document/@docid'/>&amp;parentdoctype=904&amp;command=expand`<xsl:value-of select='document/@topicid'/>`904&amp;onlyxml',
								datatype:'xml',
								async:'true',
								success: function(data){
									$("#CountMsgTheme").append("Комментариев в теме: " + $(data).find("query").attr("count"))
									$(data).find("query").find("entry").each(function(index, element){
										comid =$(this).attr("docid");
										k= index
										level = parseInt($(this).attr("level"))-1
										if (level == 0 &amp;&amp; index != 0){
											$("#msgWrapper").append('<div class="msgEntry" style="margin-top:10px" level ="'+ level + '" id="msgEntry'+ index +'"/>')
										}else{
											$("#msgWrapper").append('<div class="msgEntry" level ="'+ level + '" id="msgEntry'+ index +'"/>')
										}
										$("#msgEntry"+index).append('<div class="headermsg"  id="headermsg'+ index +'"/>')
										level = level *4;
										level =level + "em"
										$("#msgEntry"+index).css("margin-left", level);
										$("#headermsg"+index).append('<div class="authormsg">'+$(this).children("author").text()+'</div>')
										$("#headermsg"+index).append('<div class="msgdate">отправлено:'+$(this).children("viewcontent").children("viewdate").text()+'</div>')
										$("#msgEntry"+index).append('<div class="bodymsg" id="bodymsg'+ index +'">'+$(this).children("viewcontent").children("viewtext1").text()+'</div>')
										$("#msgEntry"+index).append('<div class="buttonpanemsg" id="buttonpanemsg'+ index +'"><button type="button" onclick="javascript:addCommentToForum(this,'+ $(this).attr('docid')+',905,true)" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only commenttocomment" style="float:right; margin-top:3px"><font style="font-size:12px; vertical-align:top" >Комментировать</font></button></div>')
									});
									$(".commenttocomment").button()
								}
							});
						})
					</xsl:if>
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
							$("#currentuser").hotnav({ keysource:function(e){ return "u"; }});
							$("#logout").hotnav({keysource:function(e){ return "q"; }});
							$("#helpbtn").hotnav({keysource:function(e){ return "h"; }});
						}
					]]>
				</script>
			</head>
			<body>
				<xsl:variable name="status" select="@status"/>
				<div id="docwrapper">
					<xsl:call-template name="documentheader"/>
					<div class="formwrapper">
						<div class="formtitle">
							<div class="title" style="display:none">
							</div>
						</div>
						<div class="button_panel">
							<span style="float:left">
								<xsl:call-template name="showxml"/>
								<!-- <xsl:if test="document/@status = 'new'">
									<button class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" title="Сохранить и закрыть" id="btnsavedoc">
										<xsl:attribute name="onclick">javascript:SaveFormJquery('frm','frm',&quot;<xsl:value-of select="history/entry[@type='outline'][last()]"/>&quot;)</xsl:attribute>
										<span>
											<img src="/SharedResources/img/classic/icons/disk.png" class="button_img"/>
											<font style="font-size:12px; vertical-align:top"> Сохранить</font>
										</span>
									</button>
								</xsl:if> -->
							</span>
							<span style="float:right; margin-right:5px">
								<xsl:call-template name="cancel"/>
							</span>
						</div>
				  		<div style="clear:both"/>
						<div style="-moz-border-radius:0px;height:1px; width:100%; "/>
						<div style="clear:both"/>
						<div id="tabs">
							<div class="ui-tabs-panel" id="tabs-1">
								<form action="Provider" name="frm" method="post" id="frm" enctype="application/x-www-form-urlencoded">
									<div display="block"  id="property">
										<br/>
										<xsl:if test="document/@status = 'new'">
											<table width="100%" border="0">
												<tr>
													<td class="fc">Тема обсуждения :</td>
										            <td>
							                           <input type="text" name="theme" size="30" class="td_editable" value="{document/fields/theme}" style="width:600px">
							                           		<xsl:if test="document/@editmode != 'edit'">
																<xsl:attribute name="readonly">readonly</xsl:attribute>
																<xsl:attribute name="class">td_noteditable</xsl:attribute>
															</xsl:if>
							                            </input>
							                        </td>   					
											   </tr>
											</table>
										</xsl:if>
										<table style="width:100%">
											<xsl:if test="document/@status != 'new'">
												<button type="button" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" title="Сохранить и закрыть" id="btnnewcomment" style="margin-left:5px">
													<xsl:attribute name="onclick">javascript:addCommentToForum(this,<xsl:value-of select='document/@docid'/>,904)</xsl:attribute>
													<span>
														<img src="/SharedResources/img/classic/icons/comment_add.png" class="button_img"/>
														<font style="font-size:12px; vertical-align:top"> Добавить комментарий</font>
													</span>
												</button>
											</xsl:if>
											<br/>
											<br/>
											<xsl:if test="document/@docid != ' '">
												<tr>
													<td>
														<div display="block" style="display:block; width:90%" id="topic">
															<div id="headerTheme" style="width:100%; padding-left:10px">
																<xsl:value-of select="document/fields/theme"/>
															</div>
															<div id="infoTheme" style="width:100%; padding-left:10px; padding-top:3px">
																Автор:<xsl:value-of select="document/fields/author"/> , <xsl:value-of select="document/fields/topicdate"/>
															</div>
															<br/>
															<div id="CountMsgTheme" style="color:	#555555; padding:12px; background:#E6E6E6; border:1px solid #D3D3D3; margin-left:10px; border-radius: 5px 5px 0px 0px; height:20px; font-size: 13px; font-weight: 300; overflow: hidden; ">
															</div>
															<div id="msgWrapper" style=" min-height:150px; margin-left:10px">
															</div>
															<table id="topicTbl" style=" width:100%"/>
															<br/>
														</div>
													</td>
												</tr>
											</xsl:if>
										</table>		
								    </div>   
								    <input type="hidden" name="type" value="save"/>
									<input type="hidden" name="id" value="topic"/>		
									<input type="hidden" name="key" value="{document/@docid}"/> 
									<input type="hidden" name="topicdate" value="{document/fields/topicdate}"/> 
									<input type="hidden" name="formsesid" value="{formsesid}"/>
									<input type="hidden" name="parentdocid" value="{document/@parentdocid}"/>
									<input type="hidden" name="parentdoctype" value="{document/@parentdoctype}"/>
									<input type="hidden" id="username" value="{@username}"/>
						       	</form>
						       	<br/>
						       	<br/>
						       	<br/>
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
					<div id="outlinelist" style="position:absolute; top:0px; bottom: 4.2em; left:-100%; width:100%; background:#fff; display:none; overflow:auto">
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