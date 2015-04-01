<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:import href="templates/constants.xsl" />
	<xsl:import href="templates/outline.xsl" />
	<xsl:import href="templates/nav-ws.xsl" />
	<xsl:import href="templates/view.xsl" />
	<xsl:import href="templates/actions.xsl" />
	<xsl:import href="templates/saldo.xsl" />
	<xsl:import href="templates/utils.xsl" />

	<xsl:output method="html" encoding="utf-8" indent="no" />
	<xsl:decimal-format name="df" grouping-separator=" " />
	<xsl:variable name="assert_vers" select="'1234'" />

	<xsl:variable name="UI">
		<xsl:choose>
			<xsl:when test="//@useragent = 'IPAD_SAFARI' or //@useragent = 'GALAXY_TAB_SAFARI' or //@useragent = 'ANDROID'">
				<xsl:value-of select="'mobile'" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="'desctop'" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:template name="layout">
		<xsl:param name="w_title" select="concat(page/captions/viewnamecaption/@caption, ' - ', $APP_NAME)" />
		<xsl:param name="active_aside_id" select="//current_outline_entry/response/content/entry/@id" />
		<xsl:param name="aside_collapse" select="''" />
		<xsl:param name="include" select="''" />
		<xsl:param name="widescreen" select="''" />

		<xsl:call-template name="HTML-DOCTYPE" />
		<html>
			<xsl:call-template name="html_head">
				<xsl:with-param name="w_title" select="$w_title" />
				<xsl:with-param name="include" select="$include" />
			</xsl:call-template>
			<body class="no_transition {$widescreen}">
				<xsl:if test="$UI_CLIENT = 'mobile'">
					<xsl:attribute name="class" select="concat('no_transition touch mobile ',  $widescreen)" />
				</xsl:if>
				<div class="content-overlay js-content-overlay"></div>
				<div class="layout">
					<div class="layout_canvas {$aside_collapse}">
						<header class="layout_header">
							<xsl:call-template name="main-header" />
						</header>
						<xsl:apply-templates select="//included_share_navi" mode="outline">
							<xsl:with-param name="active-entry-id" select="$active_aside_id" />
						</xsl:apply-templates>
						<section class="layout_content">
							<xsl:call-template name="_content" />
						</section>
						<xsl:apply-templates select="//availableapps" mode="ws" />
					</div>
				</div>
				<xsl:call-template name="util-js-mark-as-read" />
			</body>
		</html>
	</xsl:template>

	<xsl:template name="_content" />

	<xsl:template name="html_head">
		<xsl:param name="include" select="''" />
		<xsl:param name="w_title" select="''" />
		<head>
			<title>
				<xsl:value-of select="$w_title" />
			</title>
			<link rel="shortcut icon" href="favicon.ico" />
			<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />

			<link type="text/css" rel="stylesheet"
				href="/SharedResources/jquery/css/jquery-ui-1.10.4.custom/css/smoothness/jquery-ui-1.10.4.custom.min.css" />
			<link type="text/css" rel="Stylesheet" media="screen" href="/SharedResources/jquery/js/tiptip/tipTip.css" />
			<link type="text/css" rel="stylesheet" href="/SharedResources/jquery/js/hotnav/jquery.hotnav.css" />
			<link type="text/css" rel="stylesheet" href="classic/css/all.min.css?v={$assert_vers}" />

			<style>
				/* fix: fieldset content overflow */
				fieldset {
				    display: block;
				    min-width: inherit; /* fix overflow chrome */
				}
				@-moz-document url-prefix() {
				    fieldset {
				        display: table-column !important;
				    }
				}
			</style>

			<script type="text/javascript" src="/SharedResources/jquery/js/jquery-1.11.0.min.js"></script>
			<script type="text/javascript" src="/SharedResources/jquery/js/jquery-ui-1.10.4.custom.min.js"></script>

			<script type="text/javascript" src="/SharedResources/jquery/js/ui/minified/i18n/jquery.ui.datepicker-ru.min.js"></script>
			<script type="text/javascript" src="/SharedResources/jquery/js/tiptip/jquery.tipTip.js"></script>
			<script type="text/javascript" src="/SharedResources/jquery/js/cookie/jquery.cookie.js"></script>
			<script type="text/javascript" src="/SharedResources/jquery/js/hotnav/jquery.hotkeys.js"></script>
			<script type="text/javascript" src="/SharedResources/jquery/js/hotnav/jquery.hotnav.js"></script>
			<script type="text/javascript" src="/SharedResources/jquery/js/scrollTo/scrollTo.js"></script>
			<script type="text/javascript" src="/SharedResources/jquery/js/jquery.number.js"></script>
			<script type="text/javascript" src="/SharedResources/jquery/js/jquery.xml2json.js"></script>

			<script type="text/javascript" src="classic/js/app.build.js?v={$assert_vers}"></script>

			<xsl:copy-of select="$include" />
		</head>
	</xsl:template>

	<xsl:template name="main-header">
		<div class="main-header">
			<div class="nav-app-toggle js-toggle-nav-app"></div>
			<div class="brand">
				<img alt="logo" src="{$APP_LOGO_IMG_SRC}" class="brand-logo" />
				<span class="brand-title">
					<xsl:value-of select="$APP_NAME" />
				</span>
			</div>
			<div class="nav">
				<a href="Provider?type=edit&amp;element=userprofile&amp;id=userprofile" title="Профиль" class="user-profile">
					<xsl:value-of select="@username" />
				</a>
				<a href="Logout" title="{//captions/logout/@caption}" class="user-logout">
					<xsl:value-of select="//captions/logout/@caption" />
				</a>
				<xsl:if test="not(document)">
					<div class="search">
						<form action="Provider" method="get" name="search">
							<input type="hidden" name="type" value="page" />
							<input type="hidden" name="id" value="search" />
							<input type="search" name="keyword" value="{//current_outline_entry/response/content/search}" class="keyword"
								required="required" placeholder="Поиск" />
							<input type="submit" class="button-submit" title="Поиск" value="" />
						</form>
					</div>
				</xsl:if>
			</div>
			<div class="nav-ws-toggle js-toggle-nav-ws"></div>
		</div>
	</xsl:template>

</xsl:stylesheet>
