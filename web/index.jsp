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
	    .features-clean {
  color:#313437;
  background-color:#fff;
  padding-bottom:30px;
}
.illustration {
  text-align:center;
  padding:0 0 20px;
  font-size:100px;
  color:rgb(244,71,107);
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
<body data-spy="scroll" data-target=".bs-docs-sidebar">
<!-- Navbar
    ================================================== -->
<div class="jumbotron masthead">
  <div class="nav-agency">
    <div class="navbar navbar-static-top"> 
      <!-- navbar-fixed-top -->
      <div class="navbar-inner">
        <div class="container"> <a class="illustration" href="index.html"> <i class="typcn typcn-starburst-outline">YASE</i></a>
          <div id="main-nav">
            <div class="nav-collapse collapse">
              <ul class="nav">
                <li class="active"><a href="index.html">Home</a> </li>
                <li class="dropdown"><a class="dropdown-toggle" data-toggle="dropdown" href=""> Work <b class="caret"></b></a>
                  <ul class="dropdown-menu">
                    <li><a href="work.html">One Column</a></li>
                    <li><a href="work-two-columns.html">Two Column</a></li>
                    <li><a href="work-three-columns.html">Three Column</a></li>
                    <li><a href="work-details.html">Work Details</a></li>
                  </ul>
                </li>
                <li class="dropdown"><a class="dropdown-toggle" data-toggle="dropdown" href="javascript:"> Pricing <b class="caret"></b></a>
                  <ul class="dropdown-menu">
                    <li><a href="pricing.html">Four Column</a></li>
                    <li><a href="pricing-three-columns.html">Three Column</a></li>
                  </ul>
                </li>
                <li class="dropdown"><a href="javascript:" class="dropdown-toggle" data-toggle="dropdown"> Pages <b class="caret"></b></a>
                  <ul class="dropdown-menu">
                    <li><a href="faq.html">FAQ</a></li>
                    <li><a href="contact.html">Contact Us</a></li>
                    <li><a href="components.html">Components</a></li>
                  </ul>
                </li>
                <li class="dropdown"><a class="dropdown-toggle" data-toggle="dropdown" href="javascript:"> Blog <b class="caret"></b></a>
                  <ul class="dropdown-menu">
                    <li><a href="blog.html">Blog Page</a></li>
                    <li><a href="blog-single.html">Single Page</a></li>
                  </ul>
                </li>
                <li><a href="index.html">Purchase</a> </li>
              </ul>
            </div>
          </div>
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
    <h1> Introducing Agency!</h1>
    <p class="marketing-byline"> Need reasons to purchase this template? See below.</p>
    <hr class="soften">
    <div class="row-fluid">
      <div class="span4"> <img src="assets/img/responsive.png" alt="Responsive">
        <h2> <span class="firstword">Responsive</span> Layout</h2>
        <p class="features"> We combine creative forces with systematic activists. All ideas require implementation
          and our multi-disciplined network fosters a wide array of abilities that empower
          visionaries and entrepreneurs to lead meaningful brands.</p>
      </div>
      <div class="span4"> <img src="assets/img/think-creative.png" alt="Think Creative">
        <h2> <span class="firstword">Built With</span> Bootstrap 2</h2>
        <p> Inspired Thinking. Ask smarter questions, push for innovative solutions and believe
          in the power of creativity. Be consistently open and honest. Be true to ourselves
          and our values. Find, stimulate and maintain the best minds.</p>
      </div>
      <div class="span4"> <img src="assets/img/core-values.png" alt="Core Values">
        <h2> <span class="firstword">Valid</span> HTML5 CSS3</h2>
        <p> Inspired Thinking. Ask smarter questions, push for innovative solutions and believe
          in the power of creativity. Be consistently open and honest. Be true to ourselves
          and our values. Find, stimulate and maintain the best minds.</p>
      </div>
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
<!-- Footer
    ================================================== -->
<footer class="footer">
  <div class="container">
    <div class="row-fluid">
      <div class="span12">
        <blockquote>
          <p class="testimonial">Working with Agency has been a refreshing experience. They listened to our needs and came up with a great solution.</p>
          <p class="name">Sarfraz Shoukat, <b>Owner - Greepit.com</b></p>
        </blockquote>
      </div>
    </div>
    <hr class="soften1">
    <div class="row-fluid">
      <div class="span3">
        <h4>Navigation</h4>
        <ul class="footer-links">
          <li><a href="#">Home</a></li>
          <li><a href="#">Work</a></li>
          <li><a href="#">Elements</a></li>
          <li><a href="#">Contact</a></li>
          <li><a href="#">Blog</a></li>
        </ul>
      </div>
      <div class="span3 MT70">
        <h4>Useful Links</h4>
        <ul class="footer-links">
          <li><a href="#">eGrappler.com</a></li>
          <li><a href="#">Greepit.com</a></li>
          <li><a href="#">WordPress.com</a></li>
          <li><a href="#">ThemeForest.net</a></li>
          <li><a href="#">Free Vector Icons</a></li>
        </ul>
      </div>
      <div class="span3 MT70">
        <h4>Something from Flickr</h4>
        <div id="flickr-wrapper"> 
          <script type="text/javascript" src="http://www.flickr.com/badge_code_v2.gne?count=8&amp;display=latest&amp;size=s&amp;layout=x&amp;source=user&amp;user=10133335@N08"></script> 
        </div>
      </div>
      <div class="span3 MT70">
        <h4>Who We Are</h4>
        <p>We are a creative production studio specialising in all things digital. Find us, connect & collaborate.</p>
        <ul class="footer_social clearfix">
          <li><a href="#" class="footer_facebook">Facebook</a></li>
          <li><a href="#" class="footer_twitter">Twitter</a></li>
          <li><a href="#" class="footer_googleplus">Google+</a></li>
          <li><a href="#" class="footer_rss">RSS</a></li>
        </ul>
      </div>
    </div>
    <hr class="soften1 copyhr">
    <div class="row-fluid copyright">
      <div class="span12">Copyright &copy; 2012. Greepit.com</div>
    </div>
  </div>
</footer>
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