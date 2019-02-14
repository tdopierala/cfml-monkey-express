<cfoutput>
	
	<tr>
		<td class="first">&nbsp;</td>
		<td colspan="3" class="admin_submenu_options">
			
			<table class="admin_table">
				<thead>
					<tr>
						<th class="first">&nbsp;</th>
						<th>Nazwa pola</th>
						<th>Wartość pola</th>
						<th>Komentarze</th>
					</tr>
				</thead>
				<tbody>
					<cfloop query="myinstance" >
						<tr>
							<td>&nbsp;</td>
							<td>#fieldname#</td>
							<td>
								
								<cfif fieldtypeid eq 7 and Len(fieldbinarythumb) and fileExists(ExpandPath("files/collections/#fieldbinarythumb#"))>
																		
									<cfimage 
										source="#ExpandPath('files/collections/#fieldbinarythumb#')#" 
										action="writeToBrowser" />
								
								<cfelse>
									
									#fieldvalue#
									
								</cfif>
								
							</td>
							<td>
								#linkTo(
								text="<span>Pobierz komentarze</span>",
								controller="Place_collections",
								action="getCollectionInstanceValueComments",
								key=id,
								class="place_comments show_comments")#
								(#commentscount#)
							</td>
						</tr>
					</cfloop>
				</tbody>
			</table>
			
		</td>
	</tr>
	
</cfoutput>