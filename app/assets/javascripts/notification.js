notification = {
  new: function(type, message, from = 'top', align = 'center'){
    $.notify({
        	icon: "info",
        	message: message
        },{
            type: type,
            timer: 3000,
            placement: {
                from: from,
                align: align
            }
        });
  }
}
