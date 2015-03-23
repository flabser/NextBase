var idtr="";
var count=0; //переменная для подсчета количесива блоков согласования
var contributorscoord='Участники согласования';
var	type='Тип';
var	parcoord='Параллельное';
var	sercoord='Последовательное';
var	waittime='Время ожидания';
var	coordparam='Параметры согласования';
var	hours ='Часов';
var	yescaption ='да';
var	nocaption ='нет';
var	answercommentcaption ='Оставить комментарий ответа?';
var	warning ='Предупреждение';
var	docisexec ='Документ исполнен';
var	execrejected ='Исполнение отклонено';
var	docaccept ='Документ принят в работу';
var	docisrejected ='Документ отклонен вами';
var redirectAfterSave = "";
var button_cancel="Отмена";

function hideDialog(){
	$("#coordParam").css("display","none");
	$("#coordParam").remove();
	$('#blockWindow').remove();
	//setTimeout("coordParamClose()", 100);
}
 /* кнопка "Сохранить как черновик" */
function savePrjAsDraft(redirecturl){
	$('#coordstatus').val('draft');
	$('#action').val('draft');
    SaveFormJquery('frm', 'frm', redirecturl)		
}

/* кнопка "Отправить" */
function saveAndSend(redirecturl){
	$('#coordstatus').val('signing');
	$('#action').val('send');
	SaveFormJquery('frm', 'frm', redirecturl);	
}

/* кнопка "Согласовать"*/
function saveAndCoord(redirecturl){
	if($("[name=coordBlock]").length == 0){ 
		infoDialog("Не указан ответственный участка")
	}else{
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

		if($("[name=origin]").val().length == 0){
			infoDialog("Не указано место возникновения")
		}else{
			$("#action").val('startcoord') ;
			$("#coordstatus").val('coordinated') ;
			SaveFormJquery('frm', 'frm', redirecturl);
		}
	}
}

var dataArray=new Array;

/* Создание скрытого поля в динамической форме */
function FormData(field, value){
	$("#dynamicform").append("<input type='hidden' name='"+field +"' id='"+field +"' value='"+value +"'>")
}

/* Создание формы для ввода комментариев действий пользователя "Согласен" или "Не согласен" */
function addComment(action){
	enableblockform()
	divhtml ="<div id='dialog-message-comment' title='"+commentcaption+"'>";
	divhtml +="<textarea name='commentText' id='commentText' rows='10' tabindex='1' style='width:97%'/>";
	divhtml+="</div>";
	$("body").append(divhtml);
	$("#dialog-message-comment").dialog({ 
		width: 400,
		buttons: [{
			text: "Ok",
			click: function() { 
				commentOk(action);
				$("#dialog-message-comment").remove();
			}
		},
		{
			text: button_cancel,
			click: function() { 
				$("#dialog-message-comment").remove();
				disableblockform();
				commentCancel();
			}
		}],
		beforeClose: function() { 
			$("#dialog-message-comment").remove();
			disableblockform();
			hotkeysnav();
			commentCancel();
		} 
	});
	$("#commentBox textarea").focus()
}

/* Закрытие формы для ввода комментария и удаление динамической формы */
function commentCancel(){
	$('#commentBox').remove();
	$('#dynamicform').remove();
	disableblockform()
}

/* Запись комментария пользователя в динамичемкую форму для отправки на сервер */
function commentOk(action){
	if ($("#commentText").val().length ==0){
		//infoDialog("Введите комментарий");
		func = function(){
			$(this).dialog("close").remove();
			addComment(par)
		};
		dialogAndFunction ("Введите комментарий",func, "name",action)
	}else{
		new FormData('comment', $("#commentText").val());
		submitFormDecision(action);
	}
}

/* кнопка "Остановить документ" */
function stopDocument(key){
	form="<form action='Provider' name='dynamicform' method='post' id='dynamicform' enctype='application/x-www-form-urlencoded'></form>"
	$("body").append(form);
	new FormData('type', 'handler'); 
    new FormData('id', 'stopcoord'); 
    new FormData('key', key);
    submitFormDecision();
}

/* обработка действий пользователя при согласовании и подписании. Кнопки "Согласен" и "Не согласен" */
function decision(yesno, key, action){
	form="<form action='Provider' name='dynamicform' method='post' id='dynamicform' enctype='application/x-www-form-urlencoded'/>"
	$("body").append(form);
	actionTime= moment().format('DD.MM.YYYY HH:mm:ss');
	new FormData('actionDate',actionTime);
	new FormData('type', 'page'); 
    new FormData('id', action); 
    new FormData('key', key);
    if (yesno == "no"){
    	addComment(action)
    }else{
    	var dialog_title = "Оставить комментарий ответа?";
    	if ($.cookie("lang")=="KAZ")
    		dialog_title = "Жауаптың түсiнiктемесін қалдырасыз ма?";
        else if ($.cookie("lang")=="ENG")
        	dialog_title = "To leave the answer comment?";
        	
       dialogConfirmComment(dialog_title,action)
    }
}

/* Отправка динамической формы на сервер*/
function submitFormDecision (useraction){
	$("body").css("cursor","wait");
	data = $("#dynamicform").serialize();
	$.ajax({
		type: "POST",
		url: "Provider",
		data: data,
		success: function(xml){
			if(useraction == "acquaint"){
				infoDialog("Документ отправлен на ознакомление")
			}
			if(useraction == "remind"){
				infoDialog("Напоминание отправлено")
			}
			$("body").css("cursor","default")
			redir = $(xml).find('history').find("entry[type=view]:last").text();
			if (redir == ""){
				redir = redirectAfterSave
			}
			if(useraction != "remind" && useraction != "acquaint" ){
				if (useraction == "sign_yes"){
					setTimeout(function() {
						$("body").notify({"text":docisexec,"onopen":function(){},"loadanimation":false})
					}, 600);
					setTimeout(function() {
						$("body").hidenotify({"delay":400,"onclose":function(){if (redir == ''){window.history.back()}else{window.location.href = redir;}}})
					},1000);
				}
				if (useraction == "sign_no"){
					setTimeout(function() {
						$("body").notify({"text":execrejected,"onopen":function(){},"loadanimation":false})
					}, 600);
					setTimeout(function() {
						$("body").hidenotify({"delay":400,"onclose":function(){if (redir == ''){window.history.back()}else{window.location.href = redir;}}})
					},1000);
				}
				if (useraction == "coord_yes"){
					setTimeout(function() {
						$("body").notify({"text":docaccept,"onopen":function(){},"loadanimation":false})
					}, 600);
					setTimeout(function() {
						$("body").hidenotify({"delay":400,"onclose":function(){if (redir == ''){window.history.back()}else{window.location.href = redir;}}})
					},1000);
				}
				if (useraction == "coord_no"){
					setTimeout(function() {
						$("body").notify({"text":docisrejected,"onopen":function(){},"loadanimation":false})
					}, 600);
					setTimeout(function() {
						$("body").hidenotify({"delay":400,"onclose":function(){if (redir == ''){window.history.back()}else{window.location.href = redir;}}})
					},1000);
				}
				if (useraction == ""){	
					window.location = redir;
				}
			}
		}
	});
}

function Block(blockNum){  
    this.revTableName = 'blockrevtable'+blockNum;  
    this.revTypeRadioName = 'block_revtype_'+blockNum;
    this.hiddenFieldName = 'block_reviewers_'+blockNum;
}