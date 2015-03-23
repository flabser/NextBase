<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../templates/form.xsl"/>
	<xsl:import href="../templates/sharedactions.xsl"/>
	<xsl:variable name="doctype" select="request/document/captions/product/@caption"/>
	<xsl:variable name="editmode" select="/request/document/@editmode"/>
	<xsl:variable name="threaddocid" select="document/@docid"/>
	<xsl:output method="html" encoding="utf-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" indent="yes"/>
	<xsl:variable name="skin" select="request/@skin"/>
	<xsl:template match="/request">
		<html>
			<head>
				<title>
					<xsl:value-of select="$doctype"/> - ITS
				</title>
				<xsl:call-template name="cssandjs"/>
				<xsl:if test="document/@editmode = 'edit'">
					<xsl:if test="/request/@lang = 'RUS'">
						<script>
						$(function() {
							$('#date').datepicker({
								showOn: 'button',
								buttonImage: '/SharedResources/img/iconset/calendar.png',
								buttonImageOnly: true,
								buttonText: "Изменить срок исполнения",
								regional:['ru'],
								showAnim: '',
							});
						});
					</script>
				</xsl:if>
				<xsl:if test="/request/@lang = 'KAZ'">
					<script>
						$(function() {
							$('#date').datepicker({
								showOn: 'button',
								buttonImage: '/SharedResources/img/iconset/calendar.png',
								buttonImageOnly: true,
								regional:['ru'],
								showAnim: '',
								monthNames: ['Қаңтар','Ақпан','Наурыз','Сәуір','Мамыр','Маусым',
								'Шілде','Тамыз','Қыркүйек','Қазан','Қараша','Желтоқсан'],
								monthNamesShort: ['Қаңтар','Ақпан','Наурыз','Сәуір','Мамыр','Маусым',
								'Шілде','Тамыз','Қыркүйек','Қазан','Қараша','Желтоқсан'],
								dayNames: ['жексебі','дүйсенбі','сейсенбі','сәрсенбі','бейсенбі','жұма','сенбі'],
								dayNamesShort: ['жек','дүй','сей','сәр','бей','жұм','сен'],
								dayNamesMin: ['Жс','Дс','Сс','Ср','Бс','Жм','Сн'],
							});
						});
					</script>
				</xsl:if>
					<xsl:if test="/request/@lang = 'ENG'">
						<script>
							$(function() {
								$('#date').datepicker({
									showOn: 'button',
									buttonImage: '/SharedResources/img/iconset/calendar.png',
									buttonImageOnly: true,
									regional:['ru'],
									showAnim: '',
									monthNames: ['January','February','March','April','May','June',
									'July','August','September','October','November','December'],
									monthNamesShort: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
									'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
									dayNames: ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
									dayNamesShort: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
									dayNamesMin: ['Su','Mo','Tu','We','Th','Fr','Sa'],
									weekHeader: 'Wk',
									firstDay: 1,
									isRTL: false,
									showMonthAfterYear: false,
								});
							});
						</script>
					</xsl:if>
					
					<xsl:if test="/request/@lang = 'CHN'">
						<script>
							$(function() {
								$('#date').datepicker({
									showOn: 'button',
									buttonImage: '/SharedResources/img/iconset/calendar.png',
									buttonImageOnly: true,
									regional:['ru'],
									showAnim: '',
									closeText: '关闭',
									prevText: '&#x3c;上月',
									nextText: '下月&#x3e;',
									currentText: '今天',
									monthNames: ['一月','二月','三月','四月','五月','六月',
									'七月','八月','九月','十月','十一月','十二月'],
									monthNamesShort: ['一','二','三','四','五','六',
									'七','八','九','十','十一','十二'],
									dayNames: ['星期日','星期一','星期二','星期三','星期四','星期五','星期六'],
									dayNamesShort: ['周日','周一','周二','周三','周四','周五','周六'],
									dayNamesMin: ['日','一','二','三','四','五','六'],
									weekHeader: '周',
									firstDay: 1,
									isRTL: false,
									showMonthAfterYear: true,
									yearSuffix: '年',
								});
							});
						</script>
					</xsl:if>
				</xsl:if>
				<script type="text/javascript">
					$(document).ready(function(){
						$("#count").tipTip({'activation':'click',"field":"count","defaultPosition":"right","content":"Поле может содержать только числовые значения"});
						hotkeysnav()
					})
   					<![CDATA[
	   					function hotkeysnav() {
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
									   default:
									      	break;
									}
			   					}
							});
							$("#canceldoc").hotnav({keysource:function(e){return "b";}});
							$("#btnsavedoc").hotnav({keysource:function(e){return "s";}});
							$("#currentuser").hotnav({ keysource:function(e){return "u";}});
							$("#logout").hotnav({keysource:function(e){return "q";}});
							$("#helpbtn").hotnav({keysource:function(e){return "h";}});
						}
				]]>
			</script>
		</head>
		<body>
			<xsl:variable name="status" select="@status"/>
			<div id="docwrapper">
				<xsl:call-template name="documentheader"/>	
				<div class="formwrapper">
					<div class="formtitle">
						<div class="title">
							 <xsl:call-template name="doctitleGlossary"/>		
						</div>
					</div>
					<div class="button_panel">
						<span style="float:left">
							<xsl:call-template name="showxml"/>
							<button title ="{document/captions/saveclose/@hint}" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" id="btnsavedoc">
								<xsl:attribute name="onclick">javascript:SaveFormJquery('frm','frm',&quot;<xsl:value-of select="history/entry[@type eq 'view'][last()]"/>&amp;page=<xsl:value-of select="document/@openfrompage"/>&quot;)</xsl:attribute>
								<span>
									<img src="/SharedResources/img/classic/icons/disk.png" class="button_img"/>
									<font style="font-size:12px; vertical-align:top"><xsl:value-of select="document/captions/saveclose/@caption"/></font>
								</span>
							</button>
						</span>
						<span style="float:right; margin-right:5px">
							<xsl:call-template name="cancel"/>
						</span>
					</div>
			  		<div style="clear:both"/>
					<div style="-moz-border-radius:0px;height:1px; width:100%; margin-top:10px;"/>
					<div style="clear:both"/>
					<div id="tabs">
						<ul class="ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-all">
							<li class="ui-state-default ui-corner-top">
								<a href="#tabs-1">
									<xsl:value-of select="document/captions/properties/@caption"/>
								</a>
							</li> 
						</ul>
						<div class="ui-tabs-panel" id="tabs-1">
							<form action="Provider" name="frm" method="post" id="frm" enctype="application/x-www-form-urlencoded">
								<div display="block" id="property">
									<br/>
									<table width="100%" border="0">
										<tr>
											<td class="fc"><xsl:value-of select="document/captions/product/@caption"/> :</td>
									        <td>
									        	<xsl:variable name="product" select="document/fields/product/@attrval"/>
						                      	<select size="1" name="product" style="width:300px;" class="select_editable" autocomplete="off">
													<xsl:if test="$editmode !='edit'">
														<xsl:attribute name="disabled"/>
														<xsl:attribute name="class">select_noteditable</xsl:attribute>
													</xsl:if>
													<xsl:for-each select="document/glossaries/product/query/entry">
														<option value="{@docid}">
															<xsl:if test="$product = @docid">
																<xsl:attribute name="selected">selected</xsl:attribute>
															</xsl:if>
															<xsl:value-of select="viewcontent/viewtext1"/>
														</option>
													</xsl:for-each>
												</select>
						                    </td>   					
										</tr>
										<tr>
											<td class="fc"><xsl:value-of select="document/captions/date/@caption"/> :</td>
									        <td>
						                       <input type="text" name="date" id="date" class="td_editable" value="{document/fields/date}" style="width:80px; vertical-align:top">
						                      		<xsl:if test="$editmode != 'edit'">
														<xsl:attribute name="readonly">readonly</xsl:attribute>
														<xsl:attribute name="class">td_noteditable</xsl:attribute>
													</xsl:if>
						                       </input>
						                    </td>   					
										</tr>
										<tr>
											<td class="fc"><xsl:value-of select="document/captions/count/@caption"/> :</td>
									        <td>
						                       <input type="text" name="count" id="count" class="td_editable" value="{document/fields/count}" style="width:80px" onkeypress="javascript:Numeric(this)">
						                      		<xsl:if test="$editmode != 'edit'">
														<xsl:attribute name="readonly">readonly</xsl:attribute>
														<xsl:attribute name="class">td_noteditable</xsl:attribute>
													</xsl:if>
						                       </input>
						                    </td>   					
										</tr>
										
									</table>		
								</div>   
								<input type="hidden" name="type" value="save"/>
								<input type="hidden" name="id" value="outputproduction"/>		
								<input type="hidden" name="key" value="{document/@docid}"/> 
						    </form>
					    </div>
					</div>
		  			<div style="height:10px"/>
			 	</div>
			 </div>
		     <xsl:call-template name="formoutline"/>	
		</body>	
	</html>
</xsl:template>
</xsl:stylesheet>