<%-- 
    Document   : index
    Created on : 11-Dec-2018, 10:32:27 AM
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
	    body {
  background:#f1f7fc;
}

form {
  max-width:320px;
  width:90%;
  margin:0 auto;
  background-color:#ffffff;
  padding:40px;
  border-radius:4px;
  color:#505e6c;
  box-shadow:1px 1px 5px rgba(0,0,0,0.1);
}

.illustration {
  text-align:center;
  padding:0 0 20px;
  font-size:100px;
  color:rgb(244,71,107);
}

form .form-control {
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

.btn-primary {
  background:#f4476b;
  border:none;
  border-radius:4px;
  padding:11px;
  box-shadow:none;
  margin-top:26px;
  text-shadow:none;
  outline:none !important;
}

.btn-primary:hover, .btn-primary:active {
  background:#eb3b60;
}

.btn-primary:active {
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
.jumbotron {
	margin-bottom: 0px;
	background-image: url(assets/preview_yase_creator.JPG);background-position: 0% 25%;
	background-size: cover;
	background-repeat: no-repeat;
	color: white;
	text-shadow: black 0.1em 0.1em 0.1em;
}

.icon {
			font-size: 64px;
		}
    </style>
</head>
<body data-spy="scroll" data-target=".bs-docs-sidebar">
<!-- Navbar
    ================================================== -->
<div class="jumbotron">
  <div class="nav-agency">
    <div class="navbar navbar-static-top"> 
      <!-- navbar-fixed-top -->
      <div class="navbar-inner">
        <div class="container"> 
	    <a class="illustration" href="index.html"> <i class="typcn typcn-starburst-outline">YASE</i></a>
        </div>
      </div>
    </div>
  </div>
  <div class="container show-case-item">
    <h1> YET ANOTHER SMALL ENGINE<br />
       CRÉE INNOVER et YASE </h1>
    <p> YASE est un logiciel pour la gestion et la création de scene 3D</p>
    <!-- Regarde si on n'est connecter -->
    <a href="account/login.jsp" class="btn btn-primary">Connecter vous pour commencer l'expérience</a>
    <div class="clearfix"> </div>
  </div>
</div>
<div class="container">
  <div class="marketing">
    <h1> Bienvenue dans YASE </h1>
    <p class="marketing-byline"> Un outil simple accessbile</p>
    <hr class="soften">

    <div class="row-fluid">
	<div class="row"> 
	    <div class="col-md-2">
		<i class="icon ion-logo-windows"></i>
	    </div>
	    <div class="col-md-2">
		<i class="icon ion-logo-windows"></i>
	    </div
	    <div class="col-md-2">
		<i class="icon ion-logo-windows"></i>
	    </div
	</div>
        <h2> <span class="firstword">Responsive</span> Layout</h2>
    </div>
    <hr class="soften">
    <div class="row-fluid textleft">
      <div class="span8">
        <h2> <span class="firstword">Our</span> Services</h2>
        <p> We've been doing this for a long time and the knowledge we gather from our years
          of experience helps us to understand how the mobile channel can help our clients
          in their challenges. We help brands by creating and developing compelling and strategic
          solutions that are not depended on channels or platforms, but instead creating a
          link between human needs and brands.</p>
        <p> A few other benefits to this template include a price table element and the ability
          to modify button backgrounds using CSS3. </p>
        <div class="row-fluid bordertop">
          <p> With this templates, comes the following awesomenesses :)</p>
          <div class="span4">
            <ul class="services">
              <li><i class="icon-user"></i> Built for and by nerds</li>
              <li><i class="icon-th"></i> 12-column grid</li>
              <li><i class="icon-globe"></i> Bad-ass support</li>
              <li><i class="icon-book"></i> Growing library</li>
            </ul>
          </div>
          <div class="span4">
            <ul class="services">
              <li><i class="icon-resize-small"></i> Responsive design</li>
              <li><i class="icon-eye-open"></i> Cross-everything</li>
              <li><i class="icon-list-alt"></i> Documentation</li>
              <li><i class="icon-cog"></i> jQuery plugins</li>
            </ul>
          </div>
        </div>
      </div>
      <div class="span4">
        <h2> <span class="firstword">Agency</span> Perks</h2>
        <div class="benefit first clearfix"> <span class="icon flexible-hours"></span><span class="benefit_text">
          <div class="perks-title"> Flexible Hours</div>
          <p> Come late at work or take free time if you want, we focus on results.</p>
          </span> </div>
        <div class="benefit clearfix"> <span class="icon coffee-day"></span><span class="benefit_text">
          <div class="perks-title"> Surprise Treats</div>
          <p> Every week we have one day that is dedicated to surprise treat.</p>
          </span> </div>
        <div class="benefit clearfix"> <span class="icon personal-projects"></span><span class="benefit_text">
          <div class="perks-title"> Personal Projects</div>
          <p> We support you... to build your very own projects.</p>
          </span> </div>
      </div>
    </div>
  </div>
</div>
<script type="text/javascript">
        $(document).ready(function () {

            var showCaseItems = $('.show-case-item').hide();

            var splashes = $('.splash').hide();
            //get each image for each slide and set it as a background of the slide
            //            splashes.each(function () {
            //                var img = $(this).find('img');
            //                var imgSrc = img.attr('src');
            //                img.css('visibility', 'hidden');
            //                $(this).css({ 'background-image': 'url(' + imgSrc + ')', 'background-repeat': 'no-repeat' });
            //            });

            splashes.eq(0).show();
            showCaseItems.eq(0).show();

            var prevIndex = -1;
            var nextIndex = 0;
            var currentIndex = 0;

            $('#banner-pagination li a').click(function () {

                nextIndex = parseInt($(this).attr('rel'));

                if (nextIndex != currentIndex) {
                    $('#banner-pagination li a').html('<img src="assets/img/slidedot.png" alt="slide"/>');
                    $(this).html('<img src="assets/img/slidedot-active.png" alt="slide"/>');
                    currentIndex = nextIndex;
                    if (prevIndex < 0) prevIndex = 0;

                    splashes.eq(prevIndex).css({ opacity: 1 }).animate({ opacity: 0 }, 500, function () {
                        $(this).hide();
                    });
                    splashes.eq(nextIndex).show().css({ opacity: 0 }).animate({ opacity: 1 }, 500, function () { });

                    showCaseItems.eq(prevIndex).css({ opacity: 1 }).animate({ opacity: 0 }, 500, function () {
                        $(this).hide();
                        showCaseItems.eq(nextIndex).show().css({ opacity: 0 }).animate({ opacity: 1 }, 200, function () { });
                    });

                    prevIndex = nextIndex;
                }

                return false;
            });

        });
    </script>

</body>

</html>