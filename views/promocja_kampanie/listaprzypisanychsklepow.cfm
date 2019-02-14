<cfprocessingdirective pageencoding="utf-8" />

<cfdiv id="refreshRightForm">

<h5>Przypisane sklepy</h5>

<div class="">
	<cfform name="listaPrzypisanychSklepowForm" action="index.cfm?controller=promocja_kampanie&action=usun-sklep-z-kampanii&idKampanii=#URL.idKampanii#">
	<ol class="tagsCloud">
		<cfoutput query="listaPrzypisanychSklepow">
			<li class="singleTag"><span class="">#kodSklepu# <cfinput type="checkbox" name="usunSklepZKampanii" value="#kodSklepu#" /></span></li>
		</cfoutput>
	</ol>
	
	<cfinput type="submit" class="btn" value="Usuń" name="listaPrzypisanychSklepowFormSubmit" />
	<a href="javascript:ColdFusion.navigate('index.cfm?controller=promocja_kampanie&action=lista-przypisanych-sklepow&idKampanii=<cfoutput>#URL.idKampanii#</cfoutput>', 'paginacjaListyPrzypisanychSklepow')" title="Odśwież listę przypisanych sklepów" class="btn">Odśwież</a>
	[<a href="javascript:void(0)" class="" title="Zaznacz wszystkie" onClick="initSelectToRemoveShops()" id="usunWszystkieKodySklepow">Zaznacz wszystkie</a>]
	</cfform>
</div>

</cfdiv>