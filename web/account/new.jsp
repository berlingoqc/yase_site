<%-- 
    Document   : new
    Created on : 11-Dec-2018, 11:57:57 AM
    Author     : wq
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Account New</title>
	<jsp:include page="/shared/import.jsp" />
	<%
		// Valide si j'ai deja un token et me renvoie a la place
		// indiquer par redirectTo
	
	%>
	
	<style>
	    body {
		    background:#f1f7fc;
	    }
.login-clean {
  background:#f1f7fc;
  padding:80px 0;
}

.login-clean form {
  max-width:320px;
  width:90%;
  margin:0 auto;
  background-color:#ffffff;
  padding:40px;
  border-radius:4px;
  color:#505e6c;
  box-shadow:1px 1px 5px rgba(0,0,0,0.1);
}

.login-clean .illustration {
  text-align:center;
  padding:0 0 20px;
  font-size:100px;
  color:rgb(244,71,107);
}

.login-clean form .form-control {
  background:#f7f9fc;
  border:none;
  border-bottom:1px solid #dfe7f1;
  border-radius:0;
  box-shadow:none;
  outline:none;
  color:inherit;
  text-indent:8px;
  height:42px;
}

.login-clean form .btn-primary {
  background:#f4476b;
  border:none;
  border-radius:4px;
  padding:11px;
  box-shadow:none;
  margin-top:26px;
  text-shadow:none;
  outline:none !important;
}

.login-clean form .btn-primary:hover, .login-clean form .btn-primary:active {
  background:#eb3b60;
}

.login-clean form .btn-primary:active {
  transform:translateY(1px);
}

.login-clean form .forgot {
  display:block;
  text-align:center;
  font-size:12px;
  color:#6f7a85;
  opacity:0.9;
  text-decoration:none;
}

.login-clean form .forgot:hover, .login-clean form .forgot:active {
  opacity:1;
  text-decoration:none;
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
		$(document).ready(function() {
			$("#forgot").on('click',function() {
				$('.error').text("Tes dans marde").fadeIn(400).delay(2000).fadeOut(400);
			});
			
			$("#submit").on('click',function() {
				var user = $("#user").val();
				var psw = $("#password").val();
				var conf_psw = $("#confirmation_password").val();
				if(user === "") {
					$('.error').text("Entrer nom d'utilisateur").fadeIn(400).delay(2000).fadeOut(400);
					return;
				} 
				if(psw === "") {
					$('.error').text("Entrer un mot de passe").fadeIn(400).delay(2000).fadeOut(400);
					return;
				}
				if(conf_psw === "" || conf_psw !== psw) {
					$(".error").text("Confirmation du mot de passe invalide").fadeIn(400).delay(2000).fadeOut(400);
					return;
				}
				$this = $(this);
				$(this).button('loading');
				
				var accout_new = {
					username: user,
					password: psw
				};
				
				var json_new = JSON.stringify(accout_new);
				
				$.ajax({
					type: "POST",
					url: "/helios/api/account",
					dataType:	"json",
					data: json_new
				}).done(function () {
					// redirige vers index
					window.location.replace('/helios/dashboard.jsp');
					
				}).fail(function (xhr, status,err) {
					var resp = xhr.responseText;
					$this.button('reset');
					
					if(resp === "username") {
						$('.error').text("Utilisateur invalide").fadeIn(400).delay(2000).fadeOut(400);
					} else  if(resp === "password") {
						$('.error').text("Mot de passe invalide").fadeIn(400).delay(2000).fadeOut(400);
					} else {
						alert(resp);
					}
				});
				return false;
			});
		});
	</script>
    </head>
    <body>
	<div class="container">
		<div class="login-clean">
			<form role="form" action="">
				<h2 class="sr-only">Login Form</h2>
				<div class="illustration">
					<i class="typcn typcn-starburst-outline"></i>
					<h1>Helios</h1>
				</div>
				<div id="divuser" class="form-group">
					<input class="form-control" type="text" name="user" id="user" required="true" placeholder="Utilisateur">
				</div>
				<div id="divpassword" class="form-group">
				    <input class="form-control" type="password" name="password" id="password" required="true" placeholder="Mot de passe"
				</div>
				<div id="divpassword" class="form-group">
				    <input class="form-control" type="password" name="password" id="confirmation_password" required="true" placeholder="Confirmation">
				</div>
				<div class="form-group">
					<button id="submit" class="btn btn-primary btn-block" data-loading-text="<i class='fa fa-spin fa-spinner'></i>" type="button">Confirmer</button>
				</div>
			</form>
		</div>
		<div class="error" style='display:none'></div>
	</div>
    </body>
</html>
