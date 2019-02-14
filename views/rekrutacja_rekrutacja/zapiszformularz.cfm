<cfform name="edytujFormularz" action="index.cfm?controller=rekrutacja_rekrutacja&action=zapisz-formularz">
	<cfinput type="hidden" name="idFormularza" value="#idFormularza#" />
	
	<ol class="horizontal_right">
		<cfoutput query="polaFormularza">
			<li>
				<cfswitch expression="#idTypuPola#">
					<cfcase value="1">
						<label for="idWartosciFormularza#idWartosciFormularza#">#nazwaPola#</label>
						<cfinput type="text" class="input" name="idWartosciFormularza-#idWartosciFormularza#" value="#polaFormularza.wartoscPolaFormularza#" />
					</cfcase>
				</cfswitch> 
			</li>
		</cfoutput>
		
		<li>
			<span class="labelBlock">&nbsp;</span>
			<cfinput name="edytujFormularz" type="submit" value="Zapisz" class="btn btn-green" />
		</li>
		
	</ol>
	
</cfform>
