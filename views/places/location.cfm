<cfoutput>

	<div class="wrapper">
	
		<h5>Dane o lokalizacji</h5>
		
		#startFormTag()#
		
		<ol class="horizontal">
		
			<cfloop query="attributes">
			
				<li>
					
					#textFieldTag(
						name="placeattribute[#placeattributeid#]",
						class="input",
						label=attributename,
						labelPlacement="before")#
					
				</li>
				
			</cfloop>
		
		</ol>
		
		#endFormTag()#
	
	</div>

</cfoutput>