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
							   case 68:
							   		<!-- клавиша d -->
							     	e.preventDefault();
							     	$("#newprojectdoc").click();
							      	break;
							   case 77:
							   		<!-- клавиша m -->
							     	e.preventDefault();
							     	$("#newmilestone").click();
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
							$("#newmilestone").hotnav({keysource:function(e){ return "m"; }});
							$("#newprojectdoc").hotnav({keysource:function(e){ return "d"; }});
						});
					]]>
				</script>
                <xsl:call-template name="datepicker"/>
				<xsl:call-template name="markisread"/>
			</head>
			<body>
				<xsl:attribute name="onbeforeprint">javascript:$("#htmlcodenoteditable").html($("#txtDefaultHtmlArea").val())</xsl:attribute>
				<div id="docwrapper">
					<xsl:call-template name="documentheader"/>
					<div class="formwrapper">
						<div class="formtitle">
						   	<div class="title">
						   		<xsl:value-of select="document/captions/title/@caption"/>
						   		<xsl:if test="$status != 'new'">  
						   			 - <xsl:value-of select="document/fields/project_name"/>
						   		</xsl:if>	
							</div>
						</div>
						<!-- Сохранить и закрыть -->
						<div class="button_panel">
							<span style="float:left">	
								<xsl:call-template name="get_document_accesslist"/>							
								<xsl:call-template name="save"/>
								<xsl:if test="$status != 'new'">
								<!-- Веха -->
								 <button style="margin-right:5px; margin-bottom:5px" id="newmilestone" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" title="{document/captions/newmilestone/@caption}">
									<xsl:attribute name="onclick">location.href='Provider?type=edit&amp;element=document&amp;id=milestone&amp;docid=&amp;parentdocid=<xsl:value-of select="document/@docid"/>&amp;parentdoctype=<xsl:value-of select="document/@doctype"/>'</xsl:attribute>
									<span>
										<img src="/SharedResources/img/iconset/chart_organisation_add.png" class="button_img"/>
										<font class="button_text"><xsl:value-of select="document/captions/milestone/@caption"/></font>
									</span>
								</button>
								<!-- Документация -->
								 <button style="margin-right:5px; margin-bottom:5px" id="newprojectdoc" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" title="{document/captions/newProjectDoc/@caption}" >
									<xsl:attribute name="onclick">location.href='Provider?type=edit&amp;id=projectDoc&amp;key=&amp;parentdocid=<xsl:value-of select="document/@docid" />&amp;parentdoctype=<xsl:value-of select="document/@doctype"/>'</xsl:attribute>
									<span>
										<img src="/SharedResources/img/iconset/page_attach.png" class="button_img"/>											 
										<font class="button_text"><xsl:value-of select="document/captions/projectDoc/@caption"/></font>											 
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
									<li class="ui-corner-top">
										<a href="#tabs-2">
											<xsl:value-of select="document/captions/projectdoc/@caption"/>
										</a>
									</li>
									<li class="ui-state-default ui-corner-top">
										<a href="#tabs-3"><xsl:value-of select="document/captions/additional/@caption"/></a>
									</li>
									<xsl:call-template name="docInfo"/>
								</ul>							
								
								<div class="ui-tabs-panel" id="tabs-1" >
								
								<div display="block"  id="property" width="100%">									 
									<table width="80%" border="0" style="margin-top:8px">
										<!-- Название проекта -->
										<tr>
											<td class="fc"><font style="vertical-align:top"><xsl:value-of select="document/captions/project_name/@caption"/>: </font></td>
											<td style="width:70%"> 											
											<input type="text" required="required" id="project_name" name="project_name" class="td_editable" style="width:500px; margin-left:2px">
												<xsl:if test="$editmode != 'edit'">
													<xsl:attribute name="readonly">readonly</xsl:attribute>
													<xsl:attribute name="class">td_noteditable</xsl:attribute>
												</xsl:if>
												<xsl:attribute name="title" select="document/fields/project_name/@caption"/>
												<xsl:attribute name="value" select="document/fields/project_name"/>
											</input> 
											</td>
										</tr> 	
										<!-- Заказчик -->
										<tr>
											<td class="fc"><font style="vertical-align:top"><xsl:value-of select="document/captions/customer/@caption"/>: 
												<xsl:if test="$editmode = 'edit'">
													<a accesskey="1" class="quickkey">
														<xsl:attribute name="title" select="document/captions/customer/@caption"/>
														<xsl:attribute name="onclick">dialogBoxStructure('orgpicklist','false','customer','frm', 'customerstbl');</xsl:attribute>
														<img src="/SharedResources/img/classic/picklist.gif" />
													</a>
												</xsl:if></font>
											</td>
											<td>
												<table id="customerstbl">
													<tr>
														<td width="500px" class="td_editable">
															<xsl:value-of select="document/fields/customer"/>&#xA0;
														</td>
													</tr>												
												</table> 
												<input type="hidden" id="customer" name="customer" required="required">
													<xsl:attribute name="value" select="document/fields/customer/@attrval"/>
												</input> 
												<input type="hidden" id="customercaption">
													<xsl:attribute name="value" select="document/captions/customer/@caption"/>
												</input> 
											</td>
										</tr>
										<!-- Представитель заказчика -->
										<tr>
											<td class="fc"><font style="vertical-align:top"><xsl:value-of select="document/captions/customer_emp/@caption"/>:
												<xsl:if test="$editmode = 'edit'">
													<a accesskey="1" class="quickkey">
														<xsl:attribute name="title" select="document/captions/customer/@caption"/>
														<xsl:attribute name="onclick">dialogBoxStructure('customer_emp','true','customer_emp','frm','customersemptbl');</xsl:attribute>
														<img src="/SharedResources/img/classic/picklist.gif"/>
													</a>
												</xsl:if></font>
											</td>
											<td>
												<table id="customersemptbl">
                                                    <xsl:for-each select="document/fields/customer_emp/entry">
                                                        <tr>
                                                            <td width="500px" class="td_editable">
                                                                <xsl:value-of select="."/>&#xA0;
                                                                <input type="hidden" id="customer_emp" name="customer_emp" required="required" value="{@attrval}"/>
                                                            </td>
                                                        </tr>
                                                    </xsl:for-each>
                                                    <xsl:if test="not(document/fields/customer_emp/entry)">
                                                        <tr>
                                                            <td width="500px" class="td_editable">
                                                               &#xA0;
                                                            </td>
                                                        </tr>
                                                    </xsl:if>
												</table> 
												<input type="hidden" id="customer_empcaption" value="{document/captions/customer_emp/@caption}"/>
											</td>
										</tr>
										<!-- Ответственный менеджер -->
										<tr>
											<td class="fc"><font style="vertical-align:top"><xsl:value-of select="document/captions/manager/@caption"/>: 
												<xsl:if test="$editmode = 'edit'">
													<a accesskey="3" class="quickkey" title="{document/captions/manager/@caption}">
														<xsl:attribute name="onclick">javascript:dialogBoxStructure('executers','false','manager','frm', 'managertbl');</xsl:attribute>								
														<img src="/SharedResources/img/classic/picklist.gif"/>
													</a>
												</xsl:if>
												</font>
											</td>
											<td>
												<table id="managertbl">
													<tr>
														<td width="500px" class="td_editable">
															<xsl:value-of select="document/fields/manager"/>&#xA0;
														</td>
													</tr>
												</table> 
												<input type="hidden" id="manager" name="manager" required="required" title="{document/captions/manager/@caption}">
													<xsl:attribute name="value" select="document/fields/manager/@attrval"/>
												</input>
												<input type="hidden" id="managercaption" value="{document/captions/manager/@caption}"/>
											</td>
										</tr>	
										
										<!-- Ответственные программисты -->
										<tr>
											<td class="fc"><font style="vertical-align:top"><xsl:value-of select="document/captions/programmer/@caption"/>: 
												<xsl:if test="$editmode = 'edit'">
													<a accesskey="3" class="quickkey">
														<xsl:attribute name="title" select="document/captions/programmer/@caption"/>
														<xsl:attribute name="onclick">javascript:dialogBoxStructure('executers','false','programmer','frm', 'programmertbl');</xsl:attribute>								
														<img src="/SharedResources/img/classic/picklist.gif" />
													</a>
												</xsl:if></font>												
											</td>
											<td>
												<table id="programmertbl">
													<tr>
														<td width="500px" class="td_editable">
															<xsl:value-of select="document/fields/programmer"/>&#xA0;
														</td>
													</tr>
												</table>
												<input type="hidden" id="programmer" name="programmer" required="required">
													<xsl:attribute name="title" select="document/captions/programmer/@caption"/>
													<xsl:attribute name="value" select="document/fields/programmer/@attrval"/>
												</input>
												<input type="hidden" id="programmercaption">
													<xsl:attribute name="value" select="document/captions/programmer/@caption"/>
												</input>
											</td>
										</tr>
										
										<!-- Ответственный тестировщик -->
										<tr>
											<td  class="fc" style="padding-top:2px">
												<font style="vertical-align:top;"><xsl:value-of select="document/captions/tester/@caption"/>: 
													<xsl:if test="$editmode = 'edit'">
														<a accesskey="3" class="quickkey">
															<xsl:attribute name="title" select="document/captions/tester/@caption"/>
															<xsl:attribute name="onclick">javascript:dialogBoxStructure('executers','false','tester','frm', 'testertbl');</xsl:attribute>								
															<img src="/SharedResources/img/classic/picklist.gif"/>
														</a>
													</xsl:if>
												</font>
											</td>
											<td>
												<table id="testertbl" >
													<tr>
														<td width="500px" class="td_editable">
															<xsl:value-of select="document/fields/tester"/>&#xA0;
														</td>
													</tr>
												</table>
												<input type="hidden" id="tester" name="tester" required="required">
													<xsl:attribute name="title" select="document/captions/tester/@caption"/>
													<xsl:attribute name="value" select="document/fields/tester/@attrval"/>
												</input>
												<input type="hidden" id="testercaption">
													<xsl:attribute name="value" select="document/captions/tester/@caption"/>
												</input>
											</td>
										</tr>
										<!-- Наблюдатели -->
										<tr>
											<td  class="fc" style="padding-top:2px">
												<font style="vertical-align:top;">
													<xsl:value-of select="document/captions/observer/@caption"/>: 
													<xsl:if test="$editmode = 'edit'">
														<a class="quickkey">
															<xsl:attribute name="onclick">javascript:addMemberGroup('executers','true','observer','frm', 'observertbl');</xsl:attribute>								
															<img src="/SharedResources/img/classic/picklist.gif"/>
														</a>
													</xsl:if>
												</font>
											</td>
											<td>
												<table id="observertbl" style=" margin-top:2px">
													<xsl:for-each select="document/fields/observer/entry[@attrval !='']"> 
														<tr>
															<td width="500px" class="td_editable">
																<xsl:value-of select="."/>&#xA0;
																<input type="hidden" id="observer" name="observer">
																	<xsl:attribute name="value" select="./@attrval"/>
																</input>
																<img onclick="delmember(this)" src="/SharedResources/img/iconset/cross.png" style="width:15px; height:15px; margin-right:3px; margin-top:1px; float:right; cursor:pointer"/>
															</td>
														</tr>
													</xsl:for-each>
													<xsl:if test="document/fields/observer/@attrval or not(document/fields/observer)">
														<tr>
															<td width="500px" class="td_editable">
																<xsl:value-of select="document/fields/observer"/>&#xA0;
																<input type="hidden" id="observer" name="observer">
																	<xsl:attribute name="title" select="document/captions/observer/@caption"/>
																	<xsl:attribute name="value" select="document/fields/observer/@attrval"/>
																</input>
															</td>
														</tr>
													</xsl:if>
												</table>
												<input type="hidden" id="observercaption" value="{document/captions/observer/@caption}"/>
											</td>
										</tr>
                                        <tr>
                                            <td class="fc">
                                                <font style="vertical-align:top">
                                                    <xsl:value-of select="document/captions/status/@caption"/>:
                                                </font>
                                            </td>
                                            <td>
                                                <input type="radio" name="status"  id="status1" value="1"  autocomplete="off">
                                                    <xsl:if test="document/fields/status = '1'">
                                                        <xsl:attribute name="checked">checked</xsl:attribute>
                                                    </xsl:if>
                                                    <xsl:if test="document/@editmode != 'edit'">
                                                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                                                    </xsl:if>
                                                </input>
                                                <label for="status1"><xsl:value-of select="document/captions/status1/@caption" /></label>
                                                <br/>

                                                <input type="radio" name="status"  id="status2" value="2" autocomplete="off">
                                                    <xsl:if test="document/fields/status = '2'">
                                                        <xsl:attribute name="checked">checked</xsl:attribute>
                                                    </xsl:if>
                                                    <xsl:if test="document/@editmode != 'edit'">
                                                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                                                    </xsl:if>
                                                    <xsl:if test="document/@status = 'new'">
                                                        <xsl:attribute name="checked">checked</xsl:attribute>
                                                    </xsl:if>
                                                </input>
                                                <label for="status2"><xsl:value-of select="document/captions/status2/@caption" /></label>
                                                <br/>

                                                <input type="radio" name="status"  id="status3" value="3" autocomplete="off">
                                                    <xsl:if test="document/fields/status = '3'">
                                                        <xsl:attribute name="checked">checked</xsl:attribute>
                                                    </xsl:if>
                                                    <xsl:if test="document/@editmode != 'edit'">
                                                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                                                    </xsl:if>
                                                </input>
                                                <label for="status3"><xsl:value-of select="document/captions/status3/@caption" /></label>
                                                <br/>

                                                <input type="radio" name="status"  id="status4" value="4" autocomplete="off">
                                                    <xsl:if test="document/fields/status = '4'">
                                                        <xsl:attribute name="checked">checked</xsl:attribute>
                                                    </xsl:if>
                                                    <xsl:if test="document/@editmode != 'edit'">
                                                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                                                    </xsl:if>
                                                </input>
                                                <label for="status4"><xsl:value-of select="document/captions/status4/@caption" /></label>
                                                <br/>
                                            </td>
                                        </tr>
										<!-- % Исполнения -->
										<tr>
											<td class="fc">
												<font style="vertical-align:top">
													<xsl:value-of select="document/captions/percentage_of_completion/@caption"/>: 
												</font>
											</td>
											<td>
												<input type="text" required="required" id="percentage_of_completion" name="percentage_of_completion" class="td_editable" style="width:180px">
													<xsl:if test="$editmode != 'edit'">
														<xsl:attribute name="readonly">readonly</xsl:attribute>
														<xsl:attribute name="class">td_noteditable</xsl:attribute>
													</xsl:if>
													<xsl:attribute name="title" select="document/fields/percentage_of_completion/@caption"/>
													<xsl:attribute name="value" select="document/fields/percentage_of_completion"/>
												</input> 
											</td>
										</tr>
										
										<!-- Дата начала -->
										<tr>
											<td  class="fc">
												<font style="vertical-align:top">
													<xsl:value-of select="document/captions/startdate/@caption"/>: 
												</font>
											</td>
											<td>
												<input readonly="readonly" required="required" type="text" id="startdate"  name="startdate" onfocus="javascript:$(this).blur()" class="td_editable" style="width:100px; vertical-align:top">
													<xsl:attribute name="title" select="document/captions/startdate/@caption"/>
													<xsl:attribute name="value" select="substring(document/fields/startdate,1,10)"/>
													<xsl:if test="$editmode = 'edit'">
														<xsl:attribute name="class">eventdate</xsl:attribute>
													</xsl:if> 
												</input> 
											</td>
										</tr>
										<!-- Дата завершения -->
										<tr>
											<td class="fc">
												<xsl:value-of select="document/captions/duedate/@caption"/>: 
											</td>
											<td>
												<input readonly="readonly" required="required" type="text" id="duedate" name="duedate" onfocus="javascript:$(this).blur()" class="td_editable" style="width:100px; vertical-align:top">
													<xsl:attribute name="title" select="document/captions/duedate/@caption"/>
													<xsl:attribute name="value" select="substring(document/fields/duedate,1,10)"/>
													<xsl:if test="$editmode = 'edit'">
														<xsl:attribute name="class">eventdate</xsl:attribute>
													</xsl:if> 
												</input>  
											</td>
										</tr>	
										<!-- Ссылка на полигон -->
										<tr>
											<td class="fc">
												<font style="vertical-align:top">
													<xsl:value-of select="document/captions/link_to_poligon/@caption"/>: 
												</font>
											</td>
											<td style="width:70%"> 											
												<xsl:if test="$editmode = 'edit'">	
													<input type="text" id="link_to_poligon" name="link_to_poligon" onkeyup="javascript:checkURL(this.value)" onkeypress="javascript:CheckingURL()" class="td_editable" style="width:500px">													
														<xsl:attribute name="title" select="document/fields/link_to_poligon/@caption" />
														<xsl:attribute name="value" select="document/fields/link_to_poligon" />
													</input> &#xA0;
													<font id="load-img">
														<xsl:if test="document/fields/link_to_poligon != ''">
															<a target="blank" title="Перейти" href="{document/fields/link_to_poligon}"><img src="/SharedResources/img/classic/icons/world_go.png" /></a>
														</xsl:if>
													</font>
												</xsl:if>
												<xsl:if test="$editmode != 'edit'">
													<a href="{document/fields/link_to_poligon}" style="color:blue;" target="blank">
														<xsl:value-of select="document/fields/link_to_poligon"/>
													</a>
												</xsl:if>
											</td>
										</tr> 	
										<!-- Комментарий на полигон -->
										<tr>
											<td class="fc">
												<font style="vertical-align:top">
													<xsl:value-of select="document/captions/comment_to_poligon/@caption"/>: 
												</font>
											</td>
											<td style="width:70%"> 	 									
												<textarea  id="comment_to_poligon" name="comment_to_poligon" class="td_editable" style="max-width:500px; width:500px;height:50px">
													<xsl:if test="$editmode != 'edit'">
														<xsl:attribute name="readonly">readonly</xsl:attribute>
														<xsl:attribute name="class">td_noteditable</xsl:attribute>
													</xsl:if>
													<xsl:attribute name="title" select="document/fields/comment_to_poligon/@caption"/>
													<xsl:value-of select="document/fields/comment_to_poligon"/>
												</textarea> 											 
											</td>
										</tr> 								
										</table>
										<input type="hidden" name="type" value="save"/>
										<input type="hidden" name="id" value="{@id}"/>
										<input type="hidden" name="key" value="{document/@docid}"/>
										<input type="hidden" name="doctype" value="{document/@doctype}"/>
									</div>
								</div>
								<div class="ui-tabs-panel" id="tabs-2" >
									<table width="90%" border="0" style="margin-top:8px; margin-left:60px">
										<tr>
											<td>	
												<xsl:value-of select="document/captions/linkToProjectDoc/@caption"/>:										
											</td>
										</tr>
										<xsl:for-each select="document/fields/projectDocTitle">
											<tr> 												
												<td style="width:70%">
													<a id="projectDocUrl" class="projectDocUrl" style="color:blue">
														<xsl:variable name="pos" select="position()"/>
														<xsl:attribute name="href"><xsl:value-of select="/request/document/fields/projectDocURL[position() = $pos]"/></xsl:attribute>
														<xsl:value-of select="."/>
													</a>
												</td>
											</tr>
										</xsl:for-each>
									</table>
								</div>
								<div id="tabs-3">
									<xsl:call-template name="docinfo"/>
								</div>
							</form>	
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
				<xsl:value-of select="$kaz_part"/>
			</xsl:when>
			<xsl:otherwise>
			 	<xsl:value-of select="$rus_part"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>