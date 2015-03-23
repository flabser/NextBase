<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../templates/form.xsl"/>
	<xsl:import href="../templates/sharedactions.xsl"/>
	<xsl:variable name="doctype" select="request/document/captions/doctypemultilang/@caption"/>
	<xsl:variable name="path" select="/request/@skin"/>
	<xsl:variable name="threaddocid" select="document/@granddocid"/>
	<xsl:variable name="editmode" select="/request/document/@editmode"/>
	<xsl:output method="html" encoding="utf-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" indent="yes"/>
	<xsl:variable name="skin" select="request/@skin"/>
	<xsl:template match="/request">
	<html>
		<head>
			<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
			<title>
				<xsl:if test="document/@status != 'new'">
					<xsl:value-of select="document/@viewtext"/> - Web Technical Supervision
				</xsl:if>
				<xsl:if test="document/@status = 'new'">
					Новое &#xA0;<xsl:value-of select="lower-case($doctype)" />  - Web Technical Supervision
				</xsl:if>
			</title>
			<xsl:call-template name="cssandjs"/>
   			<xsl:call-template name="markisread"/>
   			<script>
				$(function() {
					$('#regdate').datepicker({
						showOn: 'button',
						buttonImage: '/SharedResources/img/iconset/calendar.png',
						buttonImageOnly: true,
						regional:['ru'],
						showAnim: ''
					});
				});
			</script>
			<xsl:call-template name="htmlareaeditor"/>
		</head>
		<body>
			<div id="docwrapper">
				<xsl:call-template name="documentheader"/>	
				<div class="formwrapper">
					<div class="formtitle">
						<!-- заголовок -->					
						<div class="title" style="float:left">
							<xsl:call-template name="doctitleprj"/>	
						</div>
					</div>	
					<div class="button_panel">
						<span style="vertical-align:12px; float:left">
							<xsl:call-template name="showxml"/>
					<!-- кнопка "сохранить как черновик" -->	
							<xsl:if test="document/actions/action [.='SAVE_AS_DRAFT']/@enable = 'true'">
								<button >
									<xsl:attribute name="onclick">javascript:savePrjAsDraft('<xsl:value-of select="substring-after(history/entry[@type eq 'view'][last()],'/Avanti/')"/>')</xsl:attribute>
									<span>
										<img src="/SharedResources/img/classic/icons/disk.png" class="button_img"/>
										<font style="font-size:12px; vertical-align:top"><xsl:value-of select="document/actions/action [.='SAVE_AS_DRAFT']/@caption"/></font>
									</span>
								</button>
							</xsl:if>
						<!-- кнопка "отправить на подпись" -->
							<xsl:if test="document/actions/action [.='SEND']/@enable = 'true'">
								<button class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" title="Отправить ответственному участка на согласование" style="margin-left:5px">
									<xsl:attribute name="onclick">javascript:saveAndSend('<xsl:value-of select="substring-after(history/entry[@type eq 'view'][last()],'/Avanti/')"/>')</xsl:attribute>
									<span>
										<img src="/SharedResources/img/classic/icons/page_white_go.png" class="button_img"/>
										<font style="font-size:12px; vertical-align:top">Отправить ответственному участка</font>
									</span>
								</button>
							</xsl:if>
								<!-- кнопка "подписать" -->	
							<xsl:if test="document/actions/action [.='SIGN_YES']/@enable = 'true'">
								<button class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" style="margin-left:5px">
									<xsl:attribute name="onclick">javascript:decision('yes','<xsl:value-of select="document/@docid" />','sign_yes','<xsl:value-of select="substring-after(history/entry[@type eq 'view'][last()],'/Avanti/')"/>')</xsl:attribute>
									<span>
										<img src="/SharedResources/img/classic/icons/tick.png" class="button_img"/>
										<font style="font-size:12px; vertical-align:top"><xsl:value-of select="document/actions/action [.='SIGN_YES']/@caption"/></font>
									</span>
								</button>
							</xsl:if>
								<!-- кнопка "отклонить" -->
							<xsl:if test="document/actions/action [.='SIGN_NO']/@enable = 'true'">
								<button class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" style="margin-left:5px">
									<xsl:attribute name="onclick">javascript:decision('no','<xsl:value-of select="document/@docid" />','sign_no','<xsl:value-of select="substring-after(history/entry[@type eq 'view'][last()],'/Avanti/')"/>')</xsl:attribute>
									<span>
										<img src="/SharedResources/img/classic/icons/delete.png" class="button_img"/>
										<font style="font-size:12px; vertical-align:top"><xsl:value-of select="document/actions/action [.='SIGN_NO']/@caption"/></font>
									</span>
								</button>
							</xsl:if>
								<!-- кнопка "согласен" -->
							<xsl:if test="document/actions/action [.='COORD_YES']/@enable = 'true'">
								<button class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" style="margin-left:5px">
									<xsl:attribute name="onclick">javascript:decision('yes','<xsl:value-of select="document/@docid" />','coord_yes','<xsl:value-of select="substring-after(history/entry[@type eq 'view'][last()],'/Avanti/')"/>')</xsl:attribute>
									<span>
										<img src="/SharedResources/img/classic/icons/accept.png" class="button_img"/>
										<font style="font-size:12px; vertical-align:top"><xsl:value-of select="document/actions/action [.='COORD_YES']/@caption"/></font>
									</span>
								</button>	
							</xsl:if>
								<!-- кнопка "не согласен" -->		
							<xsl:if test="document/actions/action [.='COORD_NO']/@enable = 'true'">
								<button class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" style="margin-left:5px">
									<xsl:attribute name="onclick">javascript:decision('no','<xsl:value-of select="document/@docid" />','coord_no','<xsl:value-of select="substring-after(history/entry[@type eq 'view'][last()],'/Avanti/')"/>')</xsl:attribute>
									<span>
										<img src="/SharedResources/img/classic/icons/cancel.png" class="button_img"/>
										<font style="font-size:12px; vertical-align:top"><xsl:value-of select="document/actions/action [.='COORD_NO']/@caption"/></font>
									</span>
								</button>	
							</xsl:if>
							<!-- кнопка "отметить исполнение" -->
							<xsl:if test="document/actions/action [.='COMPOSE_EXECUTION']/@enable = 'true'">
								<button class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" style="margin-left:5px">
									<xsl:attribute name="onclick">javascript:window.location.href="Provider?type=document&amp;id=ki&amp;key=&amp;parentdocid=<xsl:value-of select="document/@docid"/>&amp;parentdoctype=<xsl:value-of select="document/@doctype"/>&amp;page=null"</xsl:attribute>
									<span>
										<img src="/SharedResources/img/classic/icons/page_done.png" class="button_img"/>
										<font style="font-size:12px; vertical-align:top"><xsl:value-of select="document/actions/action [.='COMPOSE_EXECUTION']/@caption"/></font>
									</span>
								</button>
							</xsl:if>
							<xsl:if test="document/actions/action [.='COMPOSE_TASK']/@enable = 'true'">
								<button class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only"  style="margin-left:5px">
									<xsl:attribute name="onclick">javascript:window.location.href="Provider?type=document&amp;id=kr&amp;key=&amp;parentdocid=<xsl:value-of select="document/@docid"/>&amp;parentdoctype=<xsl:value-of select="document/@doctype"/>&amp;page=null"</xsl:attribute>
									<span>
										<img src="/SharedResources/img/classic/icons/page_done.png" class="button_img"/>
										<font style="font-size:12px; vertical-align:top"><xsl:value-of select="document/actions/action [.='COMPOSE_TASK']/@caption"/></font>
									</span>
								</button>
							</xsl:if>
							<xsl:call-template name="ECPsign"/>
							</span>
							<span style="float:right">
					        	<!-- кнопка "закрыть" -->
				    			<xsl:call-template name="cancel"/>
					    	</span>
						</div>				
						<div style="clear:both"/>
							<div id="forumWrapper" style="width:98%; margin:40px auto">
								<!-- <div id="headerTheme" style="color:	#555555; padding:12px; background:#E6E6E6; border:1px solid #D3D3D3;  border-radius: 5px 5px 0px 0px; height:20px; font-size: 15px; font-weight: 300; overflow: hidden; ">
									Сообщений в теме: 120 
								</div>
								<div id="msgWrapper" style="border:1px solid #DDE5ED; min-height:220px">
									<div id="msgEntry">
										<div id="headermsg" style="height:20px; background: #D5DBE0; padding:7px 0px; border-bottom:1px solid #d3d3d3 ">
											<div style="width:300px; font-size:15px; color:#222;  font-weight: 300; height:25px; padding-left:12px; float:left">Бурляй Евгений Владимирович</div>
											<div style=" font-size:12px; color:#393939;  height:25px; padding-left:12px; padding-top:3px ">отправлено: 25.05.2012 , 18:40 </div>
										</div>
										<div id="bodymsg" style="padding:15px 20px; color: #000000; font: 13px tahoma,arial,verdana,sans-serif; min-height:130px">
											jQuery — библиотека JavaScript, фокусирующаяся на взаимодействии JavaScript и HTML. Библиотека jQuery помогает легко получать доступ к любому элементу DOM, обращаться к атрибутам и содержимому элементов DOM, манипулировать ими. Также библиотека jQuery предоставляет удобный API по работе с Ajax.
										</div>
										<div id="buttonpanemsg" style="background:#E9EFF3; height:35px; width:100%;">
										</div>
									</div>
								</div>
								<div id="msgWrapper" style="border:1px solid #DDE5ED; min-height:220px">
									<div id="msgEntry">
										<div id="headermsg" style="height:20px; background: #D5DBE0; padding:7px 0px; border-bottom:1px solid #d3d3d3 ">
											<div style="width:300px; font-size:15px; color:#222;  font-weight: 300; height:25px; padding-left:12px; float:left">Иванов Иван </div>
											<div style=" font-size:12px; color:#393939;  height:25px; padding-left:12px; padding-top:3px ">отправлено: 25.05.2012 , 18:40 </div>
										</div>
										<div id="bodymsg" style="padding:15px 20px; color: #000000; font: 13px tahoma,arial,verdana,sans-serif; min-height:130px">
											HTML (от англ. HyperText Markup Language — «язык разметки гипертекста») — стандартный язык разметки документов во Всемирной паутине. Большинство веб-страниц создаются при помощи языка HTML (или XHTML). Язык HTML интерпретируется браузерами и отображается в виде документа, в удобной для человека форме.
											HTML является приложением («частным случаем») SGML (стандартного обобщённого языка разметки) и соответствует международному стандарту ISO 8879. XHTML же является приложением XML.
										</div>
										<div id="buttonpanemsg" style="background:#E9EFF3; height:35px; width:100%;">
										</div>
									</div>
								</div> -->
								<form action="Provider" name="frm" method="post" id="frm" enctype="application/x-www-form-urlencoded">
									<br/>
									<table width="100%" border="0">
											<tr>
												<td class="fc" style="padding-top:5px">
													Тема комментария :
												</td>
												<td style="padding-top:5px">
													<input type="text" name="theme"  value="{document/fields/theme}"  class="td_editable" style="width:200px; vertical-align:top">
														<xsl:if test="$editmode != 'edit'">
															<xsl:attribute name="class">td_noteditable</xsl:attribute>
														</xsl:if>
													</input>
												</td>
											</tr>
											<tr>
												<td class="fc" style="padding-top:5px">
													Дата регистрации :
												</td>
												<td style="padding-top:5px">
													<input type="text" name="regdate"  value="{document/fields/regdate}"  class="td_editable" style="width:80px; vertical-align:top">
														<xsl:if test="$editmode = 'edit'">
															<xsl:attribute name="id">regdate</xsl:attribute>
														</xsl:if>
														<xsl:if test="$editmode != 'edit'">
															<xsl:attribute name="class">td_noteditable</xsl:attribute>
														</xsl:if>
													</input>
												</td>
											</tr>
											
											<tr>
												<td class="fc" style="padding-top:5px">
													Доступен всем :
												</td>
												<td style="padding-top:5px">
													<input type="checkbox" name="flag"  value="1">
														<xsl:if test="document/fields/flag = '1'">
															<xsl:attribute name="selected">selected</xsl:attribute>
														</xsl:if>
													</input> 
												</td>
											</tr>
											<!-- <tr>
												<td class="fc" style="padding-top:5px">
													Статус :
												</td>
												<td style="padding-top:5px">
													<input type="text" name="status"  value="{document/fields/status}"  class="td_editable" style="width:120px; vertical-align:top">
														<xsl:if test="$editmode != 'edit'">
															<xsl:attribute name="class">td_noteditable</xsl:attribute>
														</xsl:if>
													</input>
												</td>
											</tr>
											<tr>
												<td class="fc" style="padding-top:5px">
													Индекс цитирования :
												</td>
												<td style="padding-top:5px">
													<input type="text" name="index"  value="{document/fields/index}"  class="td_editable" style="width:80px; vertical-align:top">
														<xsl:if test="$editmode != 'edit'">
															<xsl:attribute name="class">td_noteditable</xsl:attribute>
														</xsl:if>
													</input>
												</td>
											</tr> -->
											<tr>
													<td class="fc">
														Новый комментарий :
													</td>
													<td>
														<xsl:if test="$editmode != 'edit'">
															<div id="htmlcodenoteditable" class="textarea_noteditable" style="width:754px; height:426px">
															</div>
															<script>
																$("#htmlcodenoteditable").html('<xsl:value-of select="document/fields/contentsource"/>');
															</script>
														</xsl:if>
														<xsl:if test="$editmode = 'edit'">
															<textarea id="txtDefaultHtmlArea" name="contentsource" cols="93" rows="25">
																<xsl:attribute name="onfocus">javascript: $(this).blur()</xsl:attribute>
																<xsl:attribute name="class">textarea_noteditable</xsl:attribute>
																<xsl:value-of select="document/fields/contentsource"/>
															</textarea>
														<script>
															if($(window).width() >1200){
																$("#txtDefaultHtmlArea").width("670px");
																$("#txtDefaultHtmlArea").height("300px");
															}else{
																$("#txtDefaultHtmlArea").width("457px");
																$("#htmlcodenoteditable").width("457px");
																$("#txtDefaultHtmlArea").height("300px");
															}
														</script>
													</xsl:if>
												</td>
											</tr>
											<tr>
												<td class="fc">
												</td>
												<td>
													<button type="button" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" title="Отправить сообщение">
														<xsl:attribute name="onclick">javascript:SaveFormJquery('frm','frm','<xsl:value-of select="history/entry[@type eq 'outline'][last()]"/>')</xsl:attribute>
														<span>
															<font style="font-size:12px; vertical-align:top">Отправить сообщение</font>
														</span>
													</button>
												</td>
											</tr>
									</table>
									<br/>
									<!-- Скрытые поля -->					
									<input type="hidden" name="type" value="save"/>  
									<input type="hidden" name="id" value="discussion"/>
									<input type="hidden" name="key" value="{document/@docid}"/>
									<input type="hidden" name="topicdate" value="{document/fields/topicdate}"/>
									<input type="hidden" name="parentdocid" value="{document/@parentdocid}"/>
									<input type="hidden" name="parentdoctype" value="{document/@parentdoctype}"/>
									<input type="hidden" name="coordstatus" id="coordstatus" value="{document/fields/coordstatus}"/>
									<input type="hidden" name="docversion" id="docversion" value="{document/fields/docversion}"/>
									<input type="hidden" name="action" id="action"/> 
									<xsl:call-template name="ECPsignFields"/> 				
								</form>
							</div>
						<div style="height:10px"/>
					</div>
				</div>
				<xsl:call-template name="outline_form"/>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>