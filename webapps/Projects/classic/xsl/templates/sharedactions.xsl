<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<!-- кнопка показать xml документ  -->
	<xsl:template name="showxml">
		<xsl:if test="@debug=1">
			<button class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
				<xsl:attribute name="onclick">javascript:window.location = window.location + '&amp;onlyxml=1'</xsl:attribute>
				<span>
					<img src="/SharedResources/img/iconset/page_code.png" class="button_img"/>
					<font class="button_text">XML</font>
				</span>
			</button>
		</xsl:if>
	</xsl:template>
	
	<!-- кнопка сохранения  -->
	<xsl:template name="save">
		<xsl:if test="document/actionbar/action[@id='save_and_close']/@mode = 'ON'">
			<button style="margin-right:5px; margin-bottom:5px" title="{document/actionbar/action[@id='save_and_close']/@hint}" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" id="btnsavedoc" autocomplete="off">
				<xsl:attribute name="onclick">javascript:SaveFormJquery('<xsl:value-of select="document/actionbar/action[@id ='close']/js"/>')</xsl:attribute>
				<span>
					<img src="/SharedResources/img/classic/icons/disk.png" class="button_img"/>
					<font class="button_text"><xsl:value-of select="document/actionbar/action [@id='save_and_close']/@caption"/></font>
				</span>
			</button>
		</xsl:if>
	</xsl:template>
	
	<!--кнопка закрыть-->
	<xsl:template name="cancel">
		<button class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" title="{document/captions/close/@caption}" id="canceldoc" autocomplete="off">
			<xsl:attribute name="onclick">javascript:<xsl:value-of select="document/actionbar/action[@id ='close']/js"/></xsl:attribute>
			<span>
				<img src="/SharedResources/img/iconset/cross.png" class="button_img"/>
				<font class="button_text"><xsl:value-of select="document/actionbar/action[@id ='close']/@caption"/></font>
			</span>
		</button>
	</xsl:template>
	
	<xsl:template name="get_document_accesslist">
		<xsl:if test="document/actionbar/action[@id ='get_document_accesslist']/@mode = 'ON'">
			<button style="margin-right:5px" title="{document/actionbar/action[@id = 'get_document_accesslist']/@hint}" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" autocomplete="off">
				<xsl:attribute name="onclick">javascript:<xsl:value-of select="document/actionbar/action[@id = 'get_document_accesslist']/js"/></xsl:attribute>
				<span>
					<img src="/SharedResources/img/classic/icons/page_white_key.png" class="button_img"/>
					<font class="button_text"><xsl:value-of select="document/actionbar/action[@id = 'get_document_accesslist']/@caption"/></font>
				</span>
			</button>
		</xsl:if>
	</xsl:template>

	<!--кнопка ознакомить-->
	<xsl:template name="acquaint">
		<xsl:if test="document/actions/action [.='GRANT_ACCESS']/@enable = 'true'">
			<button class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" id="btngrantaccess" title="{document/actions/action [.='GRANT_ACCESS']/@hint}" autocomplete="off">
				<xsl:attribute name="onclick">javascript:acquaint(<xsl:value-of select="document/@docid"/>,<xsl:value-of select="document/@doctype"/>)</xsl:attribute>
				<span>
					<img src="/SharedResources/img/iconset/document_info.png" class="button_img"/>
					<font class="button_text"><xsl:value-of select="document/actions/action[.='GRANT_ACCESS']/@caption"/></font>
				</span>
			</button>
			<script>
				acquaintcaption = '<xsl:value-of select="document/actions/action[.='GRANT_ACCESS']/@caption"/>';
			</script>
		</xsl:if>
	</xsl:template>

	
	<xsl:template name="ECPsign">
	<!--  	<xsl:if test="document/@sign != '1'">
			<button>
				<xsl:attribute name="onclick">edsApp.sign('<xsl:value-of select="@id"/>', this); return false;</xsl:attribute>
				<img src="/SharedResources/img/iconset/page_edit.png" class="button_img"/>
				<font style="font-size:12px; vertical-align:top">Добавить ЭЦП</font>
			</button>
		</xsl:if>-->
	</xsl:template>
</xsl:stylesheet>