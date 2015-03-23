<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../templates/page.xsl"/>
	<xsl:variable name="viewtype">Вид</xsl:variable>
	<xsl:variable name="query" select="//query"/>
	<xsl:variable name="captions" select="/request/page/captions/page/captions"/>
	<xsl:output method="html" encoding="utf-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" indent="no"/>
	<xsl:variable name="skin" select="request/@skin"/>
	<xsl:variable name="useragent" select="request/@useragent"/>
	<xsl:variable name="lang" select="request/@lang"/>
	<xsl:template match="/request">
		<html style="overflow:hidden">
			<head>
				<title>Projects - <xsl:call-template name="pagetitle"/></title>
                <xsl:call-template name="cssjs" />

				<!-- vizualize -->
				<script type="text/javascript" src="/SharedResources/jquery/js/visualize/js/visualize.jQuery.js"/>
				<link type="text/css" rel="stylesheet" href="/SharedResources/jquery/js/visualize/css/visualize.css"/>
				<link type="text/css" rel="stylesheet" href="/SharedResources/jquery/js/visualize/css/basic.css"/>
				
				<!-- jchartfx -->
				<link rel="stylesheet" type="text/css" href="/SharedResources/jquery/js/jChartFX/styles/jchartfx.css" />
			    <script type="text/javascript" src="/SharedResources/jquery/js/jChartFX/js/jchartfx.system.js"></script>
			    <script type="text/javascript" src="/SharedResources/jquery/js/jChartFX/js/jchartfx.coreVector.js"></script>
				<script type="text/javascript" src="/SharedResources/jquery/js/jChartFX/js/jchartfx.animation.js"></script>
				<script type="text/javascript" src="/SharedResources/jquery/js/jChartFX/js/jchartfx.advanced.js"></script>
				 
				<xsl:call-template name="hotkeys"/>	
				<xsl:call-template name="calendar"/>
				<style>
					table{
						min-width:20px;
						border:none;
					}
					table tr td{
						border:none;
						margin:0;
						padding:0;
					}
				</style>
                <script>
                    $(document).click(function(event){
                        if($('#projects_list').is(":visible")) {
                            if($("#projects_list").has(event.target).length==0)  {
                                $('#projects_list').hide()
                            }
                        }else if($(event.target).is("#projects_names")){
                                $('#projects_list').show()
                            }
                        });

                    function changeEmpList(el){
                        var selected_index = el.selectedIndex + 1
                        $("#projects_list").remove()
                    }
                </script>
			</head>
			<body>
				<xsl:call-template name="flashentry"/>
				<div id="blockWindow" style="display:none"/>
				<div id="wrapper">	
					<xsl:call-template name="loadingpage"/>
					<xsl:call-template name="header-view"/>			
					<xsl:call-template name="outline-menu-view"/> 
					<span id="view" class="viewframe">

							<table style="width:100%;">
								<tr style="height:14px">
									<td style="text-align:left;">					 
										<font class="time" style="font-size:14px; padding-right:10px; font-weight:bold;">										
											<xsl:call-template name="pagetitle"/>
								    	</font>
									</td>
								</tr>
							</table>
                                <div style="width:100%;  display:inline-block;">
                                    <div id="QFilter" style="clear:both;width:auto; min-width:700px; background: #eeeeee; border:1px solid #ccc;  min-height:27px; margin-top:5px; margin-left:2px; display:block; position:absolute; top:51px; right:0px; left:12px; text-align: left;padding-left:10px">
                                        <xsl:if test="@useragent != 'IE'">
                                            <xsl:attribute name="style">width:auto;min-width:700px; background: #eeeeee; border:1px solid #ccc; min-height:29px; margin-top:5px; margin-left:2px; display:block; position:absolute; top:49px; right:0px; left:12px; text-align: left;padding-left:10px</xsl:attribute>
                                        </xsl:if>

                                        <div style="display: inline-block; width:98%">
                                            <font style="font-size:11px; line-height:25px;"><xsl:value-of select="//captions/org/@caption"/> : </font>
                                            <div id="projects_names" class="selectedNames"  style="width: calc(100% - 110px); width:-moz-calc(100% - 110px); width: -webkit-calc(100% - 110px); background:white;display: inline-block;vertical-align: middle;font-size: 12px;height: 20px;border: 1px solid rgb(169, 169, 169); white-space:nowrap; text-overflow: ellipsis;overflow: hidden;">
                                            </div>
                                        </div>

                                        <div  id="projects_list" style="display:none" class="dropDownList">
                                            <ul>
                                                <li>
                                                    <input type="checkbox" class="" id="allchbox" value="all" name="chbox" onclick="checkAll(this); changeEmpListText(this, &quot;{//captions/all/@caption}&quot;)" />
                                                    <label for="allchbox">Все</label>
                                                </li>
                                                <xsl:for-each select="//projects/response/content/statistics/entry">
                                                        <li>
                                                            <span>
                                                                <input type="checkbox" id="{@docid}" value="{@project_name}" name="chbox" onclick="changeEmpListText(this, &quot;{@project_name}&quot;)" />
                                                                <label for="{@docid}"><xsl:value-of select="@project_name"/></label>
                                                            </span>&#xA0;
                                                        </li>
                                                    <!--<xsl:apply-templates select="entry">-->
                                                    <!--</xsl:apply-templates>-->
                                                </xsl:for-each>
                                            </ul>
                                        </div>
                                        <br/>
                                        <div style="display: inline-block">
                                            <font style="font-size:11px; line-height:25px; "><xsl:value-of select="//captions/startdate/@caption"/> : </font>
                                            <input id="startdate" name="startdate" class="eventdate" style="width:70px" autocomplete="off" readonly="true"/>
                                            <font style="font-size:11px; line-height:25px; margin-left:10px"><xsl:value-of select="//captions/enddate/@caption"/> : </font>
                                            <input id="enddate" name="enddate" class="eventdate" style="width:70px" autocomplete="off"  readonly="true"/>

                                            <img class="filter_button" src="/SharedResources/img/iconset/statistics.png" style="margin-left:10px; cursor:pointer; vertical-align:-9px; border:1px solid #cdcdcd; padding:2px 2px; border-radius:3px; height:19px; width:20px">
                                                <xsl:attribute name="title" select="//captions/showstat/@caption"/>
                                                <xsl:attribute name="onclick">javascript:calcStatistics('<xsl:value-of select="@id" />')</xsl:attribute>
                                            </img>
                                            <img class="filter_button" src="/SharedResources/img/iconset/printer_empty.png" style="margin-left:10px; cursor:pointer; vertical-align:-9px; border:1px solid #cdcdcd; padding:2px 2px; border-radius:3px; height:19px; width:20px">
                                                <xsl:attribute name="title" select="//captions/print/@caption"/>
                                                <xsl:attribute name="onclick">javascript:window.print()</xsl:attribute>
                                            </img>
                                            <img class="filter_button" src="/SharedResources/img/iconset/054-delete.png" style="margin-left:10px; cursor:pointer; vertical-align:-8px; border:1px solid #cdcdcd; padding:3px 4px; border-radius:3px">
                                                <xsl:attribute name="title" select="//captions/resetfilter/@caption"/>
                                                <xsl:attribute name="onclick">javascript:resetFilter()</xsl:attribute>
                                            </img>
                                        </div>
                                    </div>
								<div style="clear:both"/>
							</div>
                        <div id="viewcontent" style="position: absolute;top: 120px;bottom: 40px;left: 20px;right: 0px;">
                            <div id="barStat" style="height: 85%;  background-color:whitesmoke; width:99%">

							</div>
                            <br/>
                            <span style="font-size:12px; color:#595959">*График строится на основе количества активных заявок в проекте за выбранный период</span>
						</div>
					</span>
				</div>
			</body>
		</html>
	</xsl:template>

    <xsl:template name="emplist">
        <xsl:param name="orgindex" />

    </xsl:template>
    <xsl:template match="entry">
        <xsl:for-each select=".">
            <xsl:if test="@doctype='889'">
                <li>
                    <span>
                        <xsl:if test="/request/@useragent != 'IE'">
                            <xsl:attribute name="style">white-space:nowrap</xsl:attribute>
                        </xsl:if>
                        <input type="checkbox"  id="{userid}" value="{userid}" name="chbox" onclick="changeEmpList(this, &quot;{@viewtext}&quot;)" />
                        <label for="{userid}"><xsl:value-of select="viewtext"/></label>
                    </span>
                </li>
            </xsl:if>
            <xsl:apply-templates select="entry">
            </xsl:apply-templates>

        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>