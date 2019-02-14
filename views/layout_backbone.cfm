<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
	
<cfparam name="title" type="string" />

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<title><cfoutput>#title#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<cfoutput>#styleSheetLinkTag("reset,style")#</cfoutput>
<!---<cfoutput>#javaScriptIncludeTag('ckeditor/ckeditor,ckeditor/adapters/jquery')#</cfoutput>--->
</head>
<body>
	<cfoutput>#includeContent()#</cfoutput>
</body>
</html>