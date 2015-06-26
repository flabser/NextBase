function addTopicToForum (el, parentdocid, parentdoctype){
	actionTime= moment().format('DD.MM.YYYY HH:mm:ss');
	if($("#topicform").length == 0){
		$("<div id='topicform'><form id='topicfrm' action='Provider' name='topiccomment' method='post' enctype='application/x-www-form-urlencoded'><input type='text' name='theme' id='topicvalue'/><br/><button type='button' id='butformadd' onclick='sendtopic()' style='margin-left:10px' class='ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'>"+add+"</button><button id='butformcancel'  style='margin-left:10px' type='button' onclick='closetopicform()' class='ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'>"+cancel+"</button></form></div>").insertAfter($(el)).slideDown("fast");
		var topicfrm = $("#topicfrm");
		$(topicfrm).append("<input type='hidden' name='type' value='save'/><input type='hidden' name='id' value='topic'/>");
		$(topicfrm).append("<input type='hidden' name='key' value=''/><input type='hidden' name='formsesid' value='1340212408'/>");
		$(topicfrm).append("<input type='hidden' name='parentdocid' value='"+ parentdocid +"'/><input type='hidden' name='parentdoctype' value='" + parentdoctype +"'/>");
		$(topicfrm).append("<input type='hidden' id='topicdate' name='topicdate' value='"+actionTime+"'/>");
		$("#butformadd, #butformcancel").button();
	}
}

function sendtopic(){
	if($("#topicvalue").val().length != 0){
		var formData = $("#topicfrm").serialize();
		$.ajax({
			type: "POST",
			url: 'Provider',
			data: formData,
			success:function (xml){
				var topic_id= $(xml).find("message[id=2]").text();
				var topicform = $("#topicform");
				var topicvalue = $("#topicvalue").val();
				var topicdate = $("#topicdate").val();
				$(topicform).slideUp("fast");
				topic = '<li><a class="doclink-dotted topiclink_'+topic_id+'" href="javascript:closeForumTopic('+topic_id+')"> '+
					'Тема: '+topicvalue+' от ' + topicdate +
					'</a>'+
					'<div class="topic" style="display:block;" id="topic_'+topic_id+'">'+
					'<div id="headerTheme">'+topicvalue+'</div>'+
					'<div id="infoTheme">Автор: '+$("#username").val()+','+ topicdate +'<button style="float:right; margin:3px 10px 0 0" class="ui-button ui-widget ui-state-default ui-corner-all commenttocomment ui-button-text-only" onclick="javascript:addCommentToForum(this,'+topic_id+',904, false)" type="button" role="button" aria-disabled="false"><font style="font-size:12px; vertical-align:top">Комментировать</font></button></div>'+
					'<br/>'+
					'<div id="CountMsgTheme">'+comment_on_discussion + ' : 0</div>'+
					'<div id="msgWrapper"/>'+
					'<table id="topicTbl"/>'+
					'<br/>'+
					'</div>'+
					'</li>';
				$("#topics_list").append(topic);
				$(topicform).remove();
				$("#topic_"+topic_id+" .commenttocomment").button();
			},
			error:function (xhr, ajaxOptions, thrownError){
				if (xhr.status == 400){
					$("body").children().wrapAll("<div id='doerrorcontent' style='display:none'></div>").append("<div id='errordata'>"+xhr.responseText+"</div>");
					$("li[type='square'] > a").attr("href","javascript:backtocontent()")
				}
			}
		});
	}else{
		func= function(){
			$("[name="+name+"]").focus();
			$(this).dialog("close").remove();
		};
		dialogAndFunction(fill_topic_title, func, "theme")
	}
}

function addCommentToForum (el, parentdocid, parentdoctype,isresp){
	var actionTime = moment().format('DD.MM.YYYY HH:mm:ss');
	var commentform = $("#commentform");
	if(commentform.length == 0){
		var div_commentform = "<div id='commentform'>" +
			"<form id='commentfrm' action='Provider' name='frmcomment' method='post' enctype='application/x-www-form-urlencoded'>" +
			"<textarea name='contentsource' id='commentvalue' style='margin:10px ; width:97.5%; height:90px'/>"+
			"<br/><button type='button' id='butformadd' onclick='sendcomment("+parentdocid+","+isresp+")' style='margin-left:10px' class='ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'>"+add+"</button>" +
			"<button id='butformcancel'  style='margin-left:10px' type='button' onclick='closecommentform()' class='ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'>"+cancel+"</button></form></div>";
		if (isresp){
			$(div_commentform).insertAfter($(el).parent().parent()).slideDown("fast");
			if($(el).parent().parent().css("float") == "right"){
				$(commentform).css("float","right");
			}
		}else{
			$(div_commentform).prependTo($("#topic_"+parentdocid +" #msgWrapper")).slideDown("fast");
		}
		$("#commentfrm").append("<input type='hidden' name='type' value='save'/><input type='hidden' name='id' value='comment'/><input type='hidden' name='key' value=''/><input type='hidden' name='parentdocid' value='"+parentdocid+"'/>");
		$("#commentfrm").append("<input type='hidden' name='parentdoctype' value='"+parentdoctype+"'/><input type='hidden' id='postdate' name='postdate' value='"+actionTime+"'/>");
		$("#butformadd, #butformcancel").button()
	}
}

function closecommentform(){
	$("#commentform").slideUp("fast", function() {
		$("#commentform").remove();
	});
}

function closetopicform(){
	$("#topicform").slideUp("fast", function() {
		$("#topicform").remove();
	});
}

function sendcomment(parentdocid,resp){
	if($("#commentvalue").val().length != 0){
		$.ajax({
			type: "POST",
			url: 'Provider',
			data: $("#commentfrm").serialize(),
			success:function (xml){
				count = $(".msgEntry").length;
				comment_id = $(xml).find("message[id=2]").text();
				if(resp){
					topic_container = $("#msgEntry"+parentdocid);
					$('<div class="msgEntry" id="msgEntry'+ comment_id  +'"/><div style="clear:both"/>').insertAfter(topic_container);
					$("#msgEntry"+comment_id).width($(topic_container).width() - 56).css("float","right");
				}else{
					topic_container = $("#topic_"+parentdocid);
					$("#topic_"+parentdocid+" #msgWrapper").append('<div class="msgEntry" id="msgEntry'+ comment_id  +'"/>')
				}
				var msgEntry = $("#msgEntry"+comment_id);
				$(msgEntry).append('<div class="headermsg" id="headermsg"/>');
				$("#msgEntry"+comment_id +" #headermsg").append('<div class="authormsg">'+$("#username").val()+'</div><div class="msgdate">'+sent+':'+$("#postdate").val()+'</div>');
				$(msgEntry).append('<div class="bodymsg" id="bodymsg">'+$("#commentvalue").val()+'</div>');
				$(msgEntry).append('<div class="buttonpanemsg" id="buttonpanemsg"><button type="button" onclick="addCommentToForum(this,'+ comment_id+',905,true)" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only commenttocomment " style="float:right; margin-top:3px"><font style="font-size:12px; vertical-align:top" >'+makecomment+'</font></button></div>');
				$("#msgEntry"+comment_id +" #buttonpanemsg button").button();
				$("#commentform").slideUp("fast", function() {
					i = count+1;
					$("#msgEntry"+comment_id +" #CountMsgTheme").html(comment_on_discussion + ":" + i);
					$("#commentform").remove();
					if(!resp) {
						$("#docwrapper").animate({scrollTop: $("#topic_" + parentdocid + " .msgEntry:last").position().top}, "slow");
					}
				});
			},
			error:function (xhr, ajaxOptions, thrownError){
				if (xhr.status == 400){
					$("body").children().wrapAll("<div id='doerrorcontent' style='display:none'></div>").append("<div id='errordata'>"+xhr.responseText+"</div>");
					$("li[type='square'] > a").attr("href","javascript:backtocontent()")
				}
			}
		});
	}else{
		func= function(){
			$("[name="+name+"]").focus();
			$(this).dialog("close").remove();
		};
		dialogAndFunction(fill_comment, func, "contentsource")
	}
}

function openForumTopic(topic_id){
	$.ajax({
		url: 'Provider?type=view&id=forum_thread&parentdocid='+topic_id+'&parentdoctype=904&command=expand`'+topic_id+'`904&onlyxml',
		datatype:'xml',
		async:'true',
		success: function(data){
			$("#topic_"+topic_id+" #msgWrapper").empty();
			$("#topic_"+topic_id+" #CountMsgTheme").html(comment_on_discussion+": " + $(data).find("query").attr("count"));
			$(data).find("query").find("entry").each(function(index, element){
				var comment_id =$(this).attr("docid");
				var level = parseInt($(this).attr("level"))-1;
				level = level * 4;
				$("#topic_"+topic_id+" #msgWrapper").append('<div class="msgEntry" level="'+ level + '"  style="margin-left:'+level+'em" id="msgEntry'+comment_id+'"/>');
				var msgEntry = $("#msgEntry"+comment_id);
				$(msgEntry).append('<div class="headermsg" id="headermsg"/>');
				$("#msgEntry"+comment_id+" #headermsg").append('<div class="authormsg">'+$(this).children("author").text()+'</div><div class="msgdate">'+sent+':'+$(this).children("viewcontent").children("viewdate").text()+'</div>');
				$(msgEntry).append('<div class="bodymsg" id="bodymsg">'+$(this).children("viewcontent").children("viewtext").text()+'</div>');
				$(msgEntry).append('<div class="buttonpanemsg" id="buttonpanemsg"><button type="button" onclick="addCommentToForum(this,'+ comment_id+',905,true)" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only commenttocomment" style="float:right; margin-top:3px"><font style="font-size:12px; vertical-align:top" >'+makecomment+'</font></button></div>')
			});
			$(".commenttocomment").button()
		}
	});
	$("#topic_"+topic_id).css("display","block");
	$(".topiclink_"+topic_id).attr("href","javascript:closeForumTopic("+topic_id+")");
}

function closeForumTopic(topic_id){
	$("#topic_"+topic_id).css("display","none");
	$(".topiclink_"+topic_id).attr("href","javascript:openForumTopic("+topic_id+")");
}