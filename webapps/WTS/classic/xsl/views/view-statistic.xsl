<?xml version="1.0" ?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="../templates/view.xsl"/>
	<xsl:variable name="viewtype">Вид</xsl:variable>
	<xsl:output method="html" encoding="utf-8" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" indent="no"/>
	<xsl:variable name="skin" select="request/@skin"/>
	<xsl:variable name="useragent" select="request/@useragent"/>
	<xsl:template match="/request">
		<html>
			<head>
				<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
				<title>WTS - <xsl:value-of select="columns/column[@id = 'VIEW']/@caption"/></title>
				<link type="text/css" rel="stylesheet" href="classic/css/outline.css"/>
				<link type="text/css" rel="stylesheet" href="classic/css/main.css"/>
				<link type="text/css" rel="stylesheet" href="/SharedResources/jquery/css/smoothness/jquery-ui-1.8.20.custom.css"/>
				<link type="text/css" rel="stylesheet" href="/SharedResources/jquery/js/visualize/css/visualize.css"/>
				<link type="text/css" rel="stylesheet" href="/SharedResources/jquery/js/visualize/css/basic.css"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/jquery-1.4.2.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.widget.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.core.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.effects.core.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.datepicker.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.datepicker-ru.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.mouse.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.draggable.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.position.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.button.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/ui/jquery.ui.dialog.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/cookie/jquery.cookie.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/visualize/js/visualize.jQuery.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/visualize/js/excanvas.js"/>
				<script type="text/javascript" src="/SharedResources/jquery/js/scrollTo/scrollTo.js"/>
				<script type="text/javascript" src="classic/scripts/outline.js"/>
				<script type="text/javascript" src="classic/scripts/view.js"/>
				<script type="text/javascript" src="classic/scripts/form.js"/>
				<script type="text/javascript">
					$(document).ready(function(){
						outline.type = '<xsl:value-of select="@type" />'; 
						outline.viewid = '<xsl:value-of select="@id" />';
						outline.element = 'project';
						outline.command='<xsl:value-of select="current/@command" />';
						outline.curPage = '<xsl:value-of select="current/@page" />'; 
						outline.category = '';
						outline.filterid = '<xsl:value-of select="@id"/>';
						<xsl:if test="/request/@id !='statindexcomplete'">
							$('table').visualize({"width": $(window).width() - 405, "height": $(window).height() - 310,"barMargin":"40", "lineWeight":"5" });
						</xsl:if>
						<xsl:if test="/request/@id ='statindexcomplete'">
							$('table').visualize({"type":"area","width": $(window).width() - 405, "height": $(window).height() - 310, "lineWeight":"3" });
						</xsl:if>
					});
				</script>
			</head>			
			<body>
				<xsl:call-template name="flashentry"/>
				<div id="blockWindow" style="display:none"/>
				<div id="wrapper">
					<xsl:call-template name="loadingpage"/>
					<xsl:call-template name="header-view"/>
					<xsl:call-template name="outline-menu-view"/>
					<span id="view" class="viewframe{outline/category[entry[@current=1]]/@id}" style="position:absolute; left:320px;   right:0px; overflow:auto">
						<div id="viewcontent" style="margin-left:12px;">
							<div id="viewcontent-header" style="height:130px;">
								<div style="clear:both"/>
									<div id="tableheader" style="width:100%;">
										<xsl:if test="/request/@id='statstatus'">
											<table  id="statistic_table">
												<caption><xsl:value-of select="columns/column[@id = 'STATNAMECAPTION']/@caption"/></caption>
												<thead>
													<tr>
														<td></td>
														<th><xsl:value-of select="columns/column[@id = 'COUNTCAPTION']/@caption"/></th>
													</tr>
												</thead>
												<tbody>
													<tr>
														<th><xsl:value-of select="columns/column[@id = 'EXECUTEDCAPTION']/@caption"/></th>
														<td><xsl:value-of select="/request/counts/complete"/></td>
													</tr>
													<tr>
														<th><xsl:value-of select="columns/column[@id = 'TOCONSIDERCAPTION']/@caption"/></th>
														<td><xsl:value-of select="/request/counts/toconsider"/></td>
													</tr>
													<tr>
														<th><xsl:value-of select="columns/column[@id = 'ONCCORDINATEDCAPTION']/@caption"/></th>
														<td><xsl:value-of select="/request/counts/oncoordinate"/></td>
													</tr>
													<tr>
														<th><xsl:value-of select="columns/column[@id = 'ONEXECUTIONAUDITCAPTION']/@caption"/></th>
														<td><xsl:value-of select="/request/counts/waitforsign"/></td>
													</tr>
													<tr>
														<th><xsl:value-of select="columns/column[@id = 'REJECTEDCAPTION']/@caption"/></th>
														<td><xsl:value-of select="/request/counts/rejected"/></td>
													</tr>
													<tr>
														<th><xsl:value-of select="columns/column[@id = 'DRAFTCAPTION']/@caption"/></th>
														<td><xsl:value-of select="/request/counts/remarkdraft"/></td>
													</tr>
												</tbody>
											</table>
										</xsl:if>
										<xsl:if test="/request/@id='statoriginplace'">
											<table  id="statistic_table">
												<caption><xsl:value-of select="columns/column[@id = 'STATNAMECAPTION']/@caption"/></caption>
												<thead>
													<tr>
														<td></td>
														<th><xsl:value-of select="columns/column[@id = 'ALLPROJECTCAPTION']/@caption"/></th>
													</tr>
												</thead>
												<tbody>
													<xsl:for-each select="glossaries/projectsprav/query/entry">
														<xsl:variable name="t" select="@docid"/>
														<tr>
															<th><xsl:value-of select="viewcontent/viewtext1"/></th>
															<td><xsl:value-of select="count(/request/query/entry[project = $t])"></xsl:value-of></td>
														</tr>
													</xsl:for-each>
												</tbody>
											</table>
										</xsl:if>
										<xsl:if test="/request/@id='statresponsiblesection'">
											<table>
												<caption><xsl:value-of select="columns/column[@id = 'STATNAMECAPTION']/@caption"/></caption>
												<thead>
													<tr>
														<td></td>
														<th><xsl:value-of select="columns/column[@id = 'TOTALCAPTION']/@caption"/></th>
													</tr>
												</thead>
												<tbody>
													<xsl:for-each select="glossaries/responsiblesection/query/entry">
														<xsl:variable name="t" select="userid"/>
														<tr>
															<th><xsl:value-of select="viewcontent/viewtext1"/></th>
															<td><xsl:value-of select="count(/request/query/entry[responsible = $t])"></xsl:value-of></td>
														</tr>
													</xsl:for-each>
												</tbody>
											</table>
										</xsl:if>
										<xsl:if test="/request/@id='statindexcomplete'">
											<xsl:variable name="cd" select="concat(current-date(),' ')"/>
											<xsl:variable name="year" select="substring($cd,1,4)"/>
											<xsl:variable name="curmonth" select="substring($cd,6,2)"/>
											<xsl:variable name="prevmonth1"><xsl:if test="number($curmonth) - 1 &lt; 10">0</xsl:if><xsl:value-of select="number($curmonth) - 1"/></xsl:variable>
											<xsl:variable name="prevmonth2"><xsl:if test="number($curmonth) - 2 &lt; 10">0</xsl:if><xsl:value-of select="number($curmonth) - 2"/></xsl:variable>
											<xsl:variable name="prevmonth3"><xsl:if test="number($curmonth) - 3 &lt; 10">0</xsl:if><xsl:value-of select="number($curmonth) - 3"/></xsl:variable>
											<xsl:variable name="prevmonth4"><xsl:if test="number($curmonth) - 4 &lt; 10">0</xsl:if><xsl:value-of select="number($curmonth) - 4"/></xsl:variable>
											<xsl:variable name="prevmonth5"><xsl:if test="number($curmonth) - 5 &lt; 10">0</xsl:if><xsl:value-of select="number($curmonth) - 5"/></xsl:variable>
											<table>
												<caption><xsl:value-of select="columns/column[@id = 'STATNAMECAPTION']/@caption"/></caption>
												<thead>
													<tr>
														<td></td>
														<th>
															<xsl:choose>
																<xsl:when test="$prevmonth5 = '01'">
																	<xsl:value-of select="columns/column[@id = 'JANUARYCAPTION']/@caption"/> 
																</xsl:when>
																<xsl:when test="$prevmonth5 = '02'"> 
																	<xsl:value-of select="columns/column[@id = 'FEBRUARYCAPTION']/@caption"/>
																</xsl:when>
																<xsl:when test="$prevmonth5 = '03'"> 
																	<xsl:value-of select="columns/column[@id = 'MARCHCAPTION']/@caption"/>
																</xsl:when>
																<xsl:when test="$prevmonth5 = '04'">
																	<xsl:value-of select="columns/column[@id = 'APRILCAPTION']/@caption"/>
																</xsl:when>
																<xsl:when test="$prevmonth5 = '05'">
																	<xsl:value-of select="columns/column[@id = 'MAYCAPTION']/@caption"/>
																</xsl:when>
																<xsl:when test="$prevmonth5 = '06'"> 
																	<xsl:value-of select="columns/column[@id = 'JUNECAPTION']/@caption"/>
																</xsl:when>
																<xsl:when test="$prevmonth5 = '07'"> 
																	<xsl:value-of select="columns/column[@id = 'JULYCAPTION']/@caption"/>
																</xsl:when>
																<xsl:when test="$prevmonth5 = '08' or $prevmonth5 = '0-4'"> 
																	<xsl:value-of select="columns/column[@id = 'AUGUSTCAPTION']/@caption"/>
																</xsl:when>
																<xsl:when test="$prevmonth5 = '09' or $prevmonth5 = '0-3'">
																	<xsl:value-of select="columns/column[@id = 'SEPTEMBERCAPTION']/@caption"/> 
																</xsl:when>
																<xsl:when test="$prevmonth5 = '10' or $prevmonth5 = '0-2'">
																	<xsl:value-of select="columns/column[@id = 'OCTOBERCAPTION']/@caption"/> 
																</xsl:when>
																<xsl:when test="$prevmonth5 = '11' or $prevmonth5 = '0-1'"> 
																	<xsl:value-of select="columns/column[@id = 'NOVEMBERCAPTION']/@caption"/>
																</xsl:when>
																<xsl:when test="$prevmonth5 = '12' or $prevmonth5 = '00'">
																	<xsl:value-of select="columns/column[@id = 'DECEMBERCAPTION']/@caption"/> 
																</xsl:when>
															</xsl:choose>
														</th>
														<th>
															<xsl:choose>
																<xsl:when test="$prevmonth4 = '01'">
																	<xsl:value-of select="columns/column[@id = 'JANUARYCAPTION']/@caption"/>
																</xsl:when>
																<xsl:when test="$prevmonth4 = '02'"> 
																	<xsl:value-of select="columns/column[@id = 'FEBRUARYCAPTION']/@caption"/>
																</xsl:when>
																<xsl:when test="$prevmonth4 = '03'"> 
																	<xsl:value-of select="columns/column[@id = 'MARCHCAPTION']/@caption"/>
																</xsl:when>
																<xsl:when test="$prevmonth4 = '04'">
																	<xsl:value-of select="columns/column[@id = 'APRILCAPTION']/@caption"/>
																</xsl:when>
																<xsl:when test="$prevmonth4 = '05'">
																	<xsl:value-of select="columns/column[@id = 'MAYCAPTION']/@caption"/>
																</xsl:when>
																<xsl:when test="$prevmonth4 = '06'"> 
																	<xsl:value-of select="columns/column[@id = 'JUNECAPTION']/@caption"/>
																</xsl:when>
																<xsl:when test="$prevmonth4 = '07'"> 
																	<xsl:value-of select="columns/column[@id = 'JULYCAPTION']/@caption"/>
																</xsl:when>
																<xsl:when test="$prevmonth4 = '08' or $prevmonth4 = '0-4'"> 
																	<xsl:value-of select="columns/column[@id = 'AUGUSTCAPTION']/@caption"/>
																</xsl:when>
																<xsl:when test="$prevmonth4 = '09' or $prevmonth4 = '0-3'">
																	<xsl:value-of select="columns/column[@id = 'SEPTEMBERCAPTION']/@caption"/> 
																</xsl:when>
																<xsl:when test="$prevmonth4 = '10' or $prevmonth4 = '0-2'">
																	<xsl:value-of select="columns/column[@id = 'OCTOBERCAPTION']/@caption"/> 
																</xsl:when>
																<xsl:when test="$prevmonth4 = '11' or $prevmonth4 = '0-1'"> 
																	<xsl:value-of select="columns/column[@id = 'NOVEMBERCAPTION']/@caption"/>
																</xsl:when>
																<xsl:when test="$prevmonth4 = '12' or $prevmonth4 = '00'">
																	<xsl:value-of select="columns/column[@id = 'DECEMBERCAPTION']/@caption"/> 
																</xsl:when>
															</xsl:choose>
														</th>
														<th>
															<xsl:choose>
																<xsl:when test="$prevmonth3 = '01'">
																	<xsl:value-of select="columns/column[@id = 'JANUARYCAPTION']/@caption"/>
																</xsl:when>
																<xsl:when test="$prevmonth3 = '02'"> 
																	<xsl:value-of select="columns/column[@id = 'FEBRUARYCAPTION']/@caption"/>
																</xsl:when>
																<xsl:when test="$prevmonth3 = '03'"> 
																	<xsl:value-of select="columns/column[@id = 'MARCHCAPTION']/@caption"/>
																</xsl:when>
																<xsl:when test="$prevmonth3 = '04'">
																	<xsl:value-of select="columns/column[@id = 'APRILCAPTION']/@caption"/> 
																</xsl:when>
																<xsl:when test="$prevmonth3 = '05'">
																	<xsl:value-of select="columns/column[@id = 'MAYCAPTION']/@caption"/>
																</xsl:when>
																<xsl:when test="$prevmonth3 = '06'"> 
																	<xsl:value-of select="columns/column[@id = 'JUNECAPTION']/@caption"/>
																</xsl:when>
																<xsl:when test="$prevmonth3 = '07'"> 
																	<xsl:value-of select="columns/column[@id = 'JULYCAPTION']/@caption"/>
																</xsl:when>
																<xsl:when test="$prevmonth3 = '08' or $prevmonth3 = '0-4'"> 
																	<xsl:value-of select="columns/column[@id = 'AUGUSTCAPTION']/@caption"/>
																</xsl:when>
																<xsl:when test="$prevmonth3 = '09' or $prevmonth3 = '0-3'">
																	<xsl:value-of select="columns/column[@id = 'SEPTEMBERCAPTION']/@caption"/> 
																</xsl:when>
																<xsl:when test="$prevmonth3 = '10' or $prevmonth3 = '0-2'">
																	<xsl:value-of select="columns/column[@id = 'OCTOBERCAPTION']/@caption"/> 
																</xsl:when>
																<xsl:when test="$prevmonth3 = '11' or $prevmonth3 = '0-1'"> 
																	<xsl:value-of select="columns/column[@id = 'NOVEMBERCAPTION']/@caption"/> 
																</xsl:when>
																<xsl:when test="$prevmonth3 = '12' or $prevmonth3 = '00'">
																	<xsl:value-of select="columns/column[@id = 'DECEMBERCAPTION']/@caption"/> 
																</xsl:when>
															</xsl:choose>
														</th>
														<th>
															<xsl:choose>
																<xsl:when test="$prevmonth2 = '01'">
																	<xsl:value-of select="columns/column[@id = 'JANUARYCAPTION']/@caption"/>
																</xsl:when>
																<xsl:when test="$prevmonth2 = '02'"> 
																	<xsl:value-of select="columns/column[@id = 'FEBRUARYCAPTION']/@caption"/>
																</xsl:when>
																<xsl:when test="$prevmonth2 = '03'"> 
																	<xsl:value-of select="columns/column[@id = 'MARCHCAPTION']/@caption"/>
																</xsl:when>
																<xsl:when test="$prevmonth2 = '04'">
																	<xsl:value-of select="columns/column[@id = 'APRILCAPTION']/@caption"/>
																</xsl:when>
																<xsl:when test="$prevmonth2 = '05'">
																	<xsl:value-of select="columns/column[@id = 'MAYCAPTION']/@caption"/>
																</xsl:when>
																<xsl:when test="$prevmonth2 = '06'"> 
																	<xsl:value-of select="columns/column[@id = 'JUNECAPTION']/@caption"/>
																</xsl:when>
																<xsl:when test="$prevmonth2 = '07'"> 
																	<xsl:value-of select="columns/column[@id = 'JULYCAPTION']/@caption"/>
																</xsl:when>
																<xsl:when test="$prevmonth2 = '08' or $prevmonth2 = '0-4'"> 
																	<xsl:value-of select="columns/column[@id = 'AUGUSTCAPTION']/@caption"/>
																</xsl:when>
																<xsl:when test="$prevmonth2 = '09' or $prevmonth2 = '0-3'">
																	<xsl:value-of select="columns/column[@id = 'SEPTEMBERCAPTION']/@caption"/>
																</xsl:when>
																<xsl:when test="$prevmonth2 = '10' or $prevmonth2 = '0-2'">
																	<xsl:value-of select="columns/column[@id = 'OCTOBERCAPTION']/@caption"/>
																</xsl:when>
																<xsl:when test="$prevmonth2 = '11' or $prevmonth2 = '0-1'"> 
																	<xsl:value-of select="columns/column[@id = 'NOVEMBERCAPTION']/@caption"/> 
																</xsl:when>
																<xsl:when test="$prevmonth2 = '12' or $prevmonth2 = '00'">
																	<xsl:value-of select="columns/column[@id = 'DECEMBERCAPTION']/@caption"/> 
																</xsl:when>
															</xsl:choose>
														</th>
														<th>
															<xsl:choose>
																<xsl:when test="$prevmonth1 = '01'">
																	<xsl:value-of select="columns/column[@id = 'JANUARYCAPTION']/@caption"/>
																</xsl:when>
																<xsl:when test="$prevmonth1 = '02'"> 
																	<xsl:value-of select="columns/column[@id = 'FEBRUARYCAPTION']/@caption"/>
																</xsl:when>
																<xsl:when test="$prevmonth1 = '03'"> 
																	<xsl:value-of select="columns/column[@id = 'MARCHCAPTION']/@caption"/>
																</xsl:when>
																<xsl:when test="$prevmonth1 = '04'">
																	<xsl:value-of select="columns/column[@id = 'APRILCAPTION']/@caption"/>
																</xsl:when>
																<xsl:when test="$prevmonth1 = '05'">
																	<xsl:value-of select="columns/column[@id = 'MAYCAPTION']/@caption"/>
																</xsl:when>
																<xsl:when test="$prevmonth1 = '06'"> 
																	<xsl:value-of select="columns/column[@id = 'JUNECAPTION']/@caption"/>
																</xsl:when>
																<xsl:when test="$prevmonth1 = '07'"> 
																	<xsl:value-of select="columns/column[@id = 'JULYCAPTION']/@caption"/>
																</xsl:when>
																<xsl:when test="$prevmonth1 = '08' or $prevmonth1 = '0-4'"> 
																	<xsl:value-of select="columns/column[@id = 'AUGUSTCAPTION']/@caption"/>
																</xsl:when>
																<xsl:when test="$prevmonth1 = '09' or $prevmonth1 = '0-3'">
																	<xsl:value-of select="columns/column[@id = 'SEPTEMBERCAPTION']/@caption"/>
																</xsl:when>
																<xsl:when test="$prevmonth1 = '10' or $prevmonth1 = '0-2'">
																	<xsl:value-of select="columns/column[@id = 'OCTOBERCAPTION']/@caption"/>
																</xsl:when>
																<xsl:when test="$prevmonth1 = '11' or $prevmonth1 = '0-1'"> 
																	<xsl:value-of select="columns/column[@id = 'NOVEMBERCAPTION']/@caption"/>
																</xsl:when>
																<xsl:when test="$prevmonth1 = '12' or $prevmonth1 = '00'">
																	<xsl:value-of select="columns/column[@id = 'DECEMBERCAPTION']/@caption"/> 
																</xsl:when>
															</xsl:choose>
														</th>
														<th>
															<xsl:choose>
																<xsl:when test="$curmonth = '01'">
																	<xsl:value-of select="columns/column[@id = 'JANUARYCAPTION']/@caption"/>
																</xsl:when>
																<xsl:when test="$curmonth = '02'"> 
																	<xsl:value-of select="columns/column[@id = 'FEBRUARYCAPTION']/@caption"/>
																</xsl:when>
																<xsl:when test="$curmonth = '03'"> 
																	<xsl:value-of select="columns/column[@id = 'MARCHCAPTION']/@caption"/>
																</xsl:when>
																<xsl:when test="$curmonth = '04'">
																	<xsl:value-of select="columns/column[@id = 'APRILCAPTION']/@caption"/>
																</xsl:when>
																<xsl:when test="$curmonth = '05'">
																	<xsl:value-of select="columns/column[@id = 'MAYCAPTION']/@caption"/>
																</xsl:when>
																<xsl:when test="$curmonth = '06'"> 
																	<xsl:value-of select="columns/column[@id = 'JUNECAPTION']/@caption"/>
																</xsl:when>
																<xsl:when test="$curmonth = '07'"> 
																	<xsl:value-of select="columns/column[@id = 'JULYCAPTION']/@caption"/>
																</xsl:when>
																<xsl:when test="$curmonth = '08'"> 
																	<xsl:value-of select="columns/column[@id = 'AUGUSTCAPTION']/@caption"/>
																</xsl:when>
																<xsl:when test="$curmonth = '09'">
																	<xsl:value-of select="columns/column[@id = 'SEPTEMBERCAPTION']/@caption"/>
																</xsl:when>
																<xsl:when test="$curmonth = '10'">
																	<xsl:value-of select="columns/column[@id = 'OCTOBERCAPTION']/@caption"/> 
																</xsl:when>
																<xsl:when test="$curmonth = '11'"> 
																	<xsl:value-of select="columns/column[@id = 'NOVEMBERCAPTION']/@caption"/>
																</xsl:when>
																<xsl:when test="$curmonth = '12'">
																	<xsl:value-of select="columns/column[@id = 'DECEMBERCAPTION']/@caption"/> 
																</xsl:when>
															</xsl:choose>
														</th>
													</tr>
												</thead>
												<tbody>
													<tr>
														<th><xsl:value-of select="columns/column[@id = 'EXECUTEDCAPTION']/@caption"/> </th>
														<td><xsl:value-of select="count(/request/query/entry[coordstatus = 362]/viewcontent[substring(viewdate, 7,4) = $year][substring(viewdate, 4,2) = $prevmonth5])"/></td>
														<td><xsl:value-of select="count(/request/query/entry[coordstatus = 362]/viewcontent[substring(viewdate, 7,4) = $year][substring(viewdate, 4,2) = $prevmonth4])"/></td>
														<td><xsl:value-of select="count(/request/query/entry[coordstatus = 362]/viewcontent[substring(viewdate, 7,4) = $year][substring(viewdate, 4,2) = $prevmonth3])"/></td>
														<td><xsl:value-of select="count(/request/query/entry[coordstatus = 362]/viewcontent[substring(viewdate, 7,4) = $year][substring(viewdate, 4,2) = $prevmonth2])"/></td>
														<td><xsl:value-of select="count(/request/query/entry[coordstatus = 362]/viewcontent[substring(viewdate, 7,4) = $year][substring(viewdate, 4,2) = $prevmonth1])"/></td>
														<td><xsl:value-of select="count(/request/query/entry[coordstatus = 362]/viewcontent[substring(viewdate, 7,4) = $year][substring(viewdate, 4,2) = $curmonth])"/></td>
													</tr>
													<tr>
														<th><xsl:value-of select="columns/column[@id = 'NOTEXECUTEDCAPTION']/@caption"/></th>
														<td><xsl:value-of select="count(/request/query/entry[coordstatus = 361 or coordstatus = 352 or coordstatus = 355]/viewcontent[substring(viewdate, 7,4) = $year][substring(viewdate, 4,2) = $prevmonth5])"/></td>
														<td><xsl:value-of select="count(/request/query/entry[coordstatus = 361 or coordstatus = 352 or coordstatus = 355]/viewcontent[substring(viewdate, 7,4) = $year][substring(viewdate, 4,2) = $prevmonth4])"/></td>
														<td><xsl:value-of select="count(/request/query/entry[coordstatus = 361 or coordstatus = 352 or coordstatus = 355]/viewcontent[substring(viewdate, 7,4) = $year][substring(viewdate, 4,2) = $prevmonth3])"/></td>
														<td><xsl:value-of select="count(/request/query/entry[coordstatus = 361 or coordstatus = 352 or coordstatus = 355]/viewcontent[substring(viewdate, 7,4) = $year][substring(viewdate, 4,2) = $prevmonth2])"/></td>
														<td><xsl:value-of select="count(/request/query/entry[coordstatus = 361 or coordstatus = 352 or coordstatus = 355]/viewcontent[substring(viewdate, 7,4) = $year][substring(viewdate, 4,2) = $prevmonth1])"/></td>
														<td><xsl:value-of select="count(/request/query/entry[coordstatus = 361 or coordstatus = 352 or coordstatus = 355]/viewcontent[substring(viewdate, 7,4) = $year][substring(viewdate, 4,2) = $curmonth])"/></td>
													</tr>
													<tr>
														<th><xsl:value-of select="columns/column[@id = 'REJECTEDCAPTION']/@caption"/></th>
														<td><xsl:value-of select="count(/request/query/entry[coordstatus = 354]/viewcontent[substring(viewdate, 7,4) = $year][substring(viewdate, 4,2) = $prevmonth5])"/></td>
														<td><xsl:value-of select="count(/request/query/entry[coordstatus = 354]/viewcontent[substring(viewdate, 7,4) = $year][substring(viewdate, 4,2) = $prevmonth4])"/></td>
														<td><xsl:value-of select="count(/request/query/entry[coordstatus = 354]/viewcontent[substring(viewdate, 7,4) = $year][substring(viewdate, 4,2) = $prevmonth3])"/></td>
														<td><xsl:value-of select="count(/request/query/entry[coordstatus = 354]/viewcontent[substring(viewdate, 7,4) = $year][substring(viewdate, 4,2) = $prevmonth2])"/></td>
														<td><xsl:value-of select="count(/request/query/entry[coordstatus = 354]/viewcontent[substring(viewdate, 7,4) = $year][substring(viewdate, 4,2) = $prevmonth1])"/></td>
														<td><xsl:value-of select="count(/request/query/entry[coordstatus = 354]/viewcontent[substring(viewdate, 7,4) = $year][substring(viewdate, 4,2) = $curmonth])"/></td>
													</tr>
												</tbody>
											</table>
										</xsl:if>
										<br/>
										<br/>
										<br/>
										<br/>
									</div>
								</div>
								<div id="viewtablediv" style="width:100%"/>
		 					</div>
						</span>
					</div>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>