<cfoutput>
		<cfloop query="licenses">
							
			<tr>
				<td>#id#</td>
				<td>obowiązuje</td>
				<td>#type#</td>
				<td>#documentnr#</td>
				<td>#projekt#</td>
				<td>#DateFormat(dateofissue, 'yyyy-mm-dd')#</td>
				<td>#DateFormat(datefrom, 'yyyy-mm-dd')#</td>
				<td>#DateFormat(dateto, 'yyyy-mm-dd')#</td>
			</tr>
						
		</cfloop>
</cfoutput>