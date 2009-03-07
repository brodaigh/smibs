//$(document).ready(function() 
//{
//  $('img.fabrics').captify(
//  {
//    speedOver: 600,
//    speedOut: 100,
//    hideDelay: 100,
//    animation: 'fade',	  	
//    prefix: '',	
//    className: 'caption'
//  });
//});

$(document).ready(function() {
  $("p:first").addClass("pad");
});

$(document).ready(function() {

$('#description').localScroll();
$('#selection').localScroll();
$('#order').localScroll();
});


$(document).ready(function()
{ 
  $(":checkbox").css({display:'none'});
  $('li').click(function() 
  {  
    var select = $(this).find(":checkbox").check('toggle',true); 
//UGLY HACK
    if ($(select).is(':checked'))
	 {
	    $(this).css({ backgroundColor:"#fff", fontWeight:"bolder"}).children('.down').hide('fast');
	    $(this).children('.up').show('fast');
     }
    else
     {  
	   $(this).css({ backgroundColor:"#000", fontWeight:"bolder"}).children('.down').show('fast');
	   $(this).children('.up').hide('fast');
	 }
  });
});


$(function() {
	$('a[@rel*=lightbox]').lightBox();
});


//, :onclick ="$.showAkModal(this.href,'Sign In',230,170);return false;"}





//blue = #E0FFFF

//found this on the internets
$.fn.check = function(mode,all) {
  var mode = mode || 'on'; // if mode is undefined, use 'on' as default
  var toggle_state = 'foo';
return this.each(function() {
if(toggle_state == 'foo' && all==true){
// toggle all of them the same, based on first one
toggle_state = !this.checked;
} else if(all!=true) {
// toggle each one individually
toggle_state = !this.checked;
alert(toggle_state);
}
switch(mode) {
case 'on':
this.checked = true;
break;
case 'off':
this.checked = false;
break;
case 'toggle':
this.checked = toggle_state;
break;
}
});
};




