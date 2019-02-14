<cfprocessingdirective pageencoding="utf-8" />

<cfdiv id="formularz_odwolania_aos">
<div class="new_material_description">
	
	<span class="close_curtain">[zamknij]</span>

	<h5>Formularz odwołania</h5>
	
	<cfif IsDefined("komunikat") or IsDefined("zgloszenieOdwolania")>
		<span class="message">
			Twoje odwołanie zostało zapisane. Proszę oczekiwać na jego rozpatrzenie.
		</span>
	</cfif>
	
	<cfif not IsDefined("komunikat") and not IsDefined("zgloszenieOdwolania")>
		
	<cfform name="eleader_aos_formularz_odwolania"
		action="#URLFor(controller='eleader',action='dodajOdwolanie')#"
		onsubmit="javascript:$('##trescodwolania').val(CKEDITOR.instances['trescodwolania'].getData())">
			
		<cfinput type="hidden" name="idaktywnosci" value="#parametryFormularza.idaktywnosci#" />
		<cfinput type="hidden" name="iddefinicjizadania" value="#parametryFormularza.iddefinicjizadania#" />
		<cfinput type="hidden" name="iddefinicjipola" value="#parametryFormularza.iddefinicjipola#" />
		<cfinput type="hidden" name="kodsklepu" value="#parametryFormularza.kodsklepu#" />
		<cfinput type="hidden" name="userid" value="#session.user.id#" />
		
		<ol class="vertical">
			<li>
				<label for="trescodwolania">Treść odwołania</label>
				<cftextarea name="trescodwolania" class="ckeditor"></cftextarea>
			</li>
			<li>
				<cfinput type="submit" name="eleader_aos_formularz_odwolania_submit" class="admin_button green_admin_button" value="Zapisz" />
			</li>
		</ol>
	
	</cfform>
	
		<cfset ajaxOnLoad("formularzOdwolania") />
	<cfelse>
		<cfset ajaxOnLoad("zamykanieOkna") />
	</cfif>
	

</div>
</cfdiv>