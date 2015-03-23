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
	<xsl:variable name="readonly" select="request/document/@editmde"/>
	<xsl:variable name="editmode"><xsl:value-of select="/request/document/@editmode"/></xsl:variable>
	<xsl:template match="/request">
		<html>		
			<head>	
				<title>OrderManagment - <xsl:value-of select="document/captions/title/@caption" /></title>
				<!-- load scripts and css link -->
				<xsl:call-template name="cssandjs"/>
                <xsl:call-template name="hotkeys"/>
				<xsl:call-template name="htmlareaeditor"/>
			</head>
			<body>
				<xsl:attribute name="onbeforeprint">javascript:$("#htmlcodenoteditable").html($("#txtDefaultHtmlArea").val())</xsl:attribute>
				<xsl:variable name="status" select="@status"/>	
				<div id="docwrapper">
					<xsl:call-template name="documentheader"/>
					<div class="formwrapper">
						<div class="formtitle">
						   	<div class="title">
						   		<xsl:variable name="status" select="document/@status" /> 
					   			<xsl:value-of select="document/captions/title/@caption" />
							</div>
						</div>
						<!-- Сохранить и закрыть -->
						<div class="button_panel">
							<span style="float:left">								
								<xsl:call-template name="save"/>
							</span>
							<!-- Закрыть -->
							<span style="float:right; padding-right:15px;">								
								<xsl:call-template name="cancel"/>
							</span>
							  
						</div>
						<div style="clear:both"/>
						<div style="-moz-border-radius:0px;height:1px; width:100%; "/>
						<div style="clear:both"/>
						<div id="tabs">
							<form action="Provider" name="frm" method="post" id="frm" enctype="application/x-www-form-urlencoded"> 
								<ul class="ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-all">
									<li class="ui-state-default ui-corner-top">
										<a href="#tabs-1">
											<xsl:value-of select="document/captions/properties/@caption"/>
										</a>
									</li> 
									<xsl:call-template name="docInfo"/>
								</ul>							
								
								<div class="ui-tabs-panel" id="tabs-1" >
                                    <div display="block"  id="property" width="100%">
                                        <table border="0" style="margin-top:8px">
										 
											<!-- Название  -->
											<tr>
												<td class="fc"><font style="vertical-align:top"><xsl:value-of select="document/captions/name/@caption" />: </font></td>
												<td style="width:70%"> 											
												<input type="text" required="required" id="name" name="name" class="td_editable" style="width:490px">
													<xsl:if test="document/@editmode != 'edit'">
														<xsl:attribute name="readonly">readonly</xsl:attribute>
														<xsl:attribute name="class">td_noteditable</xsl:attribute>
													</xsl:if>
													<xsl:attribute name="title" select="document/fields/name/@caption" />
													<xsl:attribute name="value" select="document/fields/name" />
												</input> 
												</td>
											</tr>

                                            <!-- БИН  -->
                                            <tr>
                                                <td class="fc"><font style="vertical-align:top"><xsl:value-of select="document/captions/bin/@caption" />: </font></td>
                                                <td style="width:70%">
                                                    <input type="text" required="required" id="bin" maxlength="12" name="bin" class="td_editable" style="width:200px">
                                                        <xsl:if test="document/@editmode != 'edit'">
                                                            <xsl:attribute name="readonly">readonly</xsl:attribute>
                                                            <xsl:attribute name="class">td_noteditable</xsl:attribute>
                                                        </xsl:if>
                                                        <xsl:attribute name="title" select="document/fields/name/@caption" />
                                                        <xsl:attribute name="value" select="document/fields/name" />
                                                        <xsl:attribute name="onkeydown">javascript:numericfield(this)</xsl:attribute>
                                                    </input>
                                                </td>
                                            </tr>
                                        </table>
										<input type="hidden" name="type" value="save"/>
										<input type="hidden" name="id" value="{@id}"/>
										<input type="hidden" name="key" value="{document/@docid}"/>
										<input type="hidden" name="parentdocid" value="{document/@parentdocid}"/>
										<input type="hidden" name="parentdoctype" value="{document/@parentdoctype}"/>
										<input type="hidden" name="doctype" value="{document/@doctype}"/>
										<input type="hidden" name="formsesid" value="{formsesid}"/>
									</div>
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
		<xsl:param name="param"/>
		&#xA0;
		<xsl:variable name="kaz_part" select="substring-before($param, '/*')" /> 
   		<xsl:variable name="rus_part" select="substring-after($param, '/*')" /> 
		
		<xsl:choose>
			<xsl:when test="$lang = 'KAZ'">
				<xsl:value-of select="$kaz_part" />
			</xsl:when>
			<xsl:otherwise>
			 	<xsl:value-of select="$rus_part" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>