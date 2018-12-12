<%-- 
    Document   : setup
    Created on : Oct 14, 2018, 8:33:30 PM
    Author     : wq
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
	<jsp:include page="/shared/import.jsp" />
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Configuration du Server</title>
<style>
body {
    margin-top:40px;
}


/* Include the padding and border in an element's total width and height */
* {
  box-sizing: border-box;
}

/* Remove margins and padding from the list */
ul {
  margin: 0;
  padding: 0;
}

/* Style the list items */
ul li {
  cursor: pointer;
  position: relative;
  padding: 12px 8px 12px 40px;
  list-style-type: none;
  background: #eee;
  font-size: 18px;
  transition: 0.2s;
  
  /* make the list items unselectable */
  -webkit-user-select: none;
  -moz-user-select: none;
  -ms-user-select: none;
  user-select: none;
}


/* When clicked on, add a background color and strike out text */
ul li.checked {
  background: #888;
  color: #fff;
  text-decoration: line-through;
}


ul li.failed {
	background: #ff9999;
	color: #fff;
	text-decoration: underline;
}


.stepwizard-step p {
    margin-top: 10px;
}
.stepwizard-row {
    display: table-row;
}
.stepwizard {
    display: table;
    width: 50%;
    position: relative;
}
.stepwizard-step button[disabled] {
    opacity: 1 !important;
    filter: alpha(opacity=100) !important;
}
.stepwizard-row:before {
    top: 14px;
    bottom: 0;
    position: absolute;
    content: " ";
    width: 100%;
    height: 1px;
    background-color: #ccc;
    z-order: 0;
}
.stepwizard-step {
    display: table-cell;
    text-align: center;
    position: relative;
}
.btn-circle {
    width: 30px;
    height: 30px;
    text-align: center;
    padding: 6px 0;
    font-size: 12px;
    line-height: 1.428571429;
    border-radius: 15px;
}

.error {
    width:200px;
    height:20px;
    height:auto;
    position:absolute;
    left:50%;
    margin-left:-100px;
    bottom:10px;
    background-color: #383838;
    color: #F0F0F0;
    font-family: Calibri;
    font-size: 20px;
    padding:10px;
    text-align:center;
    border-radius: 2px;
    -webkit-box-shadow: 0px 0px 24px -1px rgba(56, 56, 56, 1);
    -moz-box-shadow: 0px 0px 24px -1px rgba(56, 56, 56, 1);
    box-shadow: 0px 0px 24px -1px rgba(56, 56, 56, 1);
}
</style>
<script>
  $(document).ready(function () {
	  $("#btnSubmit").hide();
	  var SetRowState = function(state,rownbr) {
		  var items = $('.validation-list').find('.fa');
		  if(state === "INITIAL") {
			items.addClass("fa-cog");
			$(items[0]).addClass("fa-spin");
		  } else if (state === "FAILED") {
			var itemsList = $('.validation-list').find('li');
			$(itemsList[rownbr]).addClass("failed");
			$(items[rownbr]).removeClass("fa-spin fa-cog").addClass("fa-exclamation-triangle");
		  } else if (state === "CHECKED") {
			var itemsList = $('.validation-list').find('li');
			$(itemsList[rownbr]).addClass("CHECKED");
			$(items[rownbr]).removeClass("fa-spin fa-cog").addClass("fa-thumbs-up");
			var nextRow = rownbr+1;
			if(items.length > nextRow) {
				// fait spiner la prochaine row tout de suite
				$(items[nextRow]).addClass("fa-spin");
			}
		}
	  };
	  
	  var currentStep = 0;
	  
	  var ValidationTask = function() {
		  var passwordAdmin = $("#password").val();
		  
		  var smbStruct = {
			  url:	$("#url").val(),
			  username: $("#username").val(),
			  password: $("#passwordsmb").val(),
			  domain: $("#domain").val()
		  };
		  
		  var jsonsmb = JSON.stringify(smbStruct);
		  
		  var callCreateAccount = $.ajax({
			  type:		"POST",
			  url:		"/helios/api/init/config?secret"+passwordAdmin,
			  data:		"secret=" + passwordAdmin
		  });
		  var callGetSmb = $.ajax({
			  type:		"GET",
			  url:		"/helios/api/smb/test",
			  content:	"application/json",
			  dataType:	"json",
			  data:		jsonsmb
		  });
		  var callSaveSmb = $.ajax({
			  type:		"POST",
			  url:		"/helios/api/smb/share",
			  content:	"application/json",
			  dataType:	"json",
			  data:		jsonsmb
		  });
		  
		  callCreateAccount.done(function() {
			SetRowState("CHECKED",0);
			setTimeout(function() {
				SetRowState("CHECKED",1);
				setTimeout(function() {
					SetRowState("CHECKED",2);
					$("#btnSubmit").show();
				},1000);
			},1000);
		  }).fail(function(jqXHR, textStatus) {
			SetRowState("FAILED",0);
		  });
		  
	  };
	  
	SetRowState("INITIAL");
	
	// SECTION DE CONFIG DE MON FORMULAIRE MULTI-STEP
	
	// Va chercher le a dans le div dans les div qui ont la class setup-pnale
	var navListItems = $('div.setup-panel div a');
	// Va chercher tout nos formulaire qui sont avec la class setup-content
	var allWells = $('.setup-content');
	// va chercher nos boutton suivant
        var allNextBtn = $('.nextBtn');
	
	// Par default ont les caches toutes
	allWells.hide();
	
	// quand on click sur un de nos element de la navList
	navListItems.click(function (e) {
		// previent le fonctionnement par default pour nous laisser faire
		e.preventDefault();
		
		// va cherche le nom de la target du <a> qui est contenues dans sont href genre #step1
		var ref = $(this).attr('href');
		var $target = $(ref),
		$item = $(this);
		if($item.attr('disabled')) {
			// affiche toast msg s'il click sur les étapes en haut et qu'elles n'ont pas été enable
			$('.error').text("Finnisser d'abord ce formulaire").fadeIn(400).delay(2000).fadeOut(400);
			return;
		}
		

		// si notre item n'a pas la classe disabled
		if (!$item.hasClass('disabled')) {
			// enlebe la classe btn-primary a tout le monde pour remplacer par default
			navListItems.removeClass('btn-primary').addClass('btn-default');
			// donne a notre item le button default
			$item.addClass('btn-primary');
			// cache tout les formulaire
			allWells.hide();
			// affiche lui quon voulait
			$target.show();
			// Regarde si on n'est a la derniere etape
			if(ref === "#step-3") {
				// Démarre la tache de validation avec les données
				ValidationTask();
				
			}
			// mets le focus sur le premiere input du formulaire
			$target.find('input:eq(0)').focus();
			
		}
	});
	
	var ValidPasswordAndConfirmaton = function(curStep) {
		curInputs = curStep.find("input[type='password']");
		var isValid = true;
		var v1 = $(curInputs[0]).val();
		var v2 = $(curInputs[1]).val();
		// Valide origin
		if(v1 === "") {
			$(curInputs[0]).closest(".form-group").addClass("has-error");
			isValid = false;
		} else if (v1 !== v2) {
			isValid = false;
			$(curInputs[1]).closest(".form-group").addClass("has-error");
		}
		return isValid;
	};

	// Quand on client sur n'importe lequelle des bouttons next
	allNextBtn.click(function(){
		// va chercher le setup content le plus pres du button donc le formulaire courrament afficher
		var curStep = $(this).closest(".setup-content"),
		// va chercher l'id du formulaire courrant (step-1) genre
		curStepBtn = curStep.attr("id"),
		// va chercher le prochain button dans le step wizard ( le truc en haut)
		nextStepWizard = $('div.setup-panel div a[href="#' + curStepBtn + '"]').parent().next().children("a"),
		// va chercher dans le formulaire courrant tout les inputs des types passés
		curInputs,
		// variable qui retourne si la section est valide
		isValid = true;
		
		// enleve tout les has-error du formulaire 
		$(".form-group").removeClass("has-error");
		
		if(curStepBtn === "step-1") {
			isValid = ValidPasswordAndConfirmaton(curStep);
		} else {
			if(curStepBtn === "step-2") { // Pour l'étape 2 on regarde pour les mots de passe et le reste apres
				isValid = ValidPasswordAndConfirmaton(curStep);
			}
			curInputs = curStep.find("input[type='text'],input[type='url']");
					
			// va chercher les inputs et regarde s'ils sont valide
			for(var i=0; i<curInputs.length; i++){
				if (!curInputs[i].validity.valid){
					isValid = false;
					$(curInputs[i]).closest(".form-group").addClass("has-error");
				}
			}
		}
		if (isValid)
			nextStepWizard.removeAttr('disabled').trigger('click');
	});
	$('div.setup-panel div a.btn-primary').trigger('click');
});

</script>
    </head>
    <body>
         
        <div class="container">
            <div class="jumbotron">
                <h1>Initialisation du site web</h1>
                

                <p>Dans cette section, nous allons configurer le reste du serveur</p>

            </div>
        </div>
        

<div class="container">
  
<div class="stepwizard col-md-offset-3">
    <div class="stepwizard-row setup-panel">
      <div class="stepwizard-step">
        <a href="#step-1" type="button" class="btn btn-primary btn-circle" >1</a>
        <p>Admin</p>
      </div>
      <div class="stepwizard-step">
        <a href="#step-2" type="button" class="btn btn-default btn-circle" disabled="disabled">2</a>
        <p>SMB</p>
      </div>
      <div class="stepwizard-step">
        <a href="#step-3" type="button" class="btn btn-default btn-circle" disabled="disabled">3</a>
        <p>Validation</p>
      </div>
    </div>
  </div>
  
  <form role="form" action="" method="post" centered>
    <div class="row setup-content" id="step-1">
      <div class="col-xs-6 col-md-offset-3">
        <div class="col-md-12">
          <h3> Configuration du compte : admin</h3>
          <div class="form-group">
            <label class="control-label">Mot de passe</label>
            <input id="password"  maxlength="100" type="password" required="required" class="form-control" placeholder="Entre mot de passe admin"  />
          </div>
          <div class="form-group">
            <label class="control-label">Confirmation</label>
            <input maxlength="100" type="password" required="required" class="form-control" placeholder="Confirmation" />
          </div>
          <button class="btn btn-primary nextBtn btn-lg pull-right" type="button" >Prochaine étape</button>
        </div>
      </div>
    </div>
    <div class="row setup-content" id="step-2">
      <div class="col-xs-6 col-md-offset-3">
        <div class="col-md-12">
          <h3>Configurer SMB</h3>
          <div class="form-group">
            <label class="control-label">URL</label>
            <input maxlength="200" type="text" required="required" class="form-control" placeholder="smb://host/share" />
          </div>
          <div class="form-group">
            <label class="control-label">Domain</label>
            <input maxlength="200" type="text" class="form-control" placeholder="Entrer votre nom de domain (optionel)"  />
          </div>
	   <div class="form-group">
            <label class="control-label">Utilisateur</label>
            <input maxlength="200" type="text" required="required" class="form-control" placeholder="Entrer votre nom d'utilisateur"  />
          </div>
	   <div class="form-group">
            <label class="control-label">Mot de passe</label>
            <input maxlength="200" type="password" required="required" class="form-control" placeholder="Entrer votre mot de passe"  />
          </div>
	  <div class="form-group">
            <label class="control-label">Confirmation</label>
            <input maxlength="200" type="password" required="required" class="form-control" placeholder="Confirmer"  />
          </div>
          <button class="btn btn-primary nextBtn btn-lg pull-right" type="button" >Validation</button>
        </div>
      </div>
    </div>
    <div class="row setup-content" id="step-3">
      <div class="col-xs-6 col-md-offset-3">
        <div class="col-md-12">
          <h3>Validation des données avec le serveur</h3>
	  <!-- Validation des données avec le serveur  -->
	  <div class="validation-list">
		<ul>
			<li><i id="compteI" class="fa fa-cog"></i> Création du compte administrateur</li>
			<li><i id="connectionI" class="fa fa-cog"></i> Tentative de connection avec la share</li>
			<li><i id="finalisationI" class="fa fa-cog"></i> Finallisations des données</li>
		</ul>
	        <a href="/helios/index.jsp" id="btnSubmit" class="btn btn-success btn-lg pull-right">Accèder au dashboard</a>
	  </div>
        </div>
      </div>
    </div>
      <div class="error" style='display:none'></div>
  </form>
  
</div>
</body>
</html>
