function message(text,elID){
	 var myDiv = document.createElement("DIV");
	 if ($.cookie("lang")=="RUS") 
		   divhtml ="<div id='dialog-message' title='Предупреждение'  >";
		 else if ($.cookie("lang")=="KAZ") 
			   divhtml ="<div id='dialog-message' title='Ескерту'  >";
		 else if ($.cookie("lang")=="ENG") 
			   divhtml ="<div id='dialog-message' title='Warning'  >";
	   divhtml+="<span style='height:50px; margin-top:4%; width:100%; text-align:center'>"+
	   			"<font style='font-size:13px; '>"+ text +"</font>"+"</span>";
	   divhtml += "</div>";
	   myDiv.innerHTML = divhtml;
	   document.body.appendChild(myDiv);
	   $("#dialog").dialog("destroy");
	   $( "#dialog-message" ).dialog({
		height:140,
		modal: true,
		buttons: {
			"Ок": function() {
				$(this).dialog("close").remove();
				if (elID !=null){
					$("#"+elID).focus()
				}
			}
		}
	});
}