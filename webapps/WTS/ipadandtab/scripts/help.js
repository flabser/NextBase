function loadHelpContent(id){
	$('#helpContent').clear;
	/*alert(id);*/	
	$.ajax({
		  url:  'Provider?type=document&id=topics&key='+id+ '&page=null',
		  datatype:'html',
		  success: function(data) {			 
			  $('#helpContent').html(data);
		  }
	});
}