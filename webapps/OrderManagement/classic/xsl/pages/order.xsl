<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../templates/page.xsl"/>
	<xsl:variable name="viewtype">Вид</xsl:variable>
	<xsl:output method="html" encoding="utf-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" indent="no"/>
	<xsl:variable name="skin" select="request/@skin"/>
	<xsl:variable name="useragent" select="request/@useragent"/>
	<xsl:variable name="lang" select="request/@lang"/>
	<xsl:template match="/request">
		<html>
			<head>
				<title>OrderManagment - <xsl:call-template name="pagetitle"/></title>
				 <xsl:call-template name="cssandscripts" />
				 <xsl:call-template name="hotkeys" />
			</head>
			<body>
				<xsl:call-template name="flashentry"/>
				<div id="blockWindow" style="display:none"/>
				<div id="wrapper">	
					<div id='loadingpage' style='position:absolute; display:none'>
						<script>
							lw = $("#loadingpage").width();
							lh = $("#loadingpage").height();
							lt = ($(window).height() - lh )/2;
							ll = ($(window).width() - lw )/2;
							$("#loadingpage").css("top",lt);
							$("#loadingpage").css("left",ll + 95);
							$("#loadingpage").css("z-index",1);
						</script>
						<img src='/SharedResources/img/classic/4(4).gif'/>
					</div>	
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
                                            <xsl:if test="//actionbar/action[@id='new_document']/@mode =  'ON'">
                                                <button title="{//actionbar/action[@id='new_document']/@hint}" id="btnNewdoc" style="margin-right:5px">
                                                    <xsl:attribute name="onclick">javascript:window.location.href="<xsl:value-of select="//actionbar/action[@id='new_document']/@url"/>"; beforeOpenDocument()</xsl:attribute>
                                                    <img src="/SharedResources/img/iconset/page_white_add.png" class="button_img"/>
                                                    <font style="font-size:12px; vertical-align:top"><xsl:value-of select="//actionbar/action[@id='new_document']/@caption"/></font>
                                                </button>
                                            </xsl:if>
                                            <xsl:if test="//actionbar/action[@id='delete_document']/@mode =  'ON'">
                                                <button style="margin-right:5px" title="{//actionbar/action[@id='delete_document']/@hint}" id="btnDeldoc">
                                                    <xsl:attribute name="onclick">javascript:delDocument();</xsl:attribute>
                                                    <img src="/SharedResources/img/iconset/page_white_delete.png" class="button_img"/>
                                                    <font style="font-size:12px; vertical-align:top"><xsl:value-of select="//actionbar/action[@id='delete_document']/@caption"/></font>
                                                </button>
                                            </xsl:if>

                                            <button style="margin-right:5px" title="{//captions/fastfiltercaption/@caption}" id="btnQFilter">
 												<xsl:attribute name="onclick">javascript:openQFilterPanel(); </xsl:attribute>
 												<img src="/SharedResources/img/iconset/054.png" class="button_img" style=""/>
 												<font style="font-size:12px; vertical-align:top"><xsl:value-of select="//captions/filter/@caption"/></font>
 											</button>
	    								</td>	
	    								<td style="width:50%">
	    								</td>    								
	    							</tr>
	    						</table>	  
							</div>							
							<div style="clear:both"/>
							<div id="QFilter" style="width:auto; background: #eeeeee; border:1px solid #ccc; border-bottom:none; height:25px; margin-top:5px; margin-left:2px;   position:absolute; top:83px; right:0px; left:12px">
								<xsl:if test="@useragent != 'IE'">
									<xsl:attribute name="style">width:auto; background: #eeeeee; border:1px solid #ccc; height:25px; border-bottom:none; margin-top:3px; margin-left:2px;   position:absolute; top:83px; right:0px; left:12px</xsl:attribute>
								</xsl:if>
								<!--<xsl:if test="query/filtered/condition[fieldname != ''][value != '0']">-->
									<!--<xsl:attribute name="style">width:auto; background: #eeeeee; border:1px solid #ccc; height:25px; margin-top:5px; display:block;margin-left:2px;</xsl:attribute>-->
									<!--<xsl:if test="@useragent != 'IE'">-->
										<!--<xsl:attribute name="style">width:auto; background: #eeeeee; border:1px solid #ccc; height:25px; margin-top:3px;  display:block;margin-left:2px;</xsl:attribute>-->
									<!--</xsl:if>-->
								<!--</xsl:if>-->
								<font style="font-size:11px; line-height:25px; margin-left:5px"><xsl:value-of select="//captions/viewtext1/@caption"/> :</font>
									<span class="customerslistbuttonwrapper">
									  	<font id="customerslistbutton" class="listbutton">
											<xsl:attribute name="onclick">javascript:openCategoryList(this,"customerslist")</xsl:attribute>
											<font style="font-size:11px; font-weight:bold">
												<xsl:variable name="filtervalue" select="query/filtered/condition/value"/>
												<xsl:if test="//query/columns/viewtext1/filter/@mode = 'ON'">
													<xsl:value-of select="//query/columns/viewtext1/filter/@keyword"/>
												</xsl:if>
												<xsl:if test="//query/columns/viewtext1/filter/@mode = 'OFF'"><xsl:value-of select="//captions/all/@caption"/></xsl:if>
											</font>
										</font>
									</span>
									<div id="customerslist" class="glosslisttable" style="position:absolute; top:90px; z-index:999; border:1px solid #79B7E7;  width:300px; background:#fff; visibility:hidden; max-height:400px; overflow:auto">
										<table style="width:100%">
							           		<xsl:for-each select="//filter_elements/response/content/customers/entry">
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
													<xsl:attribute name="onclick">javascript:resetFilter()</xsl:attribute>
													<font style=" width:100%; font-color:#555">
														<xsl:value-of select="//captions/all/@caption"/>
													</font>
												</td>
											</tr>
				        				</table>
				        			</div>
				        		<div style="display:inline-block; width:20px"/>

		        				<font style="font-size:11px; line-height:25px;"><xsl:value-of select="//captions/viewtext2/@caption"/> :</font>
								<span class="statuslistbuttonwrapper">
								  	<font id="statuslistbutton" class="listbutton">
										<xsl:attribute name="onclick">javascript:openCategoryList(this,"statuslist")</xsl:attribute>
										<font style="font-size:11px; font-weight:bold">
											<xsl:variable name="filtervalue" select="query/filtered/condition/value"/>
											<xsl:if test="query/filtered/condition[fieldname eq 'coordstatus'][value != '0'][value != ' ']">
												<xsl:value-of select="glossaries/status/entry[value = $filtervalue]/name"/>
											</xsl:if>
											<xsl:if test="//query/columns/viewtext2/filter/@mode = 'OFF' or not(//query/columns/viewtext2/filter/@mode)"><xsl:value-of select="//captions/all/@caption"/></xsl:if>
										</font>
									</font>
								</span>
								<div id="statuslist" class="glosslisttable" style="position:absolute; top:90px; z-index:999; border:1px solid #79B7E7;  width:300px; background:#fff; visibility:hidden; max-height:400px; overflow:auto">
									<table style="width:100%">
						           		<xsl:for-each select="//filter_elements/response/content/executers/entry">
											<tr style="font-family:Verdana,Arial,Helvetica,sans-serif; font-size:13px; min-width:120px; cursor:pointer">
												<td class="categorylist_td">
													<xsl:attribute name="onclick">javascript:chooseFilter("<xsl:value-of select='@id'/>",'viewtext2')</xsl:attribute>
													<font style=" width:100%;">
														<xsl:value-of select="."/>
													</font>
												</td>
											</tr>
										</xsl:for-each>
										<tr style="font-family:Verdana,Arial,Helvetica,sans-serif; font-size:13px; min-width:120px;">
											<td class="categorylist_td" style=" cursor:pointer; border-top: 1px solid #dddddd;">
												<xsl:attribute name="onclick">javascript:resetFilter()</xsl:attribute>
												<font style=" width:100%; font-color:#555">
													<xsl:value-of select="//captions/all/@caption"/>
												</font>
											</td>
									   	</tr>
			        				</table>
			        			</div>
                                <xsl:if test="//filter/@mode = 'ON'">
                                    <img src="/SharedResources/img/iconset/054-delete.png" style="margin-left:10px; cursor:pointer; vertical-align:-9px; border:1px solid #cdcdcd; padding:3px 4px; border-radius:3px">
                                        <xsl:attribute name="title"><xsl:value-of select="//captions/removefilter/@caption" /></xsl:attribute>
                                        <xsl:attribute name="onclick">javascript:resetFilter()</xsl:attribute>
                                    </img>
                                </xsl:if>
							</div>						
						</div>
						<div id="viewtablediv" style ="top:40px">
							<div id="tableheader" style="top:111px">
								<table class="viewtable" id="viewtable" width="100%">
									<tr class="th">
										<td style="text-align:center;height:30px; width:35px;" class="thcell">
											<input type="checkbox" id="allchbox" autocomplete="off" onClick="checkAll(this)"/>					
										</td>
										<td style="text-align:center;height:30px;width:150px;" class="thcell">
											<!--<xsl:value-of select="page/captions/viewtext/@caption" />-->
 											<xsl:call-template name="sortingcell">
 												<xsl:with-param name="namefield">VIEWTEXT</xsl:with-param>
 												<xsl:with-param name="sortorder" select="//query/columns/viewtext/sorting/@order"/>
 												<xsl:with-param name="sortmode" select="//query/columns/viewtext/sorting/@mode"/>
 											</xsl:call-template>
										</td>
										<td style="text-align:center;height:30px; min-width:150px;" class="thcell">
											<!--<xsl:value-of select="page/captions/viewtext1/@caption" />-->
 											<xsl:call-template name="sortingcell">
 												<xsl:with-param name="namefield">VIEWTEXT1</xsl:with-param>
 												<xsl:with-param name="sortorder" select="//query/columns/viewtext1/sorting/@order"/>
 												<xsl:with-param name="sortmode" select="//query/columns/viewtext1/sorting/@mode"/>
 											</xsl:call-template>
										</td>
                                        <td style="text-align:center;height:30px;width:150px;" class="thcell">
                                            <!--<xsl:value-of select="page/captions/viewdate/@caption" />-->
                                            <xsl:call-template name="sortingcell">
                                                <xsl:with-param name="namefield">VIEWDATE</xsl:with-param>
                                                <xsl:with-param name="sortorder" select="//query/columns/viewdate/sorting/@order"/>
                                                <xsl:with-param name="sortmode" select="//query/columns/viewdate/sorting/@mode"/>
                                            </xsl:call-template>
                                        </td>
										<td style="width:30px;" class="thcell">										 
										</td>
									</tr>
								</table>
							</div>
							<div id="tablecontent" autocomplete="off" style="top:146px">
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

			<td style="text-align:center;border:1px solid #ccc;width:35px;">
				<input type="checkbox" name="chbox" id="{@id}" autocomplete="off" value="{@doctype}"/>
			</td>

			<!--<td style="text-align:center; border:1px solid #ccc;width:34px;">-->
				<!--<xsl:if test="@hasattach != 0">-->
					<!--<img id="atach" src="/SharedResources/img/classic/icons/attach.png" title="Вложений в документе: {@hasattach}"/>-->
				<!--</xsl:if>-->
			<!--</td> -->
			<td style="text-align:left; border:1px solid #ccc; width:150px; text-align:center; word-wrap:break-word">
				<a  href="{@url}" title="{viewcontent/viewtext}" class="doclink">
					<xsl:if test="@isread = 0">
						<xsl:attribute name="style">font-weight:bold;</xsl:attribute>
					</xsl:if> 
					<xsl:value-of select="viewcontent/viewtext"/>
				</a>
			</td>			  
			<td style="border:1px solid #ccc; min-width:160px; word-wrap:break-word;padding-left:10px">								
				<xsl:if test="@hasresponse='1'">
	       			<xsl:choose>
	       				<xsl:when test=".[responses]">
							<a href="" style="vertical-align:top; margin-right:6px" id="a{@docid}">
								<xsl:attribute name='href'>javascript:closeResponses(<xsl:value-of select="@docid"/>, <xsl:value-of select="@doctype"/>,<xsl:value-of select="position()"/>,1)</xsl:attribute>
								<img border='0' src="/SharedResources/img/classic/1/minus.png" id="img{@docid}"/>
							</a>
						</xsl:when>
						<xsl:otherwise>
							<a href="" style="vertical-align:top; margin-right:6px" id="a{@docid}">
								<xsl:attribute name='href'>javascript:openParentDocView(<xsl:value-of select="@docid"/>, <xsl:value-of select="@doctype"/>,<xsl:value-of select="position()"/>,1)</xsl:attribute>
								<img border='0' src="/SharedResources/img/classic/1/plus.png" id="img{@docid}"/>
							</a>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
				<xsl:if test="@hasresponse='0'">
					<span style="width:22px; display:inline-block"></span>
				</xsl:if>
				<a href="{@url}" title="{viewcontent/viewtext}" class="doclink">
					<xsl:if test="@isread = 0">
						<xsl:attribute name="style">font-weight:bold;</xsl:attribute>
					</xsl:if> 
					 <xsl:value-of select="viewcontent/viewtext1" />
				</a>
			</td>
 			<td  style="border:1px solid #ccc; width:150px;text-align:center">
 				<a  href="{@url}" class="doclink" >
 				<xsl:if test="@isread = 0">
 					<xsl:attribute name="style">font-weight:bold; padding-left:20px;</xsl:attribute>
 				</xsl:if>
 				<xsl:value-of select="substring(viewcontent/viewdate, 0 ,11)"/></a>
 			</td>
			<td style="border:1px solid #ccc; border-left:none; width:30px; text-align:center">
				<img class="favicon" style="cursor:pointer; width:18px; height:18px" src="/SharedResources/img/iconset/star_empty.png">
					<xsl:if test="@favourites = 1">
						<xsl:attribute name="onclick">javascript:removeDocFromFav(this,<xsl:value-of select="@docid"/>,<xsl:value-of select="@doctype"/>)</xsl:attribute> 
						<xsl:attribute name="src">/SharedResources/img/iconset/star_full.png</xsl:attribute>
						<xsl:attribute name ="title"><xsl:value-of select ="//page/captions/removefromfav/@caption"></xsl:value-of></xsl:attribute> 
					</xsl:if>
					<xsl:if test="@favourites = 0 or not(@favourites)"> 
						<xsl:attribute name="onclick">javascript:addDocToFav(this,<xsl:value-of select="@docid"/>,<xsl:value-of select="@doctype"/>)</xsl:attribute>
						<xsl:attribute name="src">/SharedResources/img/iconset/star_empty.png</xsl:attribute> 
					<xsl:attribute name ="title"><xsl:value-of select ="//page/captions/addtofav/@caption"></xsl:value-of></xsl:attribute>
					</xsl:if>
				</img>
			</td>
		</tr>
		<xsl:apply-templates select="responses"/>
	</xsl:template>
	
	<xsl:template match="responses">
		<tr class="response{../@docid}">
			<xsl:attribute name="bgcolor">#FFFFFF</xsl:attribute>
			<td/>
			<td/>  
			<td/>  
			<td/>  
			<td colspan="3" nowrap="true">
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
		<xsl:if test="@form = 'projectDoc'">				
			<xsl:call-template name="viewtable_dblclick_open"/>
			<span style="width:15px;">
				<input type="checkbox" name="chbox" id="{@id}" value="{@doctype}"/>
			</span>
		</xsl:if>
		<a href="{@url}" title="{@viewtext}" class="doclink" style="font-style:Verdana,​Arial,​Helvetica,​sans-serif; width:100%; font-size:97%; margin-left:2px">
			<xsl:attribute name="onclick">javascript:beforeOpenDocument()</xsl:attribute>
			<xsl:if test="@isread = 0">
				<xsl:attribute name="style">font-weight:bold</xsl:attribute>
			</xsl:if> 
			<xsl:if test="@hasattach != 0">
				<img id="atach" src="/SharedResources/img/classic/icons/attach.png" border="0" style="vertical-align:top; margin-left:2px; margin-right:4px">
					<xsl:attribute name="title">Вложений в документе: <xsl:value-of select="@hasattach"/></xsl:attribute>
				</img> 
			</xsl:if>			
			<xsl:variable name='simbol'>'</xsl:variable>
			<xsl:variable name='ecr1' select="replace(viewcontent/viewtext,$simbol ,'&quot;')"/>
			<xsl:variable name='ecr2' select="replace($ecr1, '&#34;' ,'&quot;')"/>
			<font id="font{@docid}{@doctype}" style="line-height:19px">
				<script>
					text='<xsl:value-of select="$ecr2"/>';
					symcount= <xsl:value-of select="string-length(@viewtext)"/>;
					ids="font<xsl:value-of select="@docid"/><xsl:value-of select="@doctype"/>";
					 replaceVal="<img/>";
					text=text.replace("->",replaceVal);
					$("#"+ids).html(text);
					$("#"+ids+" > img").attr("src","/SharedResources/img/classic/arrow_blue.gif");
					$("#"+ids+" > img").attr("style","vertical-align:middle");
					$("#"+ids).removeAttr("id");
				</script>
			</font>
		</a>
	</xsl:template>

	<xsl:template name="graft">
		<xsl:apply-templates select="ancestor::entry" mode="tree"/>
		<xsl:choose>
			<xsl:when test="following-sibling::entry">
				<img style="vertical-align:top;" src="/SharedResources/img/classic/tree_tee.gif"/>
			</xsl:when>
			<xsl:otherwise>
				<img style="vertical-align:top;" src="/SharedResources/img/classic/tree_corner.gif"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="responses" mode="tree"/>

	<xsl:template match="*" mode="tree">
		<xsl:choose>
			<xsl:when test="following-sibling::entry and entry[@url]">
				<img style="vertical-align:top;" src="/SharedResources/img/classic/tree_bar.gif"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="parent::responses">
					<img style="vertical-align:top;" src="/SharedResources/img/classic/tree_spacer.gif"/>
				</xsl:if>
				<xsl:if test="parent::entry">
					<img style="vertical-align:top;" src="/SharedResources/img/classic/tree_spacer.gif"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>