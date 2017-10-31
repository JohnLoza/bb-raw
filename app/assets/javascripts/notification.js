notification = {
  new: function(type, message, from, align){
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
