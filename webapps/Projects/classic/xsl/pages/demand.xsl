<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<xsl:import href="../templates/page.xsl"/>
	<xsl:variable name="viewtype">Вид</xsl:variable>
	<xsl:variable name="actionbar" select="//actionbar"/>
	<xsl:variable name="query" select="//query"/>
	<xsl:variable name="captions" select="/request/page/captions/page/captions"/>
	<xsl:output method="html" encoding="utf-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" indent="no"/>
	<xsl:variable name="skin" select="request/@skin"/>
	<xsl:variable name="useragent" select="request/@useragent"/>
	<xsl:variable name="lang" select="request/@lang"/>
	<xsl:template match="/request">
		<html>
			<head>
				<title>Projects - <xsl:call-template name="pagetitle"/></title>
                <xsl:call-template name="cssjs" />
                <xsl:call-template name="hotkeys" />
                <xsl:call-template name="calendar" />
			</head>
			<body>
				<xsl:call-template name="flashentry"/>
				<div id="blockWindow" style="display:none"/>
				<div id="wrapper">	
					<xsl:call-template name="loadingpage"/>
					<xsl:call-template name="header-view"/>			
					<xsl:call-template name="outline-menu-view"/>
					<span id="view" class="viewframe">
						<div id="viewcontent">
							<div id="viewcontent-header" style="height:68px; position:relative;">
								<xsl:call-template name="pageinfo"/>
								<div class="button_panel" style="top:15px; position:absolute; left:0px; right:0px">
									<table style="width:100%; top:30px; position:absolute">
		    							<tr>
		    								<td style="width:40%; padding-left:13px">
		    									<xsl:if test="$actionbar/action[@id='new_demand']/@mode =  'ON'">							
													<button title="{$actionbar/action[@id='new_demand']/@hint}" id="btnNewdoc" style="margin-right:5px">
														<xsl:attribute name="href">javascript:window.location.href="<xsl:value-of select="$actionbar/action[@id='new_demand']/@url"/>"; <!--beforeOpenDocument()--></xsl:attribute>
														<xsl:attribute name="onclick">javascript:window.location.href="<xsl:value-of select="$actionbar/action[@id='new_demand']/@url"/>"; <!--beforeOpenDocument()--></xsl:attribute>
														<img src="/SharedResources/img/iconset/page_white_add.png" class="button_img"/>
														<font class="button_text"><xsl:value-of select="$actionbar/action[@id='new_demand']/@caption"/></font>
													</button>	
												</xsl:if>
												<xsl:if test="$actionbar/action[@id='delete_document']/@mode =  'ON'">
													<button style="margin-right:5px" title="{$actionbar/action[@id='delete_document']/@hint}" id="btnDeldoc">
														<xsl:attribute name="onclick">javascript:delDocument();</xsl:attribute>
														<img src="/SharedResources/img/iconset/page_white_delete.png" class="button_img"/>
														<font class="button_text"><xsl:value-of select="$actionbar/action[@id='delete_document']/@caption"/></font>
													</button>	
												</xsl:if>
		    								</td>	
		    								<td style="width:50%">
		    								</td>    								
		    							</tr>
		    						</table>	  
								</div>							
								<div style="clear:both"/>
								<div id="QFilter" style="width:auto; background: #eeeeee; border:1px solid #ccc; border-bottom:none; height:27px; margin-top:5px; margin-left:2px; display:block; position:absolute; top:81px; right:0px; left:12px">
									<xsl:if test="@useragent != 'IE'">
										<xsl:attribute name="style">width:auto; background: #eeeeee; border:1px solid #ccc; border-bottom:none; height:29px; margin-top:5px; margin-left:2px; display:block; position:absolute; top:79px; right:0px; left:12px</xsl:attribute>
									</xsl:if>
									<xsl:if test="@id != 'demandsbyproject'">
										<font style="font-size:11px; line-height:25px; margin-left:5px"><xsl:value-of select="$captions/viewtext1/@caption"/> :</font>
										<span class="prjlistbuttonwrapper">
										  	<font id="prjlistbutton" class="listbutton">
												<xsl:attribute name="onclick">javascript:openCategoryList(this,"prjlist")</xsl:attribute>
												<font style="font-size:11px; font-weight:bold">
													<xsl:variable name="filtervalue" select="$query/filtered/condition/value"/>
													<xsl:if test="$query/columns/viewtext1/filter/@mode = 'ON'">
														<xsl:value-of select="$query/columns/viewtext1/filter/@keyword"/>
													</xsl:if>
													<xsl:if test="$query/columns/viewtext1/filter/@mode = 'OFF'"><xsl:value-of select="$captions/all/@caption"/></xsl:if>
												</font>
											</font>
										</span>
										<div id="prjlist" class="glosslisttable" style="position:absolute; top:90px; z-index:999; border:1px solid #79B7E7;  width:300px; background:#fff; display:none; max-height:400px; overflow:auto">
											<table style="width:100%">
								           		<xsl:for-each select="//filter_elements/response/content/projects/entry">
													<xsl:sort select="."/>
													<tr style="font-family:Verdana,Arial,Helvetica,sans-serif; font-size:13px; min-width:120px; cursor:pointer">
														<td class="categorylist_td">
															<xsl:attribute name="onclick">javascript:chooseFilter("<xsl:value-of select='.'/>",'viewtext1')</xsl:attribute>
															<font style=" width:100%;">
																<xsl:value-of select="."/>
															</font>
														</td>
													</tr>
												</xsl:for-each>
												<tr style="font-family:Verdana,Arial,Helvetica,sans-serif; font-size:13px; min-width:120px;">
													<td class="categorylist_td" style=" cursor:pointer; border-top: 1px solid #dddddd;">
														<xsl:attribute name="onclick">javascript:resetCurrentFilter('viewtext1')</xsl:attribute>
														<font style=" width:100%; font-color:#555">
															<xsl:value-of select="$captions/all/@caption"/>
														</font>
													</td>
												</tr>
					        				</table>
					        			</div>
					        			<div style="display:inline-block; width:20px"/>
					        		</xsl:if>
									<font style="font-size:11px; line-height:25px; margin-left:5px"><xsl:value-of select="$captions/author/@caption"/> :</font>
									<span class="catlistbuttonwrapper">
									  	<span id="catlistbutton" class="listbutton">
											<xsl:attribute name="onclick">javascript:openCategoryList(this,"catlist")</xsl:attribute>
											<font style="font-size:11px; font-weight:bold">
												<xsl:if test="$query/columns/viewtext7/filter/@mode = 'ON'">
													<xsl:value-of select="$query/columns/viewtext7/filter/@keyword"/>
												</xsl:if>
												<xsl:if test="$query/columns/viewtext7/filter/@mode = 'OFF' or not($query/columns/viewtext7/filter/@mode)"><xsl:value-of select="$captions/all/@caption"/></xsl:if>
											</font>
										</span>
									</span>
									<div id="catlist" class="glosslisttable" style="position:absolute; top:90px; z-index:999; border:1px solid #79B7E7;  width:300px; background:#fff; display:none; max-height:400px; overflow:auto">
										<table style="width:100%">
							           		<xsl:for-each select="//filter_elements/response/content/authors/entry">
												<xsl:sort select="."/>
												<tr style="font-family:Verdana,Arial,Helvetica,sans-serif; font-size:13px; min-width:120px; cursor:pointer">
													<td class="categorylist_td">
														<xsl:attribute name="onclick">javascript:chooseFilter("<xsl:value-of select='@id'/>",'viewtext7')</xsl:attribute>
														<font style=" width:100%;">
															<xsl:value-of select="."/>
														</font>
													</td>
												</tr>
											</xsl:for-each>
											<tr style="font-family:Verdana,Arial,Helvetica,sans-serif; font-size:13px; min-width:120px;">
												<td class="categorylist_td" style=" cursor:pointer; border-top: 1px solid #dddddd;">
													<xsl:attribute name="onclick">javascript:resetCurrentFilter('viewtext7')</xsl:attribute>
													<font style=" width:100%; font-color:#555">
														<xsl:value-of select="$captions/all/@caption"/>
													</font>
												</td>
										   	</tr>
				        				</table>
			        				</div>
			        				<div style="display:inline-block; width:20px"/>
			        				<font style="font-size:11px; line-height:25px;"><xsl:value-of select="$captions/executer/@caption"/> :</font>
									<span class="statuslistbuttonwrapper">
									  	<span id="statuslistbutton" class="listbutton">
											<xsl:attribute name="onclick">javascript:openCategoryList(this,"statuslist")</xsl:attribute>
											<font style="font-size:11px; font-weight:bold">
												<xsl:if test="$query/columns/viewtext5/filter/@mode = 'ON'">
													<xsl:value-of select="$query/columns/viewtext5/filter/@keyword"/>
												</xsl:if>
												<xsl:if test="$query/columns/viewtext5/filter/@mode = 'OFF' or not($query/columns/viewtext5/filter/@mode)"><xsl:value-of select="$captions/all/@caption"/></xsl:if>
											</font>
										</span>
									</span>
									<div id="statuslist" class="glosslisttable" style="position:absolute; top:90px; z-index:999; border:1px solid #79B7E7;  width:300px; background:#fff; display:none; max-height:400px; overflow:auto">
										<table style="width:100%">
							           		<xsl:for-each select="//filter_elements/response/content/executers/entry">
												<xsl:sort select="."/>
												<tr style="font-family:Verdana,Arial,Helvetica,sans-serif; font-size:13px; min-width:120px; cursor:pointer">
													<td class="categorylist_td">
														<xsl:attribute name="onclick">javascript:chooseFilter("<xsl:value-of select='@id'/>",'viewtext5')</xsl:attribute>
														<font style=" width:100%;">
															<xsl:value-of select="."/>
														</font>
													</td>
												</tr>
											</xsl:for-each>
											<tr style="font-family:Verdana,Arial,Helvetica,sans-serif; font-size:13px; min-width:120px;">
												<td class="categorylist_td" style=" cursor:pointer; border-top: 1px solid #dddddd;">
													<xsl:attribute name="onclick">javascript:resetCurrentFilter('viewtext5')</xsl:attribute>
													<font style=" width:100%; font-color:#555">
														<xsl:value-of select="$captions/all/@caption"/>
													</font>
												</td>
										   	</tr>
				        				</table>
				        			</div>
				        			<xsl:if test="//filter/@mode = 'ON'">
					        			<img src="/SharedResources/img/iconset/054-delete.png" style="margin-left:10px; cursor:pointer; vertical-align:-9px; border:1px solid #cdcdcd; padding:3px 4px; border-radius:3px">
			        						<xsl:attribute name="title"><xsl:value-of select="//captions/removefilter/@caption"/></xsl:attribute>
			        						<xsl:attribute name="onclick">javascript:resetFilter()</xsl:attribute>
				        				</img>
			        				</xsl:if>
								</div>						
							</div>
						<div id="viewtablediv" style ="top:20px">
							<div id="tableheader" style="top:112px">
								<table class="viewtable" id="viewtable" width="100%">
									<tr class="th">
										<td style="text-align:center;height:30px; width:35px;" class="thcell">
											<input type="checkbox" id="allchbox" autocomplete="off" onClick="checkAll(this)"/>					
										</td>
										<td style="text-align:center;height:30px;width:35px;" class="thcell"></td>
										<td style="text-align:center;height:30px;width:45px;" class="thcell">
											<xsl:call-template name="sortingcell">
												<xsl:with-param name="namefield">VIEWNUMBER</xsl:with-param>
												<xsl:with-param name="sortorder" select="$query/columns/viewnumber/sorting/@order"/>
												<xsl:with-param name="sortmode" select="$query/columns/viewnumber/sorting/@mode"/>
											</xsl:call-template>
										</td>
										<td style="text-align:center;height:30px; width:150px;" class="thcell">
											<xsl:call-template name="sortingcell">
												<xsl:with-param name="namefield">VIEWTEXT1</xsl:with-param>
												<xsl:with-param name="sortorder" select="$query/columns/viewtext1/sorting/@order"/>
												<xsl:with-param name="sortmode" select="$query/columns/viewtext1/sorting/@mode"/>
											</xsl:call-template>
										</td>
										<td style="min-width:160px; width:55%" class="thcell">
											<xsl:value-of select ="$captions/viewtext/@caption"/>
										</td>
										<td style="width:200px;" class="thcell">
											<xsl:call-template name="sortingcell">
												<xsl:with-param name="namefield">VIEWDATE</xsl:with-param>
												<xsl:with-param name="sortorder" select="$query/columns/viewdate/sorting/@order"/>
												<xsl:with-param name="sortmode" select="$query/columns/viewdate/sorting/@mode"/>
											</xsl:call-template>
										</td>
										<td style="width:30px;" class="thcell"></td>
                                        <td style="width:50px;" class="thcell"></td>
									</tr>
								</table>
							</div>
							<div id="tablecontent" autocomplete="off" style="top:147px">
								<table class="viewtable" id="viewtable" width="100%">	
									<xsl:apply-templates select="//query/entry"/>									
								</table>
								<div style="clear:both; width:100%">&#xA0;</div>
							</div>
							<div style="clear:both"/>	
						</div>
						</div>
					</span>
				</div>
			</body>
		</html>
	</xsl:template>
	
	<xsl:template match="//query/entry">
		<xsl:variable name="num" select="position()"/>
		<tr title="{@viewtext}" class="{@docid}" id="{@docid}{@doctype}">
			<xsl:if test ="viewcontent/viewtext2 &gt; '0'">
				<xsl:attribute name="bgcolor">#FFFFFF</xsl:attribute>
			</xsl:if>
			<xsl:if test ="viewcontent/viewtext2 ='0'">
				<xsl:attribute name="bgcolor">#FCFCE5</xsl:attribute>
			</xsl:if>
			<xsl:if test ="viewcontent/viewtext2 &lt; '0'">
				<xsl:attribute name="bgcolor">#FFEDED</xsl:attribute>
			</xsl:if>
			<td style="text-align:center;border:1px solid #ccc;width:35px;">
				<input type="checkbox" name="chbox" id="{@id}" autocomplete="off" value="{@doctype}"/>
			</td>	
			<td style="text-align:center; border:1px solid #ccc;width:34px;">
				<xsl:if test="@hasattach != 0">
					<img id="atach" src="/SharedResources/img/classic/icons/attach.png" title="Вложений в документе: {@hasattach}"/>
				</xsl:if>
			</td>
			<td style="text-align:center ;border:1px solid #ccc; width:45px;">
				<a href="{@url}" title="{viewcontent/viewtext}" class="doclink">
					<xsl:if test="@isread = 0">
						<xsl:attribute name="style">font-weight:bold;</xsl:attribute>
					</xsl:if> 
					<xsl:value-of select="viewcontent/viewnumber"/>
				</a>
			</td>	
			<td style="text-align:left; border:1px solid #ccc; width:150px; padding-left:10px; word-wrap:break-word">
				<a  href="{@url}" title="{viewcontent/viewtext}" class="doclink">
					<xsl:if test="@isread = 0">
						<xsl:attribute name="style">font-weight:bold;</xsl:attribute>
					</xsl:if> 
					<xsl:value-of select="viewcontent/viewtext1"/>
				</a>
			</td>			  
			<td style="border:1px solid #ccc; min-width:160px; word-wrap:break-word; width:55%">								
				<xsl:if test="@hasresponse='1'">
					<img style="vertical-align:-4px; margin-left:2px; margin-right:5px; border:0px; cursor:pointer" src="/SharedResources/img/classic/1/plus1.png" docid="{@docid}" doctype="{@doctype}">
						<xsl:attribute name='onclick'>javascript:openParentDocView(this)</xsl:attribute>
						<xsl:if test=".[responses]">
							<xsl:attribute name='src'>/SharedResources/img/classic/1/minus1.png</xsl:attribute>
							<xsl:attribute name='onclick'>javascript:closeResponses(this)</xsl:attribute>
						</xsl:if>
					</img>
				</xsl:if>
				<xsl:if test="@hasresponse='0'">
					<span style="width:23px; display:inline-block"></span>
				</xsl:if>
				<a href="{@url}" title="{viewcontent/viewtext}" class="doclink">
					<xsl:if test="@isread = 0">
						<xsl:attribute name="style">font-weight:bold;</xsl:attribute>
					</xsl:if> 
					<xsl:variable name='simbol'>'</xsl:variable>
					<xsl:variable name='ecr1' select="replace(viewcontent/viewtext,$simbol ,'&quot;')"/>
					<xsl:variable name='ecr2' select="replace($ecr1, '&#34;' ,'&quot;')"/>
					<xsl:variable name='ecr2' select="replace($ecr2, '&#92;&#92;' ,'&#92;&#92;&#92;&#92;')"/>
					<font id="font{@docid}{@doctype}">					 
						<script>
							control = '<xsl:value-of select = "viewcontent/viewtext4"/>'
							text='<xsl:value-of select="$ecr2"/>';
							symcount= <xsl:value-of select="string-length(@viewtext)"/>;
							ids="font<xsl:value-of select="@docid"/><xsl:value-of select="@doctype"/>";
		  					replaceVal='<img class="arrow"/>';
		 					text=text.replace("->",replaceVal); 
		 					if(control == '0' || control =='-1' || control =='2'){
								//text = $(text).find(":").first().after('<img class="control"/>')
								replaceControl =': <img height="14" class="control"/>';
		 						text=text.replace(":",replaceControl); 
							} 
							$("#"+ids).html(text);
							$("#"+ids+" > .arrow").attr("src","/SharedResources/img/classic/arrow_blue.gif");
							$("#"+ids+" > .arrow").attr("style","vertical-align:middle");
							$("#"+ids+" > .control").attr("src","/SharedResources/img/classic/icons/tick.png");
							if(control == '-1'){
								$("#"+ids+" > .control").attr("src","/SharedResources/img/iconset/bullet_orange.png").attr("title","Документ отменен автором");
							}
							if(control == '2'){
								$("#"+ids+" > .control").attr("src","/SharedResources/img/iconset/tick_gray.png").attr("title","Документ готов к снятию с контроля");
							}
							$("#"+ids+" > .control").attr("style","vertical-align:top");
							$("#"+ids).removeAttr("id");
						</script>
					</font>
				</a>
			</td>
			<td  style="border:1px solid #ccc; width:200px;">
				<a  href="{@url}" class="doclink" style="padding-left:10px;">
                    <xsl:if test="@isread = 0">
                        <xsl:attribute name="style">font-weight:bold; padding-left:10px;</xsl:attribute>
                    </xsl:if>
                    <xsl:choose>
                        <xsl:when test="viewcontent/viewtext4 = '1' or viewcontent/viewtext4 = '2'">
                            <xsl:value-of select="substring(viewcontent/viewdate, 0, 11)"/>&#xA0;
                                (<xsl:value-of select="viewcontent/viewtext2"/>)
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="substring(viewcontent/viewdate, 0, 11)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </a>
			</td>
			<td style="border:1px solid #ccc; border-left:none; width:30px; text-align:center">
				<img class="favicon" style="cursor:pointer; width:18px; height:18px" src="/SharedResources/img/iconset/star_empty.png">
					<xsl:attribute name="title" select="$captions/addtofav/@caption"/>
					<xsl:attribute name="onclick">javascript:addDocToFav(this,<xsl:value-of select="@docid"/>,<xsl:value-of select="@doctype"/>)</xsl:attribute>
					<xsl:if test="@favourites = 1">
						<xsl:attribute name="title" select="$captions/removefromfav/@caption"/>
						<xsl:attribute name="onclick">javascript:removeDocFromFav(this,<xsl:value-of select="@docid"/>,<xsl:value-of select="@doctype"/>)</xsl:attribute> 
						<xsl:attribute name="src">/SharedResources/img/iconset/star_full.png</xsl:attribute>
					</xsl:if>
				</img>
			</td>
			<td style="border:1px solid #ccc; border-left:none; width:30px; text-align:center">
				<xsl:if test="@topicid = '0'">
					<xsl:attribute name="title" select="//captions/nodiscussion/@caption"/>
				</xsl:if>
				<xsl:if test="@topicid != '0'">
					<a title="{//captions/viewdiscussion/@caption}">
						<xsl:attribute name="href">Provider?type=edit&amp;element=discussion&amp;id=topic&amp;key=<xsl:value-of select="@topicid"/></xsl:attribute>
						<img class="favicon" style="width:18px; height:18px" src="/SharedResources/img/classic/icons/comment.png"/>
					</a>
				</xsl:if> 
			</td>
		</tr>
		<xsl:apply-templates select="responses"/>
	</xsl:template>
	
	<xsl:template match="responses">
		<tr class="{concat('response',../@docid,../@doctype)}">
			<xsl:attribute name="bgcolor">#FFFFFF</xsl:attribute>
			<td/>
			<td/>  
			<td/>  
			<td/>  
			<td colspan="4" nowrap="true">
				<xsl:apply-templates mode="line"/>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template match="entry" mode="line">
		<div class="Node" style="overflow:hidden; height:22px" id="{@docid}{@doctype}">
			<xsl:call-template name="graft"/>
			<xsl:apply-templates select="." mode="item"/>
		</div>
		<xsl:apply-templates mode="line"/>
	</xsl:template>
	
	<xsl:template match="viewcontent" mode="line"></xsl:template>
	
	<xsl:template match="entry" mode="item">
		<xsl:if test="@form = 'kip'">
			<xsl:call-template name="viewtable_dblclick_open"/>
			<span style="width:15px;">
				<input type="checkbox" name="chbox" id="{@id}" value="{@doctype}"/>
			</span>
		</xsl:if>
		<a href="{@url}" title="{@viewtext}" class="doclink" style="font-style:Verdana,​Arial,​Helvetica,​sans-serif; width:100%; font-size:97%; margin-left:2px">
			<!--<xsl:attribute name="onclick">javascript:beforeOpenDocument()</xsl:attribute>-->
			<xsl:if test="@isread = 0">
				<xsl:attribute name="style">font-weight:bold</xsl:attribute>
			</xsl:if> 
			<xsl:if test="@hasattach != 0">
				<img id="atach" src="/SharedResources/img/classic/icons/attach.png" border="0" style="vertical-align:top; margin-left:2px; margin-right:4px">
					<xsl:attribute name="title" select="concat('Вложений в документе: ', @hasattach)"/> 
				</img> 
			</xsl:if>			
			<xsl:variable name='simbol'>'</xsl:variable>
			<xsl:variable name='ecr1' select="replace(viewcontent/viewtext,$simbol ,'&quot;')"/>
			<xsl:variable name='ecr2' select="replace($ecr1, '&#34;' ,'&quot;')"/>
			<xsl:variable name='ecr2' select="replace($ecr2, '&#92;&#92;' ,'&#92;&#92;&#92;&#92;')"/>
			<font id="font{@docid}{@doctype}" style="line-height:19px">
				<script>
					text='<xsl:value-of select="$ecr2"/>';
					symcount= <xsl:value-of select="string-length(@viewtext)"/>;
					ids="<xsl:value-of select="concat('font',@docid,@doctype)"/>";
					replaceVal="<img/>";
					text=text.replace("->",replaceVal);
					$("#"+ids).html(text);
					$("#"+ids+" > img").attr("src","/SharedResources/img/classic/arrow_blue.gif").attr("style","vertical-align:middle");
					$("#"+ids).removeAttr("id");
				</script>
			</font>
		</a>
	</xsl:template>

	<xsl:template name="graft">
		<xsl:apply-templates select="ancestor::entry" mode="tree"/>
		<img style="vertical-align:top;" src="/SharedResources/img/classic/tree_corner.gif">
			<xsl:if test="following-sibling::entry">
				<xsl:attribute name="src" select="'/SharedResources/img/classic/tree_tee.gif'"/>
			</xsl:if>
		</img>
	</xsl:template>
	
	<xsl:template match="responses" mode="tree"/>

	<xsl:template match="*" mode="tree">
		<xsl:choose>
			<xsl:when test="following-sibling::entry and entry[@url]">
				<img style="vertical-align:top;" src="/SharedResources/img/classic/tree_bar.gif"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="parent::responses or parent::entry">
					<img style="vertical-align:top;" src="/SharedResources/img/classic/tree_spacer.gif"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>