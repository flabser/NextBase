<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:template name="doctitleBoss">
		<font><xsl:value-of select="$doctype"/> - <xsl:value-of select="document/fields/fullname"/></font>	
	</xsl:template>
	
	<xsl:template name="doctitleGlossary">
		<font>
			<xsl:value-of select="$doctype"/> - <xsl:value-of select="document/fields/name"/>
		</font>	
	</xsl:template>
	
	<xsl:template name="outline_form">
		<div id="outline">
			<div id="outline-container" style="width:300px; padding-top:10px">
				<xsl:for-each select="document/outline/entry">
					<div  style="">
						<div class="treeentry" style="height:17px; padding:3px 0px 3px 0px; border:1px solid #F9F9F9; width:290px">								
							<img src="/SharedResources/img/classic/1/minus.png" style="margin-left:6px; cursor:pointer" alt="">
								<xsl:attribute name="onClick">javascript:ToggleCategory(this)</xsl:attribute>
							</img>
							<img src="/SharedResources/img/classic/1/folder_open_view.png" style="margin-left:5px;" alt=""/>
							<font style="font-family:arial; font-size:0.9em; margin-left:4px; vertical-align:3px">											
								<xsl:value-of select="@hint"/>
							</font>
						</div>
						<div style="clear:both;"/>
						<div class="outlineEntry">
							<xsl:for-each select="entry">
								<div class="entry treeentry" style="width:290px; padding:3px 0px 3px 0px; border:1px solid #F9F9F9;">
									<div class="viewlink" style="height:18px;">
										<xsl:if test="@current = '1'">
											<xsl:attribute name="class">viewlink_current</xsl:attribute>										
										</xsl:if>	
										<xsl:if test="/request/@id = @id">
											<xsl:attribute name="class">viewlink_current</xsl:attribute>										
										</xsl:if>	
										<div style="float:left; ">
											<xsl:if test="(@id !='favdocs') and (@id != 'recyclebin')">
												<img src="/SharedResources/img/classic/1/doc_view.png" style="margin-left:42px; cursor:pointer" alt=""/>
											</xsl:if>
											<xsl:if test="@id ='favdocs'">
												<img src="/SharedResources/img/iconset/star_full.png" height="17px" style="margin-left:42px; cursor:pointer" alt=""/>
											</xsl:if>
											<xsl:if test="@id ='recyclebin'">
												<img src="/SharedResources/img/iconset/bin.png" height="17px" style="margin-left:42px; cursor:pointer" alt=""/>
											</xsl:if>	
											<a href="{@url}" style="width:90%; vertical-align:top; text-decoration:none !important">
												<xsl:if test="../@id = 'filters'">
													<xsl:attribute name="href"><xsl:value-of select="@url"/>&amp;filterid=<xsl:value-of select="@id"/></xsl:attribute>
												</xsl:if>
												<font class="viewlinktitle">	
													 <xsl:value-of select="@caption"/>
												</font>
											</a>
										</div>
										<xsl:if test="../@id = 'mydocs'">
											<span style="text-align:left; float:right;">
												<font class="countSpan" style="vertical-align:top">
													<xsl:if test="@id!=''">	
														<xsl:attribute name="id" select="@id"/>
													</xsl:if>	
													<xsl:if test="string-length(@count)!=0">
														<xsl:value-of select="@count"/>
													</xsl:if>												
												</font>
											</span>
										</xsl:if>
									</div>
								</div>
							</xsl:for-each>
						</div>
					</div>
				</xsl:for-each>
			</div>
		</div>
		<div id="resizer" onclick="javascript:openformpanel()">
			<span id="iconresizer" class="ui-icon ui-icon-triangle-1-e"/>
		</div>
	</xsl:template>
	
	<xsl:template name="doctitleprj">
		<font>
			<xsl:value-of select="$doctype"/>&#xA0;<xsl:value-of select="document/fields/vn"/>
			&#xA0;<xsl:value-of select="document/fields/projectdate/@caption"/>&#xA0;<xsl:value-of select="document/fields/projectdate"/>
		</font>
	</xsl:template>
	
	<xsl:template name="hotkeys_glossary_form">
		$(document).ready(function(){
			hotkeysnav()  
   		})
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
	</xsl:template>
	
	<xsl:template name="htmlareaeditor">
		<script type="text/javascript">  
			$(function() {
        		//$("textarea").htmlarea(); 
	        	$("#txtDefaultHtmlArea").htmlarea({
		        	toolbar: [
	        			["html"], ["bold", "italic", "underline","strikethrough"],["subscript","superscript"],["indent","outdent"],["decreasefontsize","increasefontsize"],["orderedlist","unorderedlist"],["justifyleft","justifycenter","justifyright"],
	        			["p","h1", "h2", "h3", "h4", "h5", "h6"],["horizontalrule"]
	    			]
	    		}); // Initialize jHtmlArea's with all default values
           		$("#btnRemoveCustomHtmlArea").click(function() {
            		$("#txtCustomHtmlArea").htmlarea("dispose");
           		});
        	});
		</script>
	</xsl:template>

	<!-- Набор javascript библиотек -->
	<xsl:template name="cssandjs">
		<link type="text/css" rel="stylesheet" media="screen" href="classic/css/main.css"/>
		<link type="text/css" rel="stylesheet" media="screen" href="classic/css/form.css"/>
		<link type="text/css" rel="stylesheet" media="screen" href="classic/css/actionbar.css"/>
		<link type="text/css" rel="stylesheet" media="screen" href="classic/css/dialogs.css"/>
		<link type="text/css" rel="Stylesheet" media="screen" href="/SharedResources/jquery/js/jhtmlarea/style/jHtmlArea.css"/>
		<link type="text/css" rel="Stylesheet" media="screen" href="/SharedResources/jquery/js/tiptip/tipTip.css"/>
		<link type="text/css" rel="stylesheet" href="/SharedResources/jquery/css/smoothness/jquery-ui-1.8.20.custom.css"/>
		<link type="text/css" rel="stylesheet" href="/SharedResources/jquery/js/hotnav/jquery.hotnav.css"/>
		<script type="text/javascript" src="/SharedResources/jquery/js/jquery-1.4.2.js"/>
		<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.core.js"/>
		<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.effects.core.js"/>
		<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.widget.js"/>
		<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.datepicker.js"/>
		<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.datepicker-ru.js"/>
		<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.mouse.js"/>
		<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.slider.js"/>
		<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.progressbar.js"/>
		<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.autocomplete.js"/>
		<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.draggable.js"/>
		<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.position.js"/>
		<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.dialog.js"/>
		<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.tabs.js"/>
		<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.button.js"/>
		<script type="text/javascript" src="/SharedResources/jquery/js/tiptip/jquery.tipTip.js"/>
		<script type="text/javascript" src="classic/scripts/form.js?ver=1"/>
		<script type="text/javascript" src="classic/scripts/coord.js?ver=1"/>
		<script type="text/javascript" src="classic/scripts/dialogs.js?ver=1"/>
		<script type="text/javascript" src="classic/scripts/outline.js?ver=1"/>
		<script type="text/javascript" src="/SharedResources/jquery/js/cookie/jquery.cookie.js"/>
		<script type="text/javascript" src="/SharedResources/jquery/js/jhtmlarea/scripts/jHtmlArea-0.7.0.js"/>
		<script type="text/javascript" src="/SharedResources/jquery/js/hotnav/jquery.hotkeys.js"/>
		<script type="text/javascript" src="/SharedResources/jquery/js/hotnav/jquery.hotnav.js"/>
		<script>
			cancelcaption='<xsl:value-of select="document/captions/cancel/@caption"/>'
			docfilter='<xsl:value-of select="document/captions/docfilter/@caption"/>'
			changeviewcaption='<xsl:value-of select="document/captions/changeview/@caption"/>'
			receiverslistcaption='<xsl:value-of select="document/captions/receiverslist/@caption"/>'
			commentcaption='<xsl:value-of select="document/captions/commentcaption/@caption"/>'
			correspforacquaintance='<xsl:value-of select="document/captions/correspforacquaintance/@caption"/>'
			searchcaption='<xsl:value-of select="document/captions/searchcaption/@caption"/>'
			contributorscoord='<xsl:value-of select="document/captions/contributorscoord/@caption"/>'
			type='<xsl:value-of select="document/captions/type/@caption"/>'
			parcoord='<xsl:value-of select="document/captions/parcoord/@caption"/>'
			sercoord='<xsl:value-of select="document/captions/sercoord/@caption"/>'
			waittime='<xsl:value-of select="document/captions/waittime/@caption"/>'
			coordparam='<xsl:value-of select="document/captions/coordparam/@caption"/>'
			hours='<xsl:value-of select="document/captions/hours/@caption"/>'
			yescaption='<xsl:value-of select="document/captions/yescaption/@caption"/>'
			nocaption='<xsl:value-of select="document/captions/nocaption/@caption"/>'
			warning='<xsl:value-of select="document/captions/warning/@caption"/>'
			documentsavedcaption = '<xsl:value-of select="document/captions/documentsavedcaption/@caption"/>';
			documentmarkread = '<xsl:value-of select="document/captions/documentmarkread/@caption"/>';
			docisexec = '<xsl:value-of select="document/captions/docisexec/@caption"/>';
			execrejected = '<xsl:value-of select="document/captions/execrejected/@caption"/>';
			docaccept = '<xsl:value-of select="document/captions/docaccept/@caption"/>';
			docisrejected = '<xsl:value-of select="document/captions/docisrejected/@caption"/>';
			pleasewaitdocsave = '<xsl:value-of select="document/captions/pleasewaitdocsave/@caption"/>';
			lang='<xsl:value-of select="@lang"/>';
			redirectAfterSave = '<xsl:value-of select="history/entry[@type eq 'outline'][last()]"/>'
		</script>
		<script type="text/javascript">    
			$(function(){
				$("#tabs").tabs();
				$("button").button();
			});
    	</script>
	</xsl:template>
	
	<xsl:template name="documentheader">
		<div style="position:absolute; top:0px; left:0px; width:100%; background:url(/WTS/classic/img/yellow_background.jpg); height:70px; border-bottom:1px solid #fcdd76; z-index:2">
			<span style="float:left">
				<img alt="" src="classic/img/bigroup/logo_small.png" style="margin:5px"/>
				<font id="apptitle" style="font-size:1.17em; vertical-align:27px; color:#555555"><xsl:value-of select="document/captions/appcaption/@caption"/></font>
			</span>
			<span style="float:right; padding:5px 5px 5px 0px" id="system_buttonbar">
				<a target="_parent" id="currentuser" title="{document/captions/curuserprop/@caption}" href="Provider?type=edit&amp;element=userprofile&amp;id=userprofile" style="text-decoration:none;color: #555555 ; font: 11px Tahoma; font-weight:bold">
					<font>
						<xsl:value-of select="@username"/>
					</font>
				</a>
				<a target="_parent"  id="logout" href="Logout" title="{document/captions/logout/@caption}" style="text-decoration:none;color:#555555; font:11px Tahoma; font-weight:bold">
					<font style="margin-left:20px;"><xsl:value-of select="document/captions/logout/@caption"/></font> 
				</a>
				<a target="_parent"  id="helpbtn" href="Provider?type=static&amp;id=help_summary" title="{document/captions/help/@caption}" style="text-decoration:none; color:#555555 ; font:11px Tahoma; font-weight:bold">
					<font style="margin-left:20px;"><xsl:value-of select="document/captions/help/@caption"/></font> 
				</a>
			</span>
		</div>
	</xsl:template>

	<xsl:template name="ECPsignFields">
		<!-- <input type="hidden" name="sign" id="sign" value="{sign}" style="width:100%;" />
		<input type="hidden" name="signedfields" id="signedfields" value="{signedfields}" style="width:100%;" />
		 <APPLET CODE="kz.gamma.TumarCSP" NAME="edsApplet"  type="application/x-java-applet" ARCHIVE="/edsApplet/lib/sign-applet.jar,/edsApplet/lib/commons-logging.jar,/edsApplet/lib/xmlsec-1.3.0.jar,/edsApplet/lib/crypto.gammaprov.jar,/edsApplet/lib/sign-applet.jar,/edsApplet/lib/crypto.tsp.jar" HEIGHT="100" WIDTH="100">
			<param name="ARCHIVE" value="/edsApplet/lib/sign-applet.jar,/edsApplet/lib/commons-logging.jar,/edsApplet/lib/xmlsec-1.3.0.jar,/edsApplet/lib/crypto.gammaprov.jar,/edsApplet/lib/sign-applet.jar,/edsApplet/lib/crypto.tsp.jar"/>
		</APPLET> 

		<xsl:if test="document/@canbesign='1111'">
			<script type="text/javascript" src="/edsApplet/js/jquery.blockUI.js" charset="utf-8"></script>
        	<script type="text/javascript" src="/edsApplet/js/crypto_object.js" charset="utf-8"></script>
        	<script type="text/javascript">
				edsApp.init();
			</script>
		</xsl:if> -->
	</xsl:template>

	<xsl:template name="markisread">
		<xsl:if test="document[@isread = 0][@status != 'new']">
			<script>
				markRead(<xsl:value-of select="document/@doctype"/>, <xsl:value-of select="document/@docid"/>);
			</script>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="docinfo">
		<br/>
		<table width="100%" border="0">
			<tr>
				<td class="fc">
					<xsl:value-of select="document/captions/statusdoc/@caption"/> :
				</td>
				<td>
					<font>
						<xsl:choose>
							<xsl:when test="document/@status='new'">
								<xsl:value-of select="document/captions/newdoc/@caption"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="document/captions/saved/@caption"/>
							</xsl:otherwise>
						</xsl:choose>
					</font>		
				</td>
			</tr>
			<tr>
				<td class="fc">
					<xsl:value-of select="document/captions/permissions/@caption"/> :
				</td>
				<td>
					<font>
						<xsl:choose>
							<xsl:when test="document/@editmode='view'">
								<xsl:value-of select="document/captions/readonly/@caption"/>
							</xsl:when>
							<xsl:when test="document/@editmode='readonly'">
								<xsl:value-of select="document/captions/readonly/@caption" />
							</xsl:when>
							<xsl:when test="document/@editmode='edit'">
								<xsl:value-of select="document/captions/editing/@caption" />
							</xsl:when>
							<xsl:when test="document/@editmode='noaccess'">
								<xsl:value-of select="document/captions/readonly/@caption" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="document/captions/modenotdefined/@caption" />
							</xsl:otherwise>
						</xsl:choose>
					</font>
				</td>
			</tr>
			<xsl:if test="document/@status !='new'">
				<!-- <tr>
					<td class="fc">
						<xsl:value-of select="document/captions/infofread/@caption"/> :
					</td>
					<td>
						<font>
							<xsl:choose>
								<xsl:when test="document/@isread ='1'">
									Прочтен
								</xsl:when>
								<xsl:otherwise>
									Не прочтен
								</xsl:otherwise>
							</xsl:choose>
						</font>		
					</td>
				</tr> -->
				<tr>
					<td class="fc">
						<xsl:value-of select="document/captions/infofreaders/@caption"/> :
					</td>
					<td>
						<script type="text/javascript">
							usersWhichReadInTable(this,<xsl:value-of select="document/@doctype"/>,<xsl:value-of select="document/@docid"/>)
						</script>
						<table class="table-border-gray" id="userswhichreadtbl" style="width:600px">
							<tr>
								<td style="width:350px; text-align:center">
									<font>Кем прочтен</font>
								</td>
								<td style="width:250px; text-align:center">
									<font>Время прочтения</font>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td class="fc">
						ЭЦП :
					</td>
					<td>
						<font>
							<xsl:choose>
								<xsl:when test="document/@sign ='0'">
									Документ не подписан
								</xsl:when>
								<xsl:when test="document/@sign ='1'">
									Подпись верна
								</xsl:when>
								<xsl:when test="document/@sign ='2'">
									Подпись не верна
								</xsl:when>
								<xsl:when test="document/@sign ='3'">
									Недопустимый ключ
								</xsl:when>
								<xsl:when test="document/@sign ='4'">
									Не найден криптографический алгоритм
								</xsl:when>
								<xsl:when test="document/@sign ='5'">
									Не найден механизм заполнения
								</xsl:when>
								<xsl:when test="document/@sign ='6'">
									Недопустимая характеристика ключа
								</xsl:when>
								<xsl:when test="document/@sign ='7'">
									Недопустимый параметр алгоритма
								</xsl:when>
								<xsl:when test="document/@sign ='8'">
									Общее исключение подписи
								</xsl:when>
								<xsl:when test="document/@sign ='10'">
									Не найден файл сертификата
								</xsl:when>
								<xsl:when test="document/@sign ='11'">
									Не найдено одно из полей для подписи
								</xsl:when>
								<xsl:otherwise>
								</xsl:otherwise>
							</xsl:choose>
						</font>		
					</td>
				</tr>
			</xsl:if>
		</table>
	</xsl:template>
	
	<xsl:template name="docdiscussion">
		<br/>
		<xsl:if test="document/@status !='new'">
			<button class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" id="btnnewcomment" style="margin-left:10px;" title="Написать новый комментарий">
				<xsl:if test="document/@topicid != '0' and document/@topicid != 'null'">
					<xsl:attribute name="onclick">javascript:addCommentToForum(this,<xsl:value-of select='document/@topicid'/>,904)</xsl:attribute>
				</xsl:if>
				<xsl:if test="document/@topicid = '0' or document/@topicid = 'null'">
				 	<xsl:attribute name="onclick">javascript:addTopicToForum(this,<xsl:value-of select='document/@docid'/>,<xsl:value-of select='document/@doctype'/>)</xsl:attribute>
				</xsl:if>
<!-- 				<xsl:if test="document/@topicid = '0' or document/@topicid = 'null'">
				 	<xsl:attribute name="onclick">javascript:window.location.href="Provider?type=forum&amp;id=topic&amp;key=<xsl:if test="document/@topicid != '0'"><xsl:value-of select='document/@topicid'/></xsl:if><xsl:if test="document/@topicid = '0'"> </xsl:if>&amp;parentdoctype=<xsl:value-of select='document/@doctype'/>&amp;parentdocid=<xsl:value-of select='document/@docid'/>"</xsl:attribute>
				</xsl:if> -->
				<!--<xsl :attribute name="onclick">javascript:window.location.href="Provider?type=forum&amp;id=comment&amp;key=&amp;parentdoctype=904&amp;parentdocid=<xsl:value-of select='document/@topicid'/>"</xsl:attribute>
				-->
					<img src="/SharedResources/img/classic/icons/comment.png" class="button_img"/>
					<font style="font-size:12px; vertical-align:top">
						<xsl:if test="document/@topicid != '0'">Написать новый комментарий</xsl:if>
						<xsl:if test="document/@topicid = 'null'">Добавить тему обсуждения</xsl:if>
						<xsl:if test="document/@topicid = '0'">Добавить тему обсуждения</xsl:if>
					</font>
			</button>
			<br/>
			<br/>
			<span id="bordercomment"/>
			<xsl:if test="document/@topicid != '0' and document/@topicid != 'null'">
				<tr>
					<td>
						<div display="block" style="display:block; width:90%" id="topic">
							<div id="headerTheme" style="width:100%; padding-left:10px">
							</div>
							<div id="infoTheme" style="width:100%; padding-left:10px; padding-top:3px">
							</div>
							<br/>
							<div id="CountMsgTheme" style="color:#555555; padding:12px; background:#E6E6E6; border:1px solid #D3D3D3; margin-left:10px; border-radius: 5px 5px 0px 0px; height:20px; font-size: 13px; font-weight: 300; overflow: hidden; ">
								
							</div>
							<div id="msgWrapper" style="min-height:150px; margin-left:10px">
							</div>
							<table id="topicTbl" style=" width:100%"/>
							<br/>
						</div>
					</td>
				</tr>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="attach">
		<div id="attach" style="display:block;">
			<table style="border:0; border-collapse:collapse" id="upltable" width="99%">
				<xsl:if test="$editmode = 'edit'">
					<tr>
						<td class="fc">
							<xsl:value-of select="document/captions/attachments/@caption"/>:
						</td>
						<td>
							<input type="file" size="60" border="#CCC" name="fname">
								<xsl:attribute name="onchange">javascript:submitFile('upload', 'upltable', 'fname'); ajaxFunction()</xsl:attribute>
							</input>&#xA0;
							<!-- <a id="upla" style="margin-left:5px; border-bottom:1px dotted; text-decoration:none; color:#1A3DC1;">
								<xsl:attribute name="href">javascript:submitFile('upload', 'upltable', 'fname');ajaxFunction()</xsl:attribute>
								<xsl:value-of select="document/captions/attach/@caption"/>
							</a> -->
							<br/>
							<style>.ui-progressbar .ui-progressbar-value { background-image: url(/SharedResources/jquery/css/base/images/pbar-ani.gif); }</style>
							<div id="progressbar" style="width:370px; margin-top:5px; height:12px"></div>
							<div id="progressstate" style="width:370px; display:none">
								<font style="visibility:hidden; color:#999; font-size:11px; width:70%" id="readybytes"></font>
								<font style="visibility:hidden; color:#999; font-size:11px; float:right;" id="percentready"></font>
								<font style="visibility:hidden; text-align:center; color:#999; font-size:11px; width:30%; text-align:center" id="initializing">Подготовка к загрузке</font>
							</div>
						</td>
						<td></td>
					</tr>
				</xsl:if>
				<xsl:variable name='docid' select="document/@docid"/>
				<xsl:variable name='doctype' select="document/@doctype"/>
				<xsl:variable name='formsesid' select="formsesid"/>
				
				<xsl:for-each select="document/fields/rtfcontent/entry">
					<tr>
						<xsl:variable name='id' select='@hash'/>
						<xsl:variable name='filename' select='@filename'/>
						<xsl:variable name="extension" select="tokenize(lower-case($filename), '\.')[last()]"/>
						<xsl:variable name="resolution"/>
						<xsl:attribute name='id' select="$id"/>
						<td class="fc"></td>
						<td colspan="2">
							<div class="test" style="width:90%; overflow:hidden; display:inline-block">
								<xsl:choose>
									<xsl:when test="$extension = 'jpg' or $extension = 'jpeg' or $extension = 'gif' or $extension = 'bmp' or $extension = 'png'">
										<img class="imgAtt" title="{$filename}" style="border:1px solid lightgray; max-width:800px; max-height:600px; margin-bottom:5px">
											<xsl:attribute name="onload">checkImage(this)</xsl:attribute>
											<xsl:attribute name='src'>Provider?type=getattach&amp;formsesid=<xsl:value-of select="$formsesid"/>&amp;doctype=<xsl:value-of select="$doctype"/>&amp;key=<xsl:value-of select="$docid"/>&amp;field=rtfcontent&amp;file=<xsl:value-of select='$filename'/></xsl:attribute>
										</img>
										<xsl:if test="$editmode = 'edit'">
											<xsl:if test="comment =''">
												<a href='' style="vertical-align:top;" title='tect'>
													<xsl:attribute name='href'>javascript:addCommentToAttach('<xsl:value-of select="$id"/>')</xsl:attribute>
													<img id="commentaddimg{$id}" src="/SharedResources/img/classic/icons/comment_add.png" style="width:16px; height:16px" >
														<xsl:attribute name ="title"><xsl:value-of select ="//document/captions/add_comment/@caption"/></xsl:attribute>
													</img>
												</a>
											</xsl:if>
											<a href='' style="vertical-align:top; margin-left:8px">
												<xsl:attribute name='href'>javascript:deleterow('<xsl:value-of select="$formsesid"/>','<xsl:value-of select='$filename'/>','<xsl:value-of select="$id" />')</xsl:attribute>
												<img src="/SharedResources/img/iconset/cross.png" style="width:13px; height:13px">
												<xsl:attribute name ="title"><xsl:value-of select ="//document/captions/delete_file/@caption"/></xsl:attribute>
												</img>
											</a>
										</xsl:if>
									</xsl:when>
									<xsl:otherwise>
										<img src="/SharedResources/img/iconset/file_extension_{$extension}.png" style="margin-right:5px">
											<xsl:attribute name="onerror">javascript:changeAttIcon(this)</xsl:attribute>
										</img>
										<a style="vertical-align:5px">
											<xsl:attribute name='href'>Provider?type=getattach&amp;formsesid=<xsl:value-of select="$formsesid"/>&amp;doctype=<xsl:value-of select="$doctype"/>&amp;key=<xsl:value-of select="$docid"/>&amp;field=rtfcontent&amp;file=<xsl:value-of select='$filename'/>	</xsl:attribute>
											<xsl:value-of select='$filename'/>
										</a>&#xA0;&#xA0;
										<xsl:if test="$editmode = 'edit'">
											<xsl:if test="comment =''">
												<a href='' style="vertical-align:5px;">
													<xsl:attribute name='href'>javascript:addCommentToAttach('<xsl:value-of select="$id"/>')</xsl:attribute>
													<img id="commentaddimg{$id}" src="/SharedResources/img/classic/icons/comment_add.png" style="width:16px; height:16px">
														<xsl:attribute name ="title"><xsl:value-of select ="//document/captions/add_comment/@caption"/></xsl:attribute>
													</img>
												</a>
											</xsl:if>
											<a href='' style="vertical-align:5px; margin-left:5px">
												<xsl:attribute name='href'>javascript:deleterow('<xsl:value-of select="$formsesid"/>','<xsl:value-of select='$filename' />','<xsl:value-of select="$id"/>')</xsl:attribute>
												<img src="/SharedResources/img/iconset/cross.png" style="width:13px; height:13px">
													<xsl:attribute name ="title"><xsl:value-of select ="//document/captions/delete_file/@caption"/></xsl:attribute>
												</img>
											</a>
										</xsl:if>
									</xsl:otherwise>
								</xsl:choose>
							</div>
						</td>
					</tr>
					<tr>
						<td></td>
						<td colspan="2" style="color:#777; font-size:12px">
							<xsl:if test="comment !=''">
								<xsl:value-of select="//document/captions/comments/@caption"/> : <xsl:value-of select="comment"/>
								<br/><br/>
							</xsl:if>
						</td>
					</tr>
				</xsl:for-each>
			</table>
			<br/>
			<br/>
		</div>
	</xsl:template>
</xsl:stylesheet>