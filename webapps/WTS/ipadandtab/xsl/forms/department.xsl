<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../templates/form.xsl"/>
	<xsl:import href="../templates/sharedactions.xsl"/>
	<xsl:variable name="doctype"><xsl:value-of select="/request/document/captions/department/@caption"/></xsl:variable>
	<xsl:variable name="threaddocid" select="document/@docid"/>
	<xsl:variable name="editmode" select="/request/document/@editmode"/>
	<xsl:output method="html" encoding="utf-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" indent="yes"/>
	<xsl:variable name="skin" select="request/@skin"/>
	<xsl:template match="/request">
		<html>
			<head>
				<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
				<title><xsl:value-of select="document/captions/department/@caption"/> - Web Technical Supervision</title>
				<xsl:call-template name="cssandjs"/>
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
									   case 68:
									   		<!-- клавиша d -->
									     	e.preventDefault();
									     	$("#btnnewdep").click();
									      	break;
									   case 69:
									   		<!-- клавиша e -->
									     	e.preventDefault();
									     	$("#btnnewemp").click();
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
							$("#btnsavedoc").hotnav({keysource:function(e){ return "s"; }});
							$("#btnnewdep").hotnav({keysource:function(e){ return "d"; }});
							$("#btnnewemp").hotnav({keysource:function(e){ return "e"; }});
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
							<div class="title">
					           <xsl:call-template name="doctitleBoss"/>											
							</div>
						</div>
						<div class="button_panel">
							<span style="float:left">
								<xsl:call-template name="showxml"/>
								<button class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" title="Сохранить и закрыть" id="btnsavedoc">
									<xsl:attribute name="onclick">javascript:SaveFormJquery('frm','frm',&quot;<xsl:value-of select="history/entry[@type='outline'][last()]"/>&quot;)</xsl:attribute>
									<span>
										<img src="/SharedResources/img/classic/icons/disk.png" class="button_img"/>
										<font style="font-size:12px; vertical-align:top"><xsl:value-of select="document/captions/saveclose/@caption"/></font>
									</span>
								</button>
								<xsl:if test="document/@status !='new'">
									<button class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" id="btnnewdep" style="margin-left:5px">
										<xsl:attribute name="onclick">javascript:window.location.href="Provider?type=structure&amp;id=department&amp;key=&amp;parentdocid=<xsl:value-of select="document/@docid"/>&amp;parentdoctype=<xsl:value-of select="document/@doctype"/>"</xsl:attribute>
										<span>
											<img src="/SharedResources/img/classic/icons/package_add.png" class="button_img"/>
											<font style="font-size:12px; vertical-align:top"><xsl:value-of select="document/captions/newdept/@caption"/></font>
										</span>
									</button>
									<button class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" id="btnnewemp" style="margin-left:5px">
										<xsl:attribute name="onclick">javascript:window.location.href="Provider?type=structure&amp;id=employer&amp;key=&amp;parentdocid=<xsl:value-of select="document/@docid"/>&amp;parentdoctype=<xsl:value-of select="document/@doctype"/>"</xsl:attribute>
										<span>
											<img src="/SharedResources/img/classic/icons/user_add.png" class="button_img"/>
											<font style="font-size:12px; vertical-align:top"><xsl:value-of select="document/captions/newemp/@caption"/></font>
										</span>
									</button>
								</xsl:if>
							</span>
							<span style="float:right; margin-right:5px">
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
							</ul>
							<div class="ui-tabs-panel" id="tabs-1">
								<form action="Provider" name="frm" method="post" id="frm" enctype="application/x-www-form-urlencoded">
									<div display="block"  id="property">
										<br/>
										<table width="100%" border="0">
											<tr>
												<td class="fc"><xsl:value-of select="document/captions/name/@caption"/> :</td>
									            <td>
						                            <input type="text" name="fullname" value="{document/fields/fullname}" size="65" class="td_editable" style="width:600px;">
						                              	<xsl:if test="$editmode != 'edit'">
															<xsl:attribute name="readonly">readonly</xsl:attribute>
															<xsl:attribute name="class">td_noteditable</xsl:attribute>
														</xsl:if>
						                            </input>
						                       </td>   					
											</tr>
											<tr>
												<td class="fc"><xsl:value-of select="document/captions/shortname/@caption"/> :</td>
									            <td>
						                        	<input type="text" name="shortname" value="{document/fields/shortname}" size="65" class="td_editable" style="width:400px;">
						                            	<xsl:if test="$editmode != 'edit'">
															<xsl:attribute name="readonly">readonly</xsl:attribute>
															<xsl:attribute name="class">td_noteditable</xsl:attribute>
														</xsl:if>
						                           </input>
						                       </td>   					
											</tr>
											<tr>
												<td  class="fc"><xsl:value-of select="document/captions/headdivision/@caption"/> :
													<a href="">
														<xsl:attribute name="href">javascript:dialogBoxStructure('orgpicklist','false','parentsubkey','frm', 'orgtable');</xsl:attribute>
														<img src="/SharedResources/img/iconset/report_magnify.png"/>
													</a>
												</td>
								            	<td>
					                        		<table id="orgtable">
					                        			<tr>
					                                		<td class="td_editable" style="width:400px;">
					                                			<xsl:if test="$editmode != 'edit'">
																	<xsl:attribute name="readonly">readonly</xsl:attribute>
																	<xsl:attribute name="class">td_noteditable</xsl:attribute>
																</xsl:if>
					                                 			<xsl:value-of select="document/fields/parentsubkey"/>&#xA0;</td>
					                                 		</tr>
					                                 </table>
					                                 <input type="hidden" name="parentsubkey" size="30" class="rof" value="{document/@parentdoctype}~{document/@parentdocid}"/>
					                           </td>   					
											</tr>
											<tr>
												<td class="fc"><xsl:value-of select="document/captions/subdivision/@caption"/> :
													<a href="">
														<xsl:attribute name="href">javascript:dialogBoxStructure('subdivision','false','subdivision','frm', 'subdivisiontable');</xsl:attribute>								
														<img src="/SharedResources/img/iconset/report_magnify.png"/>			
													</a>
												</td>
									            <td>
						                        	<table id="subdivisiontable">
						                        		<tr>
						                        	       	<td class="td_editable" style="width:600px;">
						                            	   		<xsl:if test="$editmode != 'edit'">
																	<xsl:attribute name="readonly">readonly</xsl:attribute>
																	<xsl:attribute name="class">td_noteditable</xsl:attribute>
																</xsl:if>
						                               			<xsl:value-of select="document/fields/subdivision"/>&#xA0;
						                               		</td>
						                               	</tr>
						                           	</table>
						                           	<input type="hidden" name="subdivision" size="30" value="{document/fields/subdivision/@attrval}"/>
						                           	<input type="hidden" id="subdivisioncaption" size="30" value="Тип подразделения"/>
						                         </td>   					
											</tr>
											<tr>
												<td class="fc"><xsl:value-of select="document/captions/comment/@caption"/> :</td>
									            <td>
						                        	<textarea class="textarea_editable" rows="4" name="comment" value="{document/fields/comment}" cols="45" style="width:300px;">
						                        		<xsl:if test="$editmode != 'edit'">
															<xsl:attribute name="readonly">readonly</xsl:attribute>
															<xsl:attribute name="class">textarea_noteditable</xsl:attribute>
														</xsl:if>
						                                <xsl:value-of select="document/fields/comment"/>
						                        	</textarea>
						                    	</td>   					
											</tr>   
											<tr>
												<td class="fc"><xsl:value-of select="document/captions/levelhierarhy/@caption"/> :</td>
									            <td>
						                            <input type="text" name="rank" value="{document/fields/rank}" size="20" class="td_editable" style="width:300px;">
						                              	<xsl:if test="$editmode != 'edit'">
															<xsl:attribute name="readonly">readonly</xsl:attribute>
															<xsl:attribute name="class">td_noteditable</xsl:attribute>
														</xsl:if>
						                               	<xsl:attribute name="onkeydown">javascript:Numeric(this)</xsl:attribute>
						                            </input>
						                        </td>   					
											</tr>
											<tr>
												<td  class="fc"><xsl:value-of select="document/captions/index/@caption"/> :</td>
									            <td>
						                          	<input type="text" name="index" value="{document/fields/index}" size="20" class="td_editable" style="width:300px;">
						                              	<xsl:if test="$editmode != 'edit'">
															<xsl:attribute name="readonly">readonly</xsl:attribute>
															<xsl:attribute name="class">td_noteditable</xsl:attribute>
														</xsl:if>
						                            </input>
						                       </td>   					
											</tr>   
											<tr>
												<td  class="fc"><xsl:value-of select="document/captions/group/@caption"/> :</td>
									            <td>
						                           <xsl:for-each select="document/glossaries/group/query/entry">
						                           		<input type="checkbox" name="group" value="{@docid}">
						                           			<xsl:if test="../../../../fields/group/@islist = 'true' and ../../../../fields/group/*/@attrval = @docid">
						                           				<xsl:attribute name="checked">checked</xsl:attribute>
						                           			</xsl:if>
						                           			<xsl:if test="../../../../fields/group[not(@islist)] and ../../../../fields/group/@attrval = @docid">
						                           				<xsl:attribute name="checked">checked</xsl:attribute>
						                           			</xsl:if>
						                           			<xsl:value-of select="name"/>
						                           		</input>
						                           		<br/>
						                           </xsl:for-each>
						                        </td>   					
											</tr>
										</table>		
						      		</div>   
								    <input type="hidden" name="type" value="save"/>
									<input type="hidden" name="id" value="department"/>		
									<input type="hidden" name="key" value="{document/@docid}"/> 
									<input type="hidden" name="doctype" value="{document/@doctype}"/> 
									<input type="hidden" name="parentdoctype" value="{document/@parentdoctype}"/> 
									<input type="hidden" name="parentdocid" value="{document/@parentdocid}"/> 
			          			</form>
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