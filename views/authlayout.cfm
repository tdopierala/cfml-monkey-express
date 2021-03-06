<cfparam
	name="title"
	type="string" />

<?xml version=”1.0″ encoding=”UTF-8″?>
<!DOCTYPE html PUBLIC “-//W3C//DTD XHTML 1.0 Transitional//EN” “http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd”>
<html xmlns=”http://www.w3.org/1999/xhtml”>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<cfoutput>#styleSheetLinkTag("reset,style")#</cfoutput>
		<cfoutput>#javaScriptIncludeTag("jquery-1.8.0.min")#</cfoutput>

		<!--- CKEditor --->
		<cfoutput>#javaScriptIncludeTag('ckeditor/ckeditor')#</cfoutput>

		<title><cfoutput>#title#</cfoutput></title>

	</head>
	<body>
		<div id="flashMessages" style="display: none;"><cfoutput>#imageTag('ajax-loader-1.gif')#</cfoutput>Pobieram dane…</div>
		<div id="container">
			<div id="nav" class="<cfif not structKeyExists(session, 'user') or not structKeyExists(session.user, 'id')>profile_login_container</cfif>">
				<div class="width">
					<cfoutput>#includePartial(partial="/nav")#</cfoutput>
				</div>
			</div>
			<div id="content">
				<div class="width">
					<cfoutput>#includeContent()#</cfoutput>
					<div class="clear"></div>
				</div>
			</div>
			<div id="footer">
				<div class="width">
					<cfinclude template="footer.cfm" >
				</div>
			</div>
		</div>
		<div id="modal"></div>
	</body>
</html>