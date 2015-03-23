var idtr="";
var	type='Тип';
var	waittime='Время ожидания';
var	hours ='Часов';
var	yescaption ='да';
var	nocaption ='нет';
var	answercommentcaption ='Оставить комментарий ответа?';
var	warning ='Предупреждение';
var redirectAfterSave = "";

var dataArray=new Array;

/* Создание скрытого поля в динамической форме */
function FormData(field, value){
	$("#dynamicform").append("<input type='hidden' name='"+field +"' id='"+field +"' value='"+value+"'>")
}

/* Создание формы для ввода комментариев действий пользователя "Согласен" или "Не согласен" */
function addComment(){
	divhtml="<div class='comment' id='commentBox'>" +
	"<div class='headerComment'><font class='headertext'>"+commentcaption+"</font>" +
		"<div class='closeButton' onclick='commentCancel();'>" +
			"<img style='width:15px; height:15px; margin-left:3px; margin-top:2px' src='/SharedResources/img/iconset/cross.png'/>" +
		"</div></div>" +
	"<div class='contentComment'>" +
		"<br/><table style=' margin-top:2%; width:100%'>" +
			"<tr>" +
				"<td style='text-align:center'><textarea  name='commentText' id='commentText' rows='10' tabindex='1' style='width:97%'/>" +
				"</td>" +
			"</tr>" +
		"</table><br/>" +
	"</div>"+
	"<div class='buttonPaneComment button_panel' style='margin-top:1%; text-align:right; width:98%'>" +
	"<button onclick='javascript:commentOk()' style='margin-right:5px'><font class='button_text'>ОК</font></button>" +
	"<button onclick='javascript:commentCancel()'><font class='button_text'>"+cancelcaption+"</font></button>" +
	"</div>" +
	"</div>";
	$("body").append(divhtml);
	$("#commentBox .button_panel").children("button").button()
	$("#commentBox").draggable({handle:"div.headerComment"});
	centring('commentBox',470,250);
	$("#commentBox textarea").focus()
}

/* Закрытие формы для ввода комментария и удаление динамической формы */
function commentCancel(){
	$('#commentBox ,#dynamicform').remove();
	disableblockform()
}

/* Запись комментария пользователя в динамичемкую форму для отправки на сервер */
function commentOk(){
	if($("#commentText").val().length ==0){
		infoDialog("Введите комментарий");
	}else{
		new FormData('comment', $("#commentText").val());
		submitFormDecision();
	}
}

/* обработка действий пользователя при согласовании и подписании. Кнопки "Согласен" и "Не согласен" */
function decision(yesno, key, action){
	enableblockform()
	form="<form action='Provider' name='dynamicform' method='post' id='dynamicform' enctype='application/x-www-form-urlencoded'/>"
	$("body").append(form);
	actionTime= moment().format('DD.MM.YYYY HH:mm:ss');
	new FormData ('actionDate',actionTime);
	new FormData('type','handler'); 
    new FormData('id', action); 
    new FormData('key', key);
    if (yesno == "no"){
    	addComment()
    }else{
    	dialogConfirmComment(answercommentcaption,action)
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
			if(useraction != "remind" && useraction != "acquaint" ){
				redir = $(xml).find('history').find("entry[type=page]:last").text();
				if(redir == ""){
					redir = redirectAfterSave
				}
				window.location = redir;
			}
			
		}
	});
}

function Block(blockNum){  
    this.revTableName ='blockrevtable'+blockNum;  
    this.revTypeRadioName ='block_revtype_'+blockNum;
    this.hiddenFieldName ='block_reviewers_'+blockNum;
}