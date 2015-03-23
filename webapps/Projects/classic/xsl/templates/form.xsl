<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:template name="docInfo">
		<span style="float:right; font-size:11px"> 
			<xsl:value-of select="document/captions/docauthor/@caption"/>: 
			<font style="font-weight:normal;"><xsl:value-of select="document/fields/docauthor"/></font>
			<xsl:if test="@id !='demand'">&#xA0;&#xA0;
				<xsl:value-of select="document/captions/docdate/@caption"/>: 
				<font style="font-weight:normal;"><xsl:value-of select="document/fields/docdate"/></font>
				<input type="hidden" name="docdate" value="{document/fields/docdate}" />
			</xsl:if>
			<xsl:if test="document/@status = 'existing'">
				<xsl:if test="@id='demand' or @id = 'ki'">
					<font style="font-weight:bold; margin-left:10px"><xsl:value-of select="document/captions/status/@caption"/>: </font>
					<xsl:if test="document/fields/control/allcontrol = '1' or document/fields/control/allcontrol = ''">
						<font style="font-weight:normal; color:red"><xsl:value-of select="document/captions/incontrol/@caption"/></font>
					</xsl:if>
					<xsl:if test="document/fields/control/allcontrol = '2'">
						<font style="font-weight:normal; color:red"><xsl:value-of select="document/captions/readytochecking/@caption"/></font>
					</xsl:if>
					<xsl:if test="@id ='demand' and document/fields/status = 'revoked'">
						<font style="font-weight:normal; color:red" title="{document/captions/reason/@caption}: {document/fields/revoke_demand_reason_id}; от {document/fields/dateRevoked}">
							<xsl:value-of select="document/captions/revokedDemnd/@caption"/>&#xA0;
						</font>				 
					</xsl:if>
					<xsl:if test="document/fields/control/allcontrol = '0' and document/fields/status != 'revoked'">
						<font style="font-weight:normal;"><xsl:value-of select="document/captions/controlisreset/@caption"/></font>
					</xsl:if>
				</xsl:if>
			</xsl:if>
			<!-- <span id="markDocRead">
					<xsl:if test="document/@status = 'existing'">
					<xsl:attribute name="onmouseover">javascript:usersWhichRead(this,<xsl:value-of select="document/@doctype"/>,<xsl:value-of select="document/@docid"/>)</xsl:attribute>
					<xsl:attribute name="onmouseout">javascript:$("#userWhichRead").remove()</xsl:attribute>
					
				<xsl:attribute name="style">cursor:pointer</xsl:attribute>
				<xsl:choose>
					<xsl:when test="document/@isread='0'">
					
						&#xA0;<xsl:value-of select="document/captions/notread/@caption"/>
					</xsl:when>
				<xsl:otherwise>
						&#xA0;<xsl:value-of select="document/captions/read/@caption" />
					</xsl:otherwise>
				</xsl:choose>
				</xsl:if>
			</span>
			 -->
		</span>	
	</xsl:template>
	
	<xsl:template name="doctitleGlossary">
		<font>
			<xsl:if test="document/@status != 'new'">			
				<xsl:value-of select="$doctype"/> - <xsl:value-of select="document/fields/name"/>
			</xsl:if>
			<xsl:if test="document/@status = 'new'">			
				<xsl:value-of select="document/captions/newgroup/@caption"/>
			</xsl:if>
		</font>	
	</xsl:template>
	
	<xsl:template name="doctitleprj">
		<font>
			<xsl:value-of select="$doctype"/>&#xA0;<xsl:value-of select="document/fields/vn"/>
			&#xA0;<xsl:value-of select="document/fields/projectdate/@caption"/>&#xA0;<xsl:value-of select="document/fields/projectdate"/>
		</font>
	</xsl:template>
	
	<xsl:template name="htmlareaeditor">
		<script type="text/javascript">  
		  	$(document).ready(function($){
       			CKEDITOR.replace('MyTextarea',{}); 
       			CKEDITOR.config.width = "620px"
       			CKEDITOR.config.height = "285px"
    		});
		</script>
	</xsl:template>

	<!-- Набор javascript библиотек -->
	<xsl:template name="cssandjs">
		<link type="text/css" rel="stylesheet" href="classic/css/main.css?ver=3"/>
		<link type="text/css" rel="stylesheet" href="classic/css/form.css?ver=3"/>
		<link type="text/css" rel="stylesheet" href="classic/css/actionbar.css?ver=3"/>
		<link type="text/css" rel="stylesheet" href="classic/css/dialogs.css?ver=3"/>
		<link type="text/css" rel="stylesheet" href="/SharedResources/jquery/css/smoothness/jquery-ui-1.8.20.custom.css"/>
		<link type="text/css" rel="stylesheet" href="/SharedResources/jquery/js/hotnav/jquery.hotnav.css"/>
		<script type="text/javascript" src="/SharedResources/jquery/js/jquery-1.4.2.js"/>
		<script type="text/javascript" src="/SharedResources/jquery/js/ui/minified/jquery.ui.core.min.js"/>
		<script type="text/javascript" src="/SharedResources/jquery/js/ui/minified/jquery.effects.core.min.js"/>
		<script type="text/javascript" src="/SharedResources/jquery/js/ui/minified/jquery.ui.widget.min.js"/>
		<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.datepicker.js"/>
		<script type="text/javascript" src="/SharedResources/jquery/js/ui/minified/jquery.ui.mouse.min.js"/>
		<script type="text/javascript" src="/SharedResources/jquery/js/ui/minified/jquery.ui.slider.min.js"/>
		<script type="text/javascript" src="/SharedResources/jquery/js/ui/minified/jquery.ui.progressbar.min.js"/>
		<script type="text/javascript" src="/SharedResources/jquery/js/ui/minified/jquery.ui.autocomplete.min.js"/>
		<script type="text/javascript" src="/SharedResources/jquery/js/ui/minified/jquery.ui.draggable.min.js"/>
		<script type="text/javascript" src="/SharedResources/jquery/js/ui/minified/jquery.ui.position.min.js"/>
		<script type="text/javascript" src="/SharedResources/jquery/js/ui/minified/jquery.ui.dialog.min.js"/>
		<script type="text/javascript" src="/SharedResources/jquery/js/ui/minified/jquery.ui.tabs.min.js"/>
		<script type="text/javascript" src="/SharedResources/jquery/js/ui/minified/jquery.ui.button.min.js"/>
		<script type="text/javascript" src="/SharedResources/jquery/js/moment.js"/>
		<script type="text/javascript" src="classic/scripts/form.js?ver=3"/>
		<script type="text/javascript" src="classic/scripts/coord.js?ver=3"/>
		<script type="text/javascript" src="classic/scripts/dialogs.js?ver=3"/>
		<script type="text/javascript" src="classic/scripts/outline.js?ver=3"/>
		<script type="text/javascript" src="/SharedResources/jquery/js/cookie/jquery.cookie.js"/>
		<script type="text/javascript" src="/SharedResources/jquery/js/ckeditor/ckeditor.js"/>
		<script type="text/javascript" src="/SharedResources/jquery/js/hotnav/jquery.hotkeys.js"/>
		<script type="text/javascript" src="/SharedResources/jquery/js/hotnav/jquery.hotnav.js"/>
		<script type="text/javascript">    
			$(function() {
				$("#tabs").tabs();
				$("#docwrapper button").button();
			});
    	</script>
		<script>
			cancelcaption='<xsl:value-of select="document/captions/cancel/@caption"/>'
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
			lang='<xsl:value-of select="@lang"/>';
			redirectAfterSave = '<xsl:value-of select="history/entry[@type eq 'page'][last()]"/>'
			documentsavedcaption = '<xsl:value-of select="document/captions/documentsavedcaption/@caption"/>';
			attention = '<xsl:value-of select="document/captions/attention/@caption"/>';
			notifyofnewimplement = '<xsl:value-of select="document/captions/notifyofnewimplement/@caption"/>';
			cancel = '<xsl:value-of select="document/captions/cancel/@caption"/>';
			notify = '<xsl:value-of select="document/captions/notify/@caption"/>';
			removefromcontrol = '<xsl:value-of select="document/captions/removefromcontrol/@caption"/>';
			removedcaption ='<xsl:value-of select="document/captions/removedcaption/@caption"/>';
			removedfromcontrol='<xsl:value-of select="document/captions/removedfromcontrol/@caption"/>';
			projects='<xsl:value-of select="document/captions/projects/@caption"/>';
			read = '<xsl:value-of select="document/captions/read/@caption"/>';
			notread = '<xsl:value-of select="document/captions/notread/@caption"/>';
			addcommentforattachment = '<xsl:value-of select="document/captions/addcommentforattachment/@caption"/>';
			addcomment = '<xsl:value-of select="document/captions/addcomment/@caption"/>';
			showfilename = '<xsl:value-of select="document/captions/showfilename/@caption"/>';
			delete_file = '<xsl:value-of select="document/captions/delete_file/@caption"/>';
			pleasewaitdocsave= '<xsl:value-of select="document/captions/pleasewaitdocsave/@caption"/>';
			removedcaption= '<xsl:value-of select="document/captions/removedcaption/@caption"/>';
			showhistoryctrldate= '<xsl:value-of select="document/captions/showhistoryctrldate/@caption"/>';
			hidehistoryctrldate= '<xsl:value-of select="document/captions/hidehistoryctrldate/@caption"/>';
			commentcaption='<xsl:value-of select="document/captions/comments/@caption"/>';
            comment_on_discussion = '<xsl:value-of select="document/captions/comment_on_discussion/@caption"/>';
            write_discussion = '<xsl:value-of select="document/captions/write_discussion/@caption"/>';
            add = '<xsl:value-of select="document/captions/add/@caption"/>';
            sent = '<xsl:value-of select="document/captions/sent/@caption"/>';
            makecomment = '<xsl:value-of select="document/captions/makecomment/@caption"/>';
            fill_topic_title = '<xsl:value-of select="document/captions/fill_topic_title/@caption"/>';
            fill_comment = '<xsl:value-of select="document/captions/fill_comment/@caption"/>';
		</script>
	</xsl:template>

	<xsl:template name="documentheader">
		<div style="position:absolute; top:0px; left:0px; width:100%; height:70px; border-bottom:1px solid rgba(190,213,224,0.89); background:url('classic/img/blue_background.jpg'); z-index:2">
			<span style="float:left">
				<img alt="" src ="/SharedResources/logos/projects_small.png" style="margin:5px 0px 0px 10px"/>
			</span>
			<span style="float:left; margin:15px 0 0 0px">
				<font style="font-size:1.6em; color:#404040; padding-left: 10px">
					Projects
				</font>
				<font style="font-size:0.9em; color:#595959; padding-left: 10px;">
					<xsl:if test="/request/@lang = 'KAZ'"> 
						Жобаларды басқару
					</xsl:if>
					<xsl:if test="/request/@lang = 'RUS'"> 
						Управление проектами
					</xsl:if>
					<xsl:if test="/request/@lang = 'ENG'">
						Projects management
					</xsl:if>
				</font>
			</span>
			<span style="float:right; padding:5px 5px 5px 0px">
				<a id="currentuser" href="Provider?type=edit&amp;element=userprofile&amp;id=userprofile" style="color:#555555; font:11px Tahoma; font-weight:bold;">
					<xsl:attribute name="title" select="document/captions/view_userprofile/@caption"/>
					<xsl:value-of select="@username"/>
				</a>
				<a id="logout" href="Logout" title="{document/captions/logout/@caption}" style="color:#555555; font:11px Tahoma; font-weight:bold; margin-left:15px">
					<xsl:value-of select="document/captions/logout/@caption"/>
				</a>
				<a id="helpbtn" href="Provider?type=static&amp;id=help_summary" title="{document/captions/help/@caption}" style="color:#555555; font:11px Tahoma; font-weight:bold ; margin-left:15px">
					<xsl:value-of select="document/captions/help/@caption"/> 
				</a>
			</span>
		</div>
	</xsl:template>

	<!-- Статус документа -->
	<xsl:template name="markisread">
		<xsl:if test="document[@isread = 0][@status != 'new']">
			<script>
				markRead(<xsl:value-of select="document/@doctype"/>, <xsl:value-of select="document/@docid"/>);
			</script>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="docinfo">
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
							<xsl:when test="$editmode='view'">
								<xsl:value-of select="document/captions/readonly/@caption"/>
							</xsl:when>
							<xsl:when test="$editmode='readonly'">
								<xsl:value-of select="document/captions/readonly/@caption" />
							</xsl:when>
							<xsl:when test="$editmode='edit'">
								<xsl:value-of select="document/captions/editing/@caption" />
							</xsl:when>
							<xsl:when test="$editmode='noaccess'">
								<xsl:value-of select="document/captions/readonly/@caption" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="document/captions/modenotdefined/@caption"/>
							</xsl:otherwise>
						</xsl:choose>
					</font>
				</td>
			</tr>
			<xsl:if test="document/@status !='new'">
				<tr>
					<td class="fc">
						<xsl:value-of select="document/captions/infofread/@caption"/> :
					</td>
					<td>
						<font>
							<xsl:choose>
								<xsl:when test="document/@isread ='1'">
									<xsl:value-of select="document/captions/read/@caption"/>
								</xsl:when>
								<xsl:otherwise> 
									<xsl:value-of select="document/captions/notread/@caption"/>
								</xsl:otherwise>
							</xsl:choose>
						</font>		
					</td>
				</tr>
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
									<font>
										<xsl:value-of select="document/captions/infofreaders/@caption"/>
									</font>
								</td>
								<td style="width:250px; text-align:center">
									<font>
										<xsl:value-of select="document/captions/readtime/@caption"/>
									</font>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</xsl:if>
		</table>
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
							<style>.ui-progressbar .ui-progressbar-value {background-image: url(/SharedResources/jquery/css/base/images/pbar-ani.gif);}</style>
							<div id="progressbar" style="width:370px; margin-top:5px; height:12px"></div>
							<div id="progressstate" style="width:370px; display:none">
								<font style="visibility:hidden; color:#999; font-size:11px; width:70%" id="readybytes"/>
								<font style="visibility:hidden; color:#999; font-size:11px; float:right;" id="percentready"/>
								<font style="visibility:hidden; text-align:center; color:#999; font-size:11px; width:30%; text-align:center" id="initializing">Подготовка к загрузке</font>
							</div>
						</td>
						<td/>
					</tr>
				</xsl:if>
				<xsl:variable name='docid' select="document/@docid"/>
				<xsl:variable name='doctype' select="document/@doctype"/>
				<xsl:variable name='formsesid' select="formsesid"/>
				
				<xsl:for-each select="document/fields/rtfcontent/entry">
					<tr id="{@hash}">
						<xsl:variable name='id' select='@hash'/>
						<xsl:variable name='filename' select='@filename'/>
						<xsl:variable name="extension" select="tokenize(lower-case($filename), '\.')[last()]"/>
						<xsl:variable name="resolution"/>
						<td class="fc"></td>
						<td colspan="2">
							<div class="test" style="width:90%; overflow:hidden; display:inline-block">
								<xsl:choose>
									<xsl:when test="$extension = 'jpg' or $extension = 'jpeg' or $extension = 'gif' or $extension = 'bmp' or $extension = 'png'">
										<img class="imgAtt" title="{$filename}" style="border:1px solid lightgray; max-width:800px; max-height:600px; margin-bottom:5px">
											<xsl:attribute name="onload">checkImage(this)</xsl:attribute>
											<xsl:attribute name='src'>Provider?type=getattach&amp;formsesid=<xsl:value-of select="$formsesid"/>&amp;doctype=<xsl:value-of select="$doctype"/>&amp;key=<xsl:value-of select="@id"/>&amp;field=rtfcontent&amp;id=rtfcontent&amp;file=<xsl:value-of select='$filename'/></xsl:attribute>
										</img>
										<xsl:if test="$editmode = 'edit'">
											<xsl:if test="comment =''">
												<a href='' style="vertical-align:top;">
													<xsl:attribute name='href'>javascript:addCommentToAttach('<xsl:value-of select="$id"/>')</xsl:attribute>
													<img id="commentaddimg{$id}" src="/SharedResources/img/classic/icons/comment_add.png" style="width:16px; height:16px" >
														<xsl:attribute name ="title"><xsl:value-of select ="//document/captions/add_comment/@caption"/></xsl:attribute>
													</img>
												</a>
											</xsl:if>
											<a href='' style="vertical-align:top; margin-left:8px">
												<xsl:attribute name='href'>javascript:deleterow('<xsl:value-of select="$formsesid"/>','<xsl:value-of select='$filename'/>','<xsl:value-of select="$id"/>')</xsl:attribute>
												<img src="/SharedResources/img/iconset/cross.png" style="width:13px; height:13px">
													<xsl:attribute name="title" select="//document/captions/delete_file/@caption"/>
												</img>
											</a>
										</xsl:if>
									</xsl:when>
									<xsl:otherwise>
										<img src="/SharedResources/img/iconset/file_extension_{$extension}.png" style="margin-right:5px">
											<xsl:attribute name="onerror">javascript:changeAttIcon(this)</xsl:attribute>
										</img>
										<a style="vertical-align:5px">
											<xsl:attribute name='href'>Provider?type=getattach&amp;formsesid=<xsl:value-of select="$formsesid"/>&amp;doctype=<xsl:value-of select="$doctype"/>&amp;key=<xsl:value-of select="@id"/>&amp;field=rtfcontent&amp;id=rtfcontent&amp;file=<xsl:value-of select='$filename'/>	</xsl:attribute>
											<xsl:value-of select='replace($filename,"%2b","+")'/>
										</a>&#xA0;&#xA0;
										<xsl:if test="$editmode = 'edit'">
											<xsl:if test="comment =''">
												<a href='' style="vertical-align:5px;">
													<xsl:attribute name='href'>javascript:addCommentToAttach('<xsl:value-of select="$id"/>')</xsl:attribute>
													<img id="commentaddimg{$id}" src="/SharedResources/img/classic/icons/comment_add.png" style="width:16px; height:16px">
														<xsl:attribute name="title" select="//document/captions/add_comment/@caption"/>
													</img>
												</a>
											</xsl:if>
											<a href='' style="vertical-align:5px; margin-left:5px">
												<xsl:attribute name='href'>javascript:deleterow('<xsl:value-of select="$formsesid"/>','<xsl:value-of select='$filename' />','<xsl:value-of select="$id"/>')</xsl:attribute>
												<img src="/SharedResources/img/iconset/cross.png" style="width:13px; height:13px">
													<xsl:attribute name="title" select="//document/captions/delete_file/@caption"/>
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
								<xsl:value-of select="concat(//document/captions/comments/@caption,' : ',comment)"/>
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
	
	<xsl:template name="outline-section-state">
		<script>
			if($.cookie("PROJECTS_<xsl:value-of select='@id'/>")){
				$("#<xsl:value-of select='@id'/>").css("display",$.cookie("PROJECTS_<xsl:value-of select='@id'/>"))
				if($.cookie("PROJECTS_<xsl:value-of select='@id'/>") == "none"){
					$("img.<xsl:value-of select='@id'/>toogle_img").attr("src","/SharedResources/img/classic/1/plus.png")							
					$("img.<xsl:value-of select='@id'/>folder_img").attr("src","/SharedResources/img/classic/1/folder_close_view.png")							
				}
			} 
		</script>	
	</xsl:template>
	
	<!-- Outline -->
	<xsl:template name="formoutline">
		<div id="outline">
			<div id="outline-container" style="width:303px; padding-top:10px">
				<xsl:for-each select="//response/content/outline/outline">
					<div>
						<div class="treeentry" style="height:17px; padding:3px 0px 3px 0px  ; border:1px solid #F9F9F9; width:auto">								
							<img src="/SharedResources/img/classic/1/minus.png" style="margin-left:6px; cursor:pointer" alt="">
								<xsl:attribute name="onClick">javascript:ToggleCategory(this)</xsl:attribute>
							</img>
							<img src="/SharedResources/img/classic/1/folder_open_view.png" style="margin-left:5px; " alt=""/>
							<font style="font-family:arial; font-size:0.9em; margin-left:4px; vertical-align:3px">											
								<xsl:value-of select="@hint"/>
							</font>
						</div>
						<div style="clear:both;"/>
						<div class="outlineEntry" id="{@id}">
							<xsl:call-template name="outline-section-state"/>
							<xsl:for-each select="entry">
								<div class="entry treeentry" style="width:298px; padding:3px 0px 3px 0px; border:1px solid #F9F9F9;">
									<xsl:if test="/request/@id = @id">
										<xsl:attribute name="class">entry treeentrycurrent</xsl:attribute>										
									</xsl:if>
									<xsl:if test="contains(@url, //current_outline_entry/response/content/entry/@entryid) and //current_outline_entry/response/content/entry/@entryid != '' ">
										<xsl:attribute name="class">entry treeentrycurrent</xsl:attribute>										
									</xsl:if>
									<xsl:if test="@id = 'demands'">
										<img src="/SharedResources/img/classic/1/minus.png" style="margin-left:35px; cursor:pointer; float:left">
											<xsl:attribute name="onClick">javascript:ToggleCategory(this)</xsl:attribute>
										</img>
									</xsl:if>
									<a href="{@url}" style="width:90%; vertical-align:top; text-decoration:none !important;" title="{@hint}">
										<div class="viewlink">
											<xsl:if test="/request/@id = @id">
												<xsl:attribute name="class">viewlink_current</xsl:attribute>										
											</xsl:if>
											<xsl:if test="contains(@url, //current_outline_entry/response/content/entry/@entryid) and //current_outline_entry/response/content/entry/@entryid != '' ">
												<xsl:attribute name="class">viewlink_current</xsl:attribute>										
											</xsl:if>
											<xsl:if test="@id = 'demands'">
												<xsl:attribute name="style">width:80%;</xsl:attribute>
											</xsl:if>	
											<div style="padding-left:35px; white-space:nowrap">
												<xsl:if test="@id = 'demands'">
													<xsl:attribute name="style">padding-left:5px; white-space:nowrap</xsl:attribute>
												</xsl:if>
												<xsl:if test="@id !='favdocs' and (@id != 'recyclebin')">
													<img src="/SharedResources/img/classic/1/doc_view.png" style="cursor:pointer"/>
												</xsl:if>
												<xsl:if test="@id ='favdocs'">
													<img src="/SharedResources/img/iconset/star_full.png" height="17px" style="cursor:pointer"/>
												</xsl:if>
												<xsl:if test="@id ='recyclebin'">
													<img src="/SharedResources/img/iconset/bin.png" height="17px" style="cursor:pointer"/>
												</xsl:if>													 
												<font class="viewlinktitle">												
													 <xsl:value-of select="@caption"/>										
												</font>
											</div>
										</div>
									</a>
								</div>
								<div style="clear:both;"/>
								<div class="outlineEntry" id="{@id}">
									<xsl:call-template name="outline-section-state"/>
									<xsl:for-each select="entry">
										<xsl:sort select="@caption"/>
										<div class="entry treeentry" style="width:298px; padding:3px 0px 3px 15px; border:1px solid #F9F9F9;">
											<xsl:if test="/request/@id = @id">
												<xsl:attribute name="class">entry treeentrycurrent</xsl:attribute>										
											</xsl:if>
											<xsl:if test="contains(@url, /request/page/outline/page/current_outline_entry/response/content/entry/@entryid) and /request/page/outline/page/current_outline_entry/response/content/entry/@entryid != '' ">
												<xsl:attribute name="class">entry treeentrycurrent</xsl:attribute>										
											</xsl:if>
											<a href="{@url}" style="width:90%; vertical-align:top; text-decoration:none !important" title="{@hint}">
												<div class="viewlink">
													<xsl:if test="/request/@id = @id">
														<xsl:attribute name="class">viewlink_current</xsl:attribute>										
													</xsl:if>	
													<xsl:if test="contains(@url, /request/page/outline/page/current_outline_entry/response/content/entry/@entryid) and /request/page/outline/page/current_outline_entry/response/content/entry/@entryid != '' ">
														<xsl:attribute name="class">viewlink_current</xsl:attribute>										
													</xsl:if>	
													<div style="padding-left:55px; white-space:nowrap">
														<xsl:if test="@id !='favdocs' and (@id != 'recyclebin')">
															<img src="/SharedResources/img/classic/1/doc_view.png" style="cursor:pointer"/>
														</xsl:if>
														<xsl:if test="@id = 'favdocs'">
															<img src="/SharedResources/img/iconset/star_full.png" height="17px" style="cursor:pointer"/>
														</xsl:if>
														<xsl:if test="@id ='recyclebin'">
															<img src="/SharedResources/img/iconset/bin.png" height="17px" style="cursor:pointer"/>
														</xsl:if>													 
														<font class="viewlinktitle">												
															 <xsl:value-of select="@caption"/>										
														</font>
													</div>
												</div>
											</a>
										</div>
									</xsl:for-each>
								</div>
							</xsl:for-each>
						</div>
					</div>
				</xsl:for-each>
			</div>
		</div>
		<div id="resizer" onclick="javascript: openformpanel()">
			<span id="iconresizer" class="ui-icon ui-icon-triangle-1-e" style="margin-left:-2px; position:relative; top:49%"/>
		</div>
	</xsl:template>
	
	<xsl:template name="import">
		<div id="attach" style="display:block;">
			<table style="border:0; border-collapse:collapse" id="upltable" width="99%">
				<xsl:if test="document/@editmode = 'edit'">
					<tr>
						<td class="fc">
							<xsl:value-of select="document/captions/attachments/@caption"/> :
						</td>
						<td>
							<input type="file" id="fname" size="60" border="#CCC" name="fname"/>
							&#xA0;
							<a id="upla">
								<xsl:attribute name="href">javascript:uploadFile('upload', 'fname')</xsl:attribute>
								<font style="font-size:13px">
									<xsl:value-of select="document/captions/attach/@caption"/>
								</font> 
							</a>
						</td>
						<td></td>
					</tr>
				</xsl:if>
			</table>
			 <div id="editor"></div>
			<br/>
			<br/>
		</div>
	</xsl:template>
	
	<xsl:template name="docdiscussion">
		<br/>
		<xsl:if test="document/@status !='new'">
			<button type="button" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" id="btnnewcomment" style="margin-left:10px;" title="{//captions/adddiscussion/@caption}">
				<xsl:if test="document/@topicid != '0' and document/@topicid != 'null'">
                    <xsl:attribute name="title" select="//captions/write_discussion/@caption"/>
					<xsl:attribute name="onclick">javascript:addCommentToForum(this,<xsl:value-of select='document/@topicid'/>,904)</xsl:attribute>
				</xsl:if>
				<xsl:if test="document/@topicid = '0' or document/@topicid = 'null'">
				 	<xsl:attribute name="onclick">javascript:addTopicToForum(this,<xsl:value-of select='document/@docid'/>,<xsl:value-of select='document/@doctype'/>)</xsl:attribute>
                    <xsl:attribute name="title" select="//captions/adddiscussion/@caption"/>
                </xsl:if>
				<img src="/SharedResources/img/classic/icons/comment.png" class="button_img"/>
				<font style="font-size:12px; vertical-align:top">
					<xsl:if test="document/@topicid != '0'">
                        <xsl:value-of select="//captions/write_discussion/@caption"/>
                    </xsl:if>
					<xsl:if test="document/@topicid = 'null' or document/@topicid = '0'">
                        <xsl:value-of select="//captions/adddiscussion/@caption"/>
                    </xsl:if>
				</font>
			</button>
			<br/>
			<br/>
			<span id="bordercomment"/>
			<xsl:if test="document/@topicid != '0' and document/@topicid != 'null'">
				<tr>
					<td>
						<div display="block" style="display:block; width:90%" id="topic">
							<div id="headerTheme" style="width:100%; padding-left:10px"/>
							<div id="infoTheme" style="width:100%; padding-left:10px; padding-top:3px"/>
							<br/>
							<div id="CountMsgTheme" style="color:#555555; padding:12px; background:#E6E6E6; border:1px solid #D3D3D3; margin-left:10px; border-radius: 5px 5px 0px 0px; height:20px; font-size: 13px; font-weight: 300; overflow: hidden;"/>
							<div id="msgWrapper" style="min-height:150px; margin-left:10px"/>
							<table id="topicTbl" style=" width:100%"/>
							<br/>
						</div>
					</td>
				</tr>
			</xsl:if>
		</xsl:if>
	</xsl:template>
    <xsl:template name="datepicker">
        <xsl:if test="document/@editmode = 'edit'">
            <xsl:if test="/request/@lang = 'KAZ'">
                <script>
                    $(function() {
                        $('.eventdate').datepicker({
                            showOn: 'button',
                            buttonImage: '/SharedResources/img/iconset/calendar.png',
                            buttonImageOnly: true,
                            regional:['ru'],
                            showAnim: '',
                            changeYear:  true,
                            yearRange: '-5:+5',
                            changeMonth: true,
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
            <xsl:if test="/request/@lang = 'RUS'">
                <script>
                    $(function() {
                        $('.eventdate').datepicker({
                            showOn: 'button',
                            buttonImage: '/SharedResources/img/iconset/calendar.png',
                            buttonImageOnly: true,
                            regional:['ru'],
                            showAnim: '',
                            changeYear:  true,
                            yearRange: '-5:+5',
                            changeMonth: true
                        });
                    });
                </script>
            </xsl:if>
        </xsl:if>
        <xsl:if test="/request/@lang = 'ENG'">
            <script>
                $(function() {
                    $('.eventdate').datepicker({
                        showOn: 'button',
                        buttonImage: '/SharedResources/img/iconset/calendar.png',
                        buttonImageOnly: true,
                        regional:['ru'],
                        showAnim: '',
                        changeYear : true,
                        changeMonth : true,
                        yearRange: '-5:+5',
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
    </xsl:template>
</xsl:stylesheet>