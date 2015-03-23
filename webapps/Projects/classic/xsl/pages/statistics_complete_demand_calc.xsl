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
		<table class="viewtable" id="viewtable" width="100%">	
			<xsl:apply-templates select="//query/entry"/>									
		</table>
	</xsl:template>
	
	<xsl:template match="//query/entry">
		<xsl:variable name="num" select="position()"/>
		<tr title="{@viewtext}" class="{@docid}" id="{@docid}{@doctype}">
			<xsl:if test ="viewcontent/leftdays &gt; '0'">
				<xsl:attribute name="bgcolor">#FFFFFF</xsl:attribute>
			</xsl:if>
			<xsl:if test ="viewcontent/leftdays ='0'">
				<xsl:attribute name="bgcolor">#FCFCE5</xsl:attribute>
			</xsl:if>
			<xsl:if test ="viewcontent/leftdays &lt; '0'">
				<xsl:attribute name="bgcolor">#FFEDED</xsl:attribute>
			</xsl:if>
			<td style="text-align:center; border:1px solid #ccc;width:34px;" class="hasattach_td">
				<xsl:if test="@hasattach != 0">
					<img id="atach" src="/SharedResources/img/classic/icons/attach.png" title="Вложений в документе: {@hasattach}"/>
				</xsl:if>
			</td>
			<td  style="text-align:center ;border:1px solid #ccc; width:45px;">
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
			       	<xsl:choose>
			       		<xsl:when test=".[responses]">
							<img style="vertical-align:-4px; margin-left:2px; margin-right:5px; border:0px; cursor:pointer" src="/SharedResources/img/classic/1/minus1.png" docid="{@docid}" doctype="{@doctype}">
								<xsl:attribute name='onclick'>javascript:closeResponses(this)</xsl:attribute>
							</img>
						</xsl:when>
						<xsl:otherwise>
							<img style="vertical-align:-4px; margin-left:2px; margin-right:5px; border:0px; cursor:pointer" src="/SharedResources/img/classic/1/plus1.png" docid="{@docid}" doctype="{@doctype}">
								<xsl:attribute name='onclick'>javascript:openParentDocView(this)</xsl:attribute>
							</img>
						</xsl:otherwise>
					</xsl:choose>
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
			<td style="border:1px solid #ccc; width:200px;" class="viewdate_td">
				<a  href="{@url}" class="doclink" style="padding-left:10px;">
                    <xsl:if test="@isread = 0">
                        <xsl:attribute name="style">font-weight:bold; padding-left:10px;</xsl:attribute>
                    </xsl:if>
                    <xsl:choose>
                        <xsl:when test="viewcontent/viewtext4 = '1' or viewcontent/viewtext4 = '2'">
                            <xsl:value-of select="substring(viewcontent/viewdate, 0, 11)"/>&#xA0;
                            <xsl:choose>
                                <xsl:when test="not(viewcontent/leftdays)">
                                	<xsl:variable name="year" select="substring(viewcontent/viewdate,7,4)"/>
									<xsl:variable name="month" select="substring(viewcontent/viewdate,4,2)"/>
									<xsl:variable name="day" select="substring(viewcontent/viewdate,1,2)"/>
                                	<xsl:variable name="nowdate" as="xs:date" select="xs:date(current-date())"/>
									<xsl:variable name="demanddate" as="xs:date" select="xs:date(concat($year,'-',$month,'-',$day))"/>
									(<xsl:value-of select="days-from-duration($demanddate - $nowdate)"/>)
                                    <!-- (<font id="dayleft{@id}"/>)
                                    <script>
                                        today = new Date();
                                        viewdate = "<xsl:value-of select='viewcontent/viewdate'/>";
                                        ddate = new Date(viewdate.replace(/(\d{2})\.(\d{2})\.(\d{4})/,'$3-$2-$1'));
                                        diff = ddate.getTime()-today.getTime();
                                        $('#dayleft<xsl:value-of select="@id"/>').html(Math.ceil(diff/(1000 * 3600 * 24))) 
                                    </script>-->
                                </xsl:when>
                                <xsl:otherwise>
                                    (<xsl:value-of select="viewcontent/leftdays"/>)
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="substring(viewcontent/viewdate, 0, 11)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </a>
			</td>
			<td style="border:1px solid #ccc; border-left:none; width:30px; text-align:center" class="fav_td">
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
			<td style="border:1px solid #ccc; border-left:none; width:30px; text-align:center" class="discussion_td">
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
			<xsl:attribute name="onclick">javascript:beforeOpenDocument()</xsl:attribute>
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