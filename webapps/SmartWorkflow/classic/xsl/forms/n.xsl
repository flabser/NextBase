<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../templates/form.xsl"/>
	<xsl:import href="../templates/sharedactions.xsl"/>
	<xsl:variable name="doctype" select="request/document/captions/name/@caption"/>
	<xsl:variable name="threaddocid" select="document/@docid"/>
	<xsl:variable name="editmode" select="/request/document/@editmode"/>
	<xsl:output method="html" encoding="utf-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" indent="yes"/>
	<xsl:variable name="skin" select="request/@skin"/>
	<xsl:template match="/request">
		<html>
			<head>
				<title>
					<xsl:value-of select="$doctype"/> - Workflow документооборот
				</title>
				<xsl:call-template name="cssandjs"/>
				<script type="text/javascript">
					$(document).ready(function(){
						hotkeysnav()  
					}
   				</script>
				<xsl:if test="/request/@lang = 'RUS'">
						<script>
						$(function() {
							$('#storagelife').datepicker({
								showOn: 'button',
								buttonImage: '/SharedResources/img/iconset/calendar.png',
								buttonImageOnly: true,
								buttonText: "Срок хранения",
								regional:['ru'],
								showAnim: '',
							});
						});
					</script>
				</xsl:if>
				<xsl:if test="/request/@lang = 'KAZ'">
					<script>
						$(function() {
							$('#storagelife').datepicker({
								showOn: 'button',
								buttonImage: '/SharedResources/img/iconset/calendar.png',
								buttonImageOnly: true,
								buttonText: "Сақтау мерзімі",
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
								$('#storagelife').datepicker({
									showOn: 'button',
									buttonImage: '/SharedResources/img/iconset/calendar.png',
									buttonImageOnly: true,
									buttonText: "Storage period",
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
								$('#storagelife').datepicker({
									showOn: 'button',
									buttonImage: '/SharedResources/img/iconset/calendar.png',
									buttonImageOnly: true,
									buttonText: "贮存寿命",
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
   				<script>
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
							$("#canceldoc").hotnav({keysource:function(e){ return "b"; }});
							$("#btnsavedoc").hotnav({keysource:function(e){ return "s"; }});
							$("#currentuser").hotnav({ keysource:function(e){ return "u"; }});
							$("#logout").hotnav({keysource:function(e){ return "q"; }});
							$("#helpbtn").hotnav({keysource:function(e){ return "h"; }});
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
									<xsl:attribute name="onclick">javascript:SaveFormJquery('frm','frm',&quot;<xsl:value-of select="history/entry[@type eq 'view'][last()]"/>&quot;)</xsl:attribute>
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
									<div display="block"  id="property">
										<br/>
										<table width="80%" border="0">
											<tr>
												<td width="30%" class="fc"><xsl:value-of select="document/captions/name/@caption"/> :</td>
									            <td>
					                                 <input type="text" name="name" value="{document/fields/name}" size="100" class="td_editable" style="width:600px">
					                                 	<xsl:if test="$editmode != 'edit'">
															<xsl:attribute name="readonly">readonly</xsl:attribute>
															<xsl:attribute name="class">td_noteditable</xsl:attribute>
														</xsl:if>
					                                 </input>
					                           </td>   					
										   </tr>
									       <tr>
												<td class="fc"><xsl:value-of select="document/captions/code/@caption"/> :</td>
												<td>
					                           		<input type="text" name="code" id="code" value="{document/fields/code}" size="10" class="td_editable" style="width:300px">
					                           			<xsl:if test="$editmode != 'edit'">
															<xsl:attribute name="readonly">readonly</xsl:attribute>
															<xsl:attribute name="class">td_noteditable</xsl:attribute>
														</xsl:if>
					                           	 		<xsl:attribute name="onkeydown">javascript:numericfield(this)</xsl:attribute>
					        	               		 </input>
					                   			</td> 
									       </tr>
									       <tr>
												<td class="fc"><xsl:value-of select="document/captions/rank/@caption"/> :</td>
												<td>
					                          		<input type="text" name="rank" value="{document/fields/rank}" size="10" class="td_editable" style="width:300px">
					                          			<xsl:if test="$editmode != 'edit'">
															<xsl:attribute name="readonly">readonly</xsl:attribute>
															<xsl:attribute name="class">td_noteditable</xsl:attribute>
														</xsl:if>
					                           		</input>
					                   			</td> 
									       </tr>
									       <tr>
												<td class="fc"><xsl:value-of select="document/captions/nomen/@caption"/> :</td>
												<td>
					                          		<input type="text" name="ndelo" value="{document/fields/ndelo}" size="10" class="td_editable" style="width:300px">
					                          			<xsl:if test="$editmode != 'edit'">
															<xsl:attribute name="readonly">readonly</xsl:attribute>
															<xsl:attribute name="class">td_noteditable</xsl:attribute>
														</xsl:if>
					                           		</input>
					                   			</td> 
									       </tr>
									       <tr>
											<td class="fc" style="padding-top:5px">
												<xsl:value-of select="document/captions/storagelife/@caption"/>&#160; :
											</td>
											<td style="padding-top:5px">
												<input type="text" value="{substring(document/fields/storagelife,1,10)}" id="storagelife" name="storagelife" readonly="readonly" onfocus="javascript:$(this).blur()" style="width:80px; vertical-align:top" class="td_editable">
													<xsl:if test="$editmode != 'edit'">
														<xsl:attribute name="class">td_noteditable</xsl:attribute>
													</xsl:if>
												</input>
											</td>
										</tr>
										</table>		
									</div>   
									<input type="hidden" name="type" value="save"/>
									<input type="hidden" name="id" value="n"/>		
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