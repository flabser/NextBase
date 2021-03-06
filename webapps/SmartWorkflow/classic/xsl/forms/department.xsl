<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../templates/form.xsl"/>
	<xsl:import href="../templates/sharedactions.xsl"/>
	<xsl:variable name="doctype">Департамент</xsl:variable>
	<xsl:variable name="threaddocid" select="document/@docid"/>
	<xsl:variable name="editmode" select="/request/document/@editmode"/>
	<xsl:output method="html" encoding="utf-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" indent="yes"/>
	<xsl:variable name="skin" select="request/@skin"/>
	<xsl:template match="/request">
		<html>
			<head>
				<title>
					<xsl:value-of select="document/captions/department/@caption"/> - Workflow документооборот
				</title>
				<xsl:call-template name="cssandjs"/>
				<xsl:call-template name="keypressactions"/>
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
								<button title ="{document/captions/saveclose/@hint}"  class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
									<xsl:attribute name="onclick">javascript:SaveFormJquery('frm','frm',&quot;<xsl:value-of select="history/entry[@type eq 'view'][last()]"/>&quot;)</xsl:attribute>
									<span>
										<img src="/SharedResources/img/classic/icons/disk.png" class="button_img"/>
										<font style="font-size:12px; vertical-align:top"><xsl:value-of select="document/captions/saveclose/@caption"/></font>
									</span>
								</button>
								<xsl:if test="document/@status !='new'">
									<button class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" style="margin-left:5px">
										<xsl:attribute name="onclick">javascript:window.location.href="Provider?type=structure&amp;id=department&amp;key=&amp;parentdocid=<xsl:value-of select="document/@docid"/>&amp;parentdoctype=<xsl:value-of select="document/@doctype"/>"</xsl:attribute>
										<span>
											<img src="/SharedResources/img/classic/icons/package_add.png" class="button_img"/>
											<font style="font-size:12px; vertical-align:top"><xsl:value-of select="document/captions/newdept/@caption"/></font>
										</span>
									</button>
									<button class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" style="margin-left:5px">
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
					                                 			<xsl:value-of select="document/captions/parentsubkey/@caption"/>&#xA0;</td>
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
						                               			<xsl:value-of select="document/captions/subdivision/@caption"/>&#xA0;
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
						                                <xsl:value-of select="document/captions/comment/@caption"/>
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
		  		<xsl:call-template name="formoutline"/>
			</body>	
		</html>
	</xsl:template>
</xsl:stylesheet>