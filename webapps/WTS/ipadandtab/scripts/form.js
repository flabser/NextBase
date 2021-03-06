var lang = "RUS";
var fieldIsValid = true;
var alertmessage = '';
/* переменные для перевода диалогов */
var acquaintcaption = "Ознакомить"; 
var remindcaption = "Напомнить"; 
var cancelcaption = "Отмена"; 
var changeviewcaption = "Изменить вид"; 
var receiverslistcaption = "Список получателей напоминания"; 
var correspforacquaintance = "Список корреспондентов для ознакомления"; 
var searchcaption = "Поиск"; 
var commentcaption = "Комментарий"; 
var documentsavedcaption = "Документ сохранен"; 
var documentmarkread = "Документ отмечен как прочтенный"; 
var pleasewaitdocsave = "Пожалуйста ждите... Идет сохранение документа"; 
var redirectAfterSave = "";
var qkey
function removeTableElement(el){
	if($(el).closest("table").find("tr").length != 1){
		$(el).closest("tr").remove();
	}else{
		$(el).closest("td").html("&nbsp;")
	}
}	

function addTopicToForum (el, parentdocid, parentdoctype){
	var time=new Date();
	month=time.getMonth()+1;
	day=time.getDate();
	hours=time.getHours();
	minute=time.getMinutes();
	if (month< 10){month="0"+month;}
	if (day<10){day="0"+ time.getDate();}
	if (hours<10){hours="0"+time.getHours();}
	if (minute<10){minute="0"+time.getMinutes();}
	curdate=day +"."+ month + "." + time.getFullYear()+ " " + hours + ":" + minute ;
	if($("#topicform").length == 0){
		$("<div id='topicform' style='width:90%; height:90px; background:#E6E6E6; border:1px solid #ccc; margin-top:5px; display:none; margin-left:10px'><form id='topicfrm' action='Provider' name='topiccomment' method='post'  enctype='application/x-www-form-urlencoded'><input type='text' name='theme' id='topicvalue' style='margin:10px ; width:600px;'/><br/><button type='button' id='butformadd' onclick='sendtopic()' style='margin-left:10px' class='ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'>Добавить</button><button id='butformcancel'  style='margin-left:10px' type='button' onclick='javascript:closecommentform()' class='ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'>Отмена</button></form></div>").insertAfter($(el)).slideDown("fast");
		$("#topicfrm").append("<input type='hidden' name='type' value='save'/>")
		$("#topicfrm").append("<input type='hidden' name='id' value='topic'/>")
		$("#topicfrm").append("<input type='hidden' name='key' value=''/>")
		$("#topicfrm").append("<input type='hidden' name='formsesid' value='1340212408'/>")
		$("#topicfrm").append("<input type='hidden' name='parentdocid' value='"+ parentdocid +"'/>")
		$("#topicfrm").append("<input type='hidden' name='parentdoctype' value='" + parentdoctype +"'/>")
		$("#topicfrm").append("<input type='hidden' id='topicdate' name='topicdate' value='"+curdate+"'/>")
		$("#butformadd").button()
		$("#butformcancel").button()
	}
}

$.fn.extend({
    notify : function(options) {
    	var defaults = { 
    		text: "",
    	  	onopen: function(){$("body").hidenotify()},
    	  	loadanimation:true
    	};
    	var opts = $.extend(defaults, options);
    	$(this).append("<div id='notifydiv'><font>"+opts.text+"</font></div>")
    	if (opts.loadanimation){
    		$("#notifydiv").append("<img src='classic/img/26.png' style='position:absolute; top:3px; right:10px'/>")
    	}
    	$("#notifydiv").animate({top: '0px'},'fast',opts.onopen);
    },
    hidenotify : function(options) {
    	var defaults = { 
        	delay: "1500",
        	onclose: function(){}
        };
        var opts = $.extend(defaults, options);
    	setTimeout(function() {
    		$("#notifydiv").animate({top: '-40px'},'fast',opts.onclose);
        }, opts.delay);
    }
});

function sendtopic(){
	if($("#topicfrm").children("#topicvalue").val().length !="0"){
		var formData = $("#topicfrm").serialize();
		$.ajax({
			type: "POST",
			url: 'Provider',
			data: $("#topicfrm").serialize(),
			success:function (xml){
				$("#topicform").slideUp("fast")
				$("<table style='width:100%'><tr><td><div display='block' style='display:block; width:90%' id='topic'><div id='headerTheme' style='width:100%; padding-left:10px'>"+$("#topicvalue").val()+"</div><div id='infoTheme' style='width:100%; padding-left:10px; padding-top:3px'>Автор: "+$("#username").val()+","+ $("#topicdate").val()+"</div><br/><div id='CountMsgTheme' style='color:#555555; padding:12px; background:#E6E6E6; border:1px solid #D3D3D3; margin-left:10px; border-radius: 5px 5px 0px 0px; height:20px; font-size: 13px; font-weight: 300; overflow: hidden;'></div><div id='msgWrapper' style='border:1px solid #DDE5ED; min-height:150px; margin-left:10px'></div><table id='topicTbl' style=' width:100%'/><br/></div></td></tr></table>").insertAfter($("#bordercomment"));
				$("#CountMsgTheme").append("Комментариев в теме: 0")
				$("#btnnewcomment span").html("<img class='button_img' src='/SharedResources/img/classic/icons/comment.png'><font style='font-size:12px; vertical-align:top'>Написать новый комментарий</font>")
				$("#btnnewcomment").attr("onclick","javascript:addCommentToForum(this,"+$(xml).find("message[id=2]").text()+",904)")
			},
			error:function (xhr, ajaxOptions, thrownError){
				if (xhr.status == 400){
					$("body").children().wrapAll("<div id='doerrorcontent' style='display:none'></div>")
					$("body").append("<div id='errordata'>"+xhr.responseText+"</div>")
					$("li[type='square'] > a").attr("href","javascript:backtocontent()")
				}
			}    
		});
	}else{
		infoDialog("Заполните название темы")
	}
}

function addCommentToForum (el, parentdocid, parentdoctype,isresp){
	var time=new Date();
	month=time.getMonth()+1;
	day=time.getDate();
	hours=time.getHours();
	minute=time.getMinutes();
	if (month< 10){month="0"+month;}
	if (day<10){day="0"+ time.getDate();}
	if (hours<10){hours="0"+time.getHours();}
	if (minute<10){minute="0"+time.getMinutes();}
	curdate=day +"."+ month + "." + time.getFullYear()+ " " + hours + ":" + minute ;
	if($("#commentform").length == 0){
		if (isresp){
			level= parseInt($(el).parent().parent().attr("level"));
			level = level *4;
			level =level + "em";
			$("<div id='commentform' style='height:160px; background:#E6E6E6; border:1px solid #ccc; margin-top:5px; display:none; margin-left:"+ level+"'><form id='commentfrm' action='Provider' name='frmcomment' method='post'  enctype='application/x-www-form-urlencoded'><textarea name='contentsource' id='commentvalue' style='margin:10px ; width:97.5%; height:90px'></textarea><br/><button type='button' id='butformadd' onclick='sendcomment(true,el)' style='margin-left:3px; float:right' class='ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'>Добавить</button><button id='butformcancel'  style='margin-left:3px; float:right' type='button' onclick='javascript:closecommentform()' class='ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'>Отмена</button></form></div>").insertAfter($(el).parent().parent()).slideDown("fast");
		}else{
			$("<div id='commentform' style='width:90%; height:160px; background:#E6E6E6; border:1px solid #ccc; margin-top:5px; display:none; margin-left:10px'><form id='commentfrm' action='Provider' name='frmcomment' method='post'  enctype='application/x-www-form-urlencoded'><textarea name='contentsource' id='commentvalue' style='margin:10px ; width:97.5%; height:90px'></textarea><br/><button type='button' id='butformadd' onclick='sendcomment()' style='margin-left:3px; float:right' class='ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'>Добавить</button><button id='butformcancel'  style='margin-left:3px; float:right' type='button' onclick='javascript:closecommentform()' class='ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'>Отмена</button></form></div>").insertAfter($(el)).slideDown("fast");
		}
		$("#commentfrm").append("<input type='hidden' name='type' value='save'/>")
		$("#commentfrm").append("<input type='hidden' name='id' value='comment'/>")
		$("#commentfrm").append("<input type='hidden' name='key' value=''/>")
		$("#commentfrm").append("<input type='hidden' name='parentdocid' value='"+ parentdocid +"'/>")
		$("#commentfrm").append("<input type='hidden' name='parentdoctype' value='" + parentdoctype +"'/>")
		$("#commentfrm").append("<input type='hidden' id='postdate' name='postdate' value='"+curdate+"'/>")
		$("#butformadd").button()
		$("#butformcancel").button()
	}
}

function closecommentform(){
	$("#commentform").slideUp("fast", function() {
		$("#commentform").remove();
	}); 
}

function sendcomment(resp){
	if($("#commentfrm").children("#commentvalue").val().length != 0){
		var formData = $("#commentfrm").serialize();
		$.ajax({
			type: "POST",
			url: 'Provider',
			data: $("#commentfrm").serialize(),
			success:function (xml){
					count = $(".msgEntry").length;
					if(resp){
						$('<div class="msgEntry" id="msgEntry'+ count  +'"/><div style="clear:both"/>').insertAfter($("#commentform"))
						level= parseInt($("#msgEntry"+count).prev("div").prev("div").attr("level"));
						level = level+ 1;
						$("#msgEntry"+count).attr("level", level)
						level = level*4;
						level =level + "em";
						$("#msgEntry"+count).css("margin-left", level)
					}else{
						$("#msgWrapper").append('<div class="msgEntry" style="margin-top:10px" level="0" id="msgEntry'+ count  +'"/>')
					}
					$("#msgEntry"+count).append('<div class="headermsg" id="headermsg'+ count +'"/>')
					$("#headermsg"+count).append('<div class="authormsg">'+$("#username").val()+'</div>')
					$("#headermsg"+count).append('<div class="msgdate">отправлено:'+$("#postdate").val()+'</div>')
					$("#msgEntry"+count).append('<div class="bodymsg" id="bodymsg'+ count +'">'+$("#commentvalue").val()+'</div>')
					newid = $(xml).find('message[id=2]').text()
					$("#msgEntry"+count).append('<div class="buttonpanemsg" id="buttonpanemsg'+ count +'"><button type="button" onclick="javascript:addCommentToForum(this,'+ newid +',905,true)" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only commenttocomment" style="float:right; margin-top:3px"><font style="font-size:12px; vertical-align:top" >Комментировать</font></button></div>')
					$("#msgEntry"+count +" button").button()
					if(resp){
						$("#commentform").slideUp("fast", function() {
							i = count+1;
							$("#CountMsgTheme").html("Комментариев в теме:" + i)
							$("#commentform").remove();
							infoDialog("Комментарий успешно добавлен")
						}); 
					}else{
						$("#commentform").slideUp("fast", function() {
							i = count+1;
							$("#CountMsgTheme").html("Комментариев в теме:" + i)
							$("#commentform").remove();
							$("#docwrapper").animate({ scrollTop: $('#msgEntry'+count).position().top}, "slow",function() {
								infoDialog("Комментарий успешно добавлен")
							}); 
						}); 
					}
					
			},
			error:function (xhr, ajaxOptions, thrownError){
				if (xhr.status == 400){
					$("body").children().wrapAll("<div id='doerrorcontent' style='display:none'></div>")
					$("body").append("<div id='errordata'>"+xhr.responseText+"</div>")
					$("li[type='square'] > a").attr("href","javascript:backtocontent()")
				}
			}    
		});
	}else{
		infoDialog("Заполните текст комментария")
	}
}


function SuggestionContractor() {
	var availableTags = []
	$("#contractor").keyup(function(eventObject){
	if (eventObject.which != 37 && eventObject.which != 38 && eventObject.which != 39 && eventObject.which != 40 && eventObject.which != 13){
	  availableTags.length = 0;
	  if ($("#contractor").val().length > 3){
		  $("#contractor").addClass("ui-autocomplete-loading")
		  $("#tiptip_holder").css("display","none")
	  	$.ajax({
			url: 'Provider?type=query&id=contractor-sugg&page=1&keyword='+encodeURIComponent($("#contractor").val()),
			datatype:'xml',
			success: function(data) {
				$(data).find("entry[doctype=894]").each(function(index, element){
				  availableTags.push({label:$(element).find("viewcontent").find("viewtext1").text(), value:$(element).find("viewcontent").find("viewtext1").text(),id:$(element).attr("docid"),isbadperformer:$(element).find("isbadperformer").text()});
				});
			},
			complete:function() {
				$("#contractor").autocomplete({
					source: availableTags,
					select: function(event, ui) { 
						$("#contractorid").val(ui.item.id)
						$("#contractorviewtext").val(ui.item.value)
						if (ui.item.isbadperformer == "true"){
							if ($(".notecontractor").html() == null){
								$("#contractor").after("<div class='notecontractor' style='padding:5px 0px 8px 5px; height:12px; display:inline-block'><font style='color:red; font-size:11px; vertical-align:bottom'>Недобросовестный исполнитель</font></div>");
							}
						}else{
							$(".notecontractor").remove()
						}
					}
				});
				$("#contractor").autocomplete("search" , $("#contractor").val())
			}
		});	
	}else{
		 $("#tiptip_holder").css("display","block")
	}
	}
		});
}

function contractorFieldUpdate(){
	if ($("#contractor").val().length == 0 ){
		$("#contractorid , #contractorviewtext").val('')
		//$("#contractorviewtext").val('')
	}else{
		$("#contractor").val($("#contractorviewtext").val())
	}
}

function setValHiddenFields(el){
	$("[name=parentdocid]").val($(el).val());
}

function addSubCatGloss(el){
	if ($(el).val() != ''){
		$.ajax({
			url: 'Provider?type=query&id=glossresponses&parentdocid='+$(el).val()+'&parentdoctype=894',
			datatype:'xml',
			success: function(data) {
				$("#subcategory option").remove();
				$(data).find("entry[doctype=894]").each(function(index, element){
					  $("#subcategory").append("<option value='"+ $(element).attr("docid")+"'>"+ $(element).attr("viewtext") +"</option>")
				});
				if ($("#subcategory > option").length == 0){
					 $("#subcategory").append("<option value=''>Подвидов нет</option>")
				}
			}
		});	
	}
}

function openOriginPlaceExtra(){
	if($("#originplaceextra").css("display") == 'none'){
		$("#originplaceextra").slideDown("fast")
		$("#originplaceCaption").text("кратко")
		$("#originplaceCaption").attr("title","Скрыть подробности проекта")
	}else{
		$("#originplaceextra").slideUp("fast");
		$("#originplaceCaption").text("подробнее")
		$("#originplaceCaption").attr("title","Отобразить подробности проекта")
	}
}

function openProjectExtra(){
	if($("#projectextra").css("display") == 'none'){
		if($("select[name=project]").val() != ' ' && $("select[name=project]").val() != '' ){
			$.ajax({
				url: 'Provider?type=edit&element=glossary&id=projectsprav&key='+ $("select[name=project]").val() +'&onlyxml',
				datatype:'xml',
				success: function(data) {
					$(".tehnadzortr").remove()
					$("#rukproj").val($(data).find("projectmanager").text())
					$("#zamrukproj").val($(data).find("zamprojectmanager").text())
					$(data).find("techsupervision").find("entry").each(function(index, element){
						 if (index == 0){
							$("#projectextratable").append("<tr class='tehnadzortr'>"+
								"<td width='30%' class='fc'>Технический надзор :</td>" +
								"<td><input type='text' id='tehnadzor' size='10' class='td_noteditable' style='width:300px' value='"+ $(element).text()+"'/></td>" +
							"</tr>")
						 }else{
							 $("#projectextratable").append("<tr class='tehnadzortr'>"+
								"<td width='30%' class='fc'></td>" +
								"<td><input type='text' id='tehnadzor' size='10' class='td_noteditable' style='width:300px' value='"+ $(element).text()+"'/></td>" +
							"</tr>") 
						 }
					});
				}
			});	
			$("#projectextra").slideDown("fast")
			$("#projectCaption").text("кратко")
			$("#projectCaption").attr("title","Скрыть подробности места возникновения замечания")
		}else{
			$("#projectextra").slideDown("fast")
			$("#projectCaption").text("кратко")
			$("#projectCaption").attr("title","Скрыть подробности места возникновения замечания")
		}
	}else{
		$("#projectextra").slideUp("fast");
		$("#projectCaption").text("подробнее")
		$("#projectCaption").attr("title","Отобразить подробности места возникновения замечания")
	}
}

function updateProjectExtra(){
	if($("select[name=project]").val() != ' ' && $("select[name=project]").val() != '' ){
		$.ajax({
			url: 'Provider?type=edit&element=glossary&id=projectsprav&key='+ $("select[name=project]").val() +'&onlyxml',
			datatype:'xml',
			success: function(data) {
				$(".tehnadzortr").remove()
				$("#rukproj").val($(data).find("projectmanager").text())
				$("#zamrukproj").val($(data).find("zamprojectmanager").text())
				$(data).find("techsupervision").find("entry").each(function(index, element){
					if (index == 0){
						$("#projectextratable").append("<tr class='tehnadzortr'>"+
								"<td width='30%' class='fc'>Технический надзор :</td>" +
								"<td><input type='text' id='tehnadzor' size='10' class='td_noteditable' style='width:300px' value='"+ $(element).text()+"'/></td>" +
						"</tr>")
					}else{
						$("#projectextratable").append("<tr class='tehnadzortr'>"+
								"<td width='30%' class='fc'></td>" +
								"<td><input type='text' id='tehnadzor' size='10' class='td_noteditable' style='width:300px' value='"+ $(element).text()+"'/></td>" +
						"</tr>") 
					}
				});
			}
		});	
	}else{
		$(".tehnadzortr").remove()
		$("#rukproj , #zamrukproj ").val('')
		//$("#zamrukproj").val('')
	}
}
function switchModeFilter(el, mode ,num){
	if (mode == 1) {
		$(el).attr('src', "/SharedResources/img/iconset/bullet_green.png");
		$(el).attr('title', "Выключить фильтр");
		$("input[name=filter"+num+"_mode]").val('1');
		$(el).attr('onclick', "javascript:switchModeFilter(this, 0, "+ num+")");
	} else {
		$(el).attr('src',"/SharedResources/img/iconset/bullet_red.png");
		$(el).attr('title', "Включить фильтр");
		$("input[name=filter"+num+"_mode]").val('0');
		$(el).attr('onclick', "javascript:switchModeFilter(this, 1, "+ num+")");
	}
}

function openFilter(el, number){
		divhtml="<div class='picklistCoord' id='coordParam' style='height:300px; width:510px'>" +
		"<div class='headerBoxCoord' style='width:100%'>" +
		"<font class='headertext'>"+docfilter+"</font>" +
		"<div class='closeButton'  onclick='hideDialog(); '>" +
			"<img style='width:15px; height:15px; margin-left:3px; margin-top:1px' src='/SharedResources/img/iconset/cross.png' onclick='pickListClose();'/>" +
		"</div>" +
		"</div>" +
		"<div class='contentCoord'>" +
		"</div></div>";
		$("body").append(divhtml);
		$("#coordParam").draggable({handle:"div.headerBoxCoord"});
		centring('coordParam',300,510); 
		$.ajax({
			type: "get",
			url: 'Provider?type=view&id=docsfilter',
			success:function (data){
				blockWindow = "<div  class = 'ui-widget-overlay blockWindow' id = 'blockWindow'></div>"; 
				$("body").append(blockWindow);
				$('#blockWindow').css('width',$(document).width()); 
				$('#blockWindow').css('height',$(document).height());
				$(".contentCoord").append(data)
				$(".contentCoord").append("<div class='buttonPane button_panel' style='width:100%'>" +
				"<span style='float:right; margin-right:20px; margin-top:7px'><button class='ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only' onclick='saveOldFilter("+number+")' style='margin-right:5px'><span class='ui-button-text'><font style='font-size:12px; vertical-align:top'>Ок</font></span></button>" +
				"<button class='ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only' onclick='javascript:hideDialog()'><span class='ui-button-text'><font style='font-size:12px; vertical-align:top'>"+cancelcaption+"</font></span></button>" +
				"</a></span></div>")
				$("input[name=filtername]").val($("input[name=filter"+number+"_name]").val());
				$("input[name=filtermode]").val($("input[name=filter"+number+"_mode]").val());
				$("input[name=authorfilter]").val($("input[name=filter"+number+"_author]").val());
				$("input[name=authorfiltername]").val($("input[name=filter"+number+"_authorname]").val());
				$("input[name=keywordfilter]").val($("input[name=filter"+number+"_keyword]").val());
				$("input[name=datefromfilter]").val($("input[name=filter"+number+"_datefrom]").val());
				$("input[name=datetofilter]").val($("input[name=filter"+number+"_dateto]").val());
				$("input[name=filteridfilter]").val($("input[name=filter"+number+"_id]").val());
				$("select[name=doctypefilter] option[value="+$("input[name=filter"+number+"_doctype]").val()+"]").attr("selected","selected");
				$("select[name=categoryfilter] option[value="+$("input[name=filter"+number+"_category]").val()+"]").attr("selected","selected");
				$("select[name=projectfilter] option[value="+$("input[name=filter"+number+"_project]").val()+"]").attr("selected","selected");
				
				if($("input[name=filter"+number+"_author]").val() !=''){$("input[name=checkauthorfilter]").attr("checked","true")}
				if($("input[name=filter"+number+"_keyword]").val()!=''){$("input[name=checkkeywordfilter]").attr("checked","true")}
				if($("input[name=filter"+number+"_datefrom]").val()!=''){$("input[name=checkdatefilter]").attr("checked","true")}
				if($("input[name=filter"+number+"_dateto]").val()!=''){$("input[name=checkdatefilter]").attr("checked","true")}
				if($("input[name=filter"+number+"_doctype]").val()!=''){$("input[name=checkdoctypefilter]").attr("checked","true")}
				if($("input[name=filter"+number+"_category]").val()!=''){$("input[name=checkcategoryfilter]").attr("checked","true")}
				if($("input[name=filter"+number+"_project]").val()!=''){$("input[name=checkprojectfilter]").attr("checked","true")}
				
			},
			error:function (xhr, ajaxOptions, thrownError){
	            if (xhr.status == 400){
	         	  $("body").children().wrapAll("<div id='doerrorcontent' style='display:none'></div>")
	         	  $("body").append("<div id='errordata'>"+xhr.responseText+"</div>")
	         	  $("li[type='square'] > a").attr("href","javascript:backtocontent()")
	            }
	         }  
		});
		
}

function addFilter() {
	el="coordParam"
	divhtml="<div class='picklistCoord' id='coordParam'  style='height:300px; width:510px; z-index:4'>" +
	"<div class='headerBoxCoord' style='width:100%'>" +
	"<font class='headertext'>"+docfilter+"</font>" +
	"<div class='closeButton'  onclick='hideDialog(); '>" +
		"<img style='width:15px; height:15px; margin-left:3px; margin-top:1px' src='/SharedResources/img/iconset/cross.png'/>" +
	"</div>" +
	"</div>" +
	"<div class='contentCoord'>" +
	"</div></div>";
	$("body").append(divhtml);
	$("#coordParam").draggable({handle:"div.headerBoxCoord"});
	centring('coordParam',300,510); 
	$.ajax({
		type: "get",
		url: 'Provider?type=view&id=docsfilter',
		success:function (data){
			blockWindow = "<div  class = 'ui-widget-overlay' id = 'blockWindow'></div>"; 
			$("body").append(blockWindow);
			$('#blockWindow').css('width',$(document).width()); 
			$('#blockWindow').css('height',$(document).height());
			$(".contentCoord").append(data)
			$(".contentCoord").append("<div class='buttonPane button_panel' style='width:100%'>" +
			"<span style='float:right; margin-right:20px; margin-top:7px'><button class='btnFilter' onclick='saveFilter()' style='margin-right:5px'><span><font style='font-size:12px; vertical-align:top'>Ок</font></span></button>" +
			"<button  class='btnFilter' onclick='javascript:hideDialog()'><span><font style='font-size:12px; vertical-align:top'>"+cancelcaption+"</font></span></button>" +
			"</a></span></div>")
			$(".btnFilter").button()
			$("input[name=filtername]").focus();
		},
		error:function (xhr, ajaxOptions, thrownError){
            if (xhr.status == 400){
         	  $("body").children().wrapAll("<div id='doerrorcontent' style='display:none'></div>")
         	  $("body").append("<div id='errordata'>"+xhr.responseText+"</div>")
         	  $("li[type='square'] > a").attr("href","javascript:backtocontent()")
            }
         }  
	});
	
}
	var countFilter;
	
function saveOldFilter(num){
	valid = true; 
	check = false; 
	doctype = '';
	project = '';
	author = '';
	category = ''; 
	date = '';
	keyword = '';
	doctypevalue = '';
	projectvalue = '';
	authorvalue = ''; 
	categoryvalue = '';
	datetovalue = '';
	datefromvalue = '';
	datetovalue= '';
	keyword = '';
	authorname='';
	//	if($("input[name=checkdoctypefilter]").is(":checked")){
			check = true;
			doctype = $("[name=doctypefilter] option:selected").text();
		/*	if ($("[name=doctypefilter]").val().length < 1 ){
				valid = false;
			}*/
			doctypevalue = $("[name=doctypefilter]").val();
		//}
		if($("input[name=checkprojectfilter]").is(":checked")){
			check = true;
			project = $("[name=projectfilter] option:selected").text();
			if ($("[name=projectfilter]").val().length < 1 ){
				valid = false;
			}
			projectvalue = $("[name=projectfilter]").val();
		}
		if($("input[name=checkauthorfilter]").is(":checked")){
			check = true;
			author = $("[name=authorfilter]").val();
			if ($("[name=authorfilter]").val().length < 1 ){
				valid = false;
			}
			authorvalue = $("[name=authorfilter]").val();
			authorname = $("[name=authorfiltername]").val();
		}
		if($("input[name=checkcategoryfilter]").is(":checked")){
			check = true;
			category = $("[name=categoryfilter] option:selected").text();
			if ($("[name=categoryfilter]").val().length < 1 ){
				valid = false;
			}
			categoryvalue = $("[name=categoryfilter]").val(); 
		}
		if($("input[name=checkdatefilter]").is(":checked")){
			check = true;
			date = $("[name=datefromfilter]").val() + " - " + $("[name=datetofilter]").val();
			datefromvalue = $("[name=datefromfilter]").val() ;
			if ($("[name=datetofilter]").val().length < 1 &&  $("[name=datefromfilter]").val().length < 1){
				valid = false;
			}
			datetovalue = $("[name=datetofilter]").val() ;
		}
		if($("input[name=checkkeywordfilter]").is(":checked")){
			check = true;
			if ($("[name=keywordfilter]").val().length < 1 ){
				valid = false;
			}
			keyword = $("[name=keywordfilter]").val();
		}
		if (check == true){
		if (valid == false){
			infoDialog("Заполните все поля отмеченные вами")
		}else{
			if($("input[name=filtername]").val()==''){
				func= function(){
					$("[name="+name+"]").focus();
					$(this).dialog("close").remove();
				};
				dialogAndFunction ("Заполните название фильтра",func, "filtername")
			}else{
				
			if ($("input[name=filtermode]").val() == 0){
				filtermodeimg = "<img src='/SharedResources/img/iconset/bullet_red.png' style='cursor:pointer' title='Включить фильтр' onclick='javascript:switchModeFilter(this,1 ,"+num+")'/>"
			}else{
				filtermodeimg = "<img src='/SharedResources/img/iconset/bullet_green.png' style='cursor:pointer' title='Выключить фильтр' onclick='javascript:switchModeFilter(this,0 ,"+num+")'/>"
			}	
			newtr = "<tr id='filtertr"+num+"'>" ;
			//newtr = "<a href='javascript:openFilter(this, "+num+")' class='doclink'>"+$("input[name=filtername]").val()+"</a>"
			newtr +="<td><input type='checkbox' name='chbox'/></td>"
			newtr +="<td>"+ filtermodeimg +"<input type='hidden' name='filter"+num+"_"+"mode' value='"+$("input[name=filtermode]").val()+"'><input type='hidden' name='filter"+num+"_"+"id' value='"+$("input[name=filteridfilter]").val()+"'></td>"
			newtr +="<td><a href='javascript:openFilter(this, "+num+")' class='doclink'>"+$("input[name=filtername]").val()+"</a><input type='hidden' name='filter"+num+"_"+"name' value='"+$("input[name=filtername]").val()+"'></td>"
			newtr +="<td>"+doctype+"<input type='hidden' name='filter"+num+"_"+"doctype' value='"+doctypevalue+"'></td>"
			newtr +="<td>"+project+"<input type='hidden' name='filter"+num+"_"+"project' value='"+projectvalue+"'></td>"
			newtr +="<td>"+category+"<input type='hidden' name='filter"+num+"_"+"category' value='"+categoryvalue+"'></td>"
			newtr +="<td>"+authorname+"<input type='hidden' name='filter"+num+"_"+"author' value='"+authorvalue+"'></td>"
			newtr +="<td>"+date+"<input type='hidden' name='filter"+num+"_"+"datefrom' value='"+datefromvalue+"'>"+"<input type='hidden' name='filter"+num+"_"+"dateto' value='"+datetovalue+"'></td>"
			newtr +="<td>"+keyword+"<input type='hidden' name='filter"+num+"_"+"keyword' value='"+keyword+"'></td>"
			newtr +="</tr>"
			$("#filtertr"+num).replaceWith(newtr);
			hideDialog()
			
			}
		}
		}else{
			infoDialog("Вы не выбрали поля для фильтра")
		}
	}
	
	
function saveFilter(){
	valid = true; 
	check = false; 
	if (countFilter == undefined){
		countFilter = 100;
	}else{
		countFilter++
	}
	doctype = '';
	project = '';
	author = '';
	category = ''; 
	date = '';
	keyword = '';
	doctypevalue = '';
	projectvalue = '';
	authorvalue = ''; 
	categoryvalue = '';
	datetovalue = '';
	datefromvalue = '';
	datetovalue= '';
	keyword = '';
	authorname = '';
//	if($("input[name=checkdoctypefilter]").is(":checked")){
	check = true;
	doctype = $("[name=doctypefilter] option:selected").text();
/*	if ($("[name=doctypefilter]").val().length < 1 ){
		valid = false;
	}*/
	doctypevalue = $("[name=doctypefilter]").val();
//}
	if($("input[name=checkprojectfilter]").is(":checked")){
		check = true;
		project = $("[name=projectfilter] option:selected").text();
		if ($("[name=projectfilter]").val().length < 1 ){
			valid = false;
		}
		projectvalue = $("[name=projectfilter]").val();
	}
	if($("input[name=checkauthorfilter]").is(":checked")){
		check = true;
		author = $("[name=authorfilter]").val();
		if ($("[name=authorfilter]").val().length < 1 ){
			valid = false;
		}
		authorvalue = $("[name=authorfilter]").val();
		authorname = $("[name=authorfiltername]").val();
	}
	if($("input[name=checkcategoryfilter]").is(":checked")){
		check = true;
		category = $("[name=categoryfilter] option:selected").text();
		if ($("[name=categoryfilter]").val().length < 1 ){
			valid = false;
		}
		categoryvalue = $("[name=categoryfilter]").val(); 
	}
	if($("input[name=checkdatefilter]").is(":checked")){
		check = true;
		date = $("[name=datefromfilter]").val() + " - " + $("[name=datetofilter]").val();
		datefromvalue = $("[name=datefromfilter]").val() ;
		if ($("[name=datetofilter]").val().length < 1 &&  $("[name=datefromfilter]").val().length < 1){
			valid = false;
		}
		datetovalue = $("[name=datetofilter]").val() ;
	}
	if($("input[name=checkkeywordfilter]").is(":checked")){
		check = true;
		if ($("[name=keywordfilter]").val().length < 1 ){
			valid = false;
		}
		keyword = $("[name=keywordfilter]").val();
	}
	if (check == true){
	if (valid == false){
		infoDialog("Заполните все поля отмеченные вами")
	}else{
		if($("input[name=filtername]").val()==''){
			func= function(){
				$("[name="+name+"]").focus();
				$(this).dialog("close").remove();
			};
			dialogAndFunction ("Заполните название фильтра",func, "filtername")
		}else{
			newtr = "<tr id='filtertr"+countFilter+"'>" ;
		newtr +="<td><input type='checkbox' name='chbox'/></td>"
		newtr +="<td><img src='/SharedResources/img/iconset/bullet_green.png' title='Выключить фильтр' style='cursor:pointer' onclick='javascript:switchModeFilter(this,0 ,"+countFilter+")'/><input type='hidden' name='filter"+countFilter+"_"+"mode' value='1'><input type='hidden' name='filter"+countFilter+"_"+"id' value=''></td>"
		newtr +="<td><a href='javascript:openFilter(this, "+countFilter+")' class='doclink'>"+$("input[name=filtername]").val()+"</a><input type='hidden' name='filter"+countFilter+"_"+"name' value='"+$("input[name=filtername]").val()+"'></td>"
		newtr +="<td>"+doctype+"<input type='hidden' name='filter"+countFilter+"_"+"doctype' value='"+doctypevalue+"'></td>"
		newtr +="<td>"+project+"<input type='hidden' name='filter"+countFilter+"_"+"project' value='"+projectvalue+"'></td>"
		newtr +="<td>"+category+"<input type='hidden' name='filter"+countFilter+"_"+"category' value='"+categoryvalue+"'></td>"
		newtr +="<td>"+authorname+"<input type='hidden' name='filter"+countFilter+"_"+"author' value='"+authorvalue+"'></td>"
		newtr +="<td>"+date+"<input type='hidden' name='filter"+countFilter+"_"+"datefrom' value='"+datefromvalue+"'>"+"<input type='hidden' name='filter"+countFilter+"_"+"dateto' value='"+datetovalue+"'></td>"
		newtr +="<td>"+keyword+"<input type='hidden' name='filter"+countFilter+"_"+"keyword' value='"+keyword+"'></td>"
		newtr +="</tr>"
		$("#filterTable").append(newtr);
		hideDialog()
		
		}
	}
	}else{
		infoDialog("Вы не выбрали поля для фильтра")
	}
}

function delFilter(){
	$("input[name=chbox]:checked").parent("td").parent("tr").remove()
}

function enabledChbox (name){
	$("input[name="+name+"]").attr("checked","true");
}

/* ограничение количества ввода символов в поле*/
function maxCountSymbols (el, count, e, warn){
	$(el).keypress(function (e) {
		if ($(el).val().length > count){
			if ((e.which == 8) ||  (e.which > 36 && e.which < 41) ) {
				if (e.which == 8 && $("#warntext").is(":visible")){
					$("#warntext").remove()
				}
			}else{
				 if(!$("#warntext").is(":visible") && warn==true){
					 $(el).parent().append("<font id='warntext' style='color:red; font-size:11px; margin-left:5px; line-height:20px'>Длина поля не должна превышать "+count+" символов</font>")
				 }
				 return false
			}
			
		}
	});
}

/*проверка выбранного формата файла отчета*/
function reportsTypeCheck (el){
	if($(el).val() == 2){
		$("input[type=radio][name=disposition][value=inline]").attr("disabled","disabled")
		$("input[type=radio][name=disposition][value=attachment]").attr("checked","checked")
	} else{
		$("input[type=radio][name=disposition][value=inline]").removeAttr("disabled")
	}
}

function fillingReport(id){
	loadingOutline()
	enableblockform()
	var fields = $('form').serializeArray();
	var formData = $("form").serialize();
	var recursiveEncoded = $.param(fields);
	if($("input[name=typefilereport]:checked").val() == 3){
		$(".reporttable").remove();
		$(".reportinfotable").remove();
		$.ajax({
			type: "POST",
			url: 'Provider?type=handler&id=dynamic_report_as_xml',
			data: $("form").serialize(),
			success:function (xml){
				table ="<table class='reporttable' style='width:100%; border-collapse:collapse'>" +
						"<tr style='background:#dfdfdf; border:1px solid #cdcdcd; height:35px'>" +
							"<td style='text-align:center'>Наименование контрагента</td>" +
							"<td style='text-align:center; width:170px'>№ предписания </td>" +
							"<td style='text-align:center'>Наименование замечания</td>" +
							"<td style='text-align:center; width:170px'>Отметка об устранении</td>" +
							"<td style='text-align:center'>Наименование объекта</td>" +
							"<td style='text-align:center'>Сумма ущерба</td>" +
						"</tr>"
				$(xml).find("handler").find("entry[docid]").each(function(){
					if ($(this).find("status").text() == '362'){
						status="<font style='color:#00CD00'>Устранено</font>";
					}else{
						status="<font style='color:red'>Не устранено</font>";
					}
					table +="<tr>" +
								"<td style='border:1px solid #cdcdcd;padding:3px; text-align:left'>"+$(this).find("contragent").text()+"</td>" +
								"<td style='border:1px solid #cdcdcd;padding:3px; text-align:left'><a class='doclink' href='"+$(this).attr('url')+"'>"+$(this).find("remark_number").text()+"</a></td>" +
								"<td style='border:1px solid #cdcdcd;padding:3px; text-align:left'>"+$(this).find("content").text()+"</td>" +
								"<td style='border:1px solid #cdcdcd;padding:3px; text-align:left'>"+status+"</td>" +
								"<td style='border:1px solid #cdcdcd;padding:3px; text-align:left'>"+$(this).find("project").text()+"</td>" +
								"<td style='border:1px solid #cdcdcd;padding:3px; text-align:left'>"+$(this).find("amount").text()+"</td>" +
							"</tr>";
					status= null;
				})
				table +="</table>"
				$("#report_place").append(table);
				infotable ="<table class='reportinfotable' style='width:100%; border-collapse:collapse'>" +
				"<tr style=''>" +
					"<td style='text-align:left; font-size:13px'>Количество замечаний :" +
					 $(xml).find("total").text() +"</td>" +
				"</tr>"+
				"<tr style=''>" +
					"<td style='text-align:left; font-weight:bold; padding-left:10px; padding-bottom:10px'>Устранено : " +
					$(xml).find("executed").attr('count')+"</td>" +
				"</tr>"
				$(xml).find("executed").find("entry").each(function(){
					infotable +="<tr >" +
								"<td style='padding:5px 0px 5px 25px; text-align:left'><b style='color:#444'>"+ $(this).find("projectname").text() + "</b> : " 
								+ $(this).find("projectcount").text() +"</td>" +
							"</tr>"
				})
				infotable +="<tr style=''>" +
				"<td style='text-align:left; font-weight:bold; padding-left:10px; padding-bottom:10px; ; padding-top:10px'>Не устранено : " +
					$(xml).find("unexecuted").attr('count')+"</td>" +
				"</tr>"
				$(xml).find("unexecuted").find("entry").each(function(){
					infotable +="<tr >" +
								"<td style='padding:5px 0px 5px 25px; text-align:left'><b style='color:#444'>"+ $(this).find("projectname").text() + "</b> : " 
								+ $(this).find("projectcount").text() +"</td>" +
							"</tr>"
				})
				infotable +="</table>"
				$("#report_info_place").append(infotable);
				$('#loadingpage').css("display","none");
				$('#blockWindow').css("display","none");
				$("body").css("cursor","default")
				disableblockform()
			},
			error:function (xhr, ajaxOptions, thrownError){
				if (xhr.status == 400){
					$("body").children().wrapAll("<div id='doerrorcontent' style='display:none'></div>")
					$("body").append("<div id='errordata'>"+xhr.responseText+"</div>")
					$("li[type='square'] > a").attr("href","javascript:backtocontent()")
				}
			}    
		});
	}else{
		window.location.href = 'Provider?type=handler&id='+id+'&'+recursiveEncoded;
		$('#loadingpage').css("display","none");
		$('#blockWindow').css("display","none");
		$("body").css("cursor","default")
		disableblockform()
	}
}

/* кнопка "назад"*/
function CancelForm(url,grandparform) {
	if (url != null && url.length !=0 ){
		window.location.href=url
	}else{
		if (grandparform !=''){
			window.location.href = "Provider?type=view&id=remark"
		}
		else{
			window.history.back()
		}
	}
}

function fieldOnFocus(field) {
	field.style.backgroundColor = '#FFFFE4';
}

function fieldOnBlur(field) {
	field.style.backgroundColor = '#FFFFFF';
}

function Numeric(el) {
	$(el).keypress(function (e) {
		if ((e.which < 48) || (e.which > 57) ) {
			if( (e.which != 8) ){
				return false
			}
		}
	});
}

function numericfield(el) {
	$(el).keypress(function (e) {
		if ((e.which < 48) || (e.which > 57) ) {
			if( (e.which == 8 || e.which == 13 || e.which == 46 ) ){
				if ($(el).val().length == 1){
					$("#tiptip_holder").css("display","block")
				}
			}else{
				$("#tiptip_holder").css("display","block")
				return false
			}
		}else{
			$("#tiptip_holder").css("display","none")
		}
	});
}


function addExecutorField(pos,execid){
	if (pos==1){
		$("#frm").append("<input type='hidden' id='controlres"+pos+"' name='executor' value='"+ execid +"`1`0`` '/>");
	}else{
		$("#frm").append("<input type='hidden' id='controlres"+pos+"' name='executor' value='"+ execid +"`0`0`` '/>");
	}
}

/* функция поставить на контроль*/
function controlOn(pos){
	$("#idCorrControlOff"+pos).text(""); 
	$("#controlOffDate"+pos).text("");
	$("#switchControl"+pos).html("<a title='Снять с контроля' href='javascript:controlOff("+pos+")'><img  src='/SharedResources/img/classic/icons/eye_delete.png'/></a>");
	$("#controlres"+pos).val($("#idContrExec"+pos).text()+"` ` ");
}

function infoDialog(text){
	$(document).unbind("keydown")
	 var myDiv = document.createElement("DIV");
	 divhtml ="<div id='dialog-message' title='Предупреждение'>";
	 divhtml+="<span style='height:40px; width:100%; text-align:center;'>"+
	 	"<font style='font-size:13px;'>"+text+"</font>"+"</span>";
	 divhtml += "</div>";
	 myDiv.innerHTML = divhtml;
	 document.body.appendChild(myDiv);
	 $("#dialog").dialog("destroy");
	 $("#dialog-message").dialog({
		 modal: true,
		 buttons: {
			 "Ок": function() {
				 $(this).dialog( "close" );
				 $( this ).remove();
				 hotkeysnav()  
			 }
		 },
		 beforeClose: function() { 
			 $("#dialog-message").remove();
			 hotkeysnav()   
		} 
	 });
	 $(".ui-dialog button").focus();
}


function dialogAndFunction(text,func, name, par){
	var title = "Предупреждение";
	if ($.cookie("lang")=="ENG")
		title = "Warning";
	else if ($.cookie("lang")=="KAZ")
		title = "Ескерту";
	divhtml ="<div id='dialog-message' title='"+title+"'>";
	divhtml +="<span style='text-align:center'><font style='font-size:13px;'>"+text+"</font></span></div>";
	$("body").append(divhtml);
	$("#dialog-message").dialog("destroy");
	$("#dialog-message").dialog({
		modal: true,
		buttons: {
			"Ок": function() {
				func && typeof(func) === "function" ? func() : $(this).dialog("close").remove();
			}
		},
		beforeClose: function() { 
			func && typeof(func) === "function" ? func() : $(this).dialog("close").remove();
		}
	});
}
 
function dialogConfirmComment (text,action){
	var myDiv = document.createElement("DIV");
	divhtml ="<div id='dialog-message' title='"+warning+"'  >";
	divhtml+="<span style='height:50px; margin-top:4%; width:100%; text-align:center'>"+
	"<font style='font-size:13px; '>"+text+"</font>"+"</span>";
	divhtml += "</div>";
	myDiv.innerHTML = divhtml;
	document.body.appendChild(myDiv);
	$("#dialog").dialog("destroy");
	$( "#dialog-message" ).dialog({
		height:140,
		modal: true,
		buttons: {
			"да": function() {
				$( this ).dialog( "close" );
				$( this ).remove();
		    	addComment(action)
			},
			"нет": function() {
				$( this ).dialog( "close" );
				$( this ).remove();
				submitFormDecision (action)
			}
		},
		beforeClose: function() { 
			$("#dialog-message").remove();
			disableblockform();
			hotkeysnav() 
		} 
	});
	if (lang == "KAZ"){
		$( "#dialog-message" ).dialog({ buttons: { 
			"иә": function() { 
					$( this ).dialog( "close" );
					$( this ).remove();
					addComment(action)
				},
			"жоқ": function() { 
					$( this ).dialog( "close" );
					$( this ).remove();
					submitFormDecision (action)
				}
			}
		});
	}
	if (lang == "ENG"){
		$( "#dialog-message" ).dialog({ buttons: { 
			"yes": function() { 
				$( this ).dialog( "close" );
				$( this ).remove();
				addComment(action)
			},
			"no": function() { 
				$( this ).dialog( "close" );
				$( this ).remove();
				submitFormDecision (action)
			}
		}
		});
	}
	if (lang == "CHN"){
		$( "#dialog-message" ).dialog({ buttons: { 
			"是否": function() { 
				$( this ).dialog( "close" );
				$( this ).remove();
				addComment(action)
			},
			"無": function() { 
				$( this ).dialog( "close" );
				$( this ).remove();
				submitFormDecision (action)
			}
		}
		});
	}
}

var control_sum_file = null; 
function ConfirmCommentToAttach (text,csf){
	control_sum_file = csf;
	var myDiv = document.createElement("DIV");
	divhtml ="<div id='dialog-message' title='"+warning+"'>";
	divhtml +="<span style='height:50px; margin-top:4%; width:100%; text-align:center'>"+
	"<font style='font-size:13px;'>"+text+"</font>"+"</span>";
	divhtml += "</div>";
	myDiv.innerHTML = divhtml;
	document.body.appendChild(myDiv);
	$("#dialog").dialog("destroy");
	$( "#dialog-message" ).dialog({
		height:140,
		modal: true,
		buttons:{
			"да": function() {
				$(this).dialog( "close" );
				$(this).remove();
				addCommentToAttach()
			},
			"нет": function() {
				$(this).dialog( "close" );
				$(this ).remove();
				$("<tr><td colspan='3'></td></tr>").insertAfter("#"+control_sum_file)
			}
		}
	});
}

function addCommentToAttach(csf){
	if (csf){
		control_sum_file = csf;
	}
	divhtml="<div class='comment' id='commentBox'>" +
	"<div class='headerComment'><font class='headertext'>"+commentcaption+"</font>" +
		"<div class='closeButton'  onclick='commentCancel(); '>" +
			"<img style='width:15px; height:15px; margin-left:3px; margin-top:2px' src='/SharedResources/img/iconset/cross.png' />" +
		"</div></div>" +
	"<div class='contentComment'>" +
		"<br/><table style=' margin-top:2%; width:100%'>" +
			"<tr>" +
				"<td style='text-align:center'><textarea  name='commentText' id='commentText' rows='10'  tabindex='1' style='width:97%' />" +
				"</td>" +
			"</tr>" +
		"</table><br/>" +
	"</div>"+
	"<div class='buttonPaneComment button_panel' style='margin-top:1%; text-align:right; width:98%'>" +
	"<button class='ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only' onclick='javascript:commentToAttachOk()' style='margin-right:5px'><span class='ui-button-text'><font style='font-size:12px; vertical-align:top'>ОК</font></span></button>" +
	"<button class='ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only' onclick='javascript:commentCancel()'><span class='ui-button-text'><font style='font-size:12px; vertical-align:top'>"+cancelcaption+"</font></span></button>" +
	"</div>" +
	"</div>";
	$("body").append(divhtml);
	$("#commentBox").draggable({handle:"div.headerComment"});
	centring('commentBox',470,250);
	$("#commentBox textarea").focus()
}

function commentToAttachOk(){
	if ($("#commentText").val().length ==0){
		infoDialog("Введите комментарий");
	}else{
		$("#frm").append("<input type='hidden' name='comment"+control_sum_file+"' value='"+ $("#commentText").val() +"'>")
		$("<tr><td></td><td style='color:#777; font-size:12px'>комментарий : "+$("#commentText").val()+"</td><td></td></tr>").insertAfter("#"+control_sum_file)
		$("#commentaddimg"+control_sum_file).remove()
		$("#commentBox").remove()
	}
}

function dialogConfirm (text,el,actionEl){
	 var myDiv = document.createElement("DIV");
	   divhtml ="<div id='dialog-message' title='Предупреждение'>";
	   divhtml+="<span style='height:50px; margin-top:4%; width:100%; text-align:center'>"+
	   			"<font style='font-size:13px; '>"+text+"</font>"+"</span>";
	   divhtml += "</div>";
	   myDiv.innerHTML = divhtml;
	   document.body.appendChild(myDiv);
	   $("#dialog").dialog("destroy");
	   $("#dialog-message").dialog({
		   height:140,
		   modal: true,
		   buttons: {
			   "Ок": function() {
				   $(this).dialog("close");
				   $(this).remove();
				   if (el == 'picklist'){
					   $('#blockWindow').css('display',"block")
				   }
				   $('#'+el).css('display', "inline-block");
				   $("."+actionEl).remove();
			},
			"Отмена": function() {
				$(this).dialog("close");
				$(this).remove();
				if (el == 'picklist'){
					$('#blockWindow').remove()
				}
				$('#'+el).empty();
				$('#'+el).remove();
			}
		}
	});
}

/* сохранение формы */
function SaveFormJquery(typeForm, formName, redirecturl, docType) {
	enableblockform()
	$("body").notify({"text":pleasewaitdocsave,"onopen":function(){}})
	divhtml ="<div id='dialog-message' title='Сохранение'>";
	divhtml+="<div style='margin-top:8px'><font style='font-size:13px; font-family:Verdana,Arial,Helvetica,sans-serif; padding-left:10px'>Пожалуйста ждите...</font></div>";
	divhtml+="<div style='margin-top:5px'><font style='font-size:13px; font-family:Verdana,Arial,Helvetica,sans-serif; padding-left:10px'>идет сохранение документа</font></div>";
	divhtml+="<br/><div style='margin-top:5px; text-align:center;'><font style='font-size:14px; font-family:arial; padding-left:10px;'></font></div>";
	divhtml+="</div>";
	$("body").append(divhtml);
	if($("input[name=id]").val() == "remark"){
		if ($("input[name=origin]").val().length == 0 ){
		place=''
		if ($("select[name=city]").val() !=' '){
			place+=$("select[name=city] option:selected").text();
		}
		if ($("input[name=street]").val().length !=0){
			place+=', ул.'+$("input[name=street]").val();
		}
		if ($("input[name=house]").val().length !=0){
			place+=', д.'+$("input[name=house]").val();
		}
		if ($("input[name=porch]").val().length !=0){
			place+=', п.'+$("input[name=porch]").val();
		}
		if ($("input[name=apartment]").val().length !=0){
			place+=', кв.'+$("input[name=apartment]").val();
		}
		if ($("input[name=coordinats]").val().length !=0){
			place+=', Коорд.'+$("input[name=coordinats]").val();
		}
		if(place.length !=0){
			$("input[name=origin]").val(place)
		}
		}
	} 

	var formData = $("form").serialize();
	$.ajax({
		type: "POST",
		url: 'Provider',
		data: $("form").serialize(),
		success:function (xml){
			$(document).unbind("keydown")
			redir = $(xml).find('redirect').text();
			if (redir == ""){redir = $(xml).find('history').find("entry[type=view]:last").text();}
			if (redir == ""){redir = redirecturl;}
			if (redir == ""){redir = redirectAfterSave;}
			redir = redir.replace('&amp;', "&");
			$(xml).find('response').each(function(){
				var st=$(this).attr('status');
				msgtext=$(xml).find('message[id=1]').text();
				if (st =="error" || st =="undefined"){
					msgtext = msgtext || "Ошибка сохранения"
					$("#notifydiv").html("<font>"+msgtext+"</font>")
					$("body").hidenotify({"delay":800,"onclose":function(){$("#notifydiv").remove()}})
					$("#dialog-message").dialog({ 
						buttons: { 
							'Ok': function() {
								$("#dialog-message").remove();
								$('#blockWindow').remove(); 
								hotkeysnav()  
							}
						},
						beforeClose: function() { 
							$("#dialog-message").remove();
							$('#blockWindow').remove();
							hotkeysnav()  
						} 
					});
					$("#dialog-message").html("<br/><div style='text-align:center'><font style='font-size:13px; font-family:Verdana,Arial,Helvetica,sans-serif; padding-left:10px'>"+msgtext+"</font></div>");
				}
				if (st == "ok"){
					$("body").hidenotify({"delay":500,"onclose":function(){$("#notifydiv").remove()}})
					if (msgtext.length==0){
						$("#notifydiv").html("<font>"+documentsavedcaption+"</font>")
						setTimeout(function() {
							if (redir == ''){ afcl =window.history.back()}else{ afcl=window.location.href = redir;}
							$("body").hidenotify({"delay":300,"onclose":afcl})
						},500);
					}else{
						$("#notifydiv").html("<font>"+msgtext+"</font>")
						setTimeout(function() {
							$("body").hidenotify({"delay":400,"onclose":function(){}})
						},800);
						$("#dialog-message").dialog({ 
							buttons: { 
								'Ok': function() {
									$("#dialog-message").remove();
									if($("input[name=id]").val() != "topic"){
										if (redir == ''){
											window.history.back();
										}else{
											window.location = redir;
										}
									}else{
										$('#blockWindow').remove(); 
									}
									$(document).bind("keydown",qkey)
								}
							},
							beforeClose: function() { 
								$("#dialog-message").remove();
								if($("input[name=id]").val() != "topic"){
									if (redir == ''){
										window.history.back();
									}else{
										window.location = redir;
									}
								}else{
									$('#blockWindow').remove(); 
								}
								$(document).bind("keydown",qkey)
							}  
						});
						msgtext = msgtext || "Документ сохранен";
						$("#dialog-message").html("<br/><div style='text-align:center'><font style='font-size:13px; font-family:Verdana,Arial,Helvetica,sans-serif; padding-left:10px'>"+msgtext+"</font></div>");
					}
					$(".ui-dialog button").focus();
				}
			});
		},
		error:function (xhr, ajaxOptions, thrownError){
			if (xhr.status == 400){
				$("body").children().wrapAll("<div id='doerrorcontent' style='display:none'></div>")
				$("body").append("<div id='errordata'>"+xhr.responseText+"</div>")
				$("li[type='square'] > a").attr("href","javascript:backtocontent()")
			}
		}    
	});
}

/*set of upload function*/
function loadingAttch(tableID){
	$("#"+tableID).append("<tr id='loading_attach'><td></td><td><div style='position:absolute; z-index:999'><img src='/SharedResources/img/classic/progress_bar_attach.gif'></div></td></tr>")
	blockWindow = "<div class='blockWindow' id='blockWindow'/>"; 
	$("body").append(blockWindow);
	$('#blockWindow').css('width',$(document).width()); 
	$('#blockWindow').css('height',$(document).height());
	$('#blockWindow').css('display',"block")
	$("body").css("cursor","wait")
}

/* добавление приложений в форму */
function submitFile(form, tableID, fieldName) {
	if ($('[name='+fieldName+']').val() == '') {
		infoDialog('Выберите файл для вложения');
	} else {
		loadingAttch(tableID)
		form = $('#'+form);
		var frame = createIFrame();
		frame.onSendComplete = function() {
			uploadComplete(tableID, getIFrameXML(frame));
			$("#loading_attach").remove();
			$('#loadingpage').remove();
			$('#blockWindow').remove();
			$("body").css("cursor","default")
		};
		form.attr('target', frame.id);
		form.submit();
		$("#upload")[0].reset();
		//form.reset();
	}
}

function createIFrame() {
	var id = 'f' + Math.floor(Math.random() * 99999);
	var div = document.createElement('div');
	var divHTML = '<iframe style="display:none" src="about:blank" id="' + id
			+ '" name="' + id + '" onload="sendComplete(\'' + id
			+ '\')"></iframe>';
	div.innerHTML = divHTML;
	document.body.appendChild(div);
	return document.getElementById(id);
}

function sendComplete(id) {
	var iframe = document.getElementById(id);
	if (iframe.onSendComplete && typeof (iframe.onSendComplete) == 'function')
		iframe.onSendComplete();
}

function getIFrameXML(iframe) {
	var doc = iframe.contentDocument;
	if (!doc && iframe.contentWindow)
		doc = iframe.contentWindow.document;
	if (!doc)
		doc = window.frames[iframe.id].document;
	if (!doc)
		return null;
	if (doc.location == "about:blank")
		return null;
	if (doc.XMLDocument)
		doc = doc.XMLDocument;
	return doc;
}

var cnt = 0;
function uploadComplete(tableID, doc) {
	if (!doc)
		return;
	var xmldoc = doc.documentElement;
	var st = xmldoc.getAttribute('status');
	var msg = xmldoc.getElementsByTagName('BODY');
	//d=$("BODY", doc).text();
	d = $(doc).find("message[id=1]").text();
	var Url = {
			encode : function (string) {
				return escape(this._utf8_encode(string));
			},
			decode : function (string) {
				return this._utf8_decode(unescape(string));
			},
			_utf8_encode : function (string) {
				string = string.replace(/\r\n/g,"\n");
				var utftext = "";
				for (var n = 0; n < string.length; n++) {
					var c = string.charCodeAt(n);
					if (c < 128) {
						utftext += String.fromCharCode(c);
					}
					else if((c > 127) && (c < 2048)) {
						utftext += String.fromCharCode((c >> 6) | 192);
						utftext += String.fromCharCode((c & 63) | 128);
					}else {
						utftext += String.fromCharCode((c >> 12) | 224);
						utftext += String.fromCharCode(((c >> 6) & 63) | 128);
						utftext += String.fromCharCode((c & 63) | 128);
					}
				}
				return utftext;
			},
			_utf8_decode : function (utftext) {
				var string = "";
				var i = 0;
				var c = c1 = c2 = 0;
				while ( i < utftext.length ) {
					c = utftext.charCodeAt(i);
					if (c < 128) {
						string += String.fromCharCode(c);
						i++;
					}
					else if((c > 191) && (c < 224)) {
						c2 = utftext.charCodeAt(i+1);
						string += String.fromCharCode(((c & 31) << 6) | (c2 & 63));
						i += 2;
					}else {
						c2 = utftext.charCodeAt(i+1);
						c3 = utftext.charCodeAt(i+2);
						string += String.fromCharCode(((c & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63));
						i += 3;
					}
				}
				string=string.substring(0, string.length - 3)
				return string;
			}
	}
	if($.browser.mozilla)
	{
		encd=d;
	}else{
		encd= Url.encode(d)
		encd=encd.substring(0, encd.length - 3)
	}
	if (st = 'ok') {
		tableid='#'+tableID;
		var table = $(tableid);
		sesid=$(doc).find("message").attr('formsesid');
		csf=$(doc).find("message[id=2]").text();
		var range = 200 - 1 + 1;
		detectExtAttach(d); //определение расширения
		fieldid=Math.floor(Math.random()*range) + 1;;
		$(table).append("<tr id='"+ csf + "'>" +
				"<td></td>" +
				"<td>" +
				"<img class='newimageatt' onerror='javascript:changeAttIcon(this)' onload='$(this).removeClass()' src='/SharedResources/img/iconset/file_extension_"+ ext +".png' style='margin-right:5px'><a href='Provider?type=getattach&formsesid="+ sesid+"&field=rtfcontent&file="+encd+"' style='vertical-align:6px'>"+ d +"</a>&#xA0;&#xA0;" +
				
				"<a href='javascript:addCommentToAttach(&quot;"+ csf +"&quot;)' style='vertical-align:5px; '>"+
		"<img id='commentaddimg"+csf+"' src='/SharedResources/img/classic/icons/comment_add.png' style='width:12px; height:12px' title='Добавить комментарий'/></a>"+
		"<a href='javascript:deleterow("+sesid +",&quot;"+ d +"&quot;,&quot;"+ csf +"&quot;)'><img src='/SharedResources/img/iconset/cross.png' style='margin-left:5px; width:10px; height:10px; vertical-align:6px'/></a>" +
		"</td><td></td</tr>");
		ConfirmCommentToAttach("Добавить комментарий к вложению?",csf)
		$("input[name=deletertfcontentname]").each(function(index, element){
			if($(element).val() == d){
				$(element).remove()
			}
		});
		if ($("input[name=deletertfcontentname]").length == 0){
			$("input[name=deletertfcontentsesid]").remove()
			$("input[name=deletertfcontentfield]").remove()
		}
	} else {
		infoDialog('Произошла ошибка на сервере при выгрузке файла');
	}
}

function deleterow(sesid,filename, fieldid){
	$("#"+fieldid).next("tr").remove()
	$("#"+fieldid).remove()
	$("#frm").append("<input type='hidden' name='deletertfcontentsesid' value='"+ sesid +"'></input>")
	$("#frm").append("<input type='hidden' name='deletertfcontentname' value='"+ filename +"'></input>")
	$("#frm").append("<input type='hidden' name='deletertfcontentfield' value='rtfcontent'></input>")
}

function changeAttIcon(el){
	$(el).attr("src","/SharedResources/img/iconset/file_extension_undefined.png");
	$(el).removeClass()
}

/*определение расширения вложения */
function detectExtAttach(file){
	var fileLen=file.length;
	var symbol;
	while(symbol !='.' || fileLen == 0){
		symbol=(file.substring(fileLen-1,fileLen));
		fileLen = fileLen - 1;
	}
	RegEx=/\s/g;
	ext=d.substring(fileLen +1, file.length).replace(RegEx, "").toLowerCase();
	
return ext;
}

/* создание  cookie для сохранения настроек пользователя и сохранение профиля пользователя*/
function saveUserProfile(redirecturl){
	$(document).unbind("keydown")
		if ($("#newpwd").val() != $("#newpwd2").val()){
			 infoDialog("Введеные пароли не совпадают")
		}else{
		$.ajax({
			type: "POST",
			url: "Provider?type=save&element=user_profile",
			datatype:"html",
			data: $("form").serialize(),
			success: function(xml){
				redir = $(xml).find('history').find("entry[type=view]:last").text() || redirecturl;
				$.cookie("refresh", $("select[name='refresh']").val(),{ path:"/", expires:30});		
				$.cookie("lang", $("select[name='lang']").val(),{ path:"/", expires:30});		
				/*$.cookie("pagesize",$("select[name='countdocinview']").val(),{ path:"/", expires:30});	
				if ($("#history_vis").is(":checked")){
					historyval="history_on";
				}else{
					historyval="history_off";
				}
				$.cookie("history",historyval ,{ path:"/", expires:30 });		*/
				redirecturl=='' ? window.history.back() : window.location = redirecturl;
			},
			error:function (xhr, ajaxOptions, thrownError){
               if (xhr.status == 400){
            	  if( xhr.responseText.indexOf("Old password has not match")!=-1){
            		  infoDialog("Некорректно заполнено поле 'старый пароль'")
            	  }else{
            		  $("body").children().wrapAll("<div id='doerrorcontent' style='display:none'></div>")
            		  $("body").append("<div id='errordata'>"+xhr.responseText+"</div>")
            		  $("li[type='square'] > a").attr("href","javascript:backtocontent()")
            	  }
               }
            }    
		});
		}
}

function backtocontent(){
	$('#doerrorcontent').css('display','block'); 
	$('#errordata').remove();
}

/*функция о отметке о прочтении документа*/
function markRead(doctype, docid){
	$.ajax({
		type: "GET",
		url: "Provider?type=service&operation=mark_as_read&doctype="+doctype+"&key="+docid+"&nocache="+Math.random(),
		success:function (xml){
			/*$("#whichreadblock").fadeIn(3500);
			$("#markDocRead").animate({backgroundColor: '#ffff99'}, 500);
			$("#markDocRead").html("&#xA0; Прочтен");
			$("#markDocRead").animate({backgroundColor: '#ffffdd'}, 1000);*/
			$("body").notify({"text":documentmarkread,"onopen":function(){$("body").hidenotify({"delay":1200,"onclose":function(){$("#notifydiv").remove()}})},"loadanimation":false})
		}
	});
}

var el;
var UrlDecoder = {
		encode : function (string) {
			return escape(this._utf8_encode(string));
		},
		decode : function (string) {
			return this._utf8_decode(unescape(string));
		},
		_utf8_encode : function (string) {
			string = string.replace(/\r\n/g,"\n");
				var utftext = "";
				for (var n = 0; n < string.length; n++) {
					var c = string.charCodeAt(n);
					if (c < 128) {
						utftext += String.fromCharCode(c);
					}
					else if((c > 127) && (c < 2048)) {
					 utftext += String.fromCharCode((c >> 6) | 192);
					 utftext += String.fromCharCode((c & 63) | 128);
					}
					else {
						utftext += String.fromCharCode((c >> 12) | 224);
						utftext += String.fromCharCode(((c >> 6) & 63) | 128);
						utftext += String.fromCharCode((c & 63) | 128);
					}
				}
				return utftext;
			},
			_utf8_decode : function (utftext) {
				var string = "";
				var i = 0;
				var c = c1 = c2 = 0;
				while ( i < utftext.length ) {
					c = utftext.charCodeAt(i);
					if (c < 128) {
						string += String.fromCharCode(c);
						i++;
					}
					else if((c > 191) && (c < 224)) {
						c2 = utftext.charCodeAt(i+1);
						string += String.fromCharCode(((c & 31) << 6) | (c2 & 63));
						i += 2;
					}
					else {
						c2 = utftext.charCodeAt(i+1);
						c3 = utftext.charCodeAt(i+2);
						string += String.fromCharCode(((c & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63));
						i += 3;
					}
				}
				string=string.substring(0, string.length )
				return string;
			}
}

/* функция напомнить*/
function remind(key,doctype){
	el='picklist'
	divhtml ="<div class='picklist' id='picklist' onkeyUp='keyDown(el);'>";
	divhtml +="<div  class='header'><font id='headertext' class='headertext'></font>";
	divhtml +="<div class='closeButton'><img style='width:15px; height:15px; margin-left:3px; margin-top:1px' src='/SharedResources/img/iconset/cross.png' onclick='pickListClose(); '/>";
	divhtml +="</div></div><div id='divChangeView' style='margin-top:6%; margin-left:81%'></div>";
	divhtml +="<div id='divSearch' display='block'><div style='font-size:13px; text-align:left; margin-left:2%'>"+receiverslistcaption+":</div></div>" ;
	divhtml +="<div id='contentpane' style='overflow:auto;  border:1px solid  #d3d3d3; padding-top:10px; width:95%; margin:10px; height:250px;' >Загрузка данных...</div>"; 
	divhtml +="<div id='divComment' style='text-align:left; margin:10px; font-size:13px; width:95%'><table width='100%'><tr><td style='font-size:13px;'>"+commentcaption+" : </td></tr><tr><td><textarea id='comment'  rows='6' style='border:1px solid #a6c9e2;width:100%; margin-top:8px'></textarea></td></tr></table></div>"
	divhtml += "<div  id = 'btnpane' class='button_panel' style='margin:2%; text-align:right;'>";
	divhtml += "<button class='ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only' onclick='javascript:remindOk("+key+","+doctype+")' style='margin-right:5px'><span class='ui-button-text'><font style='font-size:12px; vertical-align:top'>ОК</font></span></button>" 
	divhtml += "<button class='ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only' onclick='pickListClose()'><span class='ui-button-text'><font style='font-size:12px; vertical-align:top'>"+cancelcaption+"</font></span></button>";    
	divhtml += "</div></div>";
	$("body").append(divhtml);
	$("#picklist").draggable({handle:"div.header"});
	centring('picklist',500,500);
	blockWindow = "<div  class='ui-widget-overlay' id ='blockWindow'></div>"; 
	$("body").append(blockWindow);
	$("body").css("cursor","wait");
	$('#blockWindow').css('width',$(document).width()); 
	$('#blockWindow').css('height',$(document).height());
	$('#blockWindow').css('display',"block")
	$('#picklist').css('display', "none");
	$("#headertext").text(remindcaption);
	$("#contentpane").text('');
	$("#contentpane").html($("#executers").html());
	$("#contentpane table").css("text-align","left")
	$('#picklist').css('display', "inline-block");
	$("body").css("cursor","default")
	$('#picklist').focus();
}

/* обработчик нажатия кнопки "ок" a окне "напомнить"*/	
function remindOk(key,doctype){
	var k=0;
	var chBoxes = $('input[name=chbox]'); 
	if ($("#comment").val().length == 0){
		infoDialog ("Поле 'Комментарий' не заполнено")
	}else{
		for( var i = 0; i < chBoxes.length; i ++ ){
			if (chBoxes[i].checked){ 
				if (k==0){
					form="<form action='Provider' name='dynamicform' method='post' id='dynamicform' enctype='application/x-www-form-urlencoded'></form>"
					$("body").append(form);
				}
				new FormData('notifyrecipients', chBoxes[i].id); 
				k++		 	
			}
		}
		if (k>0){
			new FormData('type', 'handler'); 
			new FormData('id', "notify_executors"); 
			new FormData('key', key);
			new FormData('doctype', doctype);
			new FormData('comment', $("#comment").val());
			submitFormDecision ()
			pickListClose(); 
		}else{
			infoDialog('Выберите значение');
		}
	}
}

/* функция ознакомить*/
function acquaint(key,doctype){
	el='picklist'
	divhtml ="<div class='picklist' id='picklist' onkeyUp='keyDown(el);'>";
	divhtml +="<div  class='header'><font id='headertext' class='headertext'></font>";
	divhtml +="<div class='closeButton'><img style='width:15px; height:15px; margin-left:3px; margin-top:1px' src='/SharedResources/img/iconset/cross.png' onclick='pickListClose(); '/>";
	divhtml +="</div></div><div id='divChangeView' style='margin-top:10px; margin-left:78%'>";
	divhtml +="<a id='btnChangeView' class='actionlink' href='javascript:changeViewAcquaint(1,"+key+","+doctype+")'><font style='font-size:11px'>"+changeviewcaption+"</font></a></div>";
	divhtml +="<div id='divSearch' class='divSearch' display='inline-block'></div><br/>" ;
	divhtml +="<div style='font-size:14px; text-align:left; margin-top:10px'>&#xA0;&#xA0;Список корреспондентов для ознакомления:</div>" ;
	divhtml +="<div id='contentpane' style='overflow:auto; border:1px solid  #d3d3d3; height:250px; width:95%; margin:10px;' >Загрузка данных...</div>";    
	divhtml +="<div id='divComment' style='text-align:left; font-size:13px; width:97.5%; margin:10px'>" ;
	divhtml +="<table width='98%'><tr><td style='font-size:13px'>"+commentcaption+": </td></tr><tr><td><textarea id='comment'  rows='6' style='width:100%; border:1px solid #d3d3d3; margin-top:8px'></textarea></td></tr></table></div>"
	divhtml += "<div  id = 'btnpane' class='button_panel' style='margin-top:2%; text-align:right; margin:2%'>";
	divhtml += "<button class='btnFilter' onclick='javascript:acquaintOk("+key+","+doctype+")' style='margin-right:5px'><font style='font-size:12px; vertical-align:top'>ОК</font></button>" 
	divhtml += "<button class='btnFilter' onclick='pickListClose()'><font style='font-size:12px; vertical-align:top'>"+cancelcaption+"</font></button>";    
	divhtml += "</div></div>";
	$("body").append(divhtml);
	$("#picklist").draggable({handle:"div.header"});
	centring('picklist',500,500);
	blockWindow = "<div  class = 'ui-widget-overlay' id = 'blockWindow'></div>"; 
	$("body").append(blockWindow);
	$("body").css("cursor","wait")
	$('#blockWindow').css('width',$(document).width()); 
	$('#blockWindow').css('height',$(document).height());
	$('#blockWindow').css('display',"block")
	$('#picklist').css('display', "none");
	$("#headertext").text(acquaintcaption);
	$.ajax({
		type: "get",
		url: 'Provider?type=view&id=bossandemppicklist',
		success:function (data){
			$("#contentpane").text('');
			$("#contentpane").append(data);
			searchTbl =
				"<font style='vertical-align:3px; float:left; margin-left:4%; font-size:13px'><b>"+searchcaption+":</b></font> " +
				"<input type='text' id='searchCor' style='float:left; margin-left:3px;' size='34' onKeyUp='findCorStructure()'/>" 
				$("#contentpane div").removeAttr("ondblclick")		
				$("#contentpane div").removeAttr("onmouseover")		
				$("#contentpane div").removeAttr("onmouseout")		
				$("#divSearch").append(searchTbl);
			$('#btnChangeView').attr("href","javascript:changeViewAcquaint(2,"+key+","+doctype+")");
			$('#picklist').css('display', "inline-block");
			$("body").css("cursor","default")
			$('#contentpane').disableSelection();		
			$('#searchCor').focus()
			$(".btnFilter").button();
		}
	});
}

/* обработчик нажатия кнопки "ок" a окне "ознакомить"*/	
function acquaintOk(key,doctype){
	var k=0;
	var chBoxes = $('input[name=chbox]'); 
	if ($("#comment").val().length == 0){
		infoDialog ("Поле 'Комментарий' не заполнено")
	}else{
		for( var i = 0; i < chBoxes.length; i ++ ){
			if (chBoxes[i].checked){ 
				if (k==0){
					form="<form action='Provider' name='dynamicform' method='post' id='dynamicform' enctype='application/x-www-form-urlencoded'></form>"
						$("body").append(form);
				}
				new FormData('grantusers', chBoxes[i].id); 
				k++		 	
			}
		}
		if (k>0){
			new FormData('type', 'handler'); 
			new FormData('id', "grant_access"); 
			new FormData('key', key);
			new FormData('doctype', doctype);
			new FormData('comment', $("#comment").val());
			submitFormDecision ("acquaint")
			pickListClose(); 
		}else{
			infoDialog('Выберите значение');
		}
	}
}

/* смена вида в окне "ознакомить"*/
function changeViewAcquaint(viewType,key,doctype){
	if (viewType==1){
		$.ajax({
			type: "get",
			url: 'Provider?type=view&id=bossandemppicklist',
			success:function (data){
				$("#contentpane").text('');
				$("#contentpane").append(data);
				searchTbl ="<font style='vertical-align:3px; float:left; margin-left:4%'><b>"+searchcaption+":</b></font>";
				searchTbl +=" <input type='text' id='searchCor' style='float:left; margin-left:3px;' size='34' onKeyUp='findCorStructure()'/>"; 
				$("#divSearch").append(searchTbl);
				$('#btnChangeView').attr("href","javascript:changeViewAcquaint(2,"+key+","+doctype+")");
				$(document).ready(function(){
					$('#picklist').disableSelection();
				});
				$('#blockWindow').css('display',"block")
				$('#picklist').css('display', "inline-block");
				$('#searchCor').focus()
				$("#contentpane").ajaxSuccess(function(evt, request, settings){
					$("#contentpane div").removeAttr("ondblclick")
					$("#contentpane div").removeAttr("onmouseover")		
					$("#contentpane div").removeAttr("onmouseout");
				});
			}
		});
	}else{
		$('#btnChangeView').attr("href","javascript:changeViewAcquaint(1,"+key+","+doctype+")");
		$.ajax({
			type: "get",
			url: 'Provider?type=view&id=structurefullpicklist',
			success:function (data){
				if(data.match("html")){
					window.location="Provider?type=static&id=start"
				}
				$("#contentpane").text('');
				$("#contentpane").append(data);
				$("#divSearch").empty();
				// запрещаем выделение текста
				$(document).ready(function(){
					$('#picklist').disableSelection();
				});
				$('#blockWindow').css('display',"block")
				$('#picklist').css('display', "inline-block");
				$("#contentpane").ajaxSuccess(function(evt, request, settings){
					$("#contentpane td").removeAttr("ondblclick")
					$("#contentpane tr").removeAttr("onmouseover")		
					$("#contentpane tr").removeAttr("onmouseout")
					$("#contentpane tr").removeAttr("onmouseout")
				});
			}
		});
	}
}

/* функция для отображения списка прочитавших текущий документ */
function usersWhichRead(el,doctype, id){
	notEmpty = false;
	var ce = $(el);
	var left_offset_position = ce.offset().left ; 
	var bottom_offset_position = ce.offset().bottom - 25; 
	$.ajax({
		type: "get",
		url: 'Provider?type=service&operation=users_which_read&doctype='+doctype+"&key="+id,
		success:function (xml){
			if (!$("#userWhichRead").length){
				$("body").append("<div id='userWhichRead' class='userwichread'></div>");
			}else{
				return false;
			}
			$(xml).find("entry").each(function(){
				if ($(this).attr('username') != undefined){
					$("#userWhichRead").append("&#xA0;"+$(this).attr('username')+ "&#xA0;&#xA0; "+$(this).attr('eventtime')+ "&#xA0;</br>");
					notEmpty = true; 
				}
			})
				if (notEmpty == true){
					$("#userWhichRead").css("left",left_offset_position).css("bottom",25).css("display","inline-block");
				}else{
					$("#userWhichRead").remove();
				}
		}
	})
}

function usersWhichReadInTable(el,doctype, id){
	$.ajax({
		type: "get",
		async:true,
		url: 'Provider?type=service&operation=users_which_read&doctype='+doctype+"&key="+id+"&nocache="+Math.random() * 300,
		success:function (xml){
			$(xml).find("entry").each(function(){
				if ($(this).attr('username') != undefined){
					$("#userswhichreadtbl").append("<tr><td>"+$(this).attr('username')+ "</td><td>"+$(this).attr('eventtime')+ "</td></tr>");
					
				}
			})
		}
	})
}

function checkImage(el){
	if ($(el).width() > $("#property").width() - $(".fc").first().width()-50 ){
		$(el).css("width",$("#property").width() - $(".fc").first().width()-50 + "px")
		$(el).parent("div").css("width",$("#property").width() - $(".fc").first().width()-10 + "px")
	}
}