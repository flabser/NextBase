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
			<td  style="border:1px solid #ccc;width:65px;">
				<div style="overflow:hidden; width:99%;">
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
						$("#btnNewdoc").hotnav({keysource:function(e){ return "n"; }});
						$("#btnDeldoc").hotnav({keysource:function(e){ return "d"; }});
						$("#currentuser").hotnav({ keysource:function(e){ return "u"; }});
						$("#btnQFilter").hotnav({keysource:function(e){ return "f"; }});
						$("#logout").hotnav({keysource:function(e){ return "q"; }});
						$("#helpbtn").hotnav({keysource:function(e){ return "h"; }});
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
						<div class="button_panel" style="margin-top:11px">
							<script type="text/javascript">    
					       		$(function() {$(".button_panel button" ).button();});
    						</script>
							<div style="float:left; margin-left:3px; margin-top:6px; margin-bottom:3px">
							</div>
							<span style="float:right; padding-right:10px;">
							</span>
						</div>
						<div style="clear:both"/>
						<div style="clear:both"/>
						<div id="tableheader">
							<table class="viewtable" id="viewtable" width="100%" style="">
								<tr class="th">
											<td style="width:200px;" class="thcell">
												Наименование объекта
											</td>
											<td style="width:200px;" class="thcell">
												Адрес
											</td>
											<td style="width:180px;" class="thcell">
												GPS координаты
											</td>
											<td style="width:80px;" class="thcell">
												Всего
											</td>
											<td style="width:80px;" class="thcell">
												Исполнено
											</td>
											<td style="min-width:80px;" class="thcell">
												Не исполнено
											</td>
								</tr>
							</table>
						</div>
					</div>
					<div id="viewtablediv">
						<div id="tablecontent">
								<xsl:attribute name="style">top:85px;</xsl:attribute>
							<table class="viewtable" id="viewtable" width="100%">
								<xsl:for-each select="query/entries/entry">
									<tr>
										<xsl:attribute name="bgcolor">#FFFFFF</xsl:attribute>
										<td style="border:1px solid #ccc; width:200px; padding-left:3px">
											<xsl:value-of select="viewtext"/>
										</td>
										<td style="border:1px solid #ccc; width:200px; padding-left:3px">
											<xsl:value-of select="address"/>
										</td>
										<td style="border:1px solid #ccc; width:180px; padding-left:3px">
											<xsl:value-of select="coordinats"/>
										</td>
										<td style="border:1px solid #ccc; width:80px; text-align:center">
											<xsl:value-of select="total"/>
										</td>
										<td style="border:1px solid #ccc; width:80px; text-align:center">
											<xsl:value-of select="executed"/>
										</td>
										<td style="border:1px solid #ccc; min-width:80px; text-align:center">
											<xsl:value-of select="unexecuted"/>
										</td>
									</tr>
								</xsl:for-each>
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