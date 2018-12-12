<%-- 
    Document   : settingsdb
    Created on : 14-Sep-2018, 11:24:47 PM
    Author     : william
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="ca.wquintal.helios.MyBD"%>
<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="import.jsp" />
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>DB settings</title>
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
                        alert("Il y a des données invalides");
                        return;
                    }
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
                        url:        "/helios/api/db/config",
                        contentType:   "applicaton/json",
                        dataType: "json",
                        data:    JSON.stringify(connectioninfo),
                        success: function(data,textStatus, jqXHR) {
                            alert(data);
                        },
                        error: function (jqXHR, textStatus, errorThrown) {
                            if(jqXHR.status === 201) {
			 //$this.html("BD valid clicker pour continuer");
                                window.location.replace('/helios/init/setup.jsp');
				
                                $this.button('reset');
				$('#btnSubmit').html("Continuer vers la prochaine étape");
                            }
                            else {
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
        
        <div class="container">
            <div class="jumbotron">
                <h1>Initialiser la base de donnée</h1>
                    <p>Entrer les informations de connexion pour la bd du site</p>
            </div>
        </div>
        
        <div class="container">
            <div class="col-md-4">              
                    <div class="form-group">
                        <label for="driver">MySQL Driver:</label>
                        <select class="form-control" name="driver" id="driver">
                            <% for(String driver: MyBD.Drivers) { %>
                                <option><%=driver%></option>
                            <%}%>
                        </select>
                        <div id="validdriver" class=""></div>
                    </div>
                    <div id="hostdiv" class="form-group">
                        <label for="host">Host:</label>
                        <input type="text" placeholder="127.0.0.1" class="form-control" name="host" id="host">
                        <div id="validhost" class=""></div>
                    </div>
                    <div id="databasediv" class="form-group">
                        <label for="database">Database:</label>
                        <input type="text" placeholder="testdb" class="form-control" name="database" id="database">
                    </div>
                    <div id="userdiv" class="form-group">
                        <label for="user">User:</label>
                        <input type="text" placeholder="test" class="form-control" name="user" id="user">
                    </div>
                    <div id="passworddiv" class="form-group">
                        <label for="password">Password:</label>
                        <input type="password" class="form-control" name="password" id="password">
                    </div>
                    <div id="confirmationdiv" class="form-group">
                        <label for="password">Confirmation:</label>
                        <input type="password" class="form-control" name="password" id="confirmation" disabled>
                    </div>
                        <p id="lol"></p>
                        <button id="btnSubmit" class="btn btn-primary btn-lg" data-loading-text="<i class='fa fa-spin fa-spinner'></i> Validation" disabled="true">Submit</button>
               
            </div>
        </div>
    </body>
</html>
