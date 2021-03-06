<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<!-- кнопка показать xml документ  -->
	<xsl:template name="showxml">
		<xsl:if test="@debug=1">
			<button class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
				<xsl:attribute name="onclick">javascript:window.location = window.location + '&amp;onlyxml=1'</xsl:attribute>
				<span>
					<img src="/SharedResources/img/classic/icons/page_code.png" class="button_img"/>
					<font style="font-size:12px; vertical-align:top">XML</font>
				</span>
			</button>
		</xsl:if>
	</xsl:template>
	
	<!-- кнопка сохранения  -->
	
	<xsl:template name="save">
		<xsl:if test="document/actionbar/action[@id='save_and_close']/@mode = 'ON'">
			<button title="{document/actionbar/action [@id='save_and_close']/@hint}" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" id="btnsavedoc">
				<xsl:attribute name="onclick">javascript:SaveFormJquery('frm','frm','<xsl:value-of select="/request/history/entry[@type = 'page'][last()]"/>')</xsl:attribute>
				<span>
					<img src="/SharedResources/img/classic/icons/disk.png" class="button_img"/>
					<font style="font-size:12px; vertical-align:top"><xsl:value-of select="document/actionbar/action [@id='save_and_close']/@caption"/></font>
				</span>
			</button>
		</xsl:if>
	</xsl:template>
	
	<!-- кнопка сохранения карточки резолюции  -->
	<xsl:template name="saveKR">
		<xsl:if test="document/actionbar/action[@id='save_and_close']/@mode = 'ON'">
			<button title ="{document/actions/action [.='SAVE']/@hint}" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" id="btnsavedoc" style="margin-left:5px">
				<xsl:attribute name="onclick">javascript:SaveFormJquery('frm','frm','<xsl:value-of select="history/entry[@type eq 'view'][last()]"/>&amp;page=<xsl:value-of select="document/@openfrompage"/>', 'kr')</xsl:attribute>
				<span>
					<img src="/SharedResources/img/classic/icons/disk.png" class="button_img"/>
					<font style="font-size:12px; vertical-align:top;"><xsl:value-of select="document/actionbar/action[@id='save_and_close']/@caption"/></font>
				</span>
			</button>
		</xsl:if>
			
	</xsl:template>
	
	<!-- 	кнопка сформировать отчет -->
	<xsl:template name="filling_report">
		<xsl:if test="document/actionbar/action[@id='save_and_close']/@mode = 'ON'">
			<button title ="{document/actions/action[. = 'SAVE']/@hint}" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" style="margin-left:5px"  id="generatereport">
				<xsl:attribute name="onclick">javascript:fillingReport()</xsl:attribute>
				<span>
					<img src="/SharedResources/img/classic/icons/disk.png" class="button_img"/>
					<font style="font-size:12px; vertical-align:top"><xsl:value-of select="document/actionbar/action [@id='save_and_close']/@caption"/></font>
				</span>
			</button>
		</xsl:if>
	</xsl:template>
	
	<!-- кнопка сохранения карточки исполнения  -->
	<xsl:template name="saveKI">
		<xsl:if test="document/actionbar/action[@id = 'save_and_close']/@mode ='ON'">
			<button title ="{document/actionbar/action[@id = 'save_and_close']/@hint}" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" id="btnsavedoc" style="margin-left:5px">
				<xsl:attribute name="onclick">javascript:SaveFormJquery('frm','frm','<xsl:value-of select="history/entry[@type eq 'view'][last()]"/>&amp;page=<xsl:value-of select="document/@openfrompage"/>', 'ki')</xsl:attribute>
				<span>
					<img src="/SharedResources/img/classic/icons/disk.png" class="button_img"/>
					<font style="font-size:12px; vertical-align:top"><xsl:value-of select="document/actionbar/action[@id = 'save_and_close']/@caption"/></font>
				</span>
			</button>
		</xsl:if>
	</xsl:template>
	
	<!-- кнопка снять с контроля  -->
	<xsl:template name="resetcontrol">
		<xsl:if test="document/actionbar/action [@id='reset']/@mode = 'ON' and document/fields/control/allcontrol != 0">
			<button  title ="{document/actionbar/action[@id = 'reset']/@hint}" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" id="btnnewkr" style="margin-left:5px">
				<xsl:attribute name="onclick">javascript:resetcontrol()</xsl:attribute>
				<span>
					<img src="/SharedResources/img/classic/icons/accept.png" class="button_img"/>
					<font style="font-size:12px; vertical-align:top"><xsl:value-of select="document/actionbar/action [@id='reset']/@caption"/></font>
				</span>
			</button>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="newdiscussion">
		<xsl:if test="document/actions/action [.='COMPOSE_DISCUSSION']/@enable = 'true'">
			<button  title ="{document/actionbar/action[@id = 'COMPOSE_DISCUSSION']/@hint}" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" style="margin-left:5px">
				<xsl:attribute name="onclick">javascript:window.location.href="Provider?type=document&amp;id=discussion&amp;key=&amp;parentdocid=<xsl:value-of select="document/@docid"/>&amp;parentdoctype=<xsl:value-of select="document/@doctype"/>&amp;page=null"</xsl:attribute>
				<span>
					<img src="/SharedResources/img/comment/icons/comments_add.png" class="button_img"/>
					<font style="font-size:12px; vertical-align:top">Создать обсуждение</font>
				</span>
			</button>
		</xsl:if>
	</xsl:template>

	<!--кнопка закрыть-->
	<xsl:template name="cancel">
		<button title= "{document/captions/close/@hint}" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" id="canceldoc">
			<xsl:attribute name="onclick">javascript:<xsl:value-of select="document/actionbar/action[@id = 'close']/js"/></xsl:attribute>
			<span>
				<img src="/SharedResources/img/classic/icons/cross.png" class="button_img"/>
				<font style="font-size:12px; vertical-align:top"><xsl:value-of select="document/captions/close/@caption"/></font>
			</span>
		</button>
	</xsl:template>

	<!--кнопка ознакомить-->
	<xsl:template name="acquaint">
		<xsl:if test="document/actions/action [.='GRANT_ACCESS']/@enable = 'true'">
			<button title ="{document/actions/action [.='GRANT_ACCESS']/@hint}" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" id="btngrantaccess" style="margin-left:5px">
				<xsl:attribute name="onclick">javascript:acquaint(<xsl:value-of select="document/@docid"/>,<xsl:value-of select="document/@doctype"/>)</xsl:attribute>
				<span>
					<img src="/SharedResources/img/classic/icons/page_white_get.png" class="button_img"/>
					<font style="font-size:12px; vertical-align:top"><xsl:value-of select="document/actions/action [.='GRANT_ACCESS']/@caption"/></font>
				</span>
			</button>
			<script>
				acquaintcaption = '<xsl:value-of select="document/actions/action [.='GRANT_ACCESS']/@caption"/>';
			</script>
		</xsl:if>
	</xsl:template>

	<!--кнопка напомнить-->
	<xsl:template name="remind">
		<xsl:if test="document/actions/action [.='NOTIFY_EXECUTERS']/@enable = 'true'">
			<button title= "{document/actions/action [.='NOTIFY_EXECUTERS']/@hint}" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" id="btnremind" style="margin-left:5px">
				<xsl:attribute name="onclick">javascript:remind(<xsl:value-of select="document/@docid"/>,<xsl:value-of select="document/@doctype"/>)</xsl:attribute>
				<span>
					<img src="/SharedResources/img/classic/icons/clock_red.png" class="button_img"/>
					<font style="font-size:12px; vertical-align:top"><xsl:value-of select="document/actions/action [.='NOTIFY_EXECUTERS']/@caption"/></font>
				</span>
			</button>
			<script>
				remindcaption = '<xsl:value-of select="document/actions/action [.='NOTIFY_EXECUTERS']/@caption"/>';
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