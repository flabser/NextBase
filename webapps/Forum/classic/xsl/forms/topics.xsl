<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../templates/form.xsl"/>
	<xsl:import href="../templates/sharedactions.xsl"/>
	<xsl:variable name="doctype">Тема обсуждения</xsl:variable>
	<xsl:variable name="editmode" select="/request/document/@editmode"/>
	<xsl:variable name="status" select="/request/document/@status"/>
	<xsl:variable name="threaddocid" select="document/@docid"/>
	<xsl:output method="html" encoding="utf-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" indent="yes"/>
	<xsl:variable name="skin" select="request/@skin"/>
	<xsl:template match="/request">
		<html>
			<head>
				<title>Тема обсуждения - Forum</title>
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
<!-- 									$("#headerTheme").append('<font>'+ $(data).find("document").find("fields").find("theme").text()+"</font>") -->
<!-- 									$("#infoTheme").append('<font>Автор: '+ $(data).find("document").find("fields").find("author").text()+', '+  $(data).find("document").find("fields").find("topicdate").text()+"</font>") -->
								}
							});
							$.ajax({
								url: 'Provider?type=view&amp;id=forum_thread&amp;parentdocid=<xsl:value-of select='document/@docid'/>&amp;parentdoctype=904&amp;command=expand`<xsl:value-of select='document/@topicid'/>`904&amp;onlyxml',
								datatype:'xml',
								async:'true',
								success: function(data){
									$("#CountMsgTheme").append(comment_on_discussion+": " + $(data).find("query").attr("count"))
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
										$("#headermsg"+index).append('<div class="msgdate">'+sent+':'+$(this).children("viewcontent").children("viewdate").text()+'</div>')
										$("#msgEntry"+index).append('<div class="bodymsg" id="bodymsg'+ index +'">'+$(this).children("viewcontent").children("viewtext").text()+'</div>')
										$("#msgEntry"+index).append('<div class="buttonpanemsg" id="buttonpanemsg'+ index +'"><button type="button" onclick="javascript:addCommentToForum(this,'+ $(this).attr('docid')+',905,true)" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only commenttocomment" style="float:right; margin-top:3px"><font style="font-size:12px; vertical-align:top" >'+makecomment+'</font></button></div>')
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
								<xsl:if test="document/@status = 'new'">
									<button class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" title="Сохранить и закрыть" id="btnsavedoc">
										<xsl:attribute name="onclick">javascript:SaveFormJquery('frm','frm',&quot;<xsl:value-of select="history/entry[@type='outline'][last()]"/>&quot;)</xsl:attribute>
										<span>
											<img src="/SharedResources/img/classic/icons/disk.png" class="button_img"/>
											<font class="button_text">Сохранить</font>
										</span>
									</button>
								</xsl:if>
							</span>
							<span style="float:right; margin-right:5px">
								<xsl:call-template name="cancel"/>
							</span>
						</div>
				  		<div style="clear:both"/>
						<div style="-moz-border-radius:0px;height:1px; width:100%;"/>
						<div style="clear:both"/>
						<div id="tabs">
							<div class="ui-tabs-panel" id="tabs-1">
								<form action="Provider" name="frm" method="post" id="frm" enctype="application/x-www-form-urlencoded">
									<div display="block"  id="property">
										<br/>
										<xsl:if test="$status = 'new'">
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
											<xsl:if test="$status != 'new'">
												<button type="button" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" title="{//captions/write_discussion/@caption}" id="btnnewcomment" style="margin-left:5px">
													<xsl:attribute name="onclick">javascript:addCommentToForum(this,<xsl:value-of select='document/@docid'/>,904)</xsl:attribute>
													<span>
														<img src="/SharedResources/img/classic/icons/comment_add.png" class="button_img"/>
														<font style="font-size:12px; vertical-align:top"><xsl:value-of select="//captions/write_discussion/@caption" /></font>
													</span>
												</button>
											</xsl:if>
											<br/>
											<br/>
											<xsl:if test="document/@docid !=' '">
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
															<div id="CountMsgTheme" style="color:#555555; padding:12px; background:#E6E6E6; border:1px solid #D3D3D3; margin-left:10px; border-radius: 5px 5px 0px 0px; height:20px; font-size: 13px; font-weight: 300; overflow: hidden; ">
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
						   	</div>
						</div>
			  			<div style="height:10px"/>
				 	</div>
				 </div>
				<xsl:call-template name="formoutline"/>
			</body>	
		</html>
	</xsl:template>
</xsl:stylesheet>