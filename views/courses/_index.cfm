			<cfoutput>
				<cfloop query="curses">
					<tr>
						<td>#id#</td>
						<td>#DateFormat(datefrom, "yyyy-mm-dd")#</td>
						<td>#DateFormat(dateto, "yyyy-mm-dd")#</td>
						<td>#place#</td>
						<td>#Right(coursetype['name'][typeid], Len(coursetype['name'][typeid])-10)#</td>
						<td>#students#</td>
						<td>
							#linkTo(
								text=imageTag("view.png"),
								controller="Courses",
								action="view",
								key=id)#
						</td>
					</tr>
				</cfloop>
				
				<!---<cfif session.user.id eq 345>
				
				<tr>
					<td colspan="6">#curses.getMetaData().getExtendedMetaData().sql#</td>
				</tr>
				<tr>
					<td colspan="6">#params.order#</td>
				</tr>
				
				</cfif>--->
			</cfoutput>
			
			<!---<cfdump var="#curses.getMetaData().getExtendedMetaData().sqlparameters#">--->