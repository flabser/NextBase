<?xml version="1.0" ?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../templates/view.xsl"/>
	<xsl:variable name="viewtype">Вид</xsl:variable>
	<xsl:variable name="actionbar" select="//actionbar"/>
	<xsl:variable name="query" select="//query"/>
	<xsl:output method="html" encoding="utf-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" indent="no"/>
	<xsl:variable name="skin" select="request/@skin"/>
	<xsl:variable name="useragent" select="request/@useragent"/>
	<xsl:variable name="id" select="//request/@id"/>
	<xsl:template match="//query/entry">
		<xsl:variable name="num" select="position()"/>
		<tr title="{@viewtext}" class="{@docid}" id="{@docid}{@doctype}">
			<xsl:attribute name="bgcolor">#FFFFFF</xsl:attribute>
			<xsl:if test="viewcontent/viewnumber &lt; 0 and viewcontent/viewtext3 = '1' and /request/@id != 'completetask'">
				<xsl:attribute name="bgcolor">#FFEDED</xsl:attribute>
			</xsl:if>
			<xsl:if test="viewcontent/viewnumber = '0' and viewcontent/viewtext3 = '1' and /request/@id != 'completetask'">
				<xsl:attribute name="bgcolor">#FCFCE5</xsl:attribute>
			</xsl:if>
			<xsl:if test="@isread = '0'">
				<xsl:attribute name="font-weight">bold</xsl:attribute>
			</xsl:if>
			<xsl:call-template name="viewtable_dblclick_open"/>
			<td style="text-align:center;border:1px solid #ccc;width:23px;">
				<input type="checkbox" name="chbox" id="{@id}" autocomplete="off" value="{@doctype}"/>
			</td>
			<td style="border:1px solid #ccc; width:60px; padding:3px;text-align:center;">
				<table style="width:auto; border-collapse:collapse; ">
					<tr class="notviewtr">
						<td style="max-width:35px; width:35px;  padding-left:3px; text-align:center">
							<xsl:choose>
								<xsl:when test="coordstatus='354'">
									<img id="control" title="Проект был отклонен" src="/SharedResources/img/classic/icons/exclamation.png" style="height:14px; width:14px"/>
								</xsl:when>
								<xsl:when test="coordstatus='356'">
									<img id="control" title="Проект подписан" src="/SharedResources/img/classic/icons/pencil.png" style="height:14px; width:14px "/>
								</xsl:when>
							</xsl:choose>
						</td>
						<td style="width:34px; padding-left:4px;">
							<xsl:if test="@hasattach != '0'">
								<img id="atach" src="/SharedResources/img/classic/icons/attach.png" title="Вложений в документе: {@hasattach}"/>
							</xsl:if>
						</td>
					</tr>
				</table>
			</td>
			
			<!-- Control -->
			<td style="border:1px solid #ccc; width:60px; padding:3px">
				<table style="width:auto; border-collapse:collapse">
					<tr  class="notviewtr">
						<td style="max-width:50px; width:50px;  padding-left:3px; text-align:center">
							<xsl:choose>
								<xsl:when test="/request/@id = 'task'  or /request/@id = 'mytasks' or /request/@id = 'taskforme'">
									<font style="font-size:9px;">
										<xsl:attribute name="color">
											<xsl:choose>
												<xsl:when test="viewcontent/viewnumber &lt; 0">#F44F00</xsl:when>
												<xsl:when test="viewcontent/viewnumber = 0">#FFD700</xsl:when>
												<xsl:otherwise>#BCBCBC</xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>
										<xsl:attribute name="title">
											<xsl:value-of select="/request/columns/column[@id='DBDCAPTION']/@caption"/>
										</xsl:attribute>
										<xsl:value-of select="viewcontent/viewnumber"/>
									</font>
								</xsl:when>
								<xsl:when test="/request/@id = 'completetask'">
									<font style="font-size:9px;">
										<xsl:attribute name="color">
											<xsl:choose>
												<xsl:when test="viewcontent/viewnumber &lt; 0">#F44F00</xsl:when>
												<xsl:when test="viewcontent/viewnumber = 0">#FFD700</xsl:when>
												<xsl:otherwise>#BCBCBC</xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>
										<xsl:attribute name="title">
											<xsl:if test="viewcontent/viewnumber &gt; 0 or viewcontent/viewnumber = 0">
												<xsl:value-of select="/request/columns/column[@id='DBDINTIMECAPTION']/@caption"/>
											</xsl:if>
											<xsl:if test="viewcontent/viewnumber &lt; 0">
												<xsl:value-of select="/request/columns/column[@id='DBDNOTINTIMECAPTION']/@caption"/>
											</xsl:if>
										</xsl:attribute>
										<xsl:value-of select="viewcontent/viewnumber"/>
									</font>
									</xsl:when>
								</xsl:choose>
							</td>
							<td style="min-width:16px; padding-left:3px;">
								<xsl:if test="/request/@id = 'completetask' or viewcontent/viewtext3 = '0'">
									<img id="control" title="Документ снят с контроля" src="/SharedResources/img/classic/icons/tick.png"/>
								</xsl:if>
							</td>
						</tr>
					</table>
			</td>
			
			<!-- NUmber -->
			<xsl:if test="/request/@id != 'task' and /request/@id != 'taskforme'  and /request/@id !='mytasks' and /request/@id !='completetask' and /request/@id != 'waitforcoord' and /request/@id != 'waitforsign' and /request/@id != 'workdocprj' and /request/@id != 'outdocprj'  and /request/@id != 'outdocreg'">
				<td  style="border:1px solid #ccc; width:60px;">
					<div style="overflow:hidden; width:100%; padding-left:5px">
						<a href="{@url}" class="doclink" style="width:100%; margin-left:5px">
							<xsl:attribute name="onclick">javascript:beforeOpenDocument()</xsl:attribute>
							<xsl:if test="@isread = '0'">
								<xsl:attribute name="style">font-weight:bold; margin-left:5px</xsl:attribute>
							</xsl:if>
							<xsl:value-of select="viewcontent/viewnumber"/>
						</a>
					</div>
				</td>
			</xsl:if>
			<!-- Date  -->
			<td  style="border:1px solid #ccc; width:160px;">
				<div style="overflow:hidden; width:100%; ">
					<xsl:if test="/request/@id = 'taskforme' or /request/@id ='tasks' or /request/@id ='mytasks' or /request/@id ='completetask'">
						<xsl:if test="@hasresponse='1'">
				        	<xsl:choose>
				        		<xsl:when test=".[responses]">
									<img style="vertical-align:top; margin-left:2px; border:0px; cursor:pointer" src="/SharedResources/img/classic/1/minus1.png" docid="{@docid}" doctype="{@doctype}">
										<xsl:attribute name='onclick'>javascript:closeResponses(this)</xsl:attribute>
									</img>
								</xsl:when>
								<xsl:otherwise>
									<img style="vertical-align:top; margin-left:3px; border:0px; cursor:pointer" src="/SharedResources/img/classic/1/plus1.png" docid="{@docid}" doctype="{@doctype}">
										<xsl:attribute name='onclick'>javascript:openParentDocView(this)</xsl:attribute>
									</img>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:if>
						<xsl:if test="@hasresponse = '0'">
							<span style="width:11px; display:inline-block"></span>
						</xsl:if>
					</xsl:if>
					<a href="{@url}" class="doclink" style="width:100%; margin-left:5px">
						<xsl:attribute name="onclick">javascript:beforeOpenDocument()</xsl:attribute>
						<xsl:if test="@isread = '0'">
							<xsl:attribute name="style">font-weight:bold; margin-left:5px</xsl:attribute>
						</xsl:if>
						<xsl:value-of select="viewcontent/viewdate"/>
					</a>
				</div>
			</td>
			<td style="border:1px solid #ccc;min-width:250px; word-wrap:break-word; padding-left: 5px">
				<div style="display:block; width:99%; " title="{viewcontent/viewtext2}">
					<a href="{@url}" class="doclink" style="width:90%">
						<xsl:attribute name="onclick">javascript:beforeOpenDocument()</xsl:attribute>
						<xsl:if test="@isread = '0'">
							<xsl:attribute name="style">font-weight:bold</xsl:attribute>
						</xsl:if>
						<xsl:value-of select="viewcontent/viewtext"/>
					</a>
				</div>
			</td>
			<td style="border:1px solid #ccc; border-left:none; width:30px; text-align:center">
				<img class="favicon" style="cursor:pointer; width:18px; height:18px" src="/SharedResources/img/iconset/star_empty.png">
					<xsl:if test="@favourites = '1'">
						<xsl:attribute name="onclick">javascript:removeDocFromFav(this,<xsl:value-of select="@docid"/>,<xsl:value-of select="@doctype"/>)</xsl:attribute> 
						<xsl:attribute name="src">/SharedResources/img/iconset/star_full.png</xsl:attribute> 
						<xsl:attribute name ="title"><xsl:value-of select ="//page/captions/removefromfav/@caption"></xsl:value-of></xsl:attribute>
					</xsl:if>
					<xsl:if test="@favourites = '0' or not(@favourites)"> 
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
			<td style="width:3%"/>
			<td style="width:5%"/>
			<td style="width:5%"/>
			<td colspan="3" nowrap="true">
				<xsl:apply-templates mode="line"/>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template match="viewtext" mode="line"/>
	<xsl:template match="viewcontent" mode="line"/>
	
	<xsl:template match="entry" mode="line">
		<div class="Node" style="overflow:hidden;" id="{@docid}{@doctype}">
			<xsl:call-template name="graft"/>
			<xsl:apply-templates select="." mode="item"/>
		</div>
		<xsl:apply-templates mode="line"/>
	</xsl:template>

	<xsl:template match="entry" mode="item">
		<a  href="{@url}" title="{@viewtext}" class="doclink" style="font-style:arial; width:100%; font-size:99%">
			<xsl:attribute name="onclick">javascript:beforeOpenDocument()</xsl:attribute>
			<xsl:if test="@isread = 0">
				<xsl:attribute name="style">font-weight:bold</xsl:attribute>
			</xsl:if>
			<xsl:if test="viewcontent/viewtext3 = '0'">
				<img id="control" title="Документ снят с контроля" src="/SharedResources/img/classic/icons/tick.png" border="0" style="margin-left:3px"/>&#xA0;
			</xsl:if>
			<xsl:if test="@hasattach != '0'">
				<img id="atach" src="/SharedResources/img/classic/icons/attach.png" border="0" style="vertical-align:top">
					<xsl:attribute name="title">Вложений в документе: <xsl:value-of select="@hasattach"/></xsl:attribute>
				</img> 
			</xsl:if>
			<xsl:variable name='simbol'>'</xsl:variable>
			<xsl:variable name='ecr1' select="replace(viewcontent/viewtext,$simbol ,'&quot;')"/>
			<xsl:variable name='ecr2' select="replace($ecr1, '&#34;' ,'&quot;')"/>
			<font class="font{@docid}{@doctype}">
				<script>
					text='<xsl:value-of select="$ecr2"/>';
					symcount= <xsl:value-of select="string-length(viewcontent/viewtext)"/>;
					ids="font<xsl:value-of select="@docid"/><xsl:value-of select="@doctype"/>";
					replaceVal="<img/>";
					text=text.replace("-->",replaceVal);
					$("."+ids).html(text);
					$("."+ids+" > img").attr("src","/SharedResources/img/classic/arrow_blue.gif");
					$("."+ids+" > img").attr("style","vertical-align:middle");
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
	
	<xsl:template match="/request">
		<html>
			<head>
				<title>
					Workflow документооборот - <xsl:value-of select="page/captions/viewnamecaption/@caption"/>
				</title>
				<link type="text/css" rel="stylesheet" href="classic/css/outline.css"/>
				<link type="text/css" rel="stylesheet" href="classic/css/main.css"/>
				<link type="text/css" rel="stylesheet" href="/SharedResources/jquery/css/smoothness/jquery-ui-1.8.20.custom.css"/>
				<link type="text/css" rel="stylesheet" href="/SharedResources/jquery/js/hotnav/jquery.hotnav.css"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/jquery-1.4.2.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.widget.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.core.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.effects.core.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.datepicker.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.datepicker-ru.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.mouse.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.draggable.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.position.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.button.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.dialog.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/cookie/jquery.cookie.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/hotnav/jquery.hotkeys.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/hotnav/jquery.hotnav.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/scrollTo/scrollTo.js"/>
				<script type="text/javascript" src="classic/scripts/outline.js"/>
				<script type="text/javascript" src="classic/scripts/view.js"/>
				<script type="text/javascript" src="classic/scripts/form.js"/>
				<script type="text/javascript" src="classic/scripts/page.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/tiptip/jquery.tipTip.js"/>
				<script type="text/javascript">
					$(document).ready(function(){
						$(".button_panel button").button();
						hotkeysnav();
						outline.type = '<xsl:value-of select="@type"/>'; 
						outline.viewid = '<xsl:value-of select="@id"/>';
						outline.element = 'project';
						outline.command='<xsl:value-of select="current/@command"/>';
						outline.curPage = '<xsl:value-of select="current/@page"/>'; 
						outline.category = '';
						outline.filterid = '<xsl:value-of select="@id"/>';
						refresher();  
					});
					function hotkeysnav(){
						$(document).bind('keydown', function(e){
 							if (e.ctrlKey) {
 								switch (e.keyCode) {
								   case 78:
										<!-- клавиша n -->
								     	e.preventDefault();
								     	$("#btnNewdoc").click();
								     	break;
								   case 68:
								   		<!-- клавиша d -->
								     	e.preventDefault();
								     	$("#btnDeldoc").click();
								      	break;
								   case 70:
								   		<!-- клавиша f -->
								     	e.preventDefault();
								     	$("#btnQFilter").click();
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
    					$("#btnNewdoc .ui-button-text").hotnav({keysource:function(e){ return "n"; }});
						$("#btnDeldoc .ui-button-text").hotnav({keysource:function(e){ return "d"; }});
						$("#btnQFilter .ui-button-text").hotnav({keysource:function(e){ return "f"; }});
						$("#currentuser").hotnav({ keysource:function(e){ return "u"; }});
						$("#logout").hotnav({keysource:function(e){ return "q"; }});
						$("#helpbtn").hotnav({keysource:function(e){ return "h"; }});
					}
				</script>
			</head>			
			<body>
				<xsl:call-template name="flashentry"/>
				<div id="blockWindow" style="display:none"/>
					<div id="wrapper">
						<xsl:call-template name="loadingpage"/>
						<xsl:call-template name="header-page"/>
						<xsl:call-template name="outline-menu-page"/>
					<span id="view" class="viewframe">
						<div id="viewcontent" style="margin-left:12px;">
							<div id="viewcontent-header" style="height:130px;">
								<xsl:call-template name="pageinfo"/>
								<div class="button_panel" style="margin-top:1px">
									<div style="float:left; margin-left:3px; margin-top:2px; margin-bottom:3px">
										<xsl:if test="$actionbar/action[@id='new_document']/@mode = 'ON'">
											<button style="margin-right:5px" title="{$actionbar/action[@id='new_document']/@hint}" id="btnNewdoc">
												<xsl:attribute name="href">javascript:window.location.href="<xsl:value-of select="$actionbar/action[@id='new_document']/@url"/>"; beforeOpenDocument()</xsl:attribute>
												<xsl:attribute name="onclick">javascript:window.location.href="<xsl:value-of select="$actionbar/action[@id='new_document']/@url"/>"; beforeOpenDocument()</xsl:attribute>
												<img src="/SharedResources/img/classic/icons/page_white.png" class="button_img"/>
												<font style="font-size:12px; vertical-align:top"><xsl:value-of select="$actionbar/action[@id='new_document']/@caption"/></font>
											</button>
										</xsl:if>
										<xsl:if test="$actionbar/action[@id='delete_document']/@mode = 'ON'">
											<button style="margin-right:5px" title="{$actionbar/action[@id='delete_document']/@hint}" id="btnDeldoc">
												<xsl:attribute name="onclick">javascript:delDocument();</xsl:attribute>
												<img src="/SharedResources/img/classic/icons/page_white_delete.png" class="button_img"/>
												<font style="font-size:12px; vertical-align:top"><xsl:value-of select="$actionbar/action[@id='delete_document']/@caption"/></font>
											</button>
										</xsl:if>
										<button style="margin-right:5px" title="{page/captions/fastfiltercaption/@caption}" id="btnQFilter">
											<xsl:attribute name="onclick">javascript:openQFilterPanel(); </xsl:attribute>
											<img src="/SharedResources/img/iconset/054.png" class="button_img" style=""/>
											<font style="font-size:12px; vertical-align:top"><xsl:value-of select="page/captions/fastfiltercaption/@caption"/></font> 
										</button>
									</div>
									<span style="float:right; padding-right:10px;">
									</span>
								</div>
								<div style="clear:both"/>
								<div id="QFilter" style="width:auto; background: #eeeeee; border:1px solid #ccc; border-bottom:none; height:25px; margin-top:5px; margin-left:2px; display:none">
									<xsl:if test="@useragent != 'IE'">
										<xsl:attribute name="style">width:auto; background: #eeeeee; border:1px solid #ccc; height:25px; border-bottom:none; margin-top:3px; margin-left:2px; display:none</xsl:attribute>
									</xsl:if>
									<xsl:if test="query/filtered/condition[fieldname != ''][value != '0']">
										<xsl:attribute name="style">width:auto; background: #eeeeee; border:1px solid #ccc; height:25px; margin-top:5px; display:block;margin-left:2px;</xsl:attribute>
										<xsl:if test="@useragent != 'IE'">
											<xsl:attribute name="style">width:auto; background: #eeeeee; border:1px solid #ccc; height:25px; margin-top:3px;  display:block;margin-left:2px;</xsl:attribute>
										</xsl:if>
									</xsl:if>
									<font style="font-size:11px; line-height:25px; margin-left:5px"><xsl:value-of select="columns/column[@id = 'PROJECT']/@caption"/> :</font>
									<span class="prjlistbuttonwrapper">
									  	<font id="prjlistbutton" class="listbutton">
											<xsl:attribute name="onclick">javascript:openCategoryList(this,"prjlist")</xsl:attribute>
											<font style="font-size:11px; font-weight:bold">
												<xsl:variable name="filtervalue" select="query/filtered/condition/value"/>
												<xsl:if test="query/filtered/condition[fieldname eq 'project'][value != '0'][value != ' ']">
													<xsl:value-of select="glossaries/projectsprav/query/entry[@docid = $filtervalue]/viewcontent/viewtext1"/>
												</xsl:if>
												<xsl:if test="query/filtered/condition[fieldname eq 'project'][value eq '0']"><xsl:value-of select="columns/column[@id = 'SHOWALL']/@caption"/></xsl:if>
												<xsl:if test="not(query/filtered/condition[fieldname eq 'project'])"><xsl:value-of select="columns/column[@id = 'SHOWALL']/@caption"/></xsl:if>
											</font>
										</font>
									</span>
									<div id="prjlist" class="glosslisttable" style="position:absolute; top:90px; z-index:999; border:1px solid #79B7E7;  width:300px; background:#fff; visibility:hidden; max-height:400px; overflow:auto">
										<table style="width:100%">
						            		<xsl:for-each select="glossaries/projectsprav/query/entry">
												<tr style="font-family:Verdana,Arial,Helvetica,sans-serif; font-size:13px; min-width:120px; cursor:pointer">
													<td class="categorylist_td">
														<xsl:attribute name="onclick">javascript:chooseProjectView(<xsl:value-of select='@docid'/>)</xsl:attribute>
														<font style=" width:100%;">
															<xsl:value-of select="viewcontent/viewtext1"/>
														</font>
													</td>
												</tr>
											</xsl:for-each>
											<tr style="font-family:Verdana,Arial,Helvetica,sans-serif; font-size:13px; min-width:120px;">
												<td class="categorylist_td" style=" cursor:pointer; border-top: 1px solid #dddddd;">
													<xsl:attribute name="onclick">javascript:chooseProjectView('0')</xsl:attribute>
													<font style=" width:100%; font-color:#555">
															<xsl:value-of select="columns/column[@id = 'SHOWALL']/@caption"/>
													</font>
												</td>
										   	</tr>
			        					</table>
			        				</div>
									<font style="font-size:11px; line-height:25px; margin-left:25px"><xsl:value-of select="columns/column[@id = 'FILTERCATEGORY']/@caption"/> :</font>
									<span class="catlistbuttonwrapper">
									  	<font id="catlistbutton" class="listbutton">
											<xsl:attribute name="onclick">javascript:openCategoryList(this,"catlist")</xsl:attribute>
											<font style="font-size:11px; font-weight:bold">
												<xsl:variable name="filtervalue" select="query/filtered/condition/value"/>
												<xsl:if test="query/filtered/condition[fieldname eq 'category'][value != '0'][value != ' ']">
													<xsl:value-of select="glossaries/docscat/query/entry[@docid = $filtervalue]/viewcontent/viewtext1"/>
												</xsl:if>
												<xsl:if test="query/filtered/condition[fieldname eq 'category'][value eq '0']"><xsl:value-of select="columns/column[@id = 'SHOWALL']/@caption"/> </xsl:if>
												<xsl:if test="not(query/filtered/condition[fieldname eq 'category'])"><xsl:value-of select="columns/column[@id = 'SHOWALL']/@caption"/> </xsl:if>
											</font>
										</font>
									</span>
									<div id="catlist" class="glosslisttable" style="position:absolute; top:90px; z-index:999; border:1px solid #79B7E7;  width:300px; background:#fff; visibility:hidden; max-height:400px; overflow:auto">
										<table style="width:100%">
						            		<xsl:for-each select="glossaries/docscat/query/entry">
												<tr style="font-family:Verdana,Arial,Helvetica,sans-serif; font-size:13px; min-width:120px; cursor:pointer">
													<td class="categorylist_td">
															<xsl:attribute name="onclick">javascript:chooseCategoryView(<xsl:value-of select='@docid'/>)</xsl:attribute>
														<font style="width:100%;">
															<xsl:value-of select="viewcontent/viewtext1"/>
														</font>
													</td>
												</tr>
											</xsl:for-each>
											<tr style="font-family:Verdana,Arial,Helvetica,sans-serif; font-size:13px; min-width:120px;">
												<td class="categorylist_td" style=" cursor:pointer; border-top: 1px solid #dddddd;">
													<xsl:attribute name="onclick">javascript:chooseCategoryView('0')</xsl:attribute>
													<font style=" width:100%; font-color:#555">
															<xsl:value-of select="columns/column[@id = 'SHOWALL']/@caption"/>
													</font>
												</td>
										   	</tr>
			        					</table>
		        					</div>
		        					<font style="font-size:11px; line-height:25px; margin-left:25px"><xsl:value-of select="columns/column[@id = 'STATUS']/@caption"/> :</font>
									<span class="statuslistbuttonwrapper">
									  	<font id="statuslistbutton" class="listbutton">
											<xsl:attribute name="onclick">javascript:openCategoryList(this,"statuslist")</xsl:attribute>
											<font style="font-size:11px; font-weight:bold">
												<xsl:variable name="filtervalue" select="query/filtered/condition/value"/>
												<xsl:if test="query/filtered/condition[fieldname eq 'coordstatus'][value != '0'][value != ' ']">
													<xsl:value-of select="glossaries/status/entry[value = $filtervalue]/name"/>
												</xsl:if>
												<xsl:if test="query/filtered/condition[fieldname eq 'coordstatus'][value eq '0']"><xsl:value-of select="columns/column[@id = 'SHOWALL']/@caption"/></xsl:if>
												<xsl:if test="not(query/filtered/condition[fieldname eq 'coordstatus'])"><xsl:value-of select="columns/column[@id = 'SHOWALL']/@caption"/></xsl:if>
											</font>
										</font>
									</span>
									<div id="statuslist" class="glosslisttable" style="position:absolute; top:90px; z-index:999; border:1px solid #79B7E7;  width:300px; background:#fff; visibility:hidden; max-height:400px; overflow:auto">
										<table style="width:100%">
						            		<xsl:for-each select="glossaries/status/entry">
												<tr style="font-family:Verdana,Arial,Helvetica,sans-serif; font-size:13px; min-width:120px; cursor:pointer">
													<td class="categorylist_td">
															<xsl:attribute name="onclick">javascript:chooseStatusView(<xsl:value-of select='value'/>)</xsl:attribute>
														<font style="width:100%;">
															<xsl:value-of select="name"/>
														</font>
													</td>
												</tr>
											</xsl:for-each>
											<tr style="font-family:Verdana,Arial,Helvetica,sans-serif; font-size:13px; min-width:120px;">
												<td class="categorylist_td" style=" cursor:pointer; border-top: 1px solid #dddddd;">
													<xsl:attribute name="onclick">javascript:chooseStatusView('0')</xsl:attribute>
													<font style=" width:100%; font-color:#555">
														<xsl:value-of select="columns/column[@id = 'SHOWALL']/@caption"/>
													</font>
												</td>
										   	</tr>
			        					</table>
			        				</div>
		        					<font style="font-size:11px; line-height:25px; margin-left:25px"><xsl:value-of select="columns/column[@id = 'AUTHOR']/@caption"/> :</font>
									<span class="authorlistbuttonwrapper">
									  	<font id="authorlistbutton" class="listbutton">
											<xsl:attribute name="onclick">javascript:openCategoryList(this,"authorlist")</xsl:attribute>
											<font style="font-size:11px; font-weight:bold">
												<xsl:variable name="filtervalue" select="query/filtered/condition/value"/>
												<xsl:if test="query/filtered/condition[fieldname eq 'author'][value != '0'][value != ' ']">
													<xsl:value-of select="glossaries/bossandemp/query/entry/responses/descendant::entry[@doctype=889][userid = $filtervalue]/viewcontent/viewtext1"/>
												</xsl:if>
												<xsl:if test="query/filtered/condition[fieldname eq 'author'][value eq '0']"><xsl:value-of select="columns/column[@id = 'SHOWALL']/@caption"/></xsl:if>
												<xsl:if test="not(query/filtered/condition[fieldname eq 'author'])"><xsl:value-of select="columns/column[@id = 'SHOWALL']/@caption"/></xsl:if>
											</font>
										</font>
									</span>
									<div id="authorlist" class="glosslisttable" style="position:absolute; top:90px; z-index:999; border:1px solid #79B7E7;  width:300px; background:#fff; visibility:hidden; max-height:400px; overflow:auto">
										<table style="width:100%">
						            		<xsl:for-each select="glossaries/bossandemp/query/entry/responses/descendant::entry[@doctype=889]">
												<tr style="font-family:Verdana,Arial,Helvetica,sans-serif; font-size:13px; min-width:120px; cursor:pointer">
													<td class="categorylist_td">
														<xsl:attribute name="onclick">javascript:chooseAuthorView("<xsl:value-of select='userid'/>")</xsl:attribute>
														<font style="width:100%;">
															<xsl:value-of select="viewtext"/>
														</font>
													</td>
												</tr>
											</xsl:for-each>
											<tr style="font-family:Verdana,Arial,Helvetica,sans-serif; font-size:13px; min-width:120px;">
												<td class="categorylist_td" style=" cursor:pointer; border-top: 1px solid #dddddd;">
													<xsl:attribute name="onclick">javascript:chooseAuthorView('0')</xsl:attribute>
													<font style=" width:100%; font-color:#555">
															<xsl:value-of select="columns/column[@id = 'SHOWALL']/@caption"/>
													</font>
												</td>
										   	</tr>
			        					</table>
			        				</div> 
		        					<font style="font-size:11px; line-height:25px; margin-left:25px"><xsl:value-of select="columns/column[@id = 'RESPONSIBLE']/@caption"/> :</font>
									<span class="resplistbuttonwrapper">
									  	<font id="resplistbutton" class="listbutton">
											<xsl:attribute name="onclick">javascript:openCategoryList(this,"resplist")</xsl:attribute>
											<font style="font-size:11px; font-weight:bold">
												<xsl:variable name="filtervalue" select="query/filtered/condition/value"/>
												<xsl:if test="query/filtered/condition[fieldname eq 'responsiblesection'][value != '0'][value != ' ']">
													<xsl:value-of select="glossaries/responsiblesection/query/entry[userid = $filtervalue]/viewcontent/viewtext1"/>
												</xsl:if>
												<xsl:if test="query/filtered/condition[fieldname eq 'responsiblesection'][value eq '0']"><xsl:value-of select="columns/column[@id = 'SHOWALL']/@caption"/></xsl:if>
												<xsl:if test="not(query/filtered/condition[fieldname eq 'responsiblesection'])"><xsl:value-of select="columns/column[@id = 'SHOWALL']/@caption"/></xsl:if>
											</font>
										</font>
									</span>
									<div id="resplist" class="glosslisttable" style="position:absolute; top:90px; z-index:999; border:1px solid #79B7E7;  width:300px; background:#fff; visibility:hidden; max-height:400px; overflow:auto">
										<table style="width:100%">
						            		<xsl:for-each select="glossaries/responsiblesection/query/entry">
												<tr style="font-family:Verdana,Arial,Helvetica,sans-serif; font-size:13px; min-width:120px; cursor:pointer">
													<td class="categorylist_td">
															<xsl:attribute name="onclick">javascript:chooseRespView("<xsl:value-of select='userid'/>")</xsl:attribute>
														<font style="width:100%;">
															<xsl:value-of select="@viewtext"/>
														</font>
													</td>
												</tr>
											</xsl:for-each>
											<tr style="font-family:Verdana,Arial,Helvetica,sans-serif; font-size:13px; min-width:120px;">
												<td class="categorylist_td" style=" cursor:pointer; border-top: 1px solid #dddddd;">
													<xsl:attribute name="onclick">javascript:chooseRespView('0')</xsl:attribute>
													<font style=" width:100%; font-color:#555">
														<xsl:value-of select="columns/column[@id = 'SHOWALL']/@caption"/>
													</font>
												</td>
										   	</tr>
			        					</table>
			        				</div> 
		        					<img src="/SharedResources/img/classic/icons/cross.png" style="float:right; margin-right:5px; width:14px; margin-top:5px; cursor:pointer">
		        						<xsl:attribute name="onclick">javascript:hideQFilterPanel();</xsl:attribute>
		        						<xsl:if test="query/filtered/condition/fieldname != ''">
		        							<xsl:attribute name="onclick">javascript:hideQFilterPanel();  resetFilterView() </xsl:attribute>
		        						</xsl:if>
		        					</img>
								</div>
								<div style="clear:both"/>
								<div id="tableheader">
									<table class="viewtable" id="viewtable" width="100%" style="">
										<tr class="th">
											<td style="text-align:center; height:30px; width:23px;" class="thcell">
												<input type="checkbox" id="allchbox" autocomplete="off" onClick="checkAll(this)"/>					
											</td>
											<td style="width:60px; padding:3px" class="thcell"></td>
											<td style="width:60px; padding:3px" class="thcell"></td>
											<xsl:if test="/request/@id != 'task' and /request/@id != 'taskforme'  and /request/@id !='mytasks' and /request/@id !='completetask' and /request/@id != 'waitforcoord' and /request/@id != 'waitforsign' and /request/@id != 'workdocprj' and /request/@id != 'outdocprj'  and /request/@id != 'outdocreg'">
												<td style="width:60px;" class="thcell">
													<xsl:call-template name="sortingcellpage">
														<xsl:with-param name="namefield">VIEWNUMBER</xsl:with-param>
														<xsl:with-param name="sortorder" select="//query/columns/viewnumber/sorting/@order"/>
														<xsl:with-param name="sortmode" select="//query/columns/viewnumber/sorting/@mode"/>
													</xsl:call-template>
												</td>
											</xsl:if>
											<td style="width:160px;" class="thcell">
												<xsl:call-template name="sortingcellpage">
													<xsl:with-param name="namefield">VIEWDATE</xsl:with-param>
													<xsl:with-param name="sortorder" select="//query/columns/viewdate/sorting/@order"/>
													<xsl:with-param name="sortmode" select="//query/columns/viewdate/sorting/@mode"/>
												</xsl:call-template>
											</td>
											<td style="min-width:250px;" class="thcell">
												<xsl:call-template name="sortingcellpage">
													<xsl:with-param name="namefield">VIEWTEXT</xsl:with-param>
													<xsl:with-param name="sortorder" select="//query/columns/viewtext/sorting/@order"/>
													<xsl:with-param name="sortmode" select="//query/columns/viewtext/sorting/@mode"/>
												</xsl:call-template>
											</td>
										</tr>
									</table>
								</div>
							</div>
							<div id="viewtablediv">
								<div id="tablecontent" style="top:101px; position:absolute">
									<xsl:if test="query/filtered/condition[fieldname != ''][value != '0']">
										<xsl:attribute name="style">top:132px;</xsl:attribute>
									</xsl:if>
									<table class="viewtable" id="viewtable" width="100%">
										<xsl:apply-templates select="//query/entry"/>
									</table>
									<div style="clear:both; width:100%">&#xA0;</div>
								</div>
							</div>
		 				</div>
					</span>
				</div>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>