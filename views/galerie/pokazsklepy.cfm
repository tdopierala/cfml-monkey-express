<cfdirectory action="list" directory="/home/admin/galeria/swieta" name="galeria" />
<cfoutput query="galeria">
	<a href="javascript:ColdFusion.navigate('index.cfm?controller=galerie&action=podglad-katalogu&katalog=#NAME#', 'swieta2014')" class="folder-icon" title="Zobacz zdjcia sklepu #NAME#">
		<span>#NAME#</span>
	</a>
</cfoutput>