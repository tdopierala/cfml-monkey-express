<cfoutput>
	
	<div class="wrapper" style="width:600px;">
		<div class="admin_wrapper">
			<table class="admin_table">
				<thead>
					<tr>
						<th class="first">&nbsp;</th>
						<th colspan="2">Dane lokalu</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>&nbsp;</td>
						<td>Ulica</td>
						<td>
							<cfif not StructIsEmpty(myinstance)>
								#myinstance.street#
							<cfelse>
								&bnsp;	
							</cfif>
							
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td>Nr domu</td>
						<td>
							<cfif not StructIsEmpty(myinstance)>
								#myinstance.streetnumber#
							<cfelse>
								&nbsp;
							</cfif>
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td>Miasto</td>
						<td>
							<cfif not StructIsEmpty(myinstance)>
								#myinstance.city#
							<cfelse>
								&nbsp;
							</cfif>
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td>Kod pocztowy</td>
						<td>
							<cfif not StructIsEmpty(myinstance)>
								#myinstance.postalcode#
							<cfelse>
								&nbsp;
							</cfif>
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td>Dodane przez</td>
						<td>
							<cfif not StructIsEmpty(myinstance)>
								#myinstance.givenname# #myinstance.sn#<br/><span class="i">#myinstance.position#</span>
							<cfelse>
								&nbsp;
							</cfif>
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td>Status</td>
						<td>
							<cfif not StructIsEmpty(mystatus)>
								#mystatus.statusname#
							<cfelse>
								&nbsp;
							</cfif>
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td>Powód</td>
						<td>
							<cfif not StructIsEmpty(myreason)>
								#myreason.reasonname#
							<cfelse>
								&nbsp;
							</cfif>
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td>Komentarz</td>
						<td>
							<cfif not StructIsEmpty(myinstance)>
								#myinstance.rejectnote#
							<cfelse>
								&nbsp;
							</cfif>
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td>Odrzucono przez</td>
						<td>
							<cfif isStruct(myuser) or myuser>
								#myuser.givenname# #myuser.sn#
							<cfelse>
								&nbsp;
							</cfif>
						</td>
						
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td>Data odrzucenia</td>
						<td>
							<cfif not StructIsEmpty(myinstance)>
								#imageTag(source="clock.png",alt="Data i godzina")# #DateFormat(myinstance.rejectdatetime, "yyyy-mm-dd")# #TimeFormat(myinstance.rejectdatetime, "HH:mm")#
							<cfelse>
								&nbsp;
							</cfif>
						</td>
					</tr>
				</tbody>
			</table>
			
		</div>
	</div>
	
</cfoutput>