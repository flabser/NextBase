var nbApp = {
	isTouch : false,
	needDocsAction : ['delete_document'],
	allActionsNeedDocsEnabled : false
};

nbApp.init = function() {
	if (window.innerWidth <= 800) {
		this.uiMakeTouch();
	}

	this.initScrollSpyActionBar();
	this.initScrollSpySide();
	this.initUI();
	this.uiToggleAvailableActions();
	$('body').removeClass('no_transition');
};

/*
 * uiMakeTouch
 */
nbApp.uiMakeTouch = function() {
	$('body').addClass('touch layout_fullscreen');
	nbApp.isTouch = true;
};

/*
 * uiToggleNavApp
 */
nbApp.uiToggleNavApp = function(e) {
	$('body').toggleClass('nav-app-open');
};

/*
 * uiToggleNavWorkspace
 */
nbApp.uiToggleNavWorkspace = function(e) {
	$('body').toggleClass('nav-ws-open');
};

/*
 * uiHideOpenedNav
 */
nbApp.uiHideOpenedNav = function(e) {
	$('body').removeClass('nav-app-open nav-ws-open');
};

/*
 * uiToggleAvailableActions
 */
nbApp.uiToggleAvailableActions = function(e) {
	var hasSelectedDoc = $('[name=docid]:checked').length > 0;

	if (nbApp.allActionsNeedDocsEnabled && hasSelectedDoc) {
		return;
	}

	var actCount = nbApp.needDocsAction.length;
	for (var i = 0; i < actCount; i++) {
		if (hasSelectedDoc) {
			$('.action_' + nbApp.needDocsAction[i]).removeClass('disabled').removeAttr('disabled');
			nbApp.allActionsNeedDocsEnabled = true;
		} else {
			$('.action_' + nbApp.needDocsAction[i]).addClass('disabled').attr('disabled', 'disabled');
			nbApp.allActionsNeedDocsEnabled = false;
		}
	}
};

nbApp.parseXmlMessageToJson = function(xml) {
	return nb.utils.parseMessageToJson(xml); // $.xml2json(xml);
};

$(document).ready(function() {
	nbApp.init();
});
