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
													<font style="vertical-align:top">
														<xsl:value-of select="document/captions/parentdocument/@caption"/> :
													</font>
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
												<font style="vertical-align:top">
													<xsl:value-of select="document/fields/executor/@caption"/> : 
												</font>
												<xsl:if test="document/@editmode ='edit'">
													<a href="">
														<xsl:attribute name="href">javascript:dialogBoxStructure('bossandemppicklist','false','intexecut','frm', 'intexecuttbl');</xsl:attribute>								
														<img src="/SharedResources/img/iconset/report_magnify.png"/>
													</a>
												</xsl:if>
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
											<td class="fc"><xsl:value-of select="document/fields/finishdate/@caption"/> :</td>
											<td>
												<input type="text" name="finishdate" value="{document/fields/finishdate}" readonly="readonly" id="finishdate" class="td_noteditable" style="width:150px;"/>
											</td>
										</tr>
										<!-- Содержание отчета -->
										<tr>
											<td class="fc"><xsl:value-of select="document/fields/report/@caption"/> :</td>							
											<td>
												<div>						
													<textarea name="report" style="width:760px" rows="15" onfocus="fieldOnFocus(this)" onblur="fieldOnBlur(this)" tabindex="1" class="textarea_editable">
														<xsl:if test="document/@editmode != 'edit'">
															<xsl:attribute name="onfocus">javascript:$(this).blur()</xsl:attribute>
															<xsl:attribute name="class">textarea_noteditable</xsl:attribute>
														</xsl:if>	
														<xsl:if test="document/@editmode = 'edit'">
															<xsl:attribute name="onfocus">javascript:fieldOnFocus(this)</xsl:attribute>
															<xsl:attribute name="onblur">javascript:fieldOnBlur(this)</xsl:attribute>
														</xsl:if>	
														<xsl:value-of select="document/fields/report"/>
													</textarea>								
												</div>
											</td>
										</tr>
					                    	<!-- Поле "код"
					                    <xsl:if test="document/@status != 'new'">
											<tr>
												<td class="fc">
													<xsl:value-of select="document/fields/ndelo/@caption"/> :
												</td>
								        		<td>
					                    			<input type="text" name="ndelo" size="10" class="td_editable" value="{document/fields/ndelo}" style="width:150px;">
														<xsl:if test="document/@editmode != 'edit'">
															<xsl:attribute name="class">td_noteditable</xsl:attribute>
															<xsl:attribute name="readonly">readonly</xsl:attribute>
														</xsl:if>
													</input>
					                        	</td>   					
											</tr>
										</xsl:if> -->
										<!-- Поле "Номенклатура дел" 						
										<tr>
											<td class="fc">
												<font style="vertical-align:top">
													<xsl:value-of select="document/fields/nomentype/@caption"/> : 
												</font>
												<xsl:if test="document/@editmode ='edit'">
													<a href="">
														<xsl:attribute name="href">javascript:dialogBoxStructure('n','false','nomentype','frm', 'nomentypetbl');</xsl:attribute>								
														<img src="/SharedResources/img/iconset/report_magnify.png"/>			
													</a>
												</xsl:if>
											</td>
											<td>
												<table id="nomentypetbl">
													<tr>
														<td class="td_editable" style="width:600px;">
															<xsl:if test="document/@editmode != 'edit'">
																<xsl:attribute name="class">td_noteditable</xsl:attribute>
															</xsl:if>
															<xsl:value-of select="document/fields/nomentype"/>&#xA0;
														</td>
													</tr>
												</table>
												<input type="hidden" id="nomentype" name="nomentype" value="{document/fields/nomentype/@attrval}"/>
												<input type="hidden" id="nomentypecaption" value="{document/fields/nomentype/@caption}"/>
											</td>
										</tr>-->
					 				</table>
					 				<br/>
								</div>
								<input type="hidden" name="author" value="{document/fields/author/@attrval}"/> 
								<input type="hidden" name="type" value="save"/>  
								<input type="hidden" name="id" value="ki"/>
								<input type="hidden" name="key" value="{document/@docid}"/>
								<input type="hidden" name="doctype" value="{document/@doctype}"/>
								<input type="hidden" name="parentdocid" value="{document/@parentdocid}"/>
								<input type="hidden" name="parentdoctype" value="{document/@parentdoctype}"/>
								<input type="hidden" name="page" value="{document/@openfrompage}"/>
								<!-- <xsl:if test="document/@status ='new'">
					           		<input type="hidden" name="ndelo" value="{document/fields/ndelo}"/>
					            </xsl:if> -->
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