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
	<xsl:variable name="editmode">
		<xsl:if test="request/document/@status = 'new'">
			<xsl:value-of select="/request/document/@editmode"/>
		</xsl:if>
		<xsl:if test="request/document/@status != 'new'">readonly</xsl:if>
	</xsl:variable>
	
	<xsl:template match="/request">
		<html>		
			<head>	
				<title>
					<xsl:value-of select="document/captions/title/@caption"/> - Support
				</title>
				<xsl:call-template name="cssandjs"/>
				<script type="text/javascript">
					var editmode = '<xsl:value-of select="document/@editmode"/>'
					<![CDATA[
						function hotkeysnav(){ 
							$("#canceldoc").hotnav({keysource:function(e){ return "b"; }});
							$("#btnsavedoc").hotnav({keysource:function(e){ return "s"; }});
							$("#currentuser").hotnav({ keysource:function(e){ return "u"; }});
							$("#logout").hotnav({keysource:function(e){ return "q"; }});
							$("#helpbtn").hotnav({keysource:function(e){ return "h"; }});
							$("#newdemand").hotnav({keysource:function(e){ return "n"; }});
							$("#resetcontrol").hotnav({keysource:function(e){ return "i"; }});
							$("#revokedemand").hotnav({keysource:function(e){ return "x"; }});
							$("#extend").hotnav({keysource:function(e){ return "y"; }});
							$("#ki").hotnav({keysource:function(e){ return "m"; }});
							$(document).bind('keydown', function(e){
		 					if (e.ctrlKey) {
		 						switch (e.keyCode) {
								   case 66:
								   		<!-- клавиша b -->
								     	e.preventDefault();
								     	$("#canceldoc").click();
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
								  case 78:
								   		<!-- клавиша n -->
								     	e.preventDefault();
								     	$("#newdemand").click();
								      	break;
								  case 88:
								   		<!-- клавиша x -->
								     	e.preventDefault();
								     	$("#revokedemand").click();
								      	break;
								  case 73:
								   		<!-- клавиша i -->
								     	e.preventDefault();
								     	$("#resetcontrol").click();
								      	break;
								  case 89:
								   		<!-- клавиша y -->
								     	e.preventDefault();
								     	$("#extend").click();
								      	break;
								  case 77:
								   		<!-- клавиша m -->
								     	e.preventDefault();
								     	$("#ki").click();
								      	break;
								   default:
								      	break;
									}
			   					}
							});
						}
					]]>
                </script>
                <xsl:call-template name="htmlareaeditor"/>
                <xsl:call-template name="markisread"/>
            </head>
            <body>
                <xsl:attribute name="onbeforeprint">javascript:$("#htmlcodenoteditable").html($("#txtDefaultHtmlArea").val())</xsl:attribute>
                <xsl:variable name="status" select="@status"/>
                <div id="docwrapper">
                    <xsl:call-template name="documentheader"/>
                    <div class="formwrapper">
                        <div class="formtitle">
                            <div class="title">
                                <xsl:variable name="status" select="document/@status"/>
                                <xsl:value-of select="document/captions/title/@caption"/>
                                <xsl:if test="$status != 'new'">
                                    № <xsl:value-of select="document/fields/vn"/>&#xA0;<xsl:value-of select="document/captions/from/@caption"/>&#xA0;<xsl:value-of select="document/fields/regDate" />
                                </xsl:if>
                            </div>
                        </div>
                        <!-- Сохранить и закрыть -->
                        <div class="button_panel">
                            <!-- Написать менеджеру -->
                            <xsl:if test="document/actionbar/action[@id='custom_action']/@mode = 'ON'">
                                <button title="{document/actionbar/action [@id='custom_action']/@hint}" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" id="btnsavedoc">
                                    <xsl:attribute name="onclick">javascript:EmailToManager()</xsl:attribute>
                                    <span>
                                        <img src="/SharedResources/img/classic/icons/email_edit.png" class="button_img"/>
                                        <font style="font-size:12px; vertical-align:top"><xsl:value-of select="document/actionbar/action [@id='custom_action']/@caption"/></font>
                                    </span>
                                </button>
                            </xsl:if>
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
                                    <li class="ui-state-default ui-corner-top">
                                        <a href="#tabs-2">
                                            <xsl:value-of select="document/captions/attachments/@caption"/>
                                        </a>
                                    </li>

                                    <xsl:call-template name="docInfo"/>
                                </ul>
                                <div class="ui-tabs-panel" id="tabs-1" >
                                <div display="block" id="property" width="100%">
                                    <table width="100%" border="0" style="margin-top:8px">
                                        <!-- Проект -->
                                        <tr>
                                            <td class="fc">
                                                <font style="vertical-align:top"><xsl:value-of select="document/captions/project/@caption"/>:

                                                </font>
                                            </td>
                                            <td>
                                                <table id="projecttbl" style="border-collapse:collapse">
                                                    <tr>
                                                        <td width="500px" class="td_noteditable">

                                                            <font id="parentProjectfont">
                                                                <xsl:value-of select="document/fields/parentProject"/>&#xA0;
                                                            </font>
                                                            <input type="hidden" name="projectid" value="{document/fields/projectid}"  />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <!-- Веха -->
                                        <tr>
                                            <td class="fc">
                                                <font style="vertical-align:top"><xsl:value-of select="document/captions/milestone/@caption"/>: </font>
                                            </td>
                                            <td>

                                                <table id="projecttbl" style="border-collapse:collapse">
                                                    <tr>
                                                        <td width="500px" class="td_noteditable">

                                                            <font id="parentProjectfont">
                                                                <xsl:value-of select="document/fields/parentMilestone"/>&#xA0;
                                                            </font>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>

                                        <!-- Срок исполнения -->
                                        <tr>
                                            <td class="fc"><font style="vertical-align:top"><xsl:value-of select="document/captions/ctrldate/@caption" />: </font></td>
                                            <td>
                                                <input readonly="readonly" type="text"   name="ctrldate" onfocus="javascript:$(this).blur()" class="td_noteditable" style="width:150px; vertical-align:top">
                                                    <xsl:attribute name="title" select="document/fields/ctrldate/@caption" />
                                                    <xsl:attribute name="value" select="substring(document/fields/control/ctrldate,1,10)" />

                                                </input>

                                            </td>
                                        </tr>
                                        <!-- Осталось дней -->
                                        <tr>
                                            <td class="fc">
                                                <font style="vertical-align:top">
                                                    <xsl:value-of select="document/captions/remained_days/@caption" /> :
                                                </font>
                                            </td>
                                            <td>
                                                <input readonly="readonly" type="text" name="remained_days" id="remained_days" onfocus="javascript:$(this).blur()" value="{document/fields/control/diff}" class="td_noteditable" style="width:150px; vertical-align:top">
                                                    <xsl:attribute name="title" select="document/fields/remained_days/@caption"/>
                                                </input>
                                            </td>
                                        </tr>
                                        <!-- Краткое содержание -->
                                        <tr>
                                            <td class="fc"><xsl:value-of select="document/captions/content/@caption"/> : </td>
                                            <td>
                                                <div id="htmlcodenoteditable" class="textarea_noteditable" style="width:610px; height:350px; display:block">
                                                </div>
                                                <script>
                                                    $("#htmlcodenoteditable").html("<xsl:value-of select="document/fields/briefcontent"/>");
                                                </script>

                                                <script>
                                                    if($(window).width() > 1200){
                                                        $("#txtDefaultHtmlArea").width("910px").height("350px");
                                                        $("#htmlcodenoteditable").width("910px");
                                                    }else{
                                                        $("#txtDefaultHtmlArea").width("610px").height("350px");
                                                    }
                                                </script>
                                                </td>
                                        </tr>

                                    </table>
                                    <input type="hidden" name="type" value="save"/>
                                    <input type="hidden" name="id" value="{@id}"/>
                                    <input type="hidden" name="key" value="{document/@docid}"/>
                                    <input type="hidden" name="allcontrol" value="{document/fields/allcontrol}"/>
                                    <input type="hidden" name="status" value="{document/fields/status}"/>
                                    <input type="hidden" name="revoke_demand_reason_id" value="{document/fields/revoke_demand_reason_id}"/>
                                    <input type="hidden" name="parentdoctype" value="{document/@parentdoctype}"/>
                                    <input type="hidden" name="parentdocid" value="{document/@parentdocid}"/>
                                    <input type="hidden" name="doctype" value="{document/@doctype}"/>
                                </div>
                            </div>
                        </form>
                        <div class="ui-tabs-panel" id="tabs-2">
                            <div display="block"  id="property" width="100%">
                                <form action="Uploader" name="upload" id="upload" method="post" enctype="multipart/form-data">
                                    <input type="hidden" name="type" value="rtfcontent"/>
                                    <input type="hidden" name="formsesid" value="{formsesid}"/>
                                    <!-- Секция "Вложения" -->
                                    <div display="block" id="att" style="width:100%">
                                        <xsl:call-template name="attach"/>
                                    </div>
                                </form>
                            </div>
                        </div>
                        </div>
                </div>
            </div>
            <!-- Outline -->
            <xsl:call-template name="formoutline"/>
        </body>
	</html>
</xsl:template>

<xsl:template name="lang_splitter">
	<xsl:param name="param"/>
	&#xA0;
	<xsl:variable name="kaz_part" select="substring-before($param, '/*')"/> 
	<xsl:variable name="rus_part" select="substring-after($param, '/*')"/> 
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