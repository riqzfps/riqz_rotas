
myslide = document.querySelectorAll('.myslide'),
dot = document.querySelectorAll('.dot');
let counter = 1;
slidefun(counter);

function as(){
	slidefun(counter);
	myslide = document.querySelectorAll('.myslide'),
	dot = document.querySelectorAll('.dot');
}

function plusSlides(n) {
	counter += n;
	slidefun(counter);
}

function slidefun(n) {
	
	let i;
	for(i = 0;i<myslide.length;i++){
		myslide[i].style.display = "none";
	}
	for(i = 0;i<dot.length;i++) {
		dot[i].className = dot[i].className.replace(' active', '');
	}
	if(n > myslide.length){
	   counter = 1;
	   }
	if(n < 1){
	   counter = myslide.length;
	   }
	myslide[counter - 1].style.display = "block";
	
	document.getElementsByClassName("botao").id = counter;
	a = document.getElementsByClassName("botao").id
}

$(function() {  
	var actionContainer = $("body");
  
	window.addEventListener("message", function(event) {
	  var item = event.data;

	  if (item.menu == 'showmenu') {
		$('.actionmenu').css('display','block');
	    actionContainer.fadeIn();
	  }
	  if (item.menu == 'hidemenu') {
	    $('body').css('background-color', 'transparent')
		actionContainer.fadeOut();
	  }

	  if(item.type == 'open') {
		let slider = ""
		let itens = item.itens

		for(var i = 0 ; i < itens.length; i++) {
			let item = itens[i]

			let nomeitem = item[0]
			let imgitem = item[1]


			if (imgitem == '') {
				imgitem = 'https://cdn.discordapp.com/attachments/1081977531437170788/1081977551959883806/Sem_Titulo-2.png'
			}


			if(i == 0){
				slider += "<div class='myslide fade' style='display: block;'><div class='itens'><img class='image' src="+imgitem+"><p>"+nomeitem.toUpperCase()+"</p></div></div>"
			} else {
				slider += "<div class='myslide fade'><div class='itens'><img class='image' src="+imgitem+"><p>"+nomeitem.toUpperCase()+"</p></div></div>"
			}

		    document.getElementById("slider").innerHTML = slider;
		}
		as()
	}
	});
	
  
	document.onkeyup = function(data) {
		var actionContainer = $("body");
	  if (data.which == 27) {
		if (actionContainer.is(":visible")) {
		  sendData("retornar", "fechar");
		  $('.actionmenu').css('display','none')
		  actionContainer.fadeOut();
		}
		
	  }
	  
	};
  });


function rota() {
	id = document.getElementsByClassName("botao").id
	console.log(id)
} 

function iniciarota() {
	var actionContainer = $("body");
	sendData("retornar", "fechar");
	actionContainer.fadeOut();

	numitem = document.getElementsByClassName("botao").id

	$.post('http://riqz_rotas/iniciar', JSON.stringify({
		numitem: numitem
	}));
} 


function sendData(name, data) {
	$.post("http://riqz_rotas/" + name, JSON.stringify(data));
}