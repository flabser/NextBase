nbApp.dialogChoiceCategory = function(el) {
	var dlg = nb.dialog.show({
		targetForm : el.form.name,
		fieldName : "category",
		title : el.title,
		maxHeight : 500,
		minHeight : 440,
		width : 500,
		href : "Provider?type=page&id=picklist-category&page=1",
		onExecute : function() {
			if (nb.form.setValues(dlg, null)) {
				var selected = $("[data-type='select']:checked", dlg[0]);

				if ($(selected[0]).hasClass("js-response")) {
					var _parent = $(selected[0]).parents(".js-parent");
					var parentCat = _parent.children("label:first");
					var parentCatName = parentCat.text();
					$("#categorytbl").html(parentCatName + " / " + $("#categorytbl").text());

					var type_op = $("[name='viewtext3']", parentCat).val();

					var requireDocument = $("[name='viewtext5']", parentCat).val() == "1";
					var requireCostCenter = $("[name='viewtext6']", parentCat).val() == "1";

					if (requireDocument) {
						$("[name=documented]").attr("required", "required").attr("checked", true);
						$("[name=documented]").attr("onclick", "return false");
						$("[name=documented]").attr("onkeydown", "return false");
					} else {
						$("[name=documented]").removeAttr("required").removeAttr("disabled");
						$("[name=documented]").attr("onclick", null);
						$("[name=documented]").attr("onkeydown", null);
					}

					if (requireCostCenter) {
						$("[name=costcenter]").attr("required", "required");
					} else {
						$("[name=costcenter]").removeAttr("required").removeAttr("disabled");
					}

					// TODO get parent data
					$("#subcategorytbl").html("");
					$("#typeoperationtbl").attr("class", "operation-type-icon-" + type_op).attr("title", type_op);
				} else {
					var type_op = $("[data-id=" + selected[0].value + "][name='viewtext3']").val();

					if (type_op == "in" || type_op == "out") {
						$("input[name=targetcash]").val("");
						$("#targetcashtbl").html("");
						$("#control-row-targetcash").hide();
						$("#costcenterbtn ").show();
					} else if (type_op == "transfer") {
						$("#control-row-targetcash").show();
						$("#costcenterbtn ").hide();
						$("input[name=costcentert]").val("");
						$("#costcenterttbl").html("");
					} else if (type_op == "calcstuff") {
						$("#control-row-targetcash").show();
						$("input[name=costcentert]").val("");
						$("#costcenterttbl").html("");
					} else if (type_op == "getcash") {

					} else if (type_op == "withdraw") {

					}

					var requireDocument = $("[data-id=" + selected[0].value + "][name='viewtext5']").val() == "1";
					var requireCostCenter = $("[data-id=" + selected[0].value + "][name='viewtext6']").val() == "1";

					if (requireDocument) {
						$("[name=documented]").attr("required", "required").attr("checked", true);
						$("[name=documented]").attr("onclick", "return false");
						$("[name=documented]").attr("onkeydown", "return false");
					} else {
						$("[name=documented]").removeAttr("required").removeAttr("disabled");
						$("[name=documented]").attr("onclick", null);
						$("[name=documented]").attr("onkeydown", null);
					}

					if (requireCostCenter) {
						$("[name=costcenter]").attr("required", "required");
					} else {
						$("[name=costcenter]").removeAttr("required").removeAttr("disabled");
					}

					$("#subcategorytbl").html("");
					$("#typeoperationtbl").attr("class", "operation-type-icon-" + type_op).attr("title", type_op);
				}

				$("input[name=subcategory]").val("");

				dlg.dialog("close");
			}
		},
		buttons : {
			"ok" : {
				text : nb.getText("select"),
				click : function() {
					dlg[0].dialogOptions.onExecute();
				}
			},
			"cancel" : {
				text : nb.getText("cancel"),
				click : function() {
					dlg.dialog("close");
				}
			}
		},
		close : function() {
			$("input[name=summa]").focus();
		}
	});
};

nbApp.dialogChoiceCostCenter = function(el) {
	var dlg = nb.dialog.show({
		targetForm : el.form.name,
		fieldName : "costcenter",
		title : el.title,
		href : "Provider?type=page&id=picklist-costcenter&page=1",
		buttons : {
			"ok" : {
				text : nb.getText("select"),
				click : function() {
					dlg[0].dialogOptions.onExecute();
				}
			},
			"cancel" : {
				text : nb.getText("cancel"),
				click : function() {
					dlg.dialog("close");
				}
			}
		},
		close : function() {
			$("textarea[name=requisites]").focus();
		}
	});
};

nbApp.dialogChoiceOrg = function(el, fieldName, isMulti) {
	var dlg = nb.dialog.show({
		effect : "shake",
		targetForm : el.form.name,
		fieldName : fieldName,
		dialogFilterListItem : ".tree-entry",
		title : el.title,
		maxHeight : 500,
		minHeight : 440,
		width : 500,
		href : "Provider?type=view&id=orgpicklist&page=1&fieldName=" + fieldName + "&isMulti=" + isMulti,
		onLoad : function() {
			if (isMulti === false) {
				$("[type='checkbox'][data-type='select']", dlg[0]).attr("type", "radio");
			}
		},
		buttons : {
			"select" : {
				text : nb.getText("select"),
				click : function() {
					dlg[0].dialogOptions.onExecute();
				}
			},
			"cancel" : {
				text : nb.getText("cancel"),
				click : function() {
					dlg.dialog("close");
				}
			}
		}
	});
};

nbApp.dialogChoiceBossAndDemp = function(el, fieldName, isMulti) {
	var dlg = nb.dialog.show({
		effect : "shake",
		targetForm : el.form.name,
		fieldName : fieldName,
		dialogFilterListItem : ".tree-entry",
		title : el.title,
		maxHeight : 500,
		minHeight : 440,
		width : 500,
		href : "Provider?type=view&id=bossandemppicklist&page=1&fieldName=" + fieldName + "&isMulti=" + isMulti,
		onLoad : function() {
			if (isMulti === false) {
				$("[type='checkbox'][data-type='select']", dlg[0]).attr("type", "radio");
			}
		},
		buttons : {
			"select" : {
				text : nb.getText("select"),
				click : function() {
					dlg[0].dialogOptions.onExecute();
				}
			},
			"cancel" : {
				text : nb.getText("cancel"),
				click : function() {
					dlg.dialog("close");
				}
			}
		}
	});
};
