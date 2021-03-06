var tableField;
var hiddenField;
var formName;
var entryCollections = new Array();

var queryOpt = {
	queryname:'',
	formname:'',
	fieldname:'',
	isMultiValue:'',
	tablename:'',
	pagenum:'1',
	keyword:'',
	dialogview:'1'
} 

function keyDown(el,event){
	if(event.keyCode==27){
		$("#"+el).css("display","none").empty().remove();
		$("#blockWindow").remove();
	}
	if(event.keyCode==13){
		if (el !='coordParam'){
			pickListBtnOk()
		}else{
			coordOk()
		}
	}
}

function pickListSingleOk(docid){
	text=$("#"+docid).val();
	var table= $("#"+queryOpt.tablename);
	$(table).empty();
	$("input[name="+ queryOpt.fieldname +"]").remove();
	if(queryOpt.queryname == 'project-list'){
		$("input[name=parentdocid]").val(docid);
		name=$("#"+docid).prev(".projectinfo").val();
		prjid=$("#"+docid).prev(".projectinfo").attr("id");
		prjdocid=$("#"+docid).prev(".projectinfo").attr("name");
		var m_data = text.split('#`');
		$(table).append("<tr><td width='500px' class='td_editable'><font id='parentProjectfont'>"+m_data[0]+"</font></td><td><a target='blank' id='projectURL' href='"+m_data[1]+"'>Перейти</a></td></tr>");
		$("#projectURL").attr("href",m_data[1]).attr("style","display:block");
		$("#parentMilestonefont").html(m_data[2]);		 
		$("#milestoneURL").attr("href",m_data[3]).attr("style","display:block");
		$("#projectname").val(name.replace("\"","'"))
		$("#projectid").val(prjid)
		$("#projectdocid").val(prjdocid)
	}else{ 
		if(queryOpt.fieldname == 'corr' || queryOpt.fieldname == 'recipient' && queryOpt.queryname == 'corrcat'){
			$(table).append("<tr><td width='500px'>"+ text +"<span style='float:right; border-left:1px solid #ccc; width:20px; padding:1px 10px 0px 2px color:#ccc; font-size:11px'>"+docid+"</span></td></tr>")
		}else{
			$(table).append("<tr><td width='500px' class='td_editable'>"+ text +"</td></tr>")
			$("#frm").append("<input type='hidden' name='"+ queryOpt.fieldname +"'  id='"+queryOpt.fieldname+"' value='"+docid+"'>")
		}
	}
	pickListClose(); 
}

function pickListBtnOk(){
	var k=0;
	var chBoxes = $('input[name=chbox]'); 
	var table= $("#"+queryOpt.tablename);
	var hidfields = $("#executorsColl").children("input[type=hidden]"); 
	if ($('input[name=chbox]:checked').length > 0){
		$(table).empty();
		$("input[name="+queryOpt.fieldname+"]").remove();
		if(queryOpt.fieldname == 'corr' || queryOpt.fieldname == 'recipient' && queryOpt.queryname == 'corrcat'){
			$('input[name=chbox]:checked').each(function(indx, element){
				$(table).append("<tr><td style='width:500px;' class='td_editable'>"+$(this).val()+"<span style='float:right; border-left:1px solid #ccc; width:20px; padding:1px 2px 10px 0px color:#ccc; font-size:11px'>"+$(this).attr("id")+"</span></td></tr>");
				$("#frm").append("<input type='hidden' name='"+queryOpt.fieldname+"' id='"+queryOpt.fieldname+"' value='"+$(this).attr(id)+"'>")
			})
		}else{
			if(queryOpt.queryname == 'project-list'){
				$('input[name=chbox]:checked').each(function(indx, element){
					name=$("#"+$(this).attr("id")).prev(".projectinfo").val();
					prjid=$("#"+$(this).attr("id")).prev(".projectinfo").attr("id");
					prjdocid=$("#"+$(this).attr("id")).prev(".projectinfo").attr("name");
					$("#projectname").val(name.replace("\"","'"))
					$("#projectid").val(prjid)
					$("#projectdocid").val(prjdocid)
					$("input[name=parentdocid]").val($("#"+$(this).attr("id")).attr("id"));
					var m_data = $(this).val().split('#`');
					$(table).append("<tr><td width='500px' class='td_editable'><font id='parentProjectfont'>"+m_data[0]+"</font></td><td><a target='blank' id='projectURL' href='"+m_data[1]+"'>Перейти</a></td></tr>");
					$("#parentMilestonefont").html(m_data[2]);		 
					$("#milestoneURL").attr("href",m_data[3]).attr("style","display:block");
				})
			}else{
				if(queryOpt.fieldname == "parentsubkey"){
					$('input[name=chbox]:checked').each(function(indx, element){
						$(table).append("<tr><td style='width:600px;' class='td_editable'>"+$(this).val()+"</td></tr>");
						$("#frm").append("<input type='hidden' name='"+queryOpt.fieldname+"' id='"+queryOpt.fieldname+"' value='"+$("#"+ $(this).attr("id") ).attr("class")+"'>")
					})
				}else{
					$('input[name=chbox]:checked').each(function(indx, element){
						$(table).append("<tr><td style='width:500px;' class='td_editable'>"+$(this).val() +"</td></tr>");
						$("#frm").append("<input type='hidden' name='"+ queryOpt.fieldname +"' id='"+queryOpt.fieldname+"' value='"+$(this).attr("id")+"'>")
					})
				}
			}
		}
		pickListClose();  
	}else{
		if ($.cookie("lang")=="RUS" || !$.cookie("lang"))
			msgtxt ="Выберите значение";
		else if ( $.cookie("lang")=="KAZ")
			msgtxt ="Мәндi таңдаңыз";
		else if ( $.cookie("lang")=="ENG")
			msgtxt ="Select value";
		else if ( $.cookie("lang")=="CHN")
			msgtxt ="选择";
		infoDialog(msgtxt);
	}
}

function pickListClose(){ 
	$("#picklist, #blockWindow").empty().remove();
	$("body").css("cursor","default")
	if (queryOpt.fieldname == 'executor'){
		$("#content").focus().blur().focus();
	}
}

function pickListSingleCoordOk(docid){ 
	text=$("#"+docid).attr("value");
	$("input[name=coorder]").remove();
	$("#frm").append("<input type='hidden' name='coorder'  id='coorder' value='"+docid+"'>")
	newTable="<table id='coordertbl' width='100%'><tr><td>"+ text +"</td></tr></table>"
	$("#coordertbl").replaceWith(newTable);
	closePicklistCoord();  
}

function closePicklistCoord(){
	$("#picklist").remove();
	$("#blockWindow").css('z-index','2');
}

function centring(id,wh,ww){
	var w=$(window).width(); 
	var h=$(window).height();
	var winH=$('#'+id).height(); 
	var winW=$('#'+id).width();
	var scrollA=$("body").scrollTop(); 
	var scrollB=$("body").scrollLeft();
	htop=scrollA+((h/2)-(winH/2))
	hleft=scrollB+((w/2)-(winW/2))
	$('#'+id).css('top',htop).css('left',hleft) ;
}

function entryOver(cell){
	cell.style.backgroundColor='#FFF1AF';
}

function entryOut(cell){
	cell.style.backgroundColor='#FFFFFF';
}

function picklistCoordinators(){
	$.ajax({
		type: "get",
		url: 'Provider?type=view&id=bossandemp',
		success:function (data){
			if(data.match("html")){
				window.location="Provider?type=static&id=start&autologin=0"
			}
			$("#contentpane").html('');
			$("#contentdiv").append(data);
			$('#searchCor').focus();
		}
	});
}

var elementCoord;

function closeDialog(el){
	$("#"+el).empty().remove();
	$("#blockWindow").remove();
}

function fastCloseDialog(){
	$("#picklist").css("display","none");
}

function enableblockform(){
	blockWindow = "<div class='ui-widget-overlay' id='blockWindow'/>"; 
	$("body").append(blockWindow);
	$('#blockWindow').css('width',$(window).width()).css('height',$(window).height()).css('display',"block"); 
}

function disableblockform(){
	$('#blockWindow').remove(); 
}

function dialogBoxStructure(query,isMultiValue, field, form, table) {
	enableblockform();
	$("body").css("cursor","wait")
	queryOpt.fieldname = field;
	queryOpt.formname = form;
	queryOpt.isMultiValue = isMultiValue;
	queryOpt.queryname = query;
	queryOpt.tablename = table;
	_type= 'view';
	if(query == "project-list"){
		_type = "page"
		query += '&form=project-list'  
	}
    if(query == "executers_by_role")   {
        _type = "page";
        query += "&demand_type="  + $("select[name='demand_type']").val()
    }
	if(query == "customer_emp"){
		if($("input[name=customer]").val().length == 0){
			infoDialog("Поле 'заказчик' не заполнено");
			disableblockform();
			$("body").css("cursor","default")
			return false;
		}
		_type = "page";
		query += '&form=customer_emp&customer_id='+$("input[name=customer]").val()+"&";
	}
	el='picklist'
	divhtml ="<div class='picklist' id='picklist' onkeyUp='keyDown(el,event);'>";
	divhtml +="<div class='header'><font id='headertext' class='headertext'/>";
	divhtml +="<div class='closeButton'><img style='width:15px; height:15px; margin-left:3px; margin-top:1px' src='/SharedResources/img/iconset/cross.png' onclick='pickListClose();'/>";
	divhtml +="</div></div><div id='divChangeView' style='margin-top:-10px'><div id='divSearch' class='divSearch' style='display:inline-block; float:left; width:360px; padding-left:15px; text-align:left'/>" 
	divhtml +="<div style='display:inline-block; float:right; width:100px; margin-top:20px'><a class='actionlink' id='btnChangeView' href='javascript:changeViewStructure(1)' style='margin-top:50px'><font style='font-size:11px'>"+changeviewcaption+"</font></a></div></div>";
	divhtml +="<div id='contentpane' class='contentpane'>Пожалуйста ждите идет загрузка...</div>";  
	divhtml += "<div id='btnpane' class='button_panel' style='margin-top:8%; margin:15px 15px 0; padding-bottom:15px;text-align:right;'>";
	divhtml += "<button onclick='pickListBtnOk()'><font class='button_text'>Ок</font></button>" 
	divhtml += "<button onclick='pickListClose()'><font class='button_text'>"+cancelcaption+"</font></button>";    
	divhtml += "</div><div id='executorsColl' display='none'/></div>";
	$("body").append(divhtml);
	$("#picklist #btnpane").children("button").button()
	$("#picklist").draggable({handle:"div.header"});
	centring('picklist',500,500);
	$("#picklist").focus().css('display', "none");
	$("#headertext").text($("#"+field+"caption").val());
	
	$.ajax({
		type: "get",
		url: 'Provider?type='+_type+'&id='+query+'&keyword='+queryOpt.keyword+'&page='+queryOpt.pagenum,
		success:function (data){
			elem = $(data);
			if (data.match("login") && data.match("password")){
				text="Cессия пользователя была закрыта, для продолжения работы необходима повторная авторизация"
				func = function(){window.location.reload()};
				dialogAndFunction (text,func)
			}else{
				if (isMultiValue=="false"){
					if($.browser.msie){
						while(data.match("checkbox")){
							data=data.replace("checkbox", "radio");
						}
					}else{
						$(elem).find("input[type=checkbox]").prop("type","radio")
					}
				}
				$("#contentpane").html(elem);
				$("#searchTable").remove();
				if(isMultiValue=="false"){
					$("#contentpane").append("<input type='hidden' id='radio' value='true'/>");
				}else{
					$("#contentpane").append("<input type='hidden' id='radio' value='false'/>");
					$("div[name=itemStruct] input[type=checkbox]").click(function(){
						addToCollectExecutor(this)
					});
				}
				  
				if(queryOpt.queryname == 'project-list'){
					searchTbl ="<font style='vertical-align:3px;font-weight:bold'>"+projects+":</font>";	
					$("#divSearch").append(searchTbl);
				}else{
					searchTbl ="<font style='vertical-align:3px; font-weight:bold'>"+searchcaption+":</font>";
					searchTbl +=" <input type='text' id='searchCor' style='margin-left:3px;margin-bottom:10px' size='34' onKeyUp='findCorStructure()'/>"; 
					$("#divSearch").append(searchTbl);
				} 
				// Запрещаем выделение текста
				$(document).ready(function(){
					$('#picklist').disableSelection();
					$("body").css("cursor","default")
				});
				if ($("#coordTableView tr").length > 1 &&  field == 'signer'){
					textConfirm="При изменении поля 'Кем будет подписан' существующие блоки согласования будут удалены";
					dialogConfirm (textConfirm, "picklist","trblockCoord")
				}else{
					$('#blockWindow').css('display',"block")
					$('#picklist').css('display', "inline-block");
				}
				$('#picklist').focus()
			}
			
		},
		error:function (xhr, ajaxOptions, thrownError){
            if (xhr.status == 400){
         	  $("body").children().wrapAll("<div id='doerrorcontent' style='display:none'/>")
         	  $("body").append("<div id='errordata'>"+xhr.responseText+"</div>")
         	  $("li[type='square'] > a").attr("href","javascript:backtocontent()")
            }
         }  
	});
	
}

function delmember(el){
	var member = $(el).parent("td").parent("tr").parent("tbody");
	if (member.children("tr").length == 1){
		$(el).parent("td").html("&#xA0;");
	}else{
		$(el).parent("td").parent("tr").remove();
	}		
}

function addMemberSingleOk(docid){
	text=$("#"+docid).attr("value");
	newtr="<tr><td style='width:500px;' class='td_editable'>"+ text +"<input type='hidden' name='"+ queryOpt.fieldname +"' id='"+queryOpt.fieldname+"' value='"+docid+"'><img style='width:15px; height:15px; margin-right:3px; margin-top:1px; float:right; cursor:pointer' src='/SharedResources/img/iconset/cross.png' onclick='delmember(this)'></td></tr>"
	$("#"+ queryOpt.tablename).append(newtr)
	if ($("#"+ queryOpt.tablename+" tr:first td input").length == 0){
		$("#"+ queryOpt.tablename+" tr:first").remove()
	}
	pickListClose(); 
}

function addMemberBtnOk(){
	var k=0;
	var chBoxes = $('input[name=chbox]'); 
	var hidfields = $("#executorsColl").children("input[type=hidden]"); 
	var chEmpty= $("#"+ queryOpt.tablename+"tr:first td input");
	for(var i = 0; i < chBoxes.length; i ++ ){
		if (chBoxes[i].checked && $(chBoxes[i]).attr("id") != ''){
			if (k==0){
				newTable="<table id="+ queryOpt.tablename +"/>"
			}
			k=k+1;
			$("#"+ queryOpt.tablename).append("<tr><td style='width:500px;' class='td_editable'>"+chBoxes[i].value+"<input type='hidden' name='"+queryOpt.fieldname+"' id='"+queryOpt.fieldname+"' value='"+chBoxes[i].id+"'><img style='width:15px; height:15px; margin-right:3px; margin-top:1px; float:right; cursor:pointer' src='/SharedResources/img/iconset/cross.png' onclick='delmember(this)'></td></tr>");
		}
	}
	if (k>0){
		if($("#"+ queryOpt.tablename+" tr:first td input").length ==0){
			$("#"+ queryOpt.tablename+" tr:first").remove()
		}
		pickListClose();  
	}else{
		if($.cookie("lang")=="RUS" || !$.cookie("lang"))
			msgtxt ="Выберите значение";
		else if($.cookie("lang")=="KAZ")
			msgtxt ="Мәндi таңдаңыз";
		else if($.cookie("lang")=="ENG")
			msgtxt ="Select value";
		
		infoDialog(msgtxt);
	}
}

function addMemberGroup(query,isMultiValue, field, form, table) {
	enableblockform()
	queryOpt.fieldname = field;
	queryOpt.formname = form;
	queryOpt.isMultiValue = isMultiValue;
	queryOpt.queryname = query;
	queryOpt.tablename = table;
	el='picklist'
	divhtml ="<div class='picklist' id='picklist' onkeyUp='keyDown(el);'>";
	divhtml +="<div class='header'><font id='headertext' class='headertext'/>";
	divhtml +="<div class='closeButton'><img style='width:15px; height:15px; margin-left:3px; margin-top:1px' src='/SharedResources/img/iconset/cross.png' onclick='pickListClose();'/>";
	divhtml +="</div></div>" 
	divhtml +="<div id='contentpane' class='contentpane'>Загрузка данных...</div>";  
	divhtml += "<div id='btnpane' class='button_panel' style='margin-top:8%; margin:15px 15px 0; padding-bottom:15px;text-align:right;'>";
	divhtml += "<button onclick='addMemberBtnOk()' style='margin-right:5px'><font class='button_text'>ОК</font></button>" 
	divhtml += "<button onclick='pickListClose()'><font class='button_text'>"+cancelcaption+"</font></button>";    
	divhtml += "</div><div id='executorsColl' display='none'/></div>";
	$("body").append(divhtml);
	$("#picklist #btnpane").children("button").button()
	$("#picklist").draggable({handle:"div.header"});
	centring('picklist',500,500);
	$("#picklist").focus().css("display","none")
	$("#headertext").text($("#"+field+"caption").val());
	$("body").css("cursor","wait")
	$.ajax({
		type: "get",
		url: 'Provider?type=view&id='+query+'&keyword='+queryOpt.keyword+'&page='+queryOpt.pagenum,
		success:function (data){
			if (data.match("login") && data.match("password")){
				text="Cессия пользователя была закрыта, для продолжения работы необходима повторная авторизация"
				func="reload";
				dialogAndFunction(text,func)
			}else{
				if(isMultiValue=="false"){
					if($.browser.msie){
						while(data.match("checkbox")){
							data=data.replace("checkbox", "radio");
						}
					}else{
						elem=$(data);
						$(elem).find("input[type=checkbox]").prop("type","radio")
						data= elem;
					}
				}
				$("#contentpane").html(data);
				$("#searchTable").remove();
				if (isMultiValue=="false"){
					$("#contentpane").append("<input type='hidden' id='radio' value='true'/>");
				}else{
					$("#contentpane").append("<input type='hidden' id='radio' value='false'/>");
					$("div[name=itemStruct] input[type=checkbox][id != '']").click(function(){
						addToCollectExecutor(this)
					});
				}
				// запрещаем выделение текста
				$(document).ready(function(){
					$('#picklist').disableSelection();
				});
				$('#blockWindow').css("display","block")
				$('#picklist').css('display',"inline-block").focus();
				$("input[name="+field+"]").each(function(){
					$("input[name=chbox][id='"+$(this).val()+"']").attr("disabled","disabled");
					$("input[name=chbox][id='"+$(this).val()+"']").parent("div").removeAttr("ondblclick").removeAttr("onmouseover").removeAttr("onmouseout").removeAttr("onclick").css("color","#ccc");
				})
			}
		},
		error:function (xhr, ajaxOptions, thrownError){
            if (xhr.status == 400){
         	  $("body").children().wrapAll("<div id='doerrorcontent' style='display:none'/>")
         	  $("body").append("<div id='errordata'>"+xhr.responseText+"</div>")
         	  $("li[type='square'] > a").attr("href","javascript:backtocontent()")
            }
         }  
	});
}

function addToCollectExecutor(el){
	if($(el).is(':checked') && $(el).attr("id") != ''){
		$("#executorsColl").append("<input type='hidden' id='"+$(el).attr("id")+"' value='"+$(el).val() +"'/>")
	}else{
		$("#executorsColl").children("#"+$(el).attr("id")).remove();
	}
	$("#executorsColl input[type=hidden]:first").attr("class","otv")
}

jQuery.fn.extend({
    disableSelection : function() {
    	this.each(function() {
    		this.onselectstart = function() { return false; };
    		this.unselectable = "on";
    		$(this).css('-moz-user-select', 'none');
    	});
    },
    enableSelection : function() {
    	this.each(function() {
    		this.onselectstart = function() {};
    		this.unselectable = "off";
    		$(this).css('-moz-user-select', 'auto');
    	});
    }
});

function findCorStructure(){
	var value=$('#searchCor').val();
	var len=value.length
	if (len > 0){
		$("div[name=itemStruct]").css("display","none");
		$("#contentpane").find("div[name=itemStruct]").each(function(){
			if ($(this).text().substring(0,len).toLowerCase() == value.toLowerCase()){
				$(this).css("display","block")
			}
		});
	}else{
		$("div[name=itemStruct]").css("display","block");
	}
}
function selectPage(page){
	queryOpt.pagenum = page;
	$.ajax({
		type: "get",
		url: 'Provider?type=view&id='+ queryOpt.queryname +'&page='+ queryOpt.pagenum +"&keyword="+queryOpt.keyword,
		success:function (data){
			elem =$(data)
			if (queryOpt.isMultiValue == "false"){
				$(elem).find("input[type=checkbox]").prop("type","radio")
			}
			$("#contentpane").html(elem);
			$('#btnChangeView').attr("href","javascript:changeViewStructure("+queryOpt.dialogview+")");
			$('#searchCor').focus()
		}
	});
}

function changeViewStructure (viewType){
	if (viewType==1){
		switch (queryOpt.queryname){
			case "corresp":
				queryOpt.queryname="corr";
				break;
			case "signers":
				queryOpt.queryname="signers";
				break;
			case "n":
				queryOpt.queryname="n";
				break;
			default:
				queryOpt.queryname="structure";
				break;
		}
		queryOpt.dialogview = 2;
	}else{
		switch (queryOpt.queryname){
			case "corr":
				queryOpt.queryname="corresp";
				break;
			case "corresp":
				queryOpt.queryname="corr";
				break;
			case "signers":
				queryOpt.queryname="signers";
				break;
			case "n":
				queryOpt.queryname="n";
				break;
			default:
				queryOpt.queryname="bossandemppicklist";
				break;
		}
		queryOpt.dialogview = 1;
	}
	$.ajax({
		type: "get",
		url: 'Provider?type=view&id='+queryOpt.queryname+'&keyword='+queryOpt.keyword+'&page='+queryOpt.pagenum,
		success:function (data){
			elem= $(data)
			if (queryOpt.isMultiValue =="false"){
				$(elem).find("input[type=checkbox]").prop("type","radio")
			}
			$("#contentpane").html(elem);
			$("#contentpane input[type=checkbox]").click(function(){
				addToCollectExecutor(this)
			});
			if(viewType == 2){
				searchTbl ="<font style='vertical-align:3px; float:left; margin-left:4%; font-weight:bold'>"+searchcaption+":</font>";
				if (queryOpt.queryname == 'n'){
					searchTbl +=" <input type='text' id='searchCor' style='float:left; margin-left:3px;' size='34' onKeyUp='ajaxFind()'/>"; 
				}else{
					searchTbl +=" <input type='text' id='searchCor' style='float:left; margin-left:3px;' size='34' onKeyUp='findCorStructure()'/>"; 
				}
				$("#divSearch").append(searchTbl);
			}else{
				$("#divSearch").empty()
			}
			$('#btnChangeView').attr("href","javascript:changeViewStructure("+queryOpt.dialogview+")");
		},
		error:function (xhr, ajaxOptions, thrownError){
			if (xhr.status == 400){
				$("body").children().wrapAll("<div id='doerrorcontent' style='display:none'/>")
				$("body").append("<div id='errordata'>"+xhr.responseText+"</div>")
				$("li[type='square'] > a").attr("href","javascript:backtocontent()")
			}
		}  
	});
}

function ajaxFind(){
	queryOpt.keyword=$("#searchCor").val()+"*";
	$.ajax({
		type: "get",
		url: 'Provider?type=view&id='+queryOpt.queryname+'&keyword='+queryOpt.keyword+"&page=1",
		success:function (data){
			elem=$(data)
			if (queryOpt.isMultiValue == "false"){
				$(elem).find("input[type=checkbox]").prop("type","radio")
			}
			$("#contentpane").html(elem);
			$('#btnChangeView').attr("href","javascript:changeViewStructure(2)");
			$('#searchCor').focus()
		},
		error:function (xhr, ajaxOptions, thrownError){
            if (xhr.status == 400){
         	  $("body").children().wrapAll("<div id='doerrorcontent' style='display:none'/>")
         	  $("body").append("<div id='errordata'>"+xhr.responseText+"</div>")
         	  $("li[type='square'] > a").attr("href","javascript:backtocontent()")
            }
         }    
	});
}

function expandChapter(query,id,doctype) {
	$.ajax({
		url: 'Provider?type=view&id='+query+'&parentdocid='+id+'&parentdoctype='+doctype+'&command=expand`'+id+'`'+doctype,
		success: function(data) {
			elem = $(data);
			if(queryOpt.isMultiValue == "false"){
				$(elem).find("input[type=checkbox]").prop("type","radio")
			}
			$(".tbl"+id+doctype).append(elem);	
			if (doctype == "891"){
				$("input[name=chbox]").removeAttr("style");	
			}
		}
	});	
	$("#a"+id+doctype).attr("href","javascript:collapseChapter('"+query+"','"+id+"','"+ doctype+"')");
	$("#img"+id+doctype).attr("src","/SharedResources/img/classic/minus.gif");
}

function collapseChapter(query,id,doctype){
	$.ajax({
		url: 'Provider?type=view&id='+query+'&parentdocid='+id+'&parentdoctype='+doctype+'&command=collaps`'+id+'`'+doctype,
		success: function(data) {
			$(".tbl"+id+doctype+" tr:[name=child]").remove()
		}
	});
	$("#img"+id+doctype).attr("src","/SharedResources/img/classic/plus.gif");
	$("#a"+id+doctype).attr("href","javascript:expandChapter('"+query+"','"+id+"','"+ doctype+"')");
}

function expandChapterCorr(docid,num,url,doctype, page) {
	el = $(".tblCorr:eq("+num+")");
	$.ajax({
		url:url+"&page="+queryOpt.pagenum,
		dataType:'html',
		success: function(data) {
			$("#contentpane").html(data)
			$("#img"+docid+doctype).attr("src","/SharedResources/img/classic/minus.gif");
			$("#a"+docid+doctype).attr("href","javascript:collapsChapterCorr('"+docid+"','"+num+"','"+ url+"','"+doctype+"','"+page+"')");
		}
	});	
}

function collapsChapterCorr(docid,num,url,doctype, page) {
	el = $(".tblCorr:eq("+num+")");
	$.ajax({
		url:"Provider?type=view&id=corrcat&command=collaps`"+docid+"&page="+ queryOpt.pagenum ,
		dataType:'html',
		success: function(data) {
			$("#contentpane").html(data)
			$("#img"+docid+doctype).attr("src","/SharedResources/img/classic/plus.gif");
			$("#a"+docid+doctype).attr("href","javascript:expandChapterCorr('"+docid+"','"+num+"','"+ url+"','"+doctype+"','"+page+"')");
		}
	});	
}

function selectItemPicklist(element, event){
	if (!event.target) {
	    event.target = event.srcElement
	}
	if(event.target.nodeName !="INPUT"){
		target_input = $(element).find("input[type!=hidden]");
		if($(target_input).attr("checked") == "checked"){
			target_input.prop("checked",false).change();
		}else{
			target_input.prop("checked",true).change()
		}
	}
}