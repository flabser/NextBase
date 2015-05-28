<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../templates/form.xsl"/>
	<xsl:import href="../templates/sharedactions.xsl"/>
	<xsl:variable name="doctype"/>
	<xsl:variable name="threaddocid" select="document/@docid"/>
	<xsl:output method="html" encoding="utf-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" indent="yes"/>
	<xsl:variable name="skin" select="request/@skin"/>
	<xsl:variable name="lang" select="request/@lang"/>
	<xsl:variable name="editmode" select="/request/document/@editmode"/>
	<xsl:variable name="status" select="/request/document/@status"/>
	<xsl:variable name="captions" select="/request/document/captions"/>	
	<xsl:variable name="fields" select="/request/document/fields"/>	
	<xsl:template match="/request">
		<html>		
			<head>	
				<title>
					<xsl:value-of select="concat('Projects - ', document/captions/title/@caption)"/>
				</title>

                <xsl:call-template name="cssandjs"/>
                <script type="text/javascript" src="/SharedResources/jquery/js/jquery-bar-rating-master/jquery.barrating.js" />
                <link type="text/css" rel="stylesheet" href="/SharedResources/jquery/js/jquery-bar-rating-master/examples/css/small.css" />

                <script type="text/javascript">
   					$(document).ready(function(){

						<xsl:if test="document/@topicid != 0 and document/@topicid != 'null'">
							topicid=<xsl:value-of select='document/@topicid'/>
							$.ajax({
								url: 'Provider?type=edit&amp;element=discussion&amp;id=topic&amp;key=<xsl:value-of select='document/@topicid'/>&amp;onlyxml',
								datatype:'xml',
								async:'true',
								success: function(data) {
									$("#headerTheme").append('<font>'+ $(data).find("document").find("theme").text()+"</font>")
									$("#infoTheme").append('<font>Автор: '+ $(data).find("document").find("author").text()+', '+  $(data).find("document").find("topicdate").text()+"</font>")
								}
							});
							$.ajax({
								url: 'Provider?type=view&amp;id=forum_thread&amp;parentdocid=<xsl:value-of select='document/@topicid'/>&amp;parentdoctype=904&amp;command=expand`<xsl:value-of select='document/@topicid'/>`904&amp;onlyxml',
								datatype:'xml',
								async:'true',
								success: function(data){
									$("#CountMsgTheme").append(comment_on_discussion+": " + $(data).find("query").attr("count"))
									$(data).find("query").find("entry").each(function(index, element){
										comid =$(this).attr("docid");
										k= index
										level = parseInt($(this).attr("level"))-1
										if (level == 0 &amp;&amp; index != 0){
											$("#msgWrapper").append('<div class="msgEntry" style="margin-top:10px" level="'+ level + '" id="msgEntry'+ index +'"/>')
										}else{
											$("#msgWrapper").append('<div class="msgEntry" level="'+ level + '" id="msgEntry'+ index +'"/>')
										}
										$("#msgEntry"+index).append('<div class="headermsg" id="headermsg'+ index +'"/>')
										 
										level = level *4;
										level =level + "em"
										$("#msgEntry"+index).css("margin-left", level);
										$("#headermsg"+index).append('<div class="authormsg">'+$(this).children("author").text()+'</div>')
										$("#headermsg"+index).append('<div class="msgdate">'+sent+':'+$(this).children("viewcontent").children("viewdate").text()+'</div>')
										$("#msgEntry"+index).append('<div class="bodymsg" id="bodymsg'+ index +'">'+$(this).children("viewcontent").children("viewtext").text()+'</div>')
										$("#msgEntry"+index).append('<div class="buttonpanemsg" id="buttonpanemsg'+ index +'"><button type="button" onclick="javascript:addCommentToForum(this,'+ $(this).attr('docid')+',905,true)" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only commenttocomment" style="float:right; margin-top:3px"><font style="font-size:12px; vertical-align:top" >'+makecomment+'</font></button></div>')
									});
									$(".commenttocomment").button()
								}
							});
						</xsl:if>
   					})
					var editmode = '<xsl:value-of select="$editmode"/>'
					function callChangeCtrlDate(){
						changeCtrlDate($("input#priority").val(), $("input#complication").val(),$("#startDate").val());
					}
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
				<!-- 	<xsl:if test="document/@status = 'new'">
						$(document).ready(function(){
							callChangeCtrlDate();
						})
					</xsl:if> -->
					<![CDATA[
						$(document).ready(function(){
							hotkeysnav() ; 
							//changeTime();
							$("#sliderP").slider({
								min: 1, 
								max: 20,
								step: 0.1,
								create:  function(event, ui){																	 	 
									editmode == 'edit' ? $("#sliderP").slider("enable",true) : $("#sliderP").slider("disable",true);
								 },
								value:  $("input#priority").val(),
								range: false,
								animate: true,
							    slide: function(event, ui){ 
							    	$("input#priority, input#pri_int").val(ui.value); 
									$("input#pri_int").attr("class", "level" + ui.value);
									callChangeCtrlDate();
									//changeTime();
							    },
							    stop: function(event, ui) {									    									 						 
									$("input#priority").val($("#sliderP").slider("values",0)); 
									$("input#pri_int").val(ui.value);
									$("input#pri_int").attr("class", "level" + $("#sliderP").slider("values",0));
									callChangeCtrlDate();
									//changeTime();
							    }
							});
							 								
							$("#sliderI").slider({
								min: 1, 
								max: 20,									
								step: 0.1,
								value: $("input#complication").val(),
								range: false,
								animate:true,
								create:  function(event, ui){																	 	 
									editmode == 'edit' ? $("#sliderI").slider("enable",true) : $("#sliderI").slider("disable",true);
								 },
								stop: function(event, ui) {											 						 
									$("input#complication").val(jQuery("#sliderI").slider("values",0)); 
									$("input#imp_int").val(ui.value);
									$("input#imp_int").attr("class", "level" + $("#sliderI").slider("values",0));
							    	//callChangeCtrlDate();
							    	//changeTime();
							    },
							    slide: function(event, ui){								    
							    	$("input#complication, input#imp_int").val(ui.value); 
									$("input#imp_int").attr("class", "level" + ui.value);
									//callChangeCtrlDate();
									//changeTime();
							    }
							});
						});
					]]>
						<xsl:if test="$editmode != 'edit' or $status != 'new'">		
							$(document).ready(function(){
								$("#sliderP, #sliderI").slider({disabled: true});
								$("#soon, #slowly, #easy, #difficult").parent("div").parent("td").remove();
							})
						</xsl:if>
						function moveUpP(){
					 		if (typeof v == 'undefined') {
								v =  parseInt($("input#priority").val());
							}
							if (v &lt;20){
							 	v+=2;
                                if(v &gt;=21)
                                    v=20
								$("#sliderP").slider({ value:v});
								$("input#pri_int, input#priority").val(v);
								$("input#pri_int").attr("class", "level" + v);
								callChangeCtrlDate();
							}
						}
						function moveDownP(){
						 	if (typeof v == 'undefined') {
								v =  parseInt($("input#priority").val());
							}
							if (v &gt;1){
							 	v-=2;

                                if(v&lt;=0)
                                    v=1;
								$("#sliderP").slider({ value:v});
								$("input#pri_int, input#priority").val(v);
								$("input#pri_int").attr("class", "level" + v);
								callChangeCtrlDate();
							}
						}
						function moveUpC(){
						 	if (typeof k == 'undefined') {
								k =  parseInt($("input#complication").val());
							}
							if (k &lt;20){
							 	k+=2;
								$("#sliderI").slider({ value:k});
								$("input#imp_int, input#complication").val(k);
								$("input#imp_int").attr("class", "level" + k);
								callChangeCtrlDate();
							}
						}
						function moveDownC(){
					 		if (typeof k == 'undefined') {
								k =  parseInt($("input#complication").val());
							}
							if (k &gt;1){
							 	k-=2;
								$("#sliderI").slider({ value:k});
								$("input#imp_int, input#complication").val(k);
								$("input#imp_int").attr("class", "level" + k);
								callChangeCtrlDate();
							}
						}
					</script>
					<xsl:if test="$editmode = 'edit' and $status = 'new'">
						<xsl:call-template name="htmlareaeditor"/>
					</xsl:if>
                    <xsl:call-template name="datepicker"/>
					<xsl:call-template name="markisread"/>
				</head>
				<body>
				<xsl:attribute name="onbeforeprint">javascript:$("#htmlcodenoteditable").html($("#txtDefaultHtmlArea").val())</xsl:attribute>
				<div id="docwrapper">
					<xsl:call-template name="documentheader"/>
					<div class="formwrapper">
						<div class="formtitle">
						   	<div class="title">
					   			<xsl:value-of select="$captions/title/@caption"/>
					   			<xsl:if test="$status != 'new'">
					   				<xsl:value-of select="concat(' № ', $fields/vn,' ', $captions/from/@caption, ' ', $fields/regDate)"/>
					   			</xsl:if>
							</div>
						</div>
						<!-- Сохранить и закрыть -->
						<div class="button_panel">
							<span style="float:left;">
								<xsl:call-template name="get_document_accesslist"/>							
								<xsl:call-template name="save"/>
								<xsl:if test="document/actionbar/action[@id = 'NEW_DOCUMENT']/@mode= 'ON'">
									<!-- Ответная заявка -->	
									 <button style="margin-right:5px; margin-bottom:5px" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" title="{document/actionbar/action[@id = 'NEW_DOCUMENT']/@hint}" id="newdemand">
										<xsl:attribute name="onclick">location.href='Provider?type=edit&amp;element=document&amp;id=demand&amp;docid=&amp;parentdocid=<xsl:value-of select="document/@docid"/>&amp;parentdoctype=<xsl:value-of select="document/@doctype"/>'</xsl:attribute>
										<span>
											<img src="/SharedResources/img/iconset/page_white_add.png" class="button_img"/>
											<font class="button_text">
												<xsl:value-of select="document/actionbar/action[@id = 'NEW_DOCUMENT']/@caption"/>
											</font>
										</span>
									</button>
								</xsl:if> 
								<xsl:if test="document/actionbar/action[@id = 'COMPOSE_EXECUTION']/@mode= 'ON'">
								<!--  Карточки Исп --> 							
									 <button style="margin-right:5px; margin-bottom:5px" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" title="{document/actionbar/action[@id = 'COMPOSE_EXECUTION']/@hint}" id="ki">
										<xsl:attribute name="onclick">location.href='Provider?type=edit&amp;element=document&amp;id=ki&amp;docid=&amp;parentdocid=<xsl:value-of select="document/@docid"/>&amp;parentdoctype=<xsl:value-of select="document/@doctype"/>'</xsl:attribute>
										<span>
											<img src="/SharedResources/img/iconset/tick.png" class="button_img"/>
											<font class="button_text"><xsl:value-of select="document/actionbar/action[@id = 'COMPOSE_EXECUTION']/@caption"/></font>
										</span>
									</button> 
								</xsl:if> 
								<xsl:if test="document/actionbar/action[.='CUSTOM_ACTION']/@id = 'RESET_CONTROL' and $fields/control/allcontrol != '0' and $fields/status !='notActual'">
								<!-- Контроль --> 							
									 <button style="margin-right:5px; margin-bottom:5px" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" title="{document/captions/resetControl/@caption}" id="resetcontrol">
										<xsl:attribute name="onclick">javascript:controlOff('<xsl:value-of select="document/@docid"/>')</xsl:attribute>
										<!-- <xsl:attribute name="onclick">javascript:changeCustomField("allcontrol","reset"); SaveFormJquery('frm','frm','<xsl:value-of select="history/entry[@type = 'page'][last()]"/>')</xsl:attribute> -->
										<!-- <xsl:attribute name="onclick">javascript:resetcontrol(<xsl:value-of select="document/@docid"/>, <xsl:value-of select="/request/document/@openfrompage"/>)</xsl:attribute> -->
										<span>
											<img src="/SharedResources/img/iconset/document_mark_as_final.png" class="button_img"/>
											<font class="button_text">
												<xsl:value-of select="$captions/resetControl/@caption"/>	
					 						</font>
										</span>
									</button> 
								</xsl:if>
								<xsl:if test="document/actionbar/action[@id = 'EDITCONTENT_DEMAND']/@mode='ON' and $fields/control/allcontrol = '1' and $fields/status !='notActual'">
									<button title="{document/actionbar/action[@id = 'EDITCONTENT_DEMAND']/@hint}" style="margin-right:5px; margin-bottom:5px" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only"  id="editcontent">
										<xsl:attribute name="onclick">javascript:changeBriefcontentDemand(<xsl:value-of select="document/@docid"/>, <xsl:value-of select="document/@doctype"/>)</xsl:attribute>
										<span>
											<img src="/SharedResources/img/iconset/page_white_edit.png" class="button_img"/>
											<font class="button_text">
												<xsl:value-of select="document/actionbar/action[@id = 'EDITCONTENT_DEMAND']/@caption"/>
											</font>
										</span>
									</button> 
								</xsl:if>
								<xsl:if test="document/actionbar/action[.='CUSTOM_ACTION']/@id = 'REVOKE_DEMAND' and $fields/status !='notActual' and $fields/control/allcontrol !='0'" >
									<!-- 	Отменить заявку --> 							
									 <button style="margin-right:5px; margin-bottom:5px" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" title="{$captions/revokeDemand/@caption}" id="revokedemand">
										<xsl:attribute name="onclick">javascript:revokeDemand(<xsl:value-of select="document/@docid"/>, <xsl:value-of select="document/@doctype"/>)</xsl:attribute>
										<span>
											<img src="/SharedResources/img/classic/icons/page_red.png" class="button_img"/>
											<font class="button_text">
												<xsl:value-of select="$captions/revokeDemand/@caption"/>	
											</font>
										</span>
									</button> 
								</xsl:if> 
								<!-- Продлить -->
								<xsl:if test="document/actionbar/action[.='CUSTOM_ACTION']/@id = 'EXTEND_DEMAND' and $fields/status !='notActual' and $fields/control/allcontrol !='0'">
									<!-- 	Продлить --> 							
									 <button style="margin-right:5px; margin-bottom:5px" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" title="{$captions/extend/@caption}" id="extend">
										<xsl:attribute name="onclick">javascript:extendDemand(<xsl:value-of select="document/@docid"/>, <xsl:value-of select="document/@doctype"/>)</xsl:attribute>
										<span>
											<img src="/SharedResources/img/classic/icons/date_next.png" class="button_img"/>
											<font class="button_text">
												<xsl:value-of select="$captions/extend/@caption"/>	
											</font>
										</span>
									</button> 
								</xsl:if> 
							</span>
							<!-- Закрыть -->
							<span style="float:right; padding-right:15px;">								
								<xsl:call-template name="cancel"/>
							</span>
	<!-- 						<xsl:if test="document/@status != 'new'">
								Ошибка
								<span style="float:left; padding-right:15px;">								
									 <button class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" title="{document/captions/newdemand/@caption}" >
										<xsl:attribute name="onclick">location.href='Provider?type=document&amp;id=error&amp;key=&amp;parentdocid=<xsl:value-of select="document/@docid"/>&amp;parentdoctype=<xsl:value-of select="document/@doctype" />'</xsl:attribute>
										<span>
											<img src="/SharedResources/img/iconset/sheduled_task.png" class="button_img"/>
											<font style="font-size:12px; vertical-align:top"><xsl:value-of select="document/captions/error/@caption"/></font>
										</span>
									</button>
								</span>
							</xsl:if>  -->
						</div>
						<div style="clear:both"/>
						<div style="-moz-border-radius:0px;height:1px; width:100%;"/>
						<div style="clear:both"/>
						<div id="tabs">
							<form action="Provider" name="frm" method="post" id="frm" enctype="application/x-www-form-urlencoded"> 
								<ul class="ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-all">
									<li class="ui-state-default ui-corner-top">
										<a href="#tabs-1">
											<xsl:value-of select="$captions/properties/@caption"/>
										</a>
									</li> 
									<li class="ui-state-default ui-corner-top">
										<a href="#tabs-2">
											<xsl:value-of select="$captions/progressexecution/@caption"/>
										</a>
									</li> 
									<li class="ui-state-default ui-corner-top">
										<a href="#tabs-3">
											<xsl:value-of select="$captions/discussion/@caption"/>
										</a>
									</li>
									<li class="ui-state-default ui-corner-top">
										<a href="#tabs-4">
											<xsl:value-of select="$captions/attachments/@caption"/>
										</a>
										<img id="loading_attach_img" style="vertical-align:-8px; margin-left:-10px; padding-right:3px; visibility:hidden" src="/SharedResources/img/classic/ajax-loader-small.gif"/>
									</li> 
									<li class="ui-state-default ui-corner-top">
										<a href="#tabs-5"><xsl:value-of select="$captions/additional/@caption"/></a>
									</li>
									<xsl:call-template name="docInfo"/>
								</ul>							
								<div class="ui-tabs-panel" id="tabs-1" >
								<div display="block" id="property" width="100%">									 
									<table width="100%" border="0" style="margin-top:8px; border-collapse:collapse" cellpadding="2">	
										<!-- Проект --> 
										<tr> 											
											<td class="fc">
												<font style="vertical-align:top"><xsl:value-of select="$captions/project/@caption"/> : 
													<xsl:if test="$editmode = 'edit'">
														<a class="picklist-button">
															<xsl:attribute name="title" select="concat($captions/project/@caption,'')"/>
															<xsl:attribute name="onclick">javascript:dialogBoxStructure('project-list','false','parentProject','frm', 'projecttbl');</xsl:attribute>								
															<img src="/SharedResources/img/classic/picklist.gif"/>
														</a>
													</xsl:if>
												</font>
											</td>
											<td>
												<table id="projecttbl" style="border-collapse:collapse">
													<tr>
														<td width="500px" class="td_editable">
															<xsl:if test="$editmode != 'edit'">
																<xsl:attribute name="class">td_noteditable</xsl:attribute>
															</xsl:if>
															<font id="parentProjectfont">
																<xsl:value-of select="$fields/parentProject"/>&#xA0;
															</font>
														</td>
														<td>
															<a href="{document/fields/parentProjectUrl}" id="projectURL" target="blank" style="text-decoration:underline !important; margin-left:3px">
																<xsl:if test="$fields/parentProjectUrl = '' or not($fields/parentProjectUrl)">
																	<xsl:attribute name="style">display:none</xsl:attribute>
																</xsl:if>
																<xsl:value-of select="$captions/go/@caption"/>
															</a>
														</td>
													</tr>
												</table> 
												<input type="hidden" id="projectname" name="projectname" value="{$fields/parentProject}"/>
												<input type="hidden" id="parentProjectcaption" value="{$captions/project/@caption}"/>												
												<input type="hidden" id="projectid" name="projectID" value="{$fields/projectID}"/>												
												<input type="hidden" id="projectdocid" name="projectDocID" value="{$fields/projectDocID}"/>												
												<input type="hidden" id="parentProject"  value="{$fields/projectDocID}"/>
											</td>
										</tr>	
										<!-- Веха -->
										<tr> 
											<td class="fc">
												<font style="vertical-align:top"><xsl:value-of select="$captions/milestone/@caption"/> : </font>
											</td>
											<td>			
												<table id="milestonetbl" style="border-collapse:collapse">
													<tr>
														<td width="500px" class="td_editable">
															<xsl:if test="$editmode != 'edit'">
																<xsl:attribute name="class">td_noteditable</xsl:attribute>
															</xsl:if>
															<font id="parentMilestonefont">
																<xsl:value-of select="$fields/parentMilestone"/>&#xA0;
															</font>
														</td>
														<td>
															<a href="{document/fields/parentMilestoneUrl}" id="milestoneURL" target="blank" style="text-decoration:underline !important; margin-left:3px">
																<xsl:if test="$fields/parentMilestoneUrl = '' or not($fields/parentMilestoneUrl)">
																	<xsl:attribute name="style">display:none</xsl:attribute>
																</xsl:if>
																<xsl:value-of select="$captions/go/@caption"/>
															</a>
														</td>
													</tr>
												</table> 
												<input type="hidden" id="parentdocid" name="parentdocid" value="{document/@parentdocid}"/>	
											</td> 
										</tr>
                                        <!-- Тип заявки -->
                                        <tr>
                                            <td class="fc">
                                                <font style="vertical-align:top"><xsl:value-of select="$captions/demandtype/@caption"/> : </font>
                                            </td>
                                            <td>
                                                <xsl:if test="$editmode ='edit'">
                                                    <select size="1" name="demand_type" style="width:510px;" class="select_editable">
                                                        <xsl:variable name="demand_type" select="$fields/demand_type/@attrval"/>
                                                        <xsl:for-each select="document/glossaries/demand_type/entry">
                                                        	<xsl:sort select="."/>
                                                            <option value="{@id}">
                                                                <xsl:if test="@id = $demand_type">
                                                                    <xsl:attribute name="selected">selected</xsl:attribute>
                                                                </xsl:if>
                                                                <xsl:value-of select="."/>
                                                            </option>
                                                        </xsl:for-each>
                                                    </select>
                                                </xsl:if>
                                                <xsl:if test="$editmode !='edit'">
                                                    <div style="width:500px;" class="title">
                                                        <xsl:attribute name="class">td_noteditable</xsl:attribute>
                                                        <xsl:value-of select="$fields/demand_type"/>&#xA0;
                                                    </div>
                                                </xsl:if>
                                            </td>
                                        </tr>
                                        <!-- Исполнитель -->
										<tr>
											<td class="fc">
												<font style="vertical-align:top"><xsl:value-of select="$captions/executer/@caption"/> : </font>
													<xsl:if test="$editmode = 'edit'">
													<a accesskey="3" class="picklist-button">
														<xsl:attribute name="title" select="concat($captions/executer/@caption,'')"/>
														<xsl:attribute name="onclick">javascript:dialogBoxStructure('executers_by_role','true','executer','frm', 'executerbl');</xsl:attribute>								
														<img src="/SharedResources/img/classic/picklist.gif" />
													</a>
												</xsl:if>
											</td>
											<td style="padding:0px">
												<table id="executerbl" style="display:inline-block">
													<xsl:if test="$status = 'new'">
														<tr>
															<td width="500px" class="td_editable">
																&#xA0;
															</td>
														</tr>
													</xsl:if>
													<xsl:for-each select="$fields/executer/entry">
														<tr style="margin:0px; padding:0px">
															<td style="width:500px; margin:0px" class="td_editable">
																<xsl:if test="$editmode != 'edit'">
																	<xsl:attribute name="class">td_noteditable</xsl:attribute>
																</xsl:if>
																<xsl:value-of select="."/>&#xA0;
																<input type="hidden" id="executer" name="executer">
																	<xsl:attribute name="value" select="@attrval"/>
																</input>
																<xsl:if test="$fields/responsible = @attrval or count($fields/executer/entry) = 1 or (not($fields/responsible) and position() = 1)">
																	<img style=" float:right" src="/SharedResources/img/classic/icons/bullet_orange.png" title="Ответственный исполнитель"/>
																</xsl:if>
															</td>
														</tr>
													</xsl:for-each>
                                                    <xsl:if test="document/@status ='new'">
                                                        <input type="hidden" id="executer" name="executer" onChange="javascript:alert('ss')" />
                                                    </xsl:if>
												</table>

												<xsl:if test="document/fields/responsible">
													<input type="hidden" name="responsible" value="{document/fields/responsible}"/>
												</xsl:if>
												<input type="hidden" id="executercaption" value="{$captions/executer/@caption}"/>
											</td>
										</tr>
                                         <!-- Рейтинг -->
                                        <xsl:if test="document/current_userid = 'kkuliyev' or document/current_userid = 'bnurlanbekova' or document/current_userid = 'ppadalko'">
                                            <tr>
                                                <td class="fc">
                                                    <font style="vertical-align:top"><xsl:value-of select="$captions/rating/@caption"/> : </font>
                                                </td>
                                                <td>
                                                    <xsl:variable name="count" select="50"/>
                                                    <select id="rating" >
                                                        <option value="" />
                                                        <xsl:for-each select="for $i in 1 to $count return $i">
                                                            <option value="{.}"><xsl:value-of select="." /></option>
                                                        </xsl:for-each>
                                                    </select>
                                                    <script type="text/javascript" defer="defer">
                                                        $(document).ready(function(){
                                                            <xsl:if test="document/@status = 'new'">
                                                                $('#rating').barrating({
                                                                    readonly: true
                                                                });
                                                            </xsl:if>
                                                            <xsl:if test="document/@status = 'existing'">
                                                                $('#rating').barrating({
                                                                    readonly: true
                                                                });

                                                                <xsl:if test="document/fields/responsible != ''">
                                                                    var r = calcRating('<xsl:value-of select="document/fields/responsible" />');

                                                                </xsl:if>
                                                                <xsl:if test="document/fields/responsible = ''">
                                                                    var r = calcRating('<xsl:value-of select="document/fields/executer/entry/@attrval" />');

                                                                </xsl:if>
                                                            </xsl:if>
                                                        });
                                                    </script>
                                                </td>
                                            </tr>
                                        </xsl:if>
                                        <!-- Приступить к работе с -->
                                        <tr>
                                            <td  class="fc">
                                                <font style="vertical-align:top">
                                                    <xsl:value-of select="document/captions/startdate/@caption"/>:
                                                </font>
                                            </td>
                                            <td>
                                                <input readonly="readonly" required="required" type="text" id="startDate"
                                                       name="startdate" onfocus="javascript:$(this).blur()" class="td_editable"
                                                       style="width:100px; vertical-align:top" onChange="callChangeCtrlDate()" autocomplete="off">
                                                    <xsl:attribute name="title" select="document/captions/startdate/@caption"/>
                                                    <xsl:attribute name="value" select="substring(document/fields/control/startdate,1,10)"/>
                                                    <xsl:if test="$editmode = 'edit'">
                                                        <xsl:attribute name="class">eventdate</xsl:attribute>
                                                    </xsl:if>
                                                    <xsl:if test="$editmode != 'edit'">
                                                        <xsl:attribute name="class">td_noteditable</xsl:attribute>
                                                    </xsl:if>
                                                </input>
                                            </td>
                                            <xsl:if test="$editmode = 'edit'">
                                                <script>
                                                    $(document).ready(function(){
                                                        $( "#startDate" ).datepicker( "option", "minDate", "d");
                                                        //startDateLimit('<xsl:value-of select="document/fields/ctrlDateInJsFormat"/>')
                                                    })
                                                </script>
                                            </xsl:if>
                                        </tr>

										<!--Приоритет -->
										<tr>
											<td class="fc" style="padding-right:5px">
												<font style="vertical-align:top"><xsl:value-of select="$captions/priority/@caption"/> : </font>
											</td>
											<td>
												<button  type="button" id="soon" style="width:80px; background:none !important; border:none; background-color: transparent; text-decoration:underline !important; vertical-align:top" onclick="moveDownP()">
													<span>
														<font class="button_text">
															<xsl:value-of select="document/captions/soon/@caption"/>
														</font>
													</span>
												</button>												  												 													 	
											 	<div id="sliderP" class="slider" style=" margin:8px 0 0 8px; width:400px; display:inline-block"></div>
											 	<input type="text" readonly="true" style="width:30px; border:1px solid #555555; margin-left:14px" id="pri_int"  value="{$fields/control/priority}">
											 		<xsl:attribute name="class" select="concat('level',$fields/control/priority)"/>
											 	</input>
											 	<input type="hidden"  id="priority" name="priority" value="{document/fields/control/priority}"/>											 			
												<button type="button" id="slowly" style="width:90px; background:none !important; border:none; background-color: transparent; text-decoration: underline !important; vertical-align:top" onclick ="moveUpP()">
													<span>
														<font class="button_text">
															<xsl:value-of select="document/captions/later/@caption"/>
														</font>
													</span>
												</button>
											</td>
										</tr>
										<!-- Коэфициент сложности-->
										<tr>
											<td class="fc">
												<font style="vertical-align:top"><xsl:value-of select="$captions/complication/@caption"/> : </font>
											</td>
											<td>
												<button type="button" id="easy" style="width:80px; background:none !important; border:none; background-color: transparent; text-decoration: underline !important ; vertical-align:top; vertical-align:top" onclick ="moveDownC()">
													<span>
														<font style="font-size:12px"><xsl:value-of select="document/captions/easier/@caption"/></font>
													</span>
												</button>
												<div id="sliderI" class="slider" style="margin:8px 0 0 8px; width:400px;  display:inline-block"/>
												<input type="text" readonly="true" style="width:30px; border:1px solid #555555; margin-left:14px" id="imp_int" value="{$fields/control/complication}">
												 		<xsl:attribute name="class" select="concat('level',$fields/control/complication)"/>
												 </input> 
												 <input type="hidden"  id="complication" name="complication" value="{$fields/control/complication}"/> 
												 <button type="button" id="difficult" style="width:90px; background:none !important; border:none; background-color: transparent; text-decoration: underline !important; vertical-align:top" onclick ="moveUpC()">
														<span>
															<font class="button_text"><xsl:value-of select="document/captions/complicated/@caption"/></font>
														</span>
												</button>
											</td>
										</tr> 
										<!-- Является ошибкой -->										 
										<tr>
											<td class="fc"><font style="vertical-align:top"><xsl:value-of select="$captions/iserror/@caption"/> :</font></td>
											<td>
												<input type="checkbox" id="iserror"  name="iserror" autocomplete="off">
													<xsl:if test="$fields/iserror ='on'">
														<xsl:attribute name="checked">checked</xsl:attribute>
													</xsl:if>
													<xsl:if test="$editmode != 'edit'">
														<xsl:attribute name="disabled">disabled</xsl:attribute>
													</xsl:if> 
												</input> 
											</td>
											<td id="dspNewCtrlDateReason"></td>
										</tr>

                                        <!-- Опубликовать для заказчика -->
										<tr>
											<td class="fc"><font style="vertical-align:top"><xsl:value-of select="$captions/publishforcustomer/@caption"/> :</font></td>
											<td>
												<input type="checkbox" id="publishforcustomer"  name="publishforcustomer" value="1" autocomplete="off">
													<xsl:if test="$fields/publishforcustomer ='1'">
														<xsl:attribute name="checked">checked</xsl:attribute>
													</xsl:if>
													<xsl:if test="$editmode != 'edit'">
														<xsl:attribute name="disabled">disabled</xsl:attribute>
													</xsl:if> 
												</input> 
											</td>
										</tr>
										<!-- Срок исполнения -->										 
										<tr>
											<td class="fc"><font style="vertical-align:top"><xsl:value-of select="$captions/ctrldate/@caption" /> : </font></td>
											<td>
												<input readonly="readonly" required="required" type="text" name="ctrldate" onfocus="javascript:$(this).blur()" class="td_noteditable" style="width:90px; vertical-align:top">
													<xsl:attribute name="title" select="$fields/ctrldate/@caption"/>
													<xsl:attribute name="value" select="substring($fields/control/ctrldate,1,10)"/>
													<xsl:if test="$editmode = 'edit'">
														<xsl:attribute name="id">ctrldate</xsl:attribute>
													</xsl:if> 
												</input>
												<xsl:if test="$status != 'new' and $fields/control/shift/entry"> 
													<a href="" id="historyprolongationCaption" class="historyprolongationCaption" title="{document/captions/showhistoryctrldate/@caption}" style="margin-left:5px; border-bottom:1px dotted; text-decoration:none; color:#1A3DC1;">
														<xsl:attribute name="href">javascript:toogleHistoryProlongation()</xsl:attribute>
														<xsl:value-of select="$captions/showhistoryctrldate/@caption"/>
													</a>
												</xsl:if>
												<input class="ctrltime" type="hidden" name="ctrltime" id="ctrltime"/>												 
											</td>
										</tr>
										</table>
										<div id="historyprolongation" style="display:none; padding-top:5px; padding-bottom:5px;">
											<table>
												<!-- Первичный Срок исполнения -->										 
												<tr>
													<td class="fc"/>
													<td style="height:50px">
														<b><xsl:value-of select="$captions/historychangectrldate/@caption"/></b>
													</td>
												</tr>
												<tr>
													<td class="fc"/>
													<td>
														<font style="vertical-align:top"><xsl:value-of select="$captions/firstctrldate/@caption"/> : </font>
														<div class="td_noteditable" style="width:80px; vertical-align:top; display:inline-block">
															<xsl:value-of select="substring($fields/control/primaryctrldate,1,10)"/>
														</div>
													</td>
												</tr>
												<tr>
										       		<td width="30%" class="fc"></td>
													<td>
														<table style="border-collapse:collapse; width:800px;">
															<tr>
																<td style="border:1px solid #cdcdcd; padding:3px; text-align:center; background:#efefef; width:160px">
																	<xsl:value-of select="$captions/startshiftdate/@caption"/>
																</td>
																<td style="border:1px solid #cdcdcd; padding:3px; text-align:center; background:#efefef; width:80px">
																	<xsl:value-of select="$captions/shiftcountdays/@caption"/>
																</td>
																<td style="border:1px solid #cdcdcd; padding:3px; text-align:center; background:#efefef">
																	<xsl:value-of select="$captions/shiftreason/@caption"/>
																</td>
																<td style="border:1px solid #cdcdcd; padding:3px; text-align:center; background:#efefef">
																	<xsl:value-of select="$captions/shiftauthor/@caption"/>
																</td>
															</tr>
															<xsl:for-each select="$fields/control/shift/entry">
																<tr style="height:35px">
																	<td style="border:1px solid #cdcdcd; padding-left:5px; text-align:center">
																		<xsl:value-of select="date"/>
																	</td>
																	<td style="border:1px solid #cdcdcd; padding-left:5px; text-align:center">
																		<xsl:value-of select="days"/>
																	</td>
																	<td style="border:1px solid #cdcdcd; padding-left:5px">
																		<xsl:value-of select="reason"/>
																	</td>
																	<td style="border:1px solid #cdcdcd; padding-left:5px">
																		<xsl:value-of select="author"/>
																	</td>
																</tr>
															</xsl:for-each>
														</table>
													</td>
												</tr>
											</table>
										</div>
										<!-- Осталось дней -->
										<table>
										<tr>
											<td class="fc">
												<font style="vertical-align:top">
													<xsl:value-of select="$captions/remained_days/@caption"/> : 
												</font>
											</td>
											<td>
												<input readonly="readonly" type="text" name="remained_days" id="remained_days" onfocus="javascript:$(this).blur()" value="{$fields/control/diff}" class="td_noteditable" style="width:90px; vertical-align:top">
													<xsl:attribute name="title" select="$fields/remained_days/@caption"/>
												</input>  
											</td> 
										</tr>

										<!-- Краткое содержание -->
										<tr>
											<td class="fc"><xsl:value-of select="$captions/content/@caption"/> : </td>
											<td>
												<xsl:if test="$editmode = 'edit' and $status = 'new'">
													<textarea id="MyTextarea" name="briefcontent">
														<xsl:if test="@useragent = 'ANDROID'">
															<xsl:attribute name="style">width:500px; height:300px</xsl:attribute>
															<xsl:attribute name="id"></xsl:attribute>
															<xsl:attribute name="class">android_text</xsl:attribute>
														</xsl:if>
														<xsl:value-of select="$fields/briefcontent"/>
													</textarea>
												</xsl:if>
												<xsl:if test="$editmode != 'edit' or $status != 'new'">
													<div id="briefcontent" style="width:500px; height:300px; background:#EEEEEE; padding: 3px 5px; overflow-x:auto">
														<script>
															<xsl:variable name="str" select="replace($fields/briefcontent,'&#92;&#92;','&#92;&#92;&#92;&#92;')"/>
															str="<xsl:value-of select='$str'/>"
															$("#briefcontent").html(str)
														</script>
													</div>
													<input type="hidden" name="briefcontent" value="{$fields/briefcontent}"/>
												</xsl:if>
											</td>
										</tr>											
									</table>
									<input type="hidden" name="type" value="save"/>
									<input type="hidden" name="id" value="{@id}"/>
									<input type="hidden" name="key" value="{document/@docid}"/> 
									<input type="hidden" name="allcontrol" value="{$fields/control/allcontrol}"/> 
									<input type="hidden" name="status" value="{$fields/status}"/> 
									<input type="hidden" name="revoke_demand_reason_id" value="{$fields/revoke_demand_reason_id}"/>
									<input type="hidden" name="parentdoctype" value="{document/@parentdoctype}"/>
									<input type="hidden" name="parentdocid" value="{document/@parentdocid}"/>
									<input type="hidden" name="doctype" value="{document/@doctype}"/>
									<input type="hidden" id="username" value="{@username}"/>
									<input type="hidden" id="username222" value="{@username}"/>
								</div>
							</div>
							<div class="ui-tabs-panel" id="tabs-2">
								<div display="block"  id="property" width="100%">	
									<div id="progressDiv" style="width:99%; overflow:hidden">
										<table width="100%" border="0" style="margin-top:8px">
											<tr>
												<td class="fc" style="min-width:240px; max-width:240px;">
													<xsl:value-of select="$captions/progressexecution/@caption"/> :
												</td>
												<td>
													<table>
														<tr>
															<td>
							  									<a href="{@url}" style="color:blue; margin-left:3px; vertical-align:7px">
							  										<xsl:value-of select="$fields/demandProgress/entry/viewtext"/>
							  									</a>
						  									</td>
						  								</tr>
				  										<xsl:apply-templates select="$fields/demandProgress/entry/responses[entry]"/>
				  									</table>
												</td>
											</tr>
										</table>
									</div>
								</div>
							</div>
							<div id="tabs-3">
								<xsl:call-template name="docdiscussion"/>
							</div>
						</form>
						<br/>
						<div class="ui-tabs-panel" id="tabs-4">
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
						<div id="tabs-5">
							<xsl:call-template name="docinfo"/>
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

<xsl:template match="responses">
	<tr class="response{../@docid}">
		<xsl:attribute name="bgcolor">#FFFFFF</xsl:attribute>
		<td nowrap="true">
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
	
<xsl:template match="viewtext" mode="line"></xsl:template>
	
<xsl:template match="entry" mode="item">
	<a href="{@url}" title="{viewtext}" class="doclink" style="font-style:Verdana,​Arial,​Helvetica,​sans-serif; width:100%; font-size:97%; margin-left:2px">
		<xsl:variable name='simbol'>'</xsl:variable>
		<font id="font{@docid}{@doctype}" style="line-height:19px">
			<xsl:value-of select="replace(viewtext, '&amp;gt;', '->')"/>
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
		<xsl:when test="following-sibling::*">
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