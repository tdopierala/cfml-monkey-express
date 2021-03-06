<cfoutput>

	<div class="wrapper">
	
		<h4>Podgląd lokalizacji</h4>
		
		<table class="table-basic">
			<thead>
				<tr>
					<th class="c bottomBorder" style="width:20%">PARTNER</th>
					<th class="c bottomBorder leftBorder" style="width:20%">WERYFIKACJA</th>
					<th class="c bottomBorder leftBorder" style="width:20%">UZUPEŁNIENIE DANYCH</th>
					<th class="c bottomBorder leftBorder" style="width:20%">KOMITET</th>
					<th class="c bottomBorder leftBorder" style="width:20%">UMOWA</th>
				</tr>
			</thead>
			
			<tbody>
				<tr>
					<td class="c">
					
						<cfif Len(workflow.step1status) AND workflow.step1status eq 2>
						
							#imageTag(source="yes.png",title="Etap zaakceptowany")#
						
						<cfelseif workflow.step1status eq 3>
						
							#imageTag(source="no.png",title="Etap odrzucony")#
						
						<cfelseif workflow.step1status eq 1>
						
							#imageTag(source="progress-bar.png",title="W trakcie")#
						
						</cfif>
						
					</td>
					
					<td class="c leftBorder">
					
						<cfif Len(workflow.step2status) AND workflow.step2status eq 2>
						
							#imageTag(source="yes.png",title="Etap zaakceptowany")#
						
						<cfelseif workflow.step2status eq 3>
						
							#imageTag(source="no.png",title="Etap odrzucony")#
						
						<cfelseif workflow.step2status eq 1>
						
							#imageTag(source="progress-bar.png",title="W trakcie")#
						
						</cfif>
						
					</td>
					
					<td class="c leftBorder">
					
						<cfif Len(workflow.step3status) AND workflow.step3status eq 2>
						
							#imageTag(source="yes.png",title="Etap zaakceptowany")#
						
						<cfelseif workflow.step3status eq 3>
						
							#imageTag(source="no.png",title="Etap odrzucony")#
						
						<cfelseif workflow.step3status eq 1>
						
							#imageTag(source="progress-bar.png",title="W trakcie")#
						
						</cfif>
						
					</td>
					
					<td class="c leftBorder">
					
						<cfif Len(workflow.step4status) AND workflow.step4status eq 2>
						
							#imageTag(source="yes.png",title="Etap zaakceptowany")#
						
						<cfelseif workflow.step4status eq 3>
						
							#imageTag(source="no.png",title="Etap odrzucony")#
						
						<cfelseif workflow.step4status eq 1>
						
							#imageTag(source="progress-bar.png",title="W trakcie")#
						
						</cfif>
						
					</td>
					
					<td class="c leftBorder">
					
						<cfif Len(workflow.step5status) AND workflow.step5status eq 2>
						
							#imageTag(source="yes.png",title="Etap zaakceptowany")#
						
						<cfelseif workflow.step5status eq 3>
						
							#imageTag(source="no.png",title="Etap odrzucony")#
						
						<cfelseif workflow.step5status eq 1>
						
							#imageTag(source="progress-bar.png",title="W trakcie")#
						
						</cfif>
						
					</td>
				</tr>
				<tr>
					<td class="c">#DateFormat(workflow.step1datetime, "dd-mm-yyyy")# #TimeFormat(workflow.step1datetime, "HH:mm")#</td>
					<td class="c leftBorder">#DateFormat(workflow.step2datetime, "dd-mm-yyyy")# #TimeFormat(workflow.step2datetime, "HH:mm")#</td>
					<td class="c leftBorder">#DateFormat(workflow.step3datetime, "dd-mm-yyyy")# #TimeFormat(workflow.step3datetime, "HH:mm")#</td>
					<td class="c leftBorder">#DateFormat(workflow.step4datetime, "dd-mm-yyyy")# #TimeFormat(workflow.step4datetime, "HH:mm")#</td>
					<td class="c leftBorder">#DateFormat(workflow.step5datetime, "dd-mm-yyyy")# #TimeFormat(workflow.step5datetime, "HH:mm")#</td>
				</tr>
			</tbody>
		</table>
	
	</div>
	
	<div class="wrapper">
	
		<h4>Historia zmian</h4>
		
		<dl class="workflow">
		
			<dt class="header">Osoba</dt>
			<dd class="header">Etap</dd>
			<dd class="header">Status</dd>
			<dd class="header">Data</dd>
			
			<cfloop query="placeworkflow">
				<dt>#givenname# #sn#</dt>
				<dd>#placestepname#</dd>
				<dd>#placestatusname#</dd>
				<dd>#DateFormat(placeworkflowstart, 'dd.mm.yyyy')# #TimeFormat(placeworkflowstart, 'HH:mm')#</dd>
				
				<cfif Len(placeworkflowstop)>
				
					<dt>#newgivenname# #newsn# </dt>
					<dd>#placestepname#</dd>
					<dd>#newplacestatusname#</dd>
					<dd>#DateFormat(placeworkflowstop, 'dd.mm.yyyy')# #TimeFormat(placeworkflowstop, 'HH:mm')#</dd>
				
				</cfif>
			</cfloop>
		</dl>
		
	</div>

</cfoutput>