<cfoutput>

<div class="wrapper">

	<h3>Historia dokumentu</h3>
	
	<div class="wrapper">
		
		<cfoutput>#includePartial(partial="/workflows/subnav")#</cfoutput>
	
	</div>
	
	<div class="wrapper">
	
		<table id="workflowDocumentHistoryTable" class="tables">
			<thead>
				<tr>
					<th class="c">Krok</th>
					<th class="c">Data otrzymania</th>
					<th class="c">Data przekazania</th>
					<th class="c">Osoba</th>
					<th class="c">Status</th>
					<th class="c">Komentarz</th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="workflowhistory">
					<tr>
						<td class="leftBorder bottomBorder">#workflowstepstatusname#</td>
						<td class="leftBorder bottomBorder">#DateFormat(workflowstepcreated, "dd/mm/yyyy")# #TimeFormat(workflowstepcreated, "HH:mm")#</td>
						<td class="leftBorder bottomBorder">
							<cfif Len(workflowstepended)>
								#DateFormat(workflowstepended, "dd/mm/yyyy")# #TimeFormat(workflowstepended, "HH:mm")#
							<cfelse>
							&nbsp;
							</cfif>
							</td>
						<td class="leftBorder bottomBorder">#givenname# #sn#</td>
						<td class="leftBorder bottomBorder">#workflowstatusname#</td>
						<td class="leftBorder bottomBorder rightBorder">
							<cfif Len(workflowsteptransfernote)>
								#workflowsteptransfernote#
							<cfelse>
								&nbsp;
							</cfif>
						</td>
					</tr>
				</cfloop>
			</tbody>
			<tfoot>
				<tr>
					<td colspan="6"></td>
				</tr>
			</tfoot>
		</table>
		
	</div>

</div>

</cfoutput>