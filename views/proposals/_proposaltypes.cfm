<cfoutput>
	<div class="wrapper filter horizontal">
	
	<h5>Filtruj wnioski</h5>
	
		<div class="proposalfilterbox">
			#selectTag(
				name="proposalstatusid",
				options=proposalstatuses,
				selected=proposalstatusid,
				includeBlank=false,
				label="Status wniosku",
				labelPlacement="before",
				class="proposalstat")#
		</div>
			
		<div style="display:none;" id="type">#params.type#</div>
		
		<cfif params.type eq 1 or params.type eq 2 or params.type eq 3>
			
			<div class="proposalfilterbox">
				#textFieldTag(
					name="proposalusername",
					value=params.user,
					label="Imię i nazwisko",
					labelPlacement="before")#
			</div>
			
		<cfelse>
			
			<div class="proposalfilterbox" style="display:none;">
				#textFieldTag(
					name="proposalusername",
					value=params.user,
					label="Imię i nazwisko",
					labelPlacement="before")#
			</div>
			
		</cfif>
			
	</div>
</cfoutput>