<cfheader statuscode="404" statustext="Not Found">

<!--- Place HTML here that should be displayed when a file is not found while running in "production" mode. --->

<?xml version=”1.0″ encoding=”UTF-8″?>
<!DOCTYPE html PUBLIC “-//W3C//DTD XHTML 1.0 Transitional//EN” “http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd”>
<html xmlns=”http://www.w3.org/1999/xhtml”>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<title><cfoutput>#arguments.exception.Cause.Message#</cfoutput></title>
		<link rel="stylesheet" type="text/css" href="stylesheets/style.css" media="screen" />
	</head>
	<body>
		<div id="container">
			<div id="header">
				<div class="width">	
					<h1 style="top: 0px;">
						<a class="monkey_intranet_logo" href="/" title="Twój profil"><img alt="Logo" height="100" src="/intranet/images/logo.png" width="100" /></a> 
					</h1>
				</div>
			</div>
			<div id="nav">
				<div class="width">	
					<ul class="">
					</ul>
				</div>
			</div>
			<div id="content">
				<div class="width">	
					<div class="wrapper" style="width:70%; margin: 0 auto;">
						
						<h3>Błąd aplikacji</h3>
						
						<div class="wrapper" style="text-align: center; ">
							<img src="images/destroy.png" class="access deny" />
							
							<div class="autherrorinfo" style="margin-top: 10px;padding-bottom: 40px;">
								
								<cfif IsDefined("error")>
									#error#
									
								<cfelse>
									
									System wykonał nieprawidłową operację.
								
								</cfif>
								<br/>
								W przypadku pytań prosimy o kontakt z <a href="mailot:informatyka@monkey.xyz" />Departamentem Informatyki</a>.
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</body>
</html>
