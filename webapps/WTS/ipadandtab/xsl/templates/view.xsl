<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:template name="flashentry">	
		<xsl:if test="query/@flashdocid !=''">
			<script type="text/javascript">
				$("document").ready(
					function() { flashentry(<xsl:value-of select="query/@flashdocid"/><xsl:value-of select="query/@flashdoctype"/>);}
				);
			</script>
		</xsl:if>	
	</xsl:template>
	
	<xsl:template name="header-view">	
		<div id="header-view">
			<span style="float:left">
				<img alt="" src ="classic/img/bigroup/logo_small.png" style="margin:5px"/>
				<font style="font-size:1.15em; vertical-align:25px; color:#555555"><xsl:value-of select="columns/column[@id = 'APPCAPTION']/@caption"/></font>
			</span>
			<span style="float:right; padding:5px 5px 5px 0px">
				<div class="sarea" style="margin-top:15px; text-align:right">
					<input id="searchInput" style="padding:0.49em 0.9em; width:200px; margin-right:3px; vertical-align:top; border:1px solid #ccc; margin-top:0px">
						<xsl:attribute name="value"><xsl:value-of select="query/@keyword"/></xsl:attribute>
					</input> 
					<script>
						$("#searchInput").keydown(function(e){ if (e.which ==13){ search(); } });
					</script> 
					<button id="btnsearch" title="Поиск" style="vertical-align:top; text-align:center">
						<xsl:attribute name="onclick">javascript:search()</xsl:attribute>
						<img src="/SharedResources/img/iconset/magnifier.png" class="button_img" style="margin-left:-13px; margin-top:-6px"/>
					</button>
					<script type="text/javascript">    
				   		$(function() {
							$(".sarea button").button();
							$(".sarea button").css("width","26px");
							$(".sarea button").css("height","26px");
							$("#btnsearch span").css("padding-top","0px");
							$("#btnsearch span").css("padding-left","2px");
				    	});
	    			</script>
				</div>
			</span>				
		</div>
	</xsl:template>
	
	<xsl:template name="outline-menu-view">	
		<div id="outline">
			<div id="outline-container" style="width:300px; padding-top:10px">
				<xsl:for-each select="outline/entry">
					<div >
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
							<script>
								if	($.cookie("WTS_<xsl:value-of select='@id'/>") != 'null'){
									$("#<xsl:value-of select='@id'/>").css("display",$.cookie("WTS_<xsl:value-of select='@id'/>"))
									if($.cookie("WTS_<xsl:value-of select='@id'/>") == "none"){
										$("#<xsl:value-of select='@id'/>").prev().prev().children("img:first").attr("src","/SharedResources/img/classic/1/plus.png")							
										$("#<xsl:value-of select='@id'/>").prev().prev().children("img:last").attr("src","/SharedResources/img/classic/1/folder_close_view.png")							
									}else{
										$("#<xsl:value-of select='@id'/>").prev().prev().children("img:first").attr("src","/SharedResources/img/classic/1/minus.png")							
										$("#<xsl:value-of select='@id'/>").prev().prev().children("img:last").attr("src","/SharedResources/img/classic/1/folder_open_view.png")
									}
								}
							</script>
							<xsl:for-each select="entry">
								<div class="entry treeentry" style="width:auto; padding:3px 0px 3px 0px; border:1px solid #F9F9F9; " >
									<xsl:if test="/request/@id = @id">
										<xsl:attribute name="class">entry treeentrycurrent</xsl:attribute>										
									</xsl:if>
									<div class="viewlink">
										<xsl:if test="/request/@id = @id">
											<xsl:attribute name="class">viewlink_current</xsl:attribute>										
										</xsl:if>	
										<div style="padding-left:35px">
											<img src="/SharedResources/img/classic/1/doc_view.png" style="cursor:pointer"/>
											<a href="{@url}" style="width:100%; vertical-align:top; text-decoration:none !important" title="{@hint}">
												<xsl:if test="../@id = 'filters'">
													<xsl:attribute name="href"><xsl:value-of select="@url"/>&amp;filterid=<xsl:value-of select="@id"/></xsl:attribute>
												</xsl:if>
												<font class="viewlinktitle">	
													 <xsl:value-of select="@caption"/>
												</font>
											</a>
										</div>
									</div>
								</div>
							</xsl:for-each>
						</div>
					</div>
				</xsl:for-each>
			</div>
		</div>
		<div id="resizer" style="position:absolute; top: 80px; left:306px; background:#E6E6E6; width:12px; bottom:0px; border-radius: 0 6px 6px 0; border: 1px solid #adadad; border-left: ; cursor:pointer" onclick="javascript: closepanel()">
			<span  id="iconresizer" class="ui-icon ui-icon-triangle-1-w" style="margin-left:-2px; position:relative; top:49%"></span>
		</div>
	</xsl:template>

	<xsl:template name="viewtable_dblclick_open">	
		<script>
			$("."+<xsl:value-of select="@docid"/>).dblclick( function(event){
  				if (event.target.nodeName != "INPUT" &amp;&amp;  event.target.nodeName != "IMG"){
  					beforeOpenDocument();
  					window.location = '<xsl:value-of select="@url"/>'
  				}
			});
		</script>
	</xsl:template>

	<xsl:template name="prepagelistsearch">
		<xsl:if test="query/@maxpage !=1">
			<table class="pagenavigator">
				<xsl:variable name="curpage" select="query/@currentpage"/>
				<xsl:variable name="prevpage" select="$curpage -1 "/>
				<xsl:variable name="beforecurview" select="substring-before(@id,'.')"/> 
            	<xsl:variable name="aftercurview" select="substring-after(@id,'.')"/> 
            	<xsl:variable name="keyword" select="query/@keyword"/> 
				<tr>
					<xsl:if test="query/@currentpage>1">
						<td>
							<a href="">
								<xsl:attribute name="href">javascript:doSearch('<xsl:value-of select="$keyword"/>',1)</xsl:attribute>
								<font style="font-size:12px">&lt;&lt;</font>
							</a>&#xA0;
						</td>
						<td>
							<a href="">
								<xsl:attribute name="href">javascript:doSearch('<xsl:value-of select="$keyword"/>',<xsl:value-of select="$prevpage"/>)</xsl:attribute>
								<font style="font-size:12px">&lt;</font>
							</a>&#xA0;
						</td>
					</xsl:if>
					<xsl:call-template name="pagenavigSearch"/>
					<xsl:if test="query/@maxpage > 15">
						<xsl:variable name="beforecurview" select="substring-before(@id,'.')"/> 
                		<xsl:variable name="aftercurview" select="substring-after(@id,'.')"/> 
						<td>
							<select>
								<xsl:attribute name="onChange">javascript:doSearch('<xsl:value-of select="$keyword"/>',this.value)</xsl:attribute>
			 					<xsl:call-template name="combobox"/>
			 				</select>
			 			</td>
					</xsl:if>
				</tr>
			</table>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="search">
		 <input id="searchInput" style=" padding:0.25em 0.9em; width:200px; margin-right:3px; vertical-align:top">
			<xsl:attribute name="value">
				<xsl:value-of select="query/@keyword"/>
			</xsl:attribute>
		</input> 
  		<script>
  			$("#searchInput").keydown(function(e){ if (e.which ==13){ search(); } });
  		</script> 
			<button id="btnsearch" title="Поиск">
				<xsl:attribute name="onclick">javascript:search()</xsl:attribute>
				<div style="text-align:center">
					<img src="/SharedResources/img/classic/icons/magnifier.png" style="border:none; position:absolute; left:8px; top:5px; width:16px; height:16px "></img>
				</div>
			</button>
		<div id="advancedSearchDiv" style="border:2px solid #ccc; background:#ffffff; display:none; margin-top:3.5%; right:0;  width:53%; position:absolute; height:100px;">
			<table style=" font-size:12px; width:100%">
				<tr>
					<td> 
						<input type="checkbox" name="typefinddoc" value="in">Входящий</input>&#xA0;
						<input type="checkbox" name="typefinddoc" value="ish" style="margin-left:12.4%">Исходящий</input>&#xA0;
						<input type="checkbox" name="typefinddoc" value="in">Карточка исполнения</input>&#xA0;
					</td>
				</tr>
				<tr style="height:28px">
					<td> 
						<input type="checkbox" name="typefinddoc" value="in">Служебная записка</input>&#xA0;
						<input type="checkbox" name="typefinddoc" value="prj">Проект</input>&#xA0;
						<input type="checkbox" name="typefinddoc" value="in" style="margin-left:5.2%">Резолюция</input>&#xA0;
					</td>
				</tr>
				<tr>
					<td> 
						<b>Дата создания:</b>
 					</td>
 				</tr>
 				<tr>
 					<td>
 						&#xA0;с &#xA0;
 						<input type="text" id="fromdate" name="fromdate" size="14" class="rof" style="height:22px" readonly="readonly">
							<xsl:attribute name="value">
								<xsl:value-of select="document/fields/from" />
							</xsl:attribute>
						</input>&#xA0;
 						по&#xA0;
 						<input type="text" id="todate" name="todate" size="14" class="rof" style="height:22px" readonly="readonly">
							<xsl:attribute name="value">
								<xsl:value-of select="document/fields/to"/>
							</xsl:attribute>
						</input>&#xA0;
 						<input type="checkbox" name="control" value="1">Контрольный</input>&#xA0;
 						<script>
							$(function() {
								$('#fromdate').datepicker({
									showOn: 'button',
									buttonImage: '/SharedResources/img/iconset/calendar.png',
									buttonImageOnly: true,
									regional:['ru'],
									showAnim: ''
								});
								$('#todate').datepicker({
									showOn: 'button',
									buttonImage: '/SharedResources/img/iconset/calendar.png',
									buttonImageOnly: true,
									regional:['ru'],
									showAnim: ''
								});
							});
						</script>
 					</td>
 				</tr>
 			</table>
 		</div>
	</xsl:template>
	
	<xsl:template name="viewinfo">
		<div style="height:30px">
			<table style="width:99%; margin-left:3px;" class="time">
				<tr>
					<td>
						<font style="font-size:14px; padding-right:10px; font-weight:bold">
							<xsl:value-of select="columns/column[@id = 'VIEW']/@caption"/>
						</font>
						<font class="time">
							<xsl:value-of select="columns/column[@id = 'PAGE']/@caption"/>:&#xA0;<xsl:value-of select="query/@currentpage"/>  &#xA0;<xsl:value-of select="columns/column[@id = 'FROM']/@caption"/>  &#xA0;<xsl:value-of select="query/@maxpage"/>
						</font>
					</td>
					<td>
<!-- 						<xsl:call-template name="prepagelist"/> -->
					</td>
					<td style="text-align:right; font-size: 12px ">
						<font class="time" >
							<xsl:value-of select="columns/column[@id = 'DOCUMENTS']/@caption"/>: <xsl:value-of select="query/@count"/>
						</font>
					</td>
				</tr>
			</table>
		</div>
	</xsl:template>
	
	<xsl:template name="prepagelist">
		<xsl:if test="query/@maxpage !=1">
			<table class="pagenavigator" style="margin:0px auto">
				<xsl:variable name="curpage" select="query/@currentpage"/>
				<xsl:variable name="prevpage" select="$curpage -1 "/>
				<xsl:variable name="beforecurview" select="substring-before(@id,'.')"/> 
            	<xsl:variable name="aftercurview" select="substring-after(@id,'.')"/> 
				<tr>
					<xsl:if test="query/@currentpage>1">
						<td>
							<a href="">
								<xsl:attribute name="href">javascript:updateView('view','<xsl:value-of select="@id"/>',1)</xsl:attribute>
								<font style="font-size:12px">&lt;&lt;</font>
							</a>&#xA0;
						</td>
						<td>
							<a href="">
								<xsl:attribute name="href">javascript:updateView('view','<xsl:value-of select="@id"/>',<xsl:value-of select="$prevpage"/>)</xsl:attribute>
								<font style="font-size:12px">&lt;</font>
							</a>&#xA0;
						</td>
					</xsl:if>
					<xsl:call-template name="pagenavig"/>
					<xsl:if test="query/@maxpage > 15">
						<xsl:variable name="beforecurview" select="substring-before(@id,'.')"/> 
                		<xsl:variable name="aftercurview" select="substring-after(@id,'.')"/> 
						<td>
							<select>
								<xsl:attribute name="onChange">javascript:updateView(&quot;<xsl:value-of select="@type"/>&quot;,&quot;<xsl:value-of select="@id"/>&quot;,this.value)</xsl:attribute>
			 					<xsl:call-template name="combobox"/>
			 				</select>
			 			</td>
					</xsl:if>
				</tr>
			</table>
		</xsl:if>
	</xsl:template>
	
	<!--	навигатор по страницам -->
	<xsl:template name="pagenavig">
 		<xsl:param name="i" select="1"/>  <!-- счетчик количества страниц отображаемых в навигаторе  -->
 		<xsl:param name="n" select="15"/> <!-- количество страниц отображаемых в навигаторе -->
  		<xsl:param name="z" select="query/@maxpage -14"/>
  		<xsl:param name="f" select="15"/>
 		<xsl:param name="c" select="query/@currentpage"/> <!-- текущая страница в виде -->
 		<xsl:param name="startnum" select="query/@currentpage - 7"/> 
  		<xsl:param name="d" select="query/@maxpage - 14"/>	<!-- переменная для вычисления начального номера страницы в навигаторе  -->
  		<xsl:param name="currentpage" select="query/@currentpage"/>
  		<xsl:param name="maxpage" select="query/@maxpage"/>
  		<xsl:param name="nextpage" select="$currentpage + 1"/>
  		<xsl:param name="prevpage" select="$currentpage - 1"/>
  		<xsl:param name="curview" select="@id"/> 
  		<xsl:param name="direction" select="query/@direction"/> 
		<xsl:choose>
			<xsl:when test="$maxpage>15">
				<xsl:choose>
					<xsl:when test="$maxpage - $currentpage &lt; 7">
						<xsl:if test="$i != $n+1">
							<xsl:if test="$z &lt; $maxpage + 1">
								<td>
									<a href="">
   										<xsl:attribute name="href">javascript:updateView('view','<xsl:value-of select="@id"/>',<xsl:value-of select="$z"/>)</xsl:attribute>
   			 								<font style="font-size:12px">
    											<xsl:if test="$z=$currentpage">
    												<xsl:attribute name="style">font-weight:bold;font-size:1.3em</xsl:attribute>
    											</xsl:if>
    											<xsl:value-of select="$z"/>
    										</font>
   									</a>&#xA0;
								</td>
							</xsl:if>
      						<xsl:call-template name="pagenavig">
	        					<xsl:with-param name="i" select="$i + 1"/>
	        					<xsl:with-param name="n" select="$n"/>
	        					<xsl:with-param name="z" select="$z+1"/>
      						</xsl:call-template>
						</xsl:if>
						<xsl:if test="$currentpage != $maxpage">
							<xsl:if test="$i = $n+1">
		 						<td>
     								<a href="">
      									<xsl:attribute name="href">javascript:updateView('view','<xsl:value-of select="@id"/>',<xsl:value-of select="$nextpage"/>)</xsl:attribute>
      									<font style="font-size:12px"> > </font>
      								</a>
      							</td>
       							<td>
       								<a href="">
       									<xsl:attribute name="href">javascript:updateView('view','<xsl:value-of select="@id"/>',<xsl:value-of select="$maxpage"/>)</xsl:attribute>
       									<font style="font-size:12px; margin-left:7px"> >> </font>
       								</a> 
						        </td>
							</xsl:if>
   						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$currentpage &lt; 7">
								<xsl:if test="$i=1">
									<xsl:if test="$currentpage = 1">
										<td>
											&#xA0;&#xA0;&#xA0;&#xA0;	
										</td>
										<td>
											&#xA0;&#xA0;&#xA0;
										</td>
									</xsl:if>
								</xsl:if>
								<xsl:if test="$i != $n+1">
									<xsl:if test="$i &lt; $maxpage + 1">
										<td>
											<a href="">
   				 								<xsl:attribute name="href">javascript:updateView('view','<xsl:value-of select="@id"/>',<xsl:value-of select="$i"/>)</xsl:attribute>
												<font style="font-size:12px">
    												<xsl:if test="$i=$currentpage">
    													<xsl:attribute name="style">font-weight:bold;font-size:1.3em</xsl:attribute>
    												</xsl:if>
    												<xsl:value-of select="$i"/>
    											</font>
						   					</a>&#xA0;
										</td>
									</xsl:if>
      								<xsl:call-template name="pagenavig">
	        							<xsl:with-param name="i" select="$i + 1"/>
	        							<xsl:with-param name="n" select="$n"/>
	        							<xsl:with-param name="c" select="$c+1"/>
      								</xsl:call-template>
      							</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="$i != $n+1">
									<xsl:if test="$i &lt; $maxpage + 1">
										<xsl:if test="$startnum !=0">
											<td>
												<a href="">
   				 									<xsl:attribute name="href">javascript:updateView('view','<xsl:value-of select="@id"/>',<xsl:value-of select="$startnum"/>)</xsl:attribute>
													<font style="font-size:12px">
    													<xsl:if test="$startnum=$currentpage">
    														<xsl:attribute name="style">font-weight:bold;font-size:1.3em</xsl:attribute>
    													</xsl:if>
    													<xsl:value-of select="$startnum"/>
    												</font>
						   						</a>&#xA0;
											</td>
										</xsl:if>
									</xsl:if>
									<xsl:if test="$startnum != 0">
      									<xsl:call-template name="pagenavig">
											<xsl:with-param name="i" select="$i + 1"/>
	        								<xsl:with-param name="n" select="$n"/>
	        								<xsl:with-param name="c" select="$c+1"/>
	        								<xsl:with-param name="startnum" select="$c - 6"/>
      									</xsl:call-template>
      								</xsl:if>
									<xsl:if test="$startnum = 0">
      									<xsl:call-template name="pagenavig">
										<xsl:with-param name="i" select="$i"/>
	        							<xsl:with-param name="n" select="$n"/>
	        							<xsl:with-param name="c" select="$c+1"/>
	        							<xsl:with-param name="startnum" select="$c - 6"/>
      								</xsl:call-template>
      							</xsl:if>
      						</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
						<xsl:if test="$currentpage != $maxpage">
							<xsl:if test="$i = $n+1">
		 						<td>
      								<a href="">
     									<xsl:attribute name="href">javascript:updateView('view','<xsl:value-of select="@id"/>',<xsl:value-of select="$nextpage"/>)</xsl:attribute>
     									<font style="font-size:12px"> > </font>
     								</a>
							    </td>
       							<td>
       								<a href="">
       									<xsl:attribute name="href">javascript:updateView('view','<xsl:value-of select="@id"/>',<xsl:value-of select="$maxpage"/>)</xsl:attribute>
       									<font style="font-size:12px; margin-left:7px"> >> </font>
       								</a>
							    </td>
							</xsl:if>
  						</xsl:if>
						
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$i=1">
					<xsl:if test="$currentpage = 1">
						<td>
							&#xA0;&#xA0;&#xA0;&#xA0;	
						</td>
						<td>
							&#xA0;&#xA0;&#xA0;
						</td>
					</xsl:if>
				</xsl:if>
				<xsl:if test="$i != $n+1">
					<xsl:if test="$i &lt; $maxpage + 1">
						<td>
							<a href="">
   								<xsl:attribute name="href">javascript:updateView('view','<xsl:value-of select="@id"/>',<xsl:value-of select="$i"/>)</xsl:attribute>
   			 					<font style="font-size:12px">
    								<xsl:if test="$i=$currentpage">
    									<xsl:attribute name="style">font-weight:bold;font-size:1.3em</xsl:attribute>
    								</xsl:if>
    								<xsl:value-of select="$i"/>
    							</font>
						    </a>&#xA0;
						</td>
					</xsl:if>
      				<xsl:call-template name="pagenavig">
	        			<xsl:with-param name="i" select="$i + 1"/>
	        			<xsl:with-param name="n" select="$n"/>
	        			<xsl:with-param name="c" select="$c+1"/>
      				</xsl:call-template>
				</xsl:if>
				<xsl:if test="$currentpage != $maxpage">
					<xsl:if test="$i = $n+1">
						<td>
      						<a href="">
      							<xsl:attribute name="href">javascript:updateView('view','<xsl:value-of select="@id"/>',<xsl:value-of select="$nextpage"/>)</xsl:attribute>
      							<font style="font-size:12px"> > </font>
      						</a>
					    </td>
       					<td>
       						<a href="">
       							<xsl:attribute name="href">javascript:updateView('view','<xsl:value-of select="@id"/>',<xsl:value-of select="$maxpage"/>)</xsl:attribute>
       							<font style="font-size:12px; margin-left:7px"> >> </font>
       						</a> 
						</td>
					</xsl:if>
   				</xsl:if>
   				<xsl:if test="$currentpage = $maxpage">
   					<xsl:if test="$i = $n+1">
						<td>
      						&#xA0;&#xA0;&#xA0;&#xA0;
					    </td>
       					<td>
       						&#xA0;&#xA0;&#xA0;&#xA0;
						</td>
					</xsl:if>
   				</xsl:if>
   			</xsl:otherwise>
  		 </xsl:choose>
 	 </xsl:template>
 	 
 	 <xsl:template name="pagenavigSearch">
 		<xsl:param name="i" select="1"/>  <!-- счетчик количества страниц отображаемых в навигаторе  -->
 		<xsl:param name="n" select="15"/> <!-- количество страниц отображаемых в навигаторе -->
  		<xsl:param name="z" select="query/@maxpage -14"/>
  		<xsl:param name="f" select="15"/>
 		<xsl:param name="c" select="query/@currentpage"/> <!-- текущая страница в виде -->
 		<xsl:param name="startnum" select="query/@currentpage - 7"/> 
  		<xsl:param name="d" select="query/@maxpage - 14"/>	<!-- переменная для вычисления начального номера страницы в навигаторе  -->
  		<xsl:param name="currentpage" select="query/@currentpage"/>
  		<xsl:param name="maxpage" select="query/@maxpage"/>
  		<xsl:param name="nextpage" select="$currentpage + 1"/>
  		<xsl:param name="prevpage" select="$currentpage - 1"/>
  		<xsl:param name="curview" select="@id"/> 
  		<xsl:param name="keyword" select="query/@keyword"/> 
  		<xsl:param name="direction" select="query/@direction"/> 
		<xsl:choose>
			<xsl:when test="$maxpage>15">
				<xsl:choose>
					<xsl:when test="$maxpage - $currentpage &lt; 7">
						<xsl:if test="$i != $n+1">
							<xsl:if test="$z &lt; $maxpage + 1">
								<td>
									<a href="">
   										<xsl:attribute name="href">javascript:doSearch('<xsl:value-of select="$keyword"/>',<xsl:value-of select="$z"/>)</xsl:attribute>
   			 								<font style="font-size:12px">
    											<xsl:if test="$z=$currentpage">
    												<xsl:attribute name="style">font-weight:bold;font-size:1.3em</xsl:attribute>
    											</xsl:if>
    											<xsl:value-of select="$z"/>
    										</font>
   									</a>&#xA0;
								</td>
							</xsl:if>
      						<xsl:call-template name="pagenavigSearch">
	        					<xsl:with-param name="i" select="$i + 1"/>
	        					<xsl:with-param name="n" select="$n"/>
	        					<xsl:with-param name="z" select="$z+1"/>
      						</xsl:call-template>
						</xsl:if>
						<xsl:if test="$currentpage != $maxpage">
							<xsl:if test="$i = $n+1">
		 						<td>
     								<a href="">
      									<xsl:attribute name="href">javascript:doSearch('<xsl:value-of select="$keyword"/>',<xsl:value-of select="$nextpage"/>)</xsl:attribute>
      									<font style="font-size:12px"> > </font>
      								</a>
      							</td>
       							<td>
       								<a href="">
       									<xsl:attribute name="href">javascript:doSearch('<xsl:value-of select="$keyword"/>',<xsl:value-of select="$maxpage"/>)</xsl:attribute>
       									<font style="font-size:12px; margin-left:7px"> >> </font>
       								</a> 
						        </td>
							</xsl:if>
   						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$currentpage &lt; 7">
								<xsl:if test="$i=1">
									<xsl:if test="$currentpage = 1">
										<td>
											&#xA0;&#xA0;&#xA0;&#xA0;	
										</td>
										<td>
											&#xA0;&#xA0;&#xA0;
										</td>
									</xsl:if>
								</xsl:if>
								<xsl:if test="$i != $n+1">
									<xsl:if test="$i &lt; $maxpage + 1">
										<td>
											<a href="">
   				 								<xsl:attribute name="href">javascript:doSearch('<xsl:value-of select="$keyword"/>',<xsl:value-of select="$i"/>)</xsl:attribute>
												<font style="font-size:12px">
    												<xsl:if test="$i=$currentpage">
    													<xsl:attribute name="style">font-weight:bold;font-size:1.3em</xsl:attribute>
    												</xsl:if>
    												<xsl:value-of select="$i"/>
    											</font>
						   					</a>&#xA0;
										</td>
									</xsl:if>
      								<xsl:call-template name="pagenavigSearch">
	        							<xsl:with-param name="i" select="$i + 1"/>
	        							<xsl:with-param name="n" select="$n"/>
	        							<xsl:with-param name="c" select="$c+1"/>
      								</xsl:call-template>
      							</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="$i != $n+1">
									<xsl:if test="$i &lt; $maxpage + 1">
										<xsl:if test="$startnum !=0">
											<td>
												<a href="">
   				 									<xsl:attribute name="href">javascript:doSearch('<xsl:value-of select="$keyword"/>',<xsl:value-of select="$startnum"/>)</xsl:attribute>
													<font style="font-size:12px">
    													<xsl:if test="$startnum=$currentpage">
    														<xsl:attribute name="style">font-weight:bold;font-size:1.3em</xsl:attribute>
    													</xsl:if>
    													<xsl:value-of select="$startnum"/>
    												</font>
						   						</a>&#xA0;
											</td>
										</xsl:if>
									</xsl:if>
									<xsl:if test="$startnum != 0">
      									<xsl:call-template name="pagenavigSearch">
											<xsl:with-param name="i" select="$i + 1"/>
	        								<xsl:with-param name="n" select="$n"/>
	        								<xsl:with-param name="c" select="$c+1"/>
	        								<xsl:with-param name="startnum" select="$c - 6"/>
      									</xsl:call-template>
      								</xsl:if>
									<xsl:if test="$startnum = 0">
      									<xsl:call-template name="pagenavigSearch">
										<xsl:with-param name="i" select="$i"/>
	        							<xsl:with-param name="n" select="$n"/>
	        							<xsl:with-param name="c" select="$c+1"/>
	        							<xsl:with-param name="startnum" select="$c - 6"/>
      								</xsl:call-template>
      							</xsl:if>
      						</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
						<xsl:if test="$currentpage != $maxpage">
							<xsl:if test="$i = $n+1">
		 						<td>
      								<a href="">
     									<xsl:attribute name="href">javascript:doSearch('<xsl:value-of select="$keyword"/>',<xsl:value-of select="$nextpage"/>)</xsl:attribute>
     									<font style="font-size:12px"> > </font>
     								</a>
							    </td>
       							<td>
       								<a href="">
       									<xsl:attribute name="href">javascript:doSearch('<xsl:value-of select="$keyword"/>',<xsl:value-of select="$maxpage"/>)</xsl:attribute>
       									<font style="font-size:12px; margin-left:7px"> >> </font>
       								</a> 
							    </td>
							</xsl:if>
  						</xsl:if>
						
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$i=1">
					<xsl:if test="$currentpage = 1">
						<td>
							&#xA0;&#xA0;&#xA0;&#xA0;	
						</td>
						<td>
							&#xA0;&#xA0;&#xA0;
						</td>
					</xsl:if>
				</xsl:if>
				<xsl:if test="$i != $n+1">
					<xsl:if test="$i &lt; $maxpage + 1">
						<td>
							<a href="">
   								<xsl:attribute name="href">javascript:doSearch('<xsl:value-of select="$keyword"/>',<xsl:value-of select="$i"/> )</xsl:attribute>
   			 					<font style="font-size:12px">
    								<xsl:if test="$i=$currentpage">
    									<xsl:attribute name="style">font-weight:bold;font-size:1.3em</xsl:attribute>
    								</xsl:if>
    								<xsl:value-of select="$i"/>
    							</font>
						    </a>&#xA0;
						</td>
					</xsl:if>
      				<xsl:call-template name="pagenavigSearch">
	        			<xsl:with-param name="i" select="$i + 1"/>
	        			<xsl:with-param name="n" select="$n"/>
	        			<xsl:with-param name="c" select="$c+1"/>
      				</xsl:call-template>
				</xsl:if>
				<xsl:if test="$currentpage != $maxpage">
					<xsl:if test="$i = $n+1">
						<td>
      						<a href="">
      							<xsl:attribute name="href">javascript:doSearch('<xsl:value-of select="$keyword"/>', <xsl:value-of select="$nextpage"/>)</xsl:attribute>
      							<font style="font-size:12px"> > </font>
      						</a>
					    </td>
       					<td>
       						<a href="">
       							<xsl:attribute name="href">javascript:doSearch('<xsl:value-of select="$keyword"/>',<xsl:value-of select="$maxpage"/> );</xsl:attribute>
       							<font style="font-size:12px; margin-left:7px"> >> </font>
       						</a> 
						</td>
					</xsl:if>
   				</xsl:if>
   			</xsl:otherwise>
  		 </xsl:choose>
 	 </xsl:template>
 	 
 	 
	 <xsl:template name="combobox">
		<xsl:param name="i" select="1"/>
		<xsl:param name="k" select="query/@currentpage"/>
 		<xsl:param name="n" select="query/@maxpage + 1"/>
		<xsl:choose>
			<xsl:when test="$n > $i">
				<option>
 					<xsl:attribute name="value"> <xsl:value-of select="$i"/></xsl:attribute>
 					<xsl:if test="$k=$i">
 						<xsl:attribute name="selected">true</xsl:attribute>
 					</xsl:if>
 					<xsl:value-of select="$i"/>
 				</option>
				<xsl:call-template name="combobox">
	        		<xsl:with-param name="i" select="$i + 1"/>
	        		<xsl:with-param name="n" select="$n"/>
	        		<xsl:with-param name="k" select="query/@currentpage"/>
	        	</xsl:call-template>
		 	</xsl:when>
 		</xsl:choose>
	 </xsl:template>
	 
	 <xsl:template name="sortingcell">
		<xsl:param name="namefield"/>
		<xsl:param name="sortfield"/>
		<xsl:param name="sortorder"/>
		<a href="" class="actionlink">
			<xsl:choose>
				<xsl:when test="$sortfield != $namefield">
					<xsl:attribute name="href">javascript:updateView('<xsl:value-of select="@type"/>','<xsl:value-of select="query/@ruleid"/>',<xsl:value-of select="query/@currentpage"/>,null,'<xsl:value-of select="$namefield"/>','ASC')</xsl:attribute>
				</xsl:when>
				<xsl:when test="$sortfield = $namefield and $sortorder = 'ASC'">
					<xsl:attribute name="href">javascript:updateView('<xsl:value-of select="@type"/>','<xsl:value-of select="query/@ruleid"/>',<xsl:value-of select="query/@currentpage"/>,null,'<xsl:value-of select="$namefield"/>','DESC')</xsl:attribute>
				</xsl:when>
				<xsl:when test="$sortfield = $namefield and $sortorder = 'DESC'">
					<xsl:attribute name="href">javascript:updateView('<xsl:value-of select="@type"/>','<xsl:value-of select="query/@ruleid"/>',<xsl:value-of select="query/@currentpage"/>,null,'<xsl:value-of select="$namefield"/>','ASC')</xsl:attribute>
				</xsl:when>
			</xsl:choose>
			<font style="vertical-align:2px"><xsl:value-of select="columns/column[@id= $namefield]/@caption"/></font>
		</a>
		<a href="">
			<xsl:choose>
				<xsl:when test="$sortfield != $namefield">
					<xsl:attribute name="href">javascript:updateView('<xsl:value-of select="@type"/>','<xsl:value-of select="query/@ruleid"/>',<xsl:value-of select="query/@currentpage"/>,null,'<xsl:value-of select="$namefield"/>','ASC')</xsl:attribute>
					<img src="/SharedResources/img/iconset/br_up.png" style="margin-left:7px ; height:12px; width:12px"/>
				</xsl:when>
				<xsl:when test="$sortfield = $namefield and $sortorder = 'ASC'">
					<xsl:attribute name="href">javascript:updateView('<xsl:value-of select="@type"/>','<xsl:value-of select="query/@ruleid"/>',<xsl:value-of select="query/@currentpage"/>,null,'<xsl:value-of select="$namefield"/>','DESC')</xsl:attribute>
					<img src="/SharedResources/img/iconset/br_up_green.png" style="margin-left:7px ; height:12px; width:12px"/>
				</xsl:when>
				<xsl:when test="$sortfield = $namefield and $sortorder = 'DESC'">
					<xsl:attribute name="href">javascript:updateView('<xsl:value-of select="@type"/>','<xsl:value-of select="query/@ruleid"/>',<xsl:value-of select="query/@currentpage"/>,null,'<xsl:value-of select="$namefield"/>','ASC')</xsl:attribute>
					<img src="/SharedResources/img/iconset/br_down_green.png" style="margin-left:7px ; height:12px; width:12px"/>
				</xsl:when>
			</xsl:choose>
		</a>
	 </xsl:template>
</xsl:stylesheet>