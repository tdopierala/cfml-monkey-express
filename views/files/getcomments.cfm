<cfoutput>
	
	<table class="filecomments">
		<thead>
			<tr>
				<th class="c rightBorder">Użytkownik</th>
				<th class="c rightBorder">Data</th>
				<th class="c">Komentarz</th>
			</tr>
		</thead>
		
		<tbody>
		
			<cfloop query="comments">
	
				<tr>
					<td class="topBorder rightBorder">#givenname# #sn#</td>
					<td class="topBorder rightBorder">#DateFormat(filecommentdate, 'dd-m-yyyy')# godz. #TimeFormat(filecommentdate, 'HH:mm')#</td>
					<td class="topBorder">#filecommenttext#</td>
				</tr>
	
			</cfloop>
		
		</tbody>
	</table>
	
</cfoutput>