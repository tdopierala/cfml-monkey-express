<style type="text/css" media="screen">
<!--
  @import url("stylesheets/pdf.css");

-->
</style>

<div class="wrapper pdf">

	<table class="placecommittee" cellpadding="0" cellspacing="0">
			
			<thead>
			
				<tr>
					<th colspan="2">
					
					<!--- Zawartość tabeli --->
					<cfloop collection="#r#" item="i">
					
						<cfset q = r[i] />
						<cfif q.recordCount>
						
							<cfloop query="q">
								
								<cfif attributeid eq 143>
									
									<cfoutput>#placeattributevaluetext#</cfoutput>
									
								</cfif>
														
							</cfloop>
						
						</cfif>
					
					</cfloop>
					
					</th>
				</tr>
				
				<tr>
					<th colspan="2">
					
					<!--- Zawartość tabeli --->
					<cfloop collection="#r#" item="i">
					
						<cfset q = r[i] />
						<cfif q.recordCount>
						
							<cfloop query="q">
								
								<cfif attributeid eq 144>
									
									<cfoutput>#placeattributevaluetext#</cfoutput>
									
								</cfif>
														
							</cfloop>
						
						</cfif>
					
					</cfloop>
					
					</th>
				</tr>
				
				<tr>
					<th>
						Data dodania nieruchomości
					</th>
					<th>
						<cfoutput>#place.placecreated#</cfoutput>
					</th>
				</tr>
			
			</thead>
		
			<tr>
				<td colspan="2">Opis nieruchomości</td>
			</tr>
			
			<!--- Zawartość tabeli --->
			<cfloop collection="#r#" item="i">
			
				<cfset q = r[i] />
				<cfif q.recordCount>
				

						<cfloop query="q">
						
							<tr>
								<td><cfoutput>#attributename#</cfoutput></td>
								<td><cfoutput>#placeattributevaluetext#</cfoutput></td>
							</tr>
						
						</cfloop>
				
				</cfif>
			
			</cfloop>
		
		</table>

</div> <!--- koniec wrapper dla ca?ego widoku --->
