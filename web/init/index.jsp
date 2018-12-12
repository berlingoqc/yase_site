<%-- 
    Document   : about
    Created on : Oct 16, 2018, 1:44:02 PM
    Author     : wq
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="ca.wquintal.helios.MyBD"%>
<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>loginDesign</title>
    <jsp:include page="/shared/import.jsp" />
    
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,700">
    
    <style>
	    .features-clean {
  color:#313437;
  background-color:#fff;
  padding-bottom:30px;
}

@media (max-width:767px) {
  .features-clean {
    padding-bottom:10px;
  }
}

.features-clean p {
  color:#7d8285;
}

.features-clean h2, h1 {
  font-weight:bold;
  margin-bottom:40px;
  padding-top:40px;
  color: rgb(244,71,107);
}


@media (max-width:767px) {
  .features-clean h2 {
    margin-bottom:25px;
    padding-top:25px;
    font-size:24px;
  }
}

.features-clean .intro {
  font-size:16px;
  max-width:700px;
  margin:0 auto 60px;
}

@media (max-width:767px) {
  .features-clean .intro {
    margin-bottom:40px;
  }
}

.features-clean .item {
  min-height:100px;
  padding-left:80px;
  margin-bottom:40px;
}

@media (max-width:767px) {
  .features-clean .item {
    min-height:0;
  }
}

.features-clean .item .name {
  font-size:20px;
  font-weight:bold;
  margin-top:0;
  margin-bottom:20px;
  color:inherit;
}

.features-clean .item .description {
  font-size:15px;
  margin-bottom:0;
}

.features-clean .item .icon {
  font-size:40px;
  color:#1485ee;
  float:left;
  margin-left:-65px;
}

.footer-basic {
  padding:40px 0;
  background-color:#ffffff;
  color:#4b4c4d;
}

.footer-basic ul {
  padding:0;
  list-style:none;
  text-align:center;
  font-size:18px;
  line-height:1.6;
  margin-bottom:0;
}

.footer-basic li {
  padding:0 10px;
  color: inherit;
}

.footer-basic ul a {
  color:inherit;
  text-decoration:none;
  opacity:0.8;
}

.footer-basic ul a:hover {
  opacity:1;
}

.footer-basic .social {
  text-align:center;
  padding-bottom:25px;
}

.footer-basic .social > a {
  font-size:24px;
  width:40px;
  height:40px;
  line-height:40px;
  display:inline-block;
  text-align:center;
  border-radius:50%;
  border:1px solid #ccc;
  margin:0 8px;
  color:inherit;
  opacity:0.75;
}

.footer-basic .social > a:hover {
  opacity:0.9;
}

.footer-basic .copyright {
  margin-top:15px;
  text-align:center;
  font-size:13px;
  color:#aaa;
  margin-bottom:0;
}


.login-clean .btn-primary {
	font-size:20px;
  font-weight:bold;
  background:#f4476b;
  border:none;
  border-radius:4px;
  padding:11px;
  box-shadow:none;
  margin-top:26px;
  color:inherit;
  text-shadow:none;
  outline:none !important;
}

.login-clean form .btn-primary:hover, .login-clean form .btn-primary:active {
  background:#eb3b60;
}

.login-clean form .btn-primary:active {
  transform:translateY(1px);
}

error {
	font-weight: bold;
	color: #ff3333;
	text-align: center;
	font-size: 18px;
	padding: 5px;
}


    </style>
    
    
    
    <script>
	     function setLoadingText(btn,text) {
                $(btn).data('loading-text', '<i class="fa fa-spin fa-spinner"> </i>'+text);
            }
            $(document).ready(function() {
                
                //$("#btnSubmit").prop('disabled', true);
                
                // pour valider des ip
                var rx=/^(?!0)(?!.*\.$)((1?\d?\d|25[0-5]|2[0-4]\d)(\.|$)){4}$/;
                
                var SetLoadingText = function($btn,$text) {
                    $btn.data('loading-text', '<i class="fa fa-spin fa-spinner"></i>  '+$text);
                };
                
                var SetFormValidationInput = function($divname,$state,$msg) {
                    if($state) {
                        $($divname).removeClass("has-error");
                        $($divname).addClass("has-success has-feedback");
                    } else {
                        $($divname).addClass("has-error has-feedback");
                    }
                    
                };
                
                var host = "";
                var driver = $("#driver").val();
                var database = "";
                var user = "";
                var password = "";
                var isconfirm = false;
                
                
                var IsAllValid = function() {
                    if(!(host === "" || driver === "" || database === "" || user === "" || password === "" || !isconfirm)) {
                        $("#btnSubmit").prop('disabled', false);
                    }
                }
                
                $("#host").on('change', function() {
                    var v = $(this).val();
                    if(!rx.test(v)) {
                        SetFormValidationInput("#hostdiv",false,"");
                    } else {
                        SetFormValidationInput("#hostdiv",true,"");
                        host = v;
                        IsAllValid();
                    }
                });
                
                $("#driver").on('change',function() {
                    driver = $(this).val();
                });
                
                $("#database").on('change',function() {
                    var v = $(this).val();
                    if(v === "") {
                        SetFormValidationInput("#databasediv",false,"");
                    } else {
                        SetFormValidationInput("#databasediv",true,"");
                        database = v;
                        IsAllValid();
                    }
                });
                
                $("#user").on('change',function() {
                   var v = $(this).val();
                    if(v === "") {
                        SetFormValidationInput("#userdiv",false,"");
                    } else {
                        SetFormValidationInput("#userdiv",true,"");
                        user = v;
                        IsAllValid();
                    }
                });
                
                $("#password").on('change',function() {
                   if ($(this).val() !== "") {
                       password = $(this).val();
                       SetFormValidationInput("#passworddiv",true,"");
                       $("#confirmation").prop('disabled', false);
                       IsAllValid();
                   } else {
                       SetFormValidationInput("#passworddiv",false,"");
                       $("#confirmation").prop('disabled', true);
                   }
                });

                $("#confirmation").on('change', function() {
                   var v = $(this).val();
                   if(v !== password) {
                       SetFormValidationInput("#confirmationdiv", false,"");
                   } else {
                       SetFormValidationInput("#confirmationdiv", true, "");
                       isconfirm = true;
                       IsAllValid();
                   }
                });
                
                $("#btnSubmit").on('click', function() {

                    if(host === "" || driver === "" || database === "" || user === "" || password === "") {
                        $(".error").html("Il y a des données invalides");
			//alert("Il y a des données invalides");
                        return;
                    }
		    ;
                    // Envoie les informations de connection a l'api pour valider s'ils sont correcte
                    // affiche le loading dans le button pendant que la requete s'execute
                    // set la valeur de spinner
                    var $this = $(this);
                    SetLoadingText($this,"Validation");
                    $this.button('loading');
                    
                    var connectioninfo = {
                        host:       host,
                        database:   database,
                        user:       user,
                        password:   password,
                        driver:     driver
                    };
                 
                    // Crée une requete ajax avec les informations de connection
                    $.ajax({
                        type:       "POST",
                        url:        "/helios/api/init/config",
                        contentType:   "applicaton/json",
                        dataType: "json",
                        data:    JSON.stringify(connectioninfo),
                        success: function(data,textStatus, jqXHR) {
                            alert(data);
                        },
                        error: function (jqXHR, textStatus, errorThrown) {
                            if(jqXHR.status === 201) {
			 //$this.html("BD valid clicker pour continuer");
                                window.location.replace('/helios/setup.jsp');
				
                                $this.button('reset');
				$('#btnSubmit').html("Continuer vers la prochaine étape");
                            }
                            else if (jqXHR.status === 201) {
                                alert(jqXHR.responseText);
                                $this.button('reset');
                            }
                        }
                    });
                });
            });
    </script>
    
    
</head>

<body>
<div class="modal fade" id="modalConfigDb" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
	  <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	  <h5 class="modal-title" id="exampleModalLabel">Configurer votre base de donnée</h5>
      </div>
      <div class="modal-body">
         <div class="container">
	     <div class="error"></div>
            <div class="col-md-4">              
                    <div class="form-group">
                        <label for="driver">Driver JDBC:</label>
                        <select class="form-control" name="driver" id="driver">
                            <% for(String driver: MyBD.Drivers) { %>
                                <option><%=driver%></option>
                            <%}%>
                        </select>
                        <div id="validdriver" class=""></div>
                    </div>
                    <div id="hostdiv" class="form-group">
                        <label for="host">IP</label>
                        <input type="text" placeholder="127.0.0.1" class="form-control" name="host" id="host">
                        <div id="validhost" class=""></div>
                    </div>
                    <div id="databasediv" class="form-group">
                        <label for="database">Base de donnée</label>
                        <input type="text" placeholder="testdb" class="form-control" name="database" id="database">
                    </div>
                    <div id="userdiv" class="form-group">
                        <label for="user">Utilisateur</label>
                        <input type="text" placeholder="test" class="form-control" name="user" id="user">
                    </div>
                    <div id="passworddiv" class="form-group">
                        <label for="password">Mot de passe</label>
                        <input type="password" class="form-control" name="password" id="password">
                    </div>
                    <div id="confirmationdiv" class="form-group">
                        <label for="password">Confirmation</label>
                        <input type="password" class="form-control" name="password" id="confirmation" disabled>
                    </div>            
            </div>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Fermer</button>
        <button id="btnSubmit" type="button" class="btn btn-primary" data-loading-text="<i class='fa fa-spin fa-spinner'></i> Validation" disabled="true">Appliquer</button>
      </div>
    </div>
  </div>
</div>
    
    <div class="features-clean">
        <div class="container">
            <div class="intro">
		<h1 class="text-center"><i class="typcn typcn-starburst-outline" style="padding:5px;padding-right:5px;"></i>Helios -&nbsp;ἥλιος</h1>
                <h2 class="text-center">Gérer vos données sur votre réseau local</h2>
                <p class="text-center">Permet d'accéder à c'est données smb , nfs ou ftp et vos ordinateurs local par ssh</p>
            </div>
            <div class="row features">
                <div class="col-sm-6 col-lg-4 item"><i class="typcn typcn-cog-outline icon"></i>
                    <h3 class="name">Executer des tâches</h3>
                    <p class="description">Démarrer des tâches préconfiguré sur vos ordinateur comme :&nbsp;</p>
                </div>
                <div class="col-sm-6 col-lg-4 item"><i class="typcn typcn-download-outline icon"></i>
                    <h3 class="name">Télécharger et classer</h3>
                    <p class="description">Télécharger des fichiers comme de la music, des films et des jeux en l'organisant automatiquement selon votre arboressence de rengement</p>
                </div>
                <div class="col-sm-6 col-lg-4 item"><i class="typcn typcn-wi-fi-outline icon"></i>
                    <h3 class="name">Analyser votre réseau local</h3>
                    <p class="description">Remplit d'outils pour administrer son réseau local</p>
                </div>
            </div>
	    <div class="login-clean text-center">
		<button class="btn btn-primary btn-block" data-toggle="modal" data-target="#modalConfigDb">Démarrer la configuration</button>
	    </div>
        </div>
    </div>
    <div class="footer-basic">
        <footer>
            <div class="social"><a href="https://github.com/berlingoqc/helios"><i class="fa fa-github"></i></a></div>
            <p class="copyright">William Quintal © 2018</p>
        </footer>
    </div>
    
    
    

</body>

</html>