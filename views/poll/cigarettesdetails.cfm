<cfoutput>
	<table class="pollTable">
		<thead>
			<tr>
				<th>Index</th>
				<th>Nazwa</th>
			</tr>
		</thead>
		<tbody>
			<cfloop query="cigarettes">
				<cfif ArrayFind(cigtab, SYMKAR) gt 0>
					<tr>
						<td>#SYMKAR#</td>
						<td>#OPIKAR1#</td>
					</tr>
				</cfif>
			</cfloop>
		</tbody>
	</table>
</cfoutput>