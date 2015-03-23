nbApp.xhrGetSaldoOnDate = function(ddbid) {
	return nb.ajax({
		method : "GET",
		url : "Provider?type=page&id=saldo_on_date&ddbid=" + ddbid
	});
};

nbApp.xhrGetSaldoSum = function() {
	return nb.ajax({
		method : "GET",
		url : "Provider?type=page&id=saldo-sum"
	});
};
