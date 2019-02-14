<cfoutput>
	
<h4 class="useractiveworkflows">Aktywne dokumenty<span class="userelementcount">(<span>#myworkflow.RecordCount#</span>)</span> <span class="showhideuserworkflows">pokaż/ukryj</span></h4>
<div id="userworkflow" class="userworkflowtable">
						
	
	<table class="newtables">
		<thead>
			<tr class="top">
				<th colspan="5" class="bottomBorder">&nbsp;</th>
			</tr>
		</thead>
		
		<tbody>
			<cfloop query="myworkflow">
				<tr>
					<td class="bottomBorder cbk">&nbsp;</td>
					<td class="bottomBorder newsimg">
						<cfif DateFormat(workflowcreated, "dd.mm") eq DateFormat(Now(), "dd.mm")>
							<span class="newworkflow">&nbsp;</span>
						<cfelse>
							&nbsp;
						</cfif>
					</td>
					<td class="bottomBorder">
						#linkTo(
							text=documentname,
							controller="Workflows",
							action="userStep",
							key=workflowid,
							title=documentname)#
					</td>
					<td class="bottomBorder">
						#linkTo(
							text=contractorname,
							controller="Search",
							action="find",
							params="search=#URLEncodedFormat(contractorname)#&searchdocuments=1")#
					</td>
					<td class="bottomBorder">
						#DateFormat(workflowcreated, "dd/mm/yyyy")#
					</td>
				</tr>
			</cfloop>
		</tbody>
	</table>
</div>
</cfoutput>