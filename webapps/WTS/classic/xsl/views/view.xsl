<?xml version="1.0" ?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../templates/view.xsl"/>
	<xsl:variable name="viewtype">Вид</xsl:variable>
	<xsl:output method="html" encoding="utf-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" indent="no"/>
	<xsl:variable name="skin" select="request/@skin"/>
	<xsl:variable name="useragent" select="request/@useragent"/>
	<xsl:template match="query/entry">
		<xsl:variable name="num" select="position()"/>
		<tr title="{@viewtext}" class="{@docid}" id="{@docid}{@doctype}">
			<xsl:attribute name="bgcolor">#FFFFFF</xsl:attribute>
			<xsl:if test="@isread = '0'">
				<xsl:attribute name="font-weight">bold</xsl:attribute>
			</xsl:if>
			<xsl:call-template name="viewtable_dblclick_open"/>
			<td style="text-align:center;border:1px solid #ccc;width:20px;">
				<input type="checkbox" name="chbox" id="{@docid}" value="{@doctype}"/>
			</td>
			<td style="border:1px solid #ccc; width:25px;">
				<xsl:if test="/request/@id ='remark'">
					<xsl:attribute name="style">border:1px solid #ccc; width:50px;</xsl:attribute>
					<span style="float:left; padding:4px 0px 0px 5px">
							<xsl:choose>
								<xsl:when test="coordstatus='362'">
									<img id="control" title="Замечание устранено" src="/SharedResources/img/classic/icons/tick.png" style="float:left"/>
								</xsl:when>
								<xsl:when test="coordstatus='361'">
									<img id="control" title="На исполнении" src="/SharedResources/img/classic/icons/control_play_blue.png" style="float:left"/>
								</xsl:when>
								<xsl:when test="coordstatus='351'">
									<!-- <img id="control" title="Черновик" src="/SharedResources/img/classic/icons/application_edit.png" style="float:left"/> -->
								</xsl:when>	
								<xsl:when test="coordstatus='352'">
									<img id="control" title="На согласовании" src="/SharedResources/img/classic/icons/comment_edit.png" style="float:left"/>
								</xsl:when>
								<xsl:when test="coordstatus='354'">
									<img id="control" title=" Отклонено ответственным участка" src="/SharedResources/img/classic/icons/comment_delete.png" style="float:left"/>
								</xsl:when>
								<xsl:when test="coordstatus='355'">
									<img id="control" title="На ревизии исполнения" src="/SharedResources/img/classic/icons/eye.png" style="float:left"/>
								</xsl:when>
							</xsl:choose>
					</span>
				</xsl:if>
				<span style="float:right">
					<xsl:if test="@hasattach != 0">
						<img id="atach" src="/SharedResources/img/classic/icons/attach.png" style="margin:5px" title="Вложений в документе: {@hasattach}"/>
					</xsl:if>
				</span>
			</td>
			<td  style="border:1px solid #ccc;width:75px;">
				<div style="overflow:hidden; width:100%;">
					<xsl:if test="hasresponse='true' and //request/@id!='toconsider'">
          				<xsl:choose>
          					<xsl:when test=".[responses]">
								<a href="" style="vertical-align:top; margin-left:3px" id="a{@docid}">
									<xsl:attribute name='href'>javascript:closeResponses(<xsl:value-of select="@docid"/>, <xsl:value-of select="@doctype"/>,<xsl:value-of select="position()"/>,1)</xsl:attribute>
									<img border='0' src="/SharedResources/img/classic/icons/minus.gif" id="img{@docid}"/>
								</a>
							</xsl:when>
							<xsl:otherwise>
								<a href="" style="vertical-align:top; margin-left:3px" id="a{@docid}">
									<xsl:attribute name='href'>javascript:openParentDocView(<xsl:value-of select="@docid"/>, <xsl:value-of select="@doctype"/>,<xsl:value-of select="position()"/>,1)</xsl:attribute>
									<img border='0' src="/SharedResources/img/classic/icons/plus.gif" id="img{@docid}"/>
								</a>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
					<xsl:if test="not(hasresponse)">
						<span style="width:11px; display:inline-block">&#xA0;</span>
					</xsl:if>
					<a class="doclink" style="padding-left:5px;" href="{@url}" title="{@viewtext}">
						<xsl:attribute name="onclick">javascript:beforeOpenDocument()</xsl:attribute>
						<xsl:if test="@isread = '0'">
							<xsl:attribute name="style">font-weight:bold;padding-left:5px</xsl:attribute>
						</xsl:if>
						<xsl:value-of select="vn"/>
					</a>
				</div>
			</td>
			<td  style="border:1px solid #ccc; width:90px; padding-left:5px">
				<div style="overflow:hidden; width:99%;">
					<a href="{@url}" class="doclink" style="width:100%">
						<xsl:attribute name="onclick">javascript:beforeOpenDocument()</xsl:attribute>
						<xsl:if test="@isread = '0'">
							<xsl:attribute name="style">font-weight:bold;</xsl:attribute>
						</xsl:if>
						<xsl:value-of select="substring(viewcontent/viewdate, 0,11)"/><br/>
						<xsl:value-of select="substring(viewcontent/viewdate, 12,8)"/>
					</a>
				</div>
			</td>
			<td  style="border:1px solid #ccc;width:220px; word-wrap:break-word; padding-left: 5px">
				<div style="overflow:hidden; width:99%;">
					<a href="{@url}" class="doclink">
						<xsl:attribute name="onclick">javascript:beforeOpenDocument()</xsl:attribute>
						<xsl:if test="@isread = '0'">
							<xsl:attribute name="style">font-weight:bold</xsl:attribute>
						</xsl:if>
						<xsl:value-of select="viewcontent/viewtext1"/>
					</a>
				</div>
			</td>
			<td  style="border:1px solid #ccc;width:220px; word-wrap:break-word; padding-left: 5px">
				<div style="overflow:hidden; width:99%;">
					<a href="{@url}" class="doclink">
						<xsl:attribute name="onclick">javascript:beforeOpenDocument()</xsl:attribute>
						<xsl:if test="@isread = '0'">
							<xsl:attribute name="style">font-weight:bold</xsl:attribute>
						</xsl:if>
						<xsl:value-of select="viewcontent/viewtext3"/>
					</a>
				</div>
			</td>
			<td  style="border:1px solid #ccc; width:50%; word-wrap:break-word; padding-left: 5px">
				<div style="display:block; width:99%; " title="{viewcontent/viewtext2}">
					<a href="{@url}" class="doclink" style="width:90%">
						<xsl:attribute name="onclick">javascript:beforeOpenDocument()</xsl:attribute>
						<xsl:if test="@isread = '0'">
							<xsl:attribute name="style">font-weight:bold</xsl:attribute>
						</xsl:if>
						
						<xsl:sequence select="replace(viewcontent/viewtext2,'&amp;nbsp;',' ')"></xsl:sequence>
					</a>
				</div>
			</td>
			<td style="border:1px solid #ccc; border-left:none; width:30px; text-align:center">
				<xsl:if test="@topicid = '0'">
					<xsl:attribute name="title">Замечание не обсуждалось</xsl:attribute>
				</xsl:if>
				<xsl:if test="@topicid != '0'">
					<a title="Посмотреть обсуждение">
						<xsl:attribute name="href">Provider?type=forum&amp;id=topic&amp;key=<xsl:value-of select="@topicid"/></xsl:attribute>
						<img class="favicon" style="cursor:pointer; width:18px; height:18px" src="/SharedResources/img/iconset/star_empty.png">
							<xsl:attribute name="src">/SharedResources/img/classic/icons/comment.png</xsl:attribute> 
						</img>  
					</a>
				</xsl:if> 
			</td>
			<td style="border:1px solid #ccc; border-left:none; width:30px; text-align:center">
				<img class="favicon" style="cursor:pointer; width:18px; height:18px" src="/SharedResources/img/iconset/star_empty.png" title="Добавить в избранное">
					<xsl:if test="@favourites = 1">
						<xsl:attribute name="onclick">javascript:removeDocFromFav(this,<xsl:value-of select="@docid"/>,<xsl:value-of select="@doctype"/>)</xsl:attribute> 
						<xsl:attribute name="src">/SharedResources/img/iconset/star_full.png</xsl:attribute> 
					</xsl:if>
					<xsl:if test="@favourites = 0"> 
						<xsl:attribute name="onclick">javascript:addDocToFav(this,<xsl:value-of select="@docid"/>,<xsl:value-of select="@doctype"/>)</xsl:attribute>
						<xsl:attribute name="src">/SharedResources/img/iconset/star_empty.png</xsl:attribute> 
					</xsl:if>
					<xsl:if test="not (@favourites)"> 
						<xsl:attribute name="onclick">javascript:addDocToFav(this,<xsl:value-of select="@docid"/>,<xsl:value-of select="@doctype"/>)</xsl:attribute>
						<xsl:attribute name="src">/SharedResources/img/iconset/star_empty.png</xsl:attribute> 
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
			<td colspan="5" nowrap="true">
				<xsl:apply-templates mode="line"/>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template match="viewtext" mode="line"/>
	
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
			<xsl:if test="@allcontrol = 0">
				<img id="control" title="Документ снят с контроля" src="/SharedResources/img/classic/icons/tick.png" border="0" style="margin-left:3px"/>&#xA0;
			</xsl:if>
			<xsl:if test="@hasattach != 0">
				<img id="atach" src="/SharedResources/img/classic/icons/attach.png" border="0" style="vertical-align:top">
					<xsl:attribute name="title">Вложений в документе: <xsl:value-of select="@hasattach"/></xsl:attribute>
				</img> 
			</xsl:if>
			<xsl:variable name='simbol'>'</xsl:variable>
			<xsl:variable name='ecr1' select="replace(viewtext,$simbol ,'&quot;')"/>
			<xsl:variable name='ecr2' select="replace($ecr1, '&#34;' ,'&quot;')"/>
			<font id="font{@docid}{@doctype}">
				<script>
					text='<xsl:value-of select="$ecr2"/>';
					symcount= <xsl:value-of select="string-length(@viewtext)"/>;
					ids="font<xsl:value-of select="@docid"/><xsl:value-of select="@doctype"/>";
					replaceVal="<img/>";
					text=text.replace("-->",replaceVal);
					$("#"+ids).html(text);
					$("#"+ids+" > img").attr("src","/SharedResources/img/classic/arrow_blue.gif");
					$("#"+ids+" > img").attr("style","vertical-align:middle");
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
				<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
				<title>WTS - <xsl:value-of select="columns/column[@id = 'VIEW']/@caption"/></title>
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
				<script type="text/javascript">
					$(document).ready(function(){
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
    					$("#btnNewdoc").hotnav({keysource:function(e){return "n";}});
						$("#btnDeldoc").hotnav({keysource:function(e){return "d";}});
						$("#currentuser").hotnav({ keysource:function(e){return "u";}});
						$("#btnQFilter").hotnav({keysource:function(e){return "f";}});
						$("#logout").hotnav({keysource:function(e){return "q";}});
						$("#helpbtn").hotnav({keysource:function(e){return "h";}});
						outline.type = '<xsl:value-of select="@type"/>'; 
						outline.viewid = '<xsl:value-of select="@id"/>';
						outline.element = 'project';
						outline.command='<xsl:value-of select="current/@command"/>';
						outline.curPage = '<xsl:value-of select="current/@page"/>'; 
						outline.category = '';
						outline.filterid = '<xsl:value-of select="@id"/>';
						refresher();  
					});
				</script>
			</head>			
			<body>
				<xsl:call-template name="flashentry"/>
				<div id="blockWindow" style="display:none"/>
				<div id="wrapper">
					<xsl:call-template name="loadingpage"/>
					<xsl:call-template name="header-view"/>
					<xsl:call-template name="outline-menu-view"/>
					<span id="view" class="viewframe{outline/category[entry[@current=1]]/@id}">
						<div id="viewcontent" style="margin-left:12px;">
							<div id="viewcontent-header" style="height:100px;">
						<xsl:call-template name="viewinfo"/>
						<div class="button_panel" style="margin-top:1px">
							<script type="text/javascript">    
					       		$(function() {$(".button_panel button" ).button();});
    						</script>
							<div style="float:left; margin-left:3px; margin-top:2px; margin-bottom:3px">
								<xsl:if test="action[.='NEW_DOCUMENT']/@enable = 'true'">
									<button title="{action[.='NEW_DOCUMENT']/@hint}" id="btnNewdoc">
										<xsl:attribute name="href">javascript:window.location.href="<xsl:value-of select="newDocURL"/>"; beforeOpenDocument()</xsl:attribute>
										<xsl:attribute name="onclick">javascript:window.location.href="<xsl:value-of select="newDocURL"/>"; beforeOpenDocument()</xsl:attribute>
										<img src="/SharedResources/img/classic/icons/page_white.png" class="button_img"/>
										<font style="font-size:12px; vertical-align:top"><xsl:value-of select="action[.='NEW_DOCUMENT']/@caption"/></font>
									</button>
								</xsl:if>
								<xsl:if test="action[.='DELETE_DOCUMENT']/@enable = 'true'">
									<button style="margin-left:5px" title="{columns/column[@id = 'BTNDELETEDOCUMENT']/@hint}" id="btnDeldoc">
										<xsl:attribute name="onclick">javascript:delGlossary("Avanti","0");</xsl:attribute>
										<img src="/SharedResources/img/classic/icons/page_white_delete.png" class="button_img"/>
										<font style="font-size:12px; vertical-align:top"><xsl:value-of select="columns/column[@id = 'BTNDELETEDOCUMENT']/@caption"/></font>
									</button>
								</xsl:if>
								<xsl:if test="action[.='DELETE_GLOSSARY']/@enable = 'true'" >
									<button style="margin-left:5px" title="{columns/column[@id = 'BTNDELETE']/@hint}" id="btnDelgloss">
										<xsl:attribute name="onclick">javascript:delGlossary("Avanti","0");</xsl:attribute>
										<img src="/SharedResources/img/classic/icons/page_white_delete.png" class="button_img"/>
										<font style="font-size:12px; vertical-align:top"><xsl:value-of select="columns/column[@id = 'BTNDELETE']/@caption"/></font>
									</button>
								</xsl:if>
								<button style="margin-left:4px" title="{columns/column[@id = 'FASTFILTERCAPTION']/@caption}" id="btnQFilter">
									<xsl:attribute name="onclick">javascript:openQFilterPanel(); </xsl:attribute>
									<img src="/SharedResources/img/iconset/054.png" class="button_img" style=""/>
									<font style="font-size:12px; vertical-align:top"><xsl:value-of select="columns/column[@id = 'FILTERCAPTION']/@caption"/></font>
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
											<!-- <xsl:value-of select="query/entry[1]/project"/> -->
											<xsl:variable name="filtervalue" select="query/filtered/condition[fieldname='project']/value"/>
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
								<font style="font-size:11px; line-height:25px; margin-left:20px"><xsl:value-of select="columns/column[@id = 'FILTERCATEGORY']/@caption"/> :</font>
								<span class="catlistbuttonwrapper">
								  	<font id="catlistbutton" class="listbutton">
										<xsl:attribute name="onclick">javascript:openCategoryList(this,"catlist")</xsl:attribute>
										<font style="font-size:11px; font-weight:bold">
											<xsl:variable name="filtervalue" select="query/filtered/condition[fieldname='category']/value"/>
											<xsl:if test="query/filtered/condition[fieldname eq 'category'][value != '0'][value != ' ']">
												<xsl:value-of select="glossaries/docscat/query/entry[@docid = $filtervalue]/viewcontent/viewtext1"/>
											</xsl:if>
											<xsl:if test="query/filtered/condition[fieldname eq 'category'][value eq '0']"><xsl:value-of select="columns/column[@id = 'SHOWALL']/@caption"/></xsl:if>
											<xsl:if test="not(query/filtered/condition[fieldname eq 'category'])"><xsl:value-of select="columns/column[@id = 'SHOWALL']/@caption"/></xsl:if>
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
	        					<font style="font-size:11px; line-height:25px; margin-left:20px"><xsl:value-of select="columns/column[@id = 'STATUS']/@caption"/> :</font>
								<span class="statuslistbuttonwrapper">
								  	<font id="statuslistbutton" class="listbutton">
										<xsl:attribute name="onclick">javascript:openCategoryList(this,"statuslist")</xsl:attribute>
										<font style="font-size:11px; font-weight:bold">
											<xsl:variable name="filtervalue" select="query/filtered/condition[fieldname='coordstatus']/value"/>
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
	        					<font style="font-size:11px; line-height:25px; margin-left:20px"><xsl:value-of select="columns/column[@id = 'AUTHOR']/@caption"/> :</font>
								<span class="authorlistbuttonwrapper">
								  	<font id="authorlistbutton" class="listbutton">
										<xsl:attribute name="onclick">javascript:openCategoryList(this,"authorlist")</xsl:attribute>
										<font style="font-size:11px; font-weight:bold">
											<xsl:variable name="filtervalue" select="query/filtered/condition[fieldname='author']/value"/>
											<xsl:if test="query/filtered/condition[fieldname eq 'author'][value != '0'][value != ' ']">
												<xsl:value-of select="glossaries/bossandemp/query/entry/responses/descendant::entry[@doctype=889][userid = $filtervalue]/viewtext"/>
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
	        					<font style="font-size:11px; line-height:25px; margin-left:20px"><xsl:value-of select="columns/column[@id = 'RESPONSIBLE']/@caption"/> :</font>
								<span class="resplistbuttonwrapper">
								  	<font id="resplistbutton" class="listbutton">
										<xsl:attribute name="onclick">javascript:openCategoryList(this,"resplist")</xsl:attribute>
										<font style="font-size:11px; font-weight:bold">
											<xsl:variable name="filtervalue" select="query/filtered/condition[fieldname='responsiblesection']/value"/>
											<xsl:if test="query/filtered/condition[fieldname eq 'responsiblesection'][value != '0'][value != ' ']">
												<xsl:value-of select="glossaries/responsiblesection/query/entry[userid = $filtervalue]/@viewtext"/>
											</xsl:if>
											<xsl:if test="query/filtered/condition[fieldname eq 'responsiblesection'][value eq '0']"><xsl:value-of select="columns/column[@id = 'SHOWALL']/@caption"/> </xsl:if>
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
									<xsl:choose>
										<xsl:when test="query/@ruleid='reports'">
											<td style="text-align:center;height:30px;width:20px;" class="thcell">
												<input type="checkbox" id="allchbox" onClick="checkAll(this)"/>					
											</td>
											<td style="text-align:center;height:30px" class="thcell">
												Название
											</td>
										</xsl:when>
										<xsl:otherwise>
											<td style="text-align:center;height:30px;width:20px;" class="thcell">
												<input type="checkbox" id="allchbox" onClick="checkAll(this)"/>					
											</td>
											<td style="width:25px" class="thcell">
												<xsl:if test="/request/@id ='remark'">
													<xsl:attribute name="style">width:50px</xsl:attribute>
												</xsl:if>
											</td>
											<td style="width:75px;" class="thcell">
												<xsl:call-template name="sortingcell">
													<xsl:with-param name="namefield">VIEWNUMBER</xsl:with-param>
													<xsl:with-param name="sortfield" select="query/sorting/field"/>
													<xsl:with-param name="sortorder" select="query/sorting/order"/>
												</xsl:call-template>
											</td>
											<td style="width:90px;" class="thcell">
												<xsl:call-template name="sortingcell">
													<xsl:with-param name="namefield">VIEWDATE</xsl:with-param>
													<xsl:with-param name="sortfield" select="query/sorting/field"/>
													<xsl:with-param name="sortorder" select="query/sorting/order"/>
												</xsl:call-template>
											</td>
											<td style="width:220px;" class="thcell">
												<xsl:call-template name="sortingcell">
													<xsl:with-param name="namefield">VIEWTEXT1</xsl:with-param>
													<xsl:with-param name="sortfield" select="query/sorting/field"/>
													<xsl:with-param name="sortorder" select="query/sorting/order"/>
												</xsl:call-template>
											</td>
											<td style="width:220px;" class="thcell">
												<xsl:call-template name="sortingcell">
													<xsl:with-param name="namefield">VIEWTEXT3</xsl:with-param>
													<xsl:with-param name="sortfield" select="query/sorting/field"/>
													<xsl:with-param name="sortorder" select="query/sorting/order"/>
												</xsl:call-template>
											</td>
											<td style="min-width:280px;" class="thcell">
												<xsl:call-template name="sortingcell">
													<xsl:with-param name="namefield">VIEWTEXT2</xsl:with-param>
													<xsl:with-param name="sortfield" select="query/sorting/field"/>
													<xsl:with-param name="sortorder" select="query/sorting/order"/>
												</xsl:call-template>
											</td>
										</xsl:otherwise>
									</xsl:choose>
								</tr>
							</table>
						</div>
					</div>
					<div id="viewtablediv">
						<div id="tablecontent">
							<xsl:if test="query/filtered/condition[fieldname != ''][value != '0']">
								<xsl:attribute name="style">top:132px;</xsl:attribute>
							</xsl:if>
							<table class="viewtable" id="viewtable" width="100%">
								<xsl:choose>
<!-- 									<xsl:when test="query/@ruleid='status_report' or query/@ruleid='object_report' or query/@ruleid='instruction_report' or query/@ruleid='originplace_report'"> -->
									<xsl:when test="query/@ruleid='reports'">
										<tr onmouseover="javascript:elemBackground(this,'EEEEEE')" onmouseout="elemBackground(this,'FFFFFF')">
											<xsl:attribute name="bgcolor">#FFFFFF</xsl:attribute>
											<td style="text-align:center;border:1px solid #ccc;width:20px;">
												<input type="checkbox" name="chbox"/>
											</td>
											<td style="border:1px solid #ccc; padding-left:5px">
												<a href="Provider?type=document&amp;id=status_report&amp;key=" class="doclink">По статусу</a>
											</td>
										</tr>
										<tr onmouseover="javascript:elemBackground(this,'EEEEEE')" onmouseout="elemBackground(this,'FFFFFF')">
											<xsl:attribute name="bgcolor">#FFFFFF</xsl:attribute>
											<td style="text-align:center;border:1px solid #ccc;width:20px;">
												<input type="checkbox" name="chbox"/>
											</td>
											<td style="border:1px solid #ccc; padding-left:5px">
												<a href="Provider?type=document&amp;id=project_report&amp;key=" class="doclink">По объектам</a>
											</td>
										</tr>
										<tr onmouseover="javascript:elemBackground(this,'EEEEEE')" onmouseout="elemBackground(this,'FFFFFF')">
											<xsl:attribute name="bgcolor">#FFFFFF</xsl:attribute>
											<td style="text-align:center;border:1px solid #ccc;width:20px;">
												<input type="checkbox" name="chbox"/>
											</td>
											<td style="border:1px solid #ccc; padding-left:5px">
												<a href="Provider?type=document&amp;id=instruction_report&amp;key=" class="doclink">По предписаниям</a>
											</td>
										</tr>
										<tr onmouseover="javascript:elemBackground(this,'EEEEEE')" onmouseout="elemBackground(this,'FFFFFF')">
											<xsl:attribute name="bgcolor">#FFFFFF</xsl:attribute>
											<td style="text-align:center;border:1px solid #ccc;width:20px;">
												<input type="checkbox" name="chbox"/>
											</td>
											<td style="border:1px solid #ccc; padding-left:5px">
												<a href="Provider?type=document&amp;id=originplace_report&amp;key=" class="doclink">По месту возникновения</a>
											</td>
										</tr>
										<tr onmouseover="javascript:elemBackground(this,'EEEEEE')" onmouseout="elemBackground(this,'FFFFFF')">
											<xsl:attribute name="bgcolor">#FFFFFF</xsl:attribute>
											<td style="text-align:center;border:1px solid #ccc;width:20px;">
												<input type="checkbox" name="chbox"/>
											</td>
											<td style="border:1px solid #ccc; padding-left:5px">
												<a href="Provider?type=document&amp;id=dynamic_report&amp;key=" class="doclink">Динамический отчет</a>
											</td>
										</tr>
									</xsl:when>
									<xsl:otherwise>
										<xsl:apply-templates select="query/entry"/>
									</xsl:otherwise>
								</xsl:choose>
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