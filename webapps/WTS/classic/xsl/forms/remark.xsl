<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../templates/form.xsl"/>
	<xsl:import href="../templates/sharedactions.xsl"/>
	<xsl:variable name="doctype" select="request/document/captions/doctypemultilang/@caption"/>
	<xsl:variable name="editmode" select="/request/document/@editmode"/>
	<xsl:output method="html" encoding="utf-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" indent="no"/>
	<xsl:variable name="skin" select="request/@skin"/>
	<xsl:template match="/request">
	<html>
		<head>
			<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
			<title>
				<xsl:if test="document/@status != 'new'">
					<xsl:value-of select="document/@viewtext"/> -  Web Technical Supervision
				</xsl:if>
				<xsl:if test="document/@status = 'new'">
					<xsl:value-of select="document/captions/new/@caption"/>&#xA0;<xsl:value-of select="lower-case($doctype)" />  - Web Technical Supervision
				</xsl:if>
			</title>
			<xsl:call-template name="cssandjs"/>
   			<xsl:call-template name="markisread"/>
   			<link rel="stylesheet" media="print" href="classic/css/print.css"/>
   			<script type="text/javascript">
   				$(document).ready(function(){
					$("#contractor , #amountdamage").tipTip({'activation':'click',"field":"contractor","defaultPosition":"right"});
					SuggestionContractor()
					hotkeysnav()  
					<xsl:if test="document/@topicid != 0 and document/@topicid != 'null'">
						topicid=<xsl:value-of select='document/@topicid'/>
						$.ajax({
							url: 'Provider?type=forum&amp;id=topic&amp;key=<xsl:value-of select='document/@topicid'/>&amp;onlyxml',
							datatype:'xml',
							async:'true',
							success: function(data) {
								$("#headerTheme").append('<font>'+ $(data).find("document").find("fields").find("theme").text()+"</font>")
								$("#infoTheme").append('<font>Автор: '+ $(data).find("document").find("fields").find("author").text()+', '+  $(data).find("document").find("fields").find("topicdate").text()+"</font>")
							}
						});
						$.ajax({
							url: 'Provider?type=view&amp;id=forum_thread&amp;parentdocid=<xsl:value-of select='document/@topicid'/>&amp;parentdoctype=904&amp;command=expand`<xsl:value-of select='document/@topicid'/>`904&amp;onlyxml',
							datatype:'xml',
							async:'true',
							success: function(data){
								$("#CountMsgTheme").append("Комментариев в теме: " + $(data).find("query").attr("count"))
								$(data).find("query").find("entry").each(function(index, element){
									comid =$(this).attr("docid");
									k= index
									level = parseInt($(this).attr("level"))-1
									if (level == 0 &amp;&amp; index != 0){
										$("#msgWrapper").append('<div class="msgEntry" style="margin-top:10px" level ="'+ level + '" id="msgEntry'+ index +'"/>')
									}else{
										$("#msgWrapper").append('<div class="msgEntry" level ="'+ level + '" id="msgEntry'+ index +'"/>')
									}
									$("#msgEntry"+index).append('<div class="headermsg"  id="headermsg'+ index +'"/>')
									 
									level = level *4;
									level =level + "em"
									$("#msgEntry"+index).css("margin-left", level);
									$("#headermsg"+index).append('<div class="authormsg">'+$(this).children("author").text()+'</div>')
									$("#headermsg"+index).append('<div class="msgdate">отправлено:'+$(this).children("viewcontent").children("viewdate").text()+'</div>')
									$("#msgEntry"+index).append('<div class="bodymsg" id="bodymsg'+ index +'">'+$(this).children("viewcontent").children("viewtext1").text()+'</div>')
									$("#msgEntry"+index).append('<div class="buttonpanemsg" id="buttonpanemsg'+ index +'"><button type="button" onclick="javascript:addCommentToForum(this,'+ $(this).attr('docid')+',905,true)" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only commenttocomment" style="float:right; margin-top:3px"><font style="font-size:12px; vertical-align:top" >Комментировать</font></button></div>')
								});
								$(".commenttocomment").button()
							}
						});
					</xsl:if> 
   				})
   				<![CDATA[
						function hotkeysnav() {
							$("#canceldoc").hotnav({keysource:function(e){ return "b"; }});
							$("#btncoordyes").hotnav({keysource:function(e){ return "y"; }});
							$("#btncoordno").hotnav({keysource:function(e){ return "n"; }});
							$("#btngrantaccess").hotnav({keysource:function(e){ return "g"; }});
							$("#btnsavedraft").hotnav({keysource:function(e){ return "s"; }});
							$("#btntocoordinate").hotnav({keysource:function(e){ return "t"; }});
							$("#btnexecution").hotnav({keysource:function(e){ return "e"; }});
							$("#btnsign").hotnav({keysource:function(e){ return "y"; }});
							$("#btnsignno").hotnav({keysource:function(e){ return "n"; }});
							$("#currentuser").hotnav({ keysource:function(e){ return "u"; }});
							$("#logout").hotnav({keysource:function(e){ return "q"; }});
							$("#helpbtn").hotnav({keysource:function(e){ return "h"; }});
							$(document).bind('keydown', function(e){
			 					if (e.ctrlKey) {
			 						switch (e.keyCode) {
									   case 66:
									   		<!-- клавиша b -->
									    	e.preventDefault();
									     	$("#canceldoc").click();
									      	break;
									   case 69:
									   		<!-- клавиша e -->
									     	e.preventDefault();
									     	$("#btnexecution").click();
									      	break;
									   case 71:
									  		<!-- клавиша g -->
									     	e.preventDefault();
									     	$("#btngrantaccess").click();
									      	break;
									   case 78:
									  		<!-- клавиша n -->
									    	e.preventDefault();
									    	$("#btnsignno").click();
									    	$("#btncoordno").click();
									      	break;
									   case 83:
									   		<!-- клавиша s -->
									     	e.preventDefault();
									     	$("#btnsavedraft").click();
									      	break;
									   case 84:
									   		<!-- клавиша t -->
									     	e.preventDefault();
									     	$("#btntocoordinate").click();
									      	break;
									   case 89:
									   		<!-- клавиша y -->
									     	e.preventDefault();
									     	$("#btnsign").click();
									     	$("#btncoordyes").click();
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
						}
					]]>
				
		</script>
		<xsl:if test="document/@editmode = 'edit'">
			<script>
				$(function() {
					$('#ctrldate').datepicker({
						showOn: 'button',
						buttonImage: '/SharedResources/img/iconset/calendar.png',
						buttonImageOnly: true,
						regional:['ru'],
						showAnim: '',
						onSelect: function( selectedDate ) {
							instance = $( this ).data( "datepicker" );
							var m = 60 * 1000; 
							var h = m * 60 ; 
							var d = h * 24 ; 
							t=new Date(selectedDate.split(".")[2],selectedDate.split(".")[1] - 1,selectedDate.split(".")[0]).getTime() - new Date().getTime()
							diff= (Math.floor(t/d)+1);
							$("[name=dbd]").val(diff)
						}
					});
				});
			</script>
		</xsl:if>
		<xsl:call-template name="htmlareaeditor"/>
	</head>
	<body>
		<xsl:attribute name="onbeforeprint">javascript:$("#htmlcodenoteditable").html($("#txtDefaultHtmlArea").val())</xsl:attribute>
		<div id="docwrapper">
			<xsl:call-template name="documentheader"/>	
				<div class="formwrapper">
					<div class="formtitle">
						<!-- заголовок -->					
						<div class="title" style="float:left">
							<xsl:call-template name="doctitleprj"/><span id="whichreadblock" style="display:none ;width:120px; font-size:12px; margin-left:15px; background:	#FFA500; padding:5px 10px; vertical-align:5px; border-radius:5px ; color:#ffffff">Прочтен</span>
						</div>
					</div>	
					<div class="button_panel">
						<span style="vertical-align:12px; float:left">
							<xsl:call-template name="showxml"/>
							<!-- кнопка "сохранить как черновик" -->	
							<xsl:if test="document/actions/action [.='SAVE_AS_DRAFT']/@enable = 'true'">
								<button title="{document/actions/action [.='SAVE_AS_DRAFT']/@hint}" id="btnsavedraft">
									<xsl:attribute name="onclick">javascript:savePrjAsDraft('<xsl:value-of select="history/entry[@type eq 'view'][last()]"/>')</xsl:attribute>
									<span>
										<img src="/SharedResources/img/classic/icons/disk.png" class="button_img"/>
										<font style="font-size:12px; vertical-align:top"><xsl:value-of select="document/actions/action [.='SAVE_AS_DRAFT']/@caption"/></font>
									</span>
								</button>
							</xsl:if>
							<!-- кнопка "подписать" -->	
							<xsl:if test="document/actions/action [.='SIGN_YES']/@enable = 'true'" >
								<button class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" id="btnsign" style="margin-left:5px" title="{document/captions/prinyatvrabotucaption/@caption}">
									<xsl:attribute name="onclick">javascript:decision('yes','<xsl:value-of select="document/@docid" />','sign_yes','<xsl:value-of select="history/entry[@type eq 'view'][last()]"/>')</xsl:attribute>
									<span>
										<img src="/SharedResources/img/classic/icons/tick.png" class="button_img"/>
										<font style="font-size:12px; vertical-align:top"><xsl:value-of select="document/captions/podtverditcaption/@caption"/></font>
									</span>
								</button>
							</xsl:if>
							<!-- кнопка "отклонить" -->
							<xsl:if test="document/actions/action [.='SIGN_NO']/@enable = 'true'" >
								<button class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only"  id="btnsignno" style="margin-left:5px" title="Отклонить исполнение">
									<xsl:attribute name="onclick">javascript:decision('no','<xsl:value-of select="document/@docid" />','sign_no','<xsl:value-of select="history/entry[@type eq 'view'][last()]"/>')</xsl:attribute>
									<span>
										<img src="/SharedResources/img/classic/icons/delete.png" class="button_img"/>
										<font style="font-size:12px; vertical-align:top"><xsl:value-of select="document/captions/otklispcaption/@caption"/></font>
									</span>
								</button>
							</xsl:if>
							<!-- кнопка "согласен" -->
							<xsl:if test="document/actions/action [.='COORD_YES']/@enable = 'true'" >
								<button class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" id="btncoordyes" style="margin-left:5px" title="{document/captions/prinyatvrabotucaption/@caption}">
									<xsl:attribute name="onclick">javascript:decision('yes','<xsl:value-of select="document/@docid" />','coord_yes','<xsl:value-of select="history/entry[@type eq 'view'][last()]"/>')</xsl:attribute>
									<span>
										<img src="/SharedResources/img/classic/icons/accept.png" class="button_img"/>
										<font style="font-size:12px; vertical-align:top"><xsl:value-of select="document/captions/prinyatvrabotucaption/@caption"/></font>
									</span>
								</button>	
							</xsl:if>
							<!-- кнопка "не согласен" -->		
							<xsl:if test="document/actions/action [.='COORD_NO']/@enable = 'true'">
								<button class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" id="btncoordno" style="margin-left:5px" title="{document/actions/action [.='COORD_NO']/@hint}">
									<xsl:attribute name="onclick">javascript:decision('no','<xsl:value-of select="document/@docid" />','coord_no','<xsl:value-of select="history/entry[@type eq 'view'][last()]"/>')</xsl:attribute>
									<span>
										<img src="/SharedResources/img/classic/icons/cancel.png" class="button_img"/>
										<font style="font-size:12px; vertical-align:top"><xsl:value-of select="document/actions/action [.='COORD_NO']/@caption"/></font>
									</span>
								</button>	
							</xsl:if>
							<!-- кнопка "отметить исполнение" -->
							<xsl:if test="document/actions/action [.='COMPOSE_EXECUTION']/@enable = 'true'">
								<button class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" id="btnexecution" style="margin-left:5px" title="{document/actions/action [.='COMPOSE_EXECUTION']/@hint}">
									<xsl:attribute name="onclick">javascript:window.location.href="Provider?type=edit&amp;element=document&amp;id=execution&amp;key=&amp;parentdocid=<xsl:value-of select="document/@docid"/>&amp;parentdoctype=<xsl:value-of select="document/@doctype"/>&amp;page=null"</xsl:attribute>
									<span>
										<img src="/SharedResources/img/classic/icons/page_done.png" class="button_img"/>
										<font style="font-size:12px; vertical-align:top"><xsl:value-of select="document/actions/action [.='COMPOSE_EXECUTION']/@caption"/></font>
									</span>
								</button>
							</xsl:if>
							<!-- кнопка "ознакомить" -->
							<xsl:if test="document/actions/action [.='GRANT_ACCESS']/@enable = 'true'">
								<button class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" id="btngrantaccess" style="margin-left:5px" title="{document/actions/action [.='GRANT_ACCESS']/@hint}">
									<xsl:attribute name="onclick">javascript:acquaint(<xsl:value-of select="document/@docid"/>,<xsl:value-of select="document/@doctype"/>)</xsl:attribute>
									<span>
										<img src="/SharedResources/img/classic/icons/page_white_get.png" class="button_img"/>
										<font style="font-size:12px; vertical-align:top"><xsl:value-of select="document/actions/action [.='GRANT_ACCESS']/@caption"/></font>
									</span>
								</button>
							</xsl:if>
							<!-- кнопка "отправить на согласование" -->
							<xsl:if test="document/actions/action [.='TO_COORDINATE']/@enable = 'true'">
								<button class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" id="btntocoordinate" style="margin-left:5px" title="Отправить ответственному участка">
									<xsl:attribute name="onclick">javascript:saveAndCoord('<xsl:value-of select="history/entry[@type eq 'view'][last()]"/>')</xsl:attribute>
									<span>
										<img src="/SharedResources/img/classic/icons/page_white_go.png" class="button_img"/>
										<font style="font-size:12px; vertical-align:top"><xsl:value-of select="document/captions/otpravitotvuchcaption/@caption"/></font>
									</span>
								</button>
							</xsl:if>
							<!-- <button class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" id="btntocoordinate" style="margin-left:5px" title="Распечатать документ">
									<xsl:attribute name="onclick">javascript:window.print()</xsl:attribute>
									<span>
										<img src="/SharedResources/img/classic/icons/printer.png" class="button_img"/>
										<font style="font-size:12px; vertical-align:top">Распечатать документ</font>
									</span>
							</button>
							<xsl:if test="document/@status !='new'">
								<button class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" id="btntocoordinate" style="margin-left:5px" title="Бланк предписания">
									<xsl:attribute name="onclick">javascript:window.location.href="Provider?type=edit&amp;element=project&amp;id=remarkblankpred&amp;key=<xsl:value-of select="document/@docid"/>&amp;page=1"</xsl:attribute>
									<span>
										<img src="/SharedResources/img/classic/icons/printer.png" class="button_img"/>
										<font style="font-size:12px; vertical-align:top">Бланк предписания</font>
									</span>
								</button>
							</xsl:if> -->
							<xsl:call-template name="ECPsign"/>
							</span>
							<span style="float:right">
					        	<!-- кнопка "закрыть" -->
				    			<xsl:call-template name="cancel"/>
					    	</span>
						</div>				
						<div style="clear:both"/>
						<div style="-moz-border-radius:0px;height:1px; width:100%; margin-top:10px;"/>
						<div style="clear:both"/>
						<div id="tabs">
							<ul class="ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-all">
								<li class="ui-state-default ui-corner-top">
									<a href="#tabs-1"><xsl:value-of select="document/captions/properties/@caption"/></a>
								</li> 
								<li class="ui-state-default ui-corner-top">
									<a href="#tabs-2"><xsl:value-of select="document/captions/files/@caption"/></a>
								</li>
								<li class="ui-state-default ui-corner-top">
									<a href="#tabs-3"><xsl:value-of select="document/captions/discussion/@caption"/></a>
								</li>
								<li class="ui-state-default ui-corner-top">
									<a href="#tabs-4"><xsl:value-of select="document/captions/print/@caption"/></a>
								</li>
								<li class="ui-state-default ui-corner-top">
									<a href="#tabs-5"><xsl:value-of select="document/captions/additional/@caption"/></a>
								</li>
								<li style="float:right; padding:0.5em 0.5em; position:absolute; right:0px; color:#000">
		                 			<div>
										<font style="font-size:11px; font-style: arial;">
											<xsl:value-of select="document/captions/statuscoord/@caption"/> :
										</font>
										<font style="font-size:11px; font-style: arial">
											<b> 
												<xsl:choose>
													<xsl:when test="document/fields/coordstatus='351'">
														<xsl:attribute name="title"><xsl:value-of select="document/captions/draftcaption/@caption"/></xsl:attribute>
														<xsl:value-of select="document/captions/draftcaption/@caption"/>
													</xsl:when>
													<xsl:when test="document/fields/coordstatus='352'">
														<xsl:attribute name="title"><xsl:value-of select="document/captions/nasoglasovaniiuitrcaption/@caption"/></xsl:attribute>
														<xsl:value-of select="document/captions/nasoglasovaniiuitrcaption/@caption"/>													
													</xsl:when>
													<xsl:when test="document/fields/coordstatus='353'">
														<xsl:attribute name="title"><xsl:value-of select="document/captions/soglasovancaption/@caption"/></xsl:attribute>
														<xsl:value-of select="document/captions/soglasovancaption/@caption"/>
													</xsl:when>
													<!-- Отклонен -->
													<xsl:when test="document/fields/coordstatus='354'">
														<xsl:attribute name="title"><xsl:value-of select="document/captions/otklonenitrcaption/@caption"/></xsl:attribute>
														<xsl:value-of select="document/captions/otklonencaption/@caption"/>
													</xsl:when>
													<!-- Новая версия -->
													<xsl:when test="document/fields/coordstatus='360'">
														<xsl:attribute name="title">Проект пересмотрен в новой редакции</xsl:attribute>
														<xsl:value-of select="document/captions/newversioncaption/@caption"/>
													</xsl:when>	
													<!-- На исполнении -->
													<xsl:when test="document/fields/coordstatus='361'">
														<xsl:attribute name="title"><xsl:value-of select="document/captions/naispolneniicaption/@caption"/></xsl:attribute>
														<xsl:value-of select="document/captions/naispolneniicaption/@caption"/>
													</xsl:when>	
													<!-- Исполнено -->
													<xsl:when test="document/fields/coordstatus='362'">
														<xsl:attribute name="title"><xsl:value-of select="document/captions/ispolnenocaption/@caption"/></xsl:attribute>
														<xsl:value-of select="document/captions/ispolnenocaption/@caption"/>
													</xsl:when>	
													<!-- Ревизия исполнения -->
													<xsl:when test="document/fields/coordstatus='355'">
														<xsl:attribute name="title"><xsl:value-of select="document/captions/revisionispolneniyacaption/@caption"/> &#xA0;<xsl:value-of select="signerdisplay"/></xsl:attribute>
														<xsl:value-of select="document/captions/revisionispolneniyacaption/@caption"/>
													</xsl:when>	
													<!-- Подписан   -->
													<xsl:when test="document/fields/coordstatus='356'">
														<xsl:attribute name="title"><xsl:value-of select="document/captions/podpisancaption/@caption"/> - <xsl:value-of select="document/fields/coordblocks/entry[status=366]/signers/entry[decision=341]/user"/></xsl:attribute>
														<xsl:value-of select="document/captions/podpisancaption/@caption"/>
													</xsl:when>	
													<!-- Подписан -->
													<xsl:when test="document/fields/coordstatus='357'">
														<xsl:attribute name="title"><xsl:value-of select="document/captions/podpisancaption/@caption"/> &#xA0;<xsl:value-of select="signerdisplay"/></xsl:attribute>
														<xsl:value-of select="document/captions/podpisancaption/@caption"/>
													</xsl:when>	
													<!-- Просрочен -->
													<xsl:when test="coordstatus='359'">
														<xsl:attribute name="title"><xsl:value-of select="document/captions/prosrochencaption/@caption"/></xsl:attribute>
														<xsl:value-of select="document/captions/prosrochencaption/@caption"/>
													</xsl:when>																										
												</xsl:choose>
											</b>
										</font>	
									</div>
								</li>
							</ul>
							<form action="Provider" name="frm" method="post" id="frm" enctype="application/x-www-form-urlencoded">
								<div class="ui-tabs-panel" id="tabs-1">
									<br/>
									<table width="100%" border="0">
										<tr>
											<td class="fc">
												<font style="vertical-align:top">
													<xsl:value-of select="document/captions/avtorcaption/@caption"/> : 
												</font>												
											</td>
											<td>
												<table id="authortbl" style="border-spacing:0px 3px;">
													<tr>
														<td class="td_noteditable" style="width:600px;">
															<xsl:value-of select="document/fields/author"/> - <xsl:value-of select="document/fields/position"/> &#xA0;
														</td>
													</tr>
												</table>
												<input type="hidden" name="author" value="{document/fields/author/@attrval}"/>
											</td>
										</tr>
										<tr>
											<td class="fc">
												<a style="vertical-align:top; margin-left:5px; text-decoration:none; color:#444444" class="actioncaption">
													<xsl:if test="$editmode = 'edit'">
														<xsl:attribute name="href">javascript:dialogBoxStructure('responsiblesection','false','responsible','frm', 'responsiblesectiontbl');</xsl:attribute>
													</xsl:if>
													<xsl:value-of select="document/captions/otvetstvennyicaption/@caption"/>
												</a>
												<font style="vertical-align:top"> : </font>
												<xsl:if test="$editmode = 'edit'">
													<a>
														<xsl:attribute name="href">javascript:dialogBoxStructure('responsiblesection','false','responsible','frm', 'responsiblesectiontbl');</xsl:attribute>
														<img src="/SharedResources/img/iconset/report_magnify.png"/>
													</a>
												</xsl:if>
											</td>
											<td>
												<xsl:if test="document/@status='new'">
													<table id="responsiblesectiontbl" style="border-spacing:0px 3px;">
														<tr>
															<td class="td_editable" style="width:600px;">
																<xsl:if test="$editmode != 'edit'">
																	<xsl:attribute name="class">td_noteditable</xsl:attribute>
																</xsl:if>
																<xsl:value-of select="document/fields/responsible"/>&#xA0;
															</td>
														</tr>
													</table>
												</xsl:if>
												<xsl:if test="document/@status != 'new'">
													<table id="responsiblesectiontbl" style="border-spacing:0px 3px;">
														<tr>
															<td class="td_editable" style="width:600px;">
																<xsl:if test="$editmode != 'edit'">
																	<xsl:attribute name="class">td_noteditable</xsl:attribute>
																</xsl:if>
																<xsl:value-of select="document/fields/responsible"/><xsl:if test="document/fields/respost !=''"> - <xsl:value-of select="document/fields/respost"/></xsl:if>&#xA0;
															</td>
														</tr>
													</table>
												</xsl:if>
												<input type="hidden" id="responsiblecaption" value="Ответственный участка"/>
												<script>
													if ($("#signertbl tr").length &lt; 1){
														$("#signertbl").append("<tr><td>&#xA0;</td></tr>");
					 								}
												</script>
											</td>
										</tr>
										<xsl:if test="document/fields/coordstatus !='351' and document/fields/coordstatus !='352' and document/fields/coordblocks/entry/coordinators/entry/comment != ''">	
											<tr>
												<td class="fc">
													<font style="vertical-align:top">
														<xsl:value-of select="document/captions/commentcaption/@caption"/> : 
													</font>												
												</td>
												<td>
													<table style="border-spacing:0px 3px;">
														<tr>
															<td class="td_noteditable" style="width:600px;">
																<xsl:value-of select="document/fields/coordblocks/entry/coordinators/entry/user"/> : <xsl:value-of select="document/fields/coordblocks/entry/coordinators/entry/comment"/>&#xA0;
															</td>
														</tr>
													</table>
												</td>
											</tr>
										</xsl:if>	
										<!-- поле "Проект" -->
										<xsl:if test="not(document/fields/project/@mode = 'hide')">
											<tr>
												<td class="fc" style="padding-top:5px"><xsl:value-of select="document/captions/svprojectcaption/@caption"/> :</td>
												<td style="padding-top:5px">
													<xsl:variable name="project" select="document/fields/project/@attrval"/>
													<select size="1" class="select_editable" name="project" id="project"  style="width:610px;" onchange="updateProjectExtra()">
														<xsl:if test="$editmode != 'edit'">
															<xsl:attribute name="disabled">true</xsl:attribute>
															<xsl:attribute name="class">select_noteditable</xsl:attribute>
															<option value="{document/fields/project/@attrval}">
																<xsl:attribute name="selected">selected</xsl:attribute>
																<xsl:value-of select="document/fields/project"/>
															</option>
														</xsl:if>
														<xsl:if test="$editmode = 'edit'">
															<option value=" ">
																<xsl:attribute name="selected">selected</xsl:attribute>
																&#xA0;
															</option>
														</xsl:if>
														<xsl:for-each select="document/glossaries/projectsprav/query/entry">
															<option value="{@docid}">
																<xsl:if test="$project = @docid">
																	<xsl:attribute name="selected">selected</xsl:attribute>
																</xsl:if>
																<xsl:value-of select="viewcontent/viewtext1"/>
															</option>
														</xsl:for-each>
													</select>
													<a href="" class="projectCaption" id="projectCaption" title="Отобразить подробности места возникновения замечания" style="margin-left:5px; border-bottom:1px dotted; text-decoration:none; color:#1A3DC1;">
														<xsl:attribute name="href">javascript:openProjectExtra()</xsl:attribute>подробнее
													</a>															
												</td>
											</tr>
										</xsl:if>
									</table>
									<div id="projectextra" style="display:none; padding-top:10px; padding-bottom:10px;">
										<table id="projectextratable">
									    	<tr>
									       		<td width="30%" class="fc"><xsl:value-of select="document/captions/rukprojcaption/@caption"/> :</td>
												<td>
													<input type="text" id="rukproj"  size="10" class="td_noteditable" style="width:300px">
														<xsl:attribute name="readonly">readonly</xsl:attribute>
													</input>
												</td>
											</tr>
										   	<tr>
										   		<td width="30%" class="fc"><xsl:value-of select="document/captions/zamrukprojcaption/@caption"/>  :</td>
												<td>
													<input type="text" id="zamrukproj" size="10" class="td_noteditable" style="width:300px">
														<xsl:attribute name="readonly">readonly</xsl:attribute>
													</input>
												</td>
											</tr>
										</table>
									</div>
								<table>
								<!-- Контрагент -->
									<tr>
										<td class="fc" style="padding-top:5px"><xsl:value-of select="document/captions/contracaption/@caption"/> :</td>
										<td style="padding-top:5px">
											<input type="text" id="contractor" value="{document/fields/contragent}" title="Для поиска контрагента необходимо ввести минимум 4 символа" class="td_editable" style="width:600px; vertical-align:top" onblur="javascript:contractorFieldUpdate()">
												<xsl:if test="$editmode != 'edit'">
													<xsl:attribute name="class">td_noteditable</xsl:attribute>
												</xsl:if>
											</input>
											<input type="hidden" id="contractorid" name="contragent" value="{document/fields/contragent/@attrval}"/>
											<input type="hidden" id="contractorviewtext" value="{document/fields/contragent}"/>
										</td>
									</tr>
									<!-- поле "Срок исполнения" -->
									<tr>
										<td class="fc" style="padding-top:5px">
											<xsl:value-of select="document/captions/srokispcaption/@caption"/>  :
										</td>
										<td style="padding-top:5px">
											<input type="text" name="ctrldate" maxlength="10" value="{substring(document/fields/ctrldate,1,10)}" readonly="readonly" onfocus="javascript:$(this).blur()" class="td_editable" style="width:80px; vertical-align:top">
												<xsl:if test="$editmode = 'edit'">
													<xsl:attribute name="id">ctrldate</xsl:attribute>
												</xsl:if>
												<xsl:if test="$editmode != 'edit'">
													<xsl:attribute name="class">td_noteditable</xsl:attribute>
												</xsl:if>
											</input>
										</td>
									</tr>
									<!-- поле "Вид работ" -->
									<xsl:if test="not(document/fields/category/@mode = 'hide')">
										<tr>
											<td class="fc" style="padding-top:5px"><xsl:value-of select="document/captions/vidrabotcaption/@caption"/>  :</td>
											<td style="padding-top:5px">
												<xsl:variable name="category" select="document/fields/category/@attrval" />
												<xsl:variable name="parentcategory" select="document/fields/parentcategory"/>
												<select size="1" id="category" name="category" style="width:610px;" class="select_editable" onchange="javascript:addSubCatGloss(this); $('#subcategory').attr('style','width:610px')">
													<xsl:if test="$editmode != 'edit'">
														<xsl:attribute name="disabled">true</xsl:attribute>
														<xsl:attribute name="class">select_noteditable</xsl:attribute>
														<option value=" ">
															<xsl:attribute name="selected">selected</xsl:attribute>
															<xsl:value-of select="document/fields/category"/>
														</option>
													</xsl:if>
													<xsl:if test="$editmode = 'edit'">
														<option value=" ">
															<xsl:attribute name="selected">selected</xsl:attribute>&#xA0;
														</option>
															</xsl:if>
														<script>
															$(document).ready(function(){
																if ($("#category").val() != ' '){
																	$('#subcategory').attr('style','width:610px')
																	$.ajax({
																		url: 'Provider?type=query&amp;id=glossresponses&amp;parentdocid='+$("#category").val()+'&amp;parentdoctype=894',
																		datatype:'xml',
																		success: function(data) {
																			$("#subcategory option").remove();
																			$(data).find("entry[doctype=894]").each(function(index, element){
																				<![CDATA[ $("#subcategory").append("<option value='"+ $(element).attr("docid")+"'>"+ $(element).attr("viewtext") +"</option>")]]>
																			});
																			if ($("#subcategory > option").length == 0){
																				<![CDATA[$("#subcategory").append("<option value=''>Подвидов нет</option>")]]>
																			}
																			$("#subcategory > option[value=<xsl:value-of select='document/fields/subcategory/@attrval'/>]").attr("selected","selected")
																		}
																	});	
																}
															});
														</script>
														<!-- <xsl:if test="$parentcategory != ''">
															<xsl:attribute name="class">select_noteditable</xsl:attribute>
															<xsl:attribute name="disabled"/>
														</xsl:if> -->
														<xsl:for-each select="document/glossaries/docscat/query/entry">
															<option value="{@docid}" >
																<xsl:if test="$category = @docid">
																	<xsl:attribute name="selected">selected</xsl:attribute>
																</xsl:if>
																<xsl:if test="$parentcategory = @docid">
																	<xsl:attribute name="selected">selected</xsl:attribute>
																</xsl:if>
																<xsl:value-of select="viewcontent/viewtext1"/>
															</option>
														</xsl:for-each>
													</select>
												</td>
											</tr>
										</xsl:if>
										<!-- поле "Подвид работ" -->
										<xsl:if test="not(document/fields/category/@mode = 'hide')">
											<tr>
												<td class="fc" style="padding-top:5px"><xsl:value-of select="document/captions/podvidrabotcaption/@caption"/>  :</td>
												<td style="padding-top:5px">
													<xsl:variable name="subcategory" select="document/fields/subcategory/@attrval" />
													<xsl:variable name="parentcategory" select="document/fields/parentsubcategory"/>
													<select size="1" name="subcategory" id="subcategory" style="width:610px; " class="select_editable">
														<xsl:if test="document/fields/subcategory = '0' or not(document/fields/subcategory)">
															<xsl:attribute name="style">width:610px; font-style:italic; color:#555</xsl:attribute> 
														</xsl:if>
														<xsl:if test="$editmode != 'edit'">
															<xsl:attribute name="class">select_noteditable</xsl:attribute>
															<xsl:attribute name="disabled"/>
															<option value=" ">
																<xsl:attribute name="selected">selected</xsl:attribute>
																<xsl:value-of select="document/fields/subcategory"/>
															</option>
														</xsl:if>
														<xsl:if test="$editmode = 'edit'">
															<option value=" " style="font-style:italic; color:#bbb">
																<xsl:attribute name="selected">selected</xsl:attribute>
																<i>Выберите вид работ</i>
															</option>
														</xsl:if>
														<!-- <xsl:if test="$parentcategory != ''">
															<xsl:attribute name="class">select_noteditable</xsl:attribute>
															<xsl:attribute name="disabled"/>
														</xsl:if> -->
														<!-- <xsl:for-each select="document/glossaries/subcat/query/entry">
															<option value="{@docid}">
																<xsl:if test="$subcategory = @docid">
																	<xsl:attribute name="selected">selected</xsl:attribute>
																</xsl:if>
																<xsl:if test="$parentcategory = @docid">
																	<xsl:attribute name="selected">selected</xsl:attribute>
																</xsl:if>
																<xsl:value-of select="@viewtext"/>
															</option>
														</xsl:for-each> -->
													</select>
												</td>
											</tr>
										</xsl:if>
										<tr>
											<td class="fc" style="padding-top:5px">
												<xsl:value-of select="document/captions/summauscherba/@caption"/> :
											</td>
											<td style="padding-top:5px">
												<input type="text" id="amountdamage" name="amountdamage" value="{document/fields/amountdamage}" class="td_editable" style="width:600px; vertical-align:top" title="Поле может содержать только числовые значения">
													<xsl:if test="$editmode != 'edit'">
														<xsl:attribute name="class">td_noteditable</xsl:attribute>
													</xsl:if>
													<xsl:attribute name="onkeydown">javascript:numericfield(this)</xsl:attribute>
												</input>
											</td>
										</tr>
										<tr>
											<td class="fc" style="padding-top:5px">
												<xsl:value-of select="document/captions/mestovozcaption/@caption"/>	 :
											</td>
											<td style="padding-top:5px">
												<input type="text" name="origin" value="{document/fields/origin}"   class="td_editable" style="width:600px; vertical-align:top">
													<xsl:if test="$editmode != 'edit'">
														<xsl:attribute name="class">td_noteditable</xsl:attribute>
													</xsl:if>
												</input>
												<a href="" id="originplaceCaption" class="originplaceCaption" title="Отобразить подробности места возникновения замечания" style="margin-left:5px; border-bottom:1px dotted; text-decoration:none; color:#1A3DC1;">
													<xsl:attribute name="href">javascript:openOriginPlaceExtra()</xsl:attribute>подробнее
												</a>
											</td>
										</tr>
										<!-- поле "Место возникновения замечания" -->
										<!-- <tr>
											<td class="fc" style="padding-top:5px">
												Место возникновения :
											</td>
											<td style="padding-top:5px">
												<xsl:variable name="har" select="document/fields/origin/@attrval"/>
												<select name="origin" class="select_editable" style="width:611px; vertical-align:4px">
													<xsl:if test="$editmode != 'edit'">
														<xsl:attribute name="disabled">true</xsl:attribute>
														<xsl:attribute name="class">select_noteditable</xsl:attribute>
													</xsl:if>
													<xsl:for-each select="document/glossaries/originplace/query/entry">
														<option value="{@docid}">
															<xsl:if test="$har = @docid">
																	<xsl:attribute name="selected">selected</xsl:attribute>
																</xsl:if>
																<xsl:value-of select="@viewtext"/>
															</option>
														</xsl:for-each>
													</select>
													<a href="" class="doclink"  id="originplaceCaption" title="Отобразить подробности места возникновения замечания" style="margin-left:5px">
														<xsl:attribute name="href">javascript:openOriginPlaceExtra()</xsl:attribute>
														<font id="originplaceCaption">подробнее ...</font>
													</a>
												</td>
											</tr> -->
									</table>
									<div id="originplaceextra" style=" display:none; padding-top:10px; padding-bottom:10px;">
										<table>
											<tr>
									       		<td width="30%" class="fc"><xsl:value-of select="document/captions/cordinatycaption/@caption"/>  :</td>
												<td>
													<input type="text" name="coordinats" value="{document/fields/coordinats}" size="10" class="td_editable" style="width:250px">
														<xsl:if test="document/@editmode != 'edit'">
															<xsl:attribute name="readonly">readonly</xsl:attribute>
															<xsl:attribute name="class">td_noteditable</xsl:attribute>
														</xsl:if>
													</input>
												</td>
											</tr>
									    	<tr>
									       		<td width="30%" class="fc"><xsl:value-of select="document/captions/citycaption/@caption"/>  :</td>
												<td>
													<xsl:variable name="city" select="document/fields/city/@attrval"/>
													<select name="city" class="select_editable" style="width:611px;">
														<xsl:if test="$editmode != 'edit'">
															<xsl:attribute name="disabled">true</xsl:attribute>
															<xsl:attribute name="class">select_noteditable</xsl:attribute>
															<option value=" ">
																<xsl:attribute name="selected">selected</xsl:attribute>
																<xsl:value-of select="document/fields/city"/>
															</option>
														</xsl:if>
															<xsl:if test="$editmode = 'edit'">
																<option value=" ">
																	<xsl:attribute name="selected">selected</xsl:attribute>
																	&#xA0;
																</option>
															</xsl:if>
														<xsl:for-each select="document/glossaries/city/query/entry">
															<option value="{@docid}">
																<xsl:if test="$city = @docid">
																	<xsl:attribute name="selected">selected</xsl:attribute>
																</xsl:if>
																<xsl:value-of select="viewcontent/viewtext1"/>
															</option>
														</xsl:for-each>
													</select>
												</td>
											</tr>
									       <tr>
									       		<td width="30%" class="fc"><xsl:value-of select="document/captions/streetcaption/@caption"/>  :</td>
												<td>
													<input type="text" name="street" value="{document/fields/street}" size="10" class="td_editable" style="width:250px">
														<xsl:if test="document/@editmode != 'edit'">
															<xsl:attribute name="readonly">readonly</xsl:attribute>
															<xsl:attribute name="class">td_noteditable</xsl:attribute>
														</xsl:if>
													</input>
												</td>
											</tr>
									       <tr>
									       		<td width="30%" class="fc"><xsl:value-of select="document/captions/domcaption/@caption"/>  :</td>
												<td>
													<input type="text" name="house" value="{document/fields/house}" size="10" class="td_editable" style="width:50px">
														<xsl:if test="document/@editmode != 'edit'">
															<xsl:attribute name="readonly">readonly</xsl:attribute>
															<xsl:attribute name="class">td_noteditable</xsl:attribute>
														</xsl:if>
													</input>
												</td>
											</tr>
									       <tr>
									       		<td width="30%" class="fc"><xsl:value-of select="document/captions/podezdcaption/@caption"/>  :</td>
												<td>
													<input type="text" name="porch" value="{document/fields/porch}" size="10" class="td_editable" style="width:50px">
														<xsl:if test="document/@editmode != 'edit'">
															<xsl:attribute name="readonly">readonly</xsl:attribute>
															<xsl:attribute name="class">td_noteditable</xsl:attribute>
														</xsl:if>
														<xsl:attribute name="onkeydown">javascript:Numeric(this)</xsl:attribute>
													</input>
												</td>
											</tr>
									       <tr>
									       		<td width="30%" class="fc"><xsl:value-of select="document/captions/etazhcaption/@caption"/>  :</td>
												<td>
													<input type="text" name="floor" value="{document/fields/floor}" size="10" class="td_editable" style="width:50px">
														<xsl:if test="document/@editmode != 'edit'">
															<xsl:attribute name="readonly">readonly</xsl:attribute>
															<xsl:attribute name="class">td_noteditable</xsl:attribute>
														</xsl:if>
														<xsl:attribute name="onkeydown">javascript:Numeric(this)</xsl:attribute>
													</input>
												</td>
											</tr>
									       <tr>
									       		<td width="30%" class="fc"><xsl:value-of select="document/captions/kvartcaption/@caption"/>  :</td>
												<td>
													<input type="text" name="apartment" value="{document/fields/apartment}" size="10" class="td_editable" style="width:50px">
														<xsl:if test="document/@editmode != 'edit'">
															<xsl:attribute name="readonly">readonly</xsl:attribute>
															<xsl:attribute name="class">td_noteditable</xsl:attribute>
														</xsl:if>
														<xsl:attribute name="onkeydown">javascript:Numeric(this)</xsl:attribute>
													</input>
												</td>
											</tr>
											</table>
											</div>
											<table>
											<tr>
												<td class="fc">
													<xsl:value-of select="document/captions/opisaniecaption/@caption"/> :
												</td>
												<td>
														<div id="htmlcodenoteditable" class="textarea_noteditable" style="width:654px; height:426px; display:block">
<!-- 															<xsl:attribute name="onbeforeprint">$("#htmlcodenoteditable").html($(".jHtmlArea").html())</xsl:attribute> -->
															
															<xsl:if test="$editmode = 'edit'">
																<xsl:attribute name="style">width:654px; height:426px; display:none</xsl:attribute>
															</xsl:if>
														</div>
														<script>
															$("#htmlcodenoteditable").html('<xsl:value-of select="document/fields/contentsource"/>');
														</script>
													
														<xsl:if test="$editmode = 'edit'">
															<textarea id="txtDefaultHtmlArea" name="contentsource" cols="93" rows="25">
																<xsl:attribute name="onfocus">javascript: $(this).blur()</xsl:attribute>
																<xsl:attribute name="class">textarea_noteditable</xsl:attribute>
																<xsl:value-of select="document/fields/contentsource"/>
															</textarea>
															<script>
																if($(window).width() >1200){
																	$("#txtDefaultHtmlArea").width("610px");
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
												<xsl:if test="document/@status !='new'">
													<tr>
														<td class="fc">
															Отметки о  исполнении :
														</td>
														<td>
															<div display="block" style="display:block; width:90%" id="execution">
																<div style="width:100%; font-size:15px"/>
																<table id="executionTbl" style=" width:100%; table-layout: fixed"/>
																<script>
																	$.ajax({
																		url: 'Provider?type=view&amp;id=docthreadremark&amp;parentdocid=<xsl:value-of select="document/@docid"/>&amp;parentdoctype=<xsl:value-of select="document/@doctype"/>',
																		datatype:'html',
																		async:'true',
																		success: function(data) {
																			$("#executionTbl").append(data)
																			$("#executionTbl a").css("font-size","12px")
																			$("#executionTbl tr").css("width","600px")
																			$("#executionTbl tr").css("word-wrap","break-word")
																		}
																	});
																</script>
																<br/>
															</div>
														</td>
													</tr>
												</xsl:if>
											</table>
											<br/>
											<br/>
											<br/>
											<div style="font-size:11px; display:none" id="printmediasign">
												<span style="float:left"><font>Автор замечания: <br/><br/>  __________________________ </font></span>
												<span style="float:right"><font>Подрядчик:<br/><br/>  __________________________</font></span>
											</div>
										</div>
										<!-- Скрытые поля -->					
										<input type="hidden" id='responsible' name="responsible" value="{document/fields/responsible/@attrval}"/>
										<xsl:if test="document/@status != 'new'">
											<input type="hidden" name="coordBlock">
												<xsl:attribute name="value">1`par`0`<xsl:value-of select="document/fields/coordblocks/entry[@type=328]/coordinators/entry/user/@attrval"/>`<xsl:value-of select="document/fields/coordblocks/entry[@type=328]/status"/></xsl:attribute>
											</input>						
											<input type="hidden" name="coordBlock">
												<xsl:attribute name="value">1`tosign`0`<xsl:value-of select="document/fields/author/@attrval"/>`<xsl:value-of select="document/fields/coordblocks/entry[@type=327]/status"/></xsl:attribute>
											</input>
										</xsl:if>						
										<input type="hidden" name="type" value="save"/>  
										<input type="hidden" name="id" value="remark"/>
										<input type="hidden" name="key" value="{document/@docid}"/>
										<input type="hidden" name="projectdate" value="{document/fields/projectdate}"/>
										<input type="hidden" name="coordstatus" id="coordstatus" value="{document/fields/coordstatus}"/>
										<input type="hidden" name="docversion" id="docversion" value="{document/fields/docversion}"/>
										<xsl:if test="document/fields/respost !=''">
											<input type="hidden" name="respost" id="respost" value="{document/fields/respost}"/>
										</xsl:if>
										<input type="hidden" id="username" value="{@username}"/>
										<input type="hidden" name="action" id="action"/> 
										<input type="hidden" name="dbd" value="{document/fields/dbd}">
											<xsl:if test="document/@status = 'new'">
												<xsl:attribute name="value">15</xsl:attribute>
											</xsl:if>
										</input>
										<xsl:call-template name="ECPsignFields"/> 				
									</form>	
									<!-- Форма "Вложения" -->
									<table style="display:none" id="extraCoordTable"/>
									<table style="display:none" id="notesTable">
										<tr></tr>
									</table>
									<div id="tabs-2">
										<form action="Uploader" name="upload" id="upload" method="post" enctype="multipart/form-data">
											<input type="hidden" name="type" value="rtfcontent" />
											<input type="hidden" name="formsesid" value="{formsesid}"/>
											<!-- Секция "Вложения" -->
											<div display="block" id="att">
												<br/>	
												<xsl:call-template name="attach"/>
											</div>
										</form>
									</div>
									<div id="tabs-3">
										<xsl:call-template name="docdiscussion"/>
									</div>
									<div id="tabs-4" style="min-height:650px">
										<div id="containerEx5">
											<div id="preview-wrapper" >
												<xsl:if test="document/@status !='new'">
													<img src="classic/img/blankpred.png"  title="Распечатать бланк предписания">
														<xsl:attribute name="onclick">javascript:window.location.href="Provider?type=edit&amp;element=project&amp;id=remarkblankpred&amp;key=<xsl:value-of select="document/@docid"/>&amp;page=1"</xsl:attribute>
													</img>
												</xsl:if>
												<img src="classic/img/print.png" onclick="javascript:window.print()"  title="Распечатать документ"/>
											</div>
										</div>
									</div>
									<div id="tabs-5">
										<xsl:call-template name="docinfo"/>
									</div>
								</div>
								<div style="height:10px"/>
							</div>
						</div>
						<xsl:call-template name="outline_form"/>
					</body>
				</html>
	</xsl:template>
</xsl:stylesheet>