<cfoutput>
<h4>Komunikaty<span class="userelementcount">(#mymessages.RecordCount#)</span> <span class="showhidemessages">pokaż/ukryj</span></h4>
<div class="usermessagestable">
	<table class="newtables">
		<thead>
			<tr class="top">
				<th colspan="5" class="bottomBorder singlemessageoptions">
					#linkTo(
						text="<span>Usuń komunikat</span>",
						controller="Messages",
						action="delete",
						class="deletemessage",
						title="Usuń zaznaczone komunikaty")#
					
					#linkTo(
						text="<span>Dodaj komunikat</span>",
						controller="Messages",
						action="add",
						class="addmessage ajaxlink",
						title="Dodaj nowy komunikat")#
				</th>
			</tr>
		</thead>
		<tbody>
			<cfloop query="mymessages">
				<tr class="<cfif usermessagereaded eq 0> unread </cfif>">
					<td class="c bottomBorder cbk">
						#checkBoxTag(name="messageid",value=id,label=false)#
					</td>
					<td class="bottomBorder newsimg">
						<cfif DateFormat(messagecreated, "dd.mm.yyyy") eq DateFormat(Now(), "dd.mm.yyyy")>
							<span class="newmessage">&nbsp;</span>
						<cfelse>
							&nbsp;
						</cfif>
					</td>
					<td class="c bottomBorder cbk">
						#prioritylabel#
					</td>
					<td class="bottomBorder">
						#linkTo(
							text=messagetitle,
							controller="Messages",
							action="view",
							key=messageid,
							class="ajaxlink",
							title=messagetitle)#
					</td>
					<td class="bottomBorder messageauthor">#givenname# #sn#</td>
				</tr>
			</cfloop>
		</tbody>
		<tfoot></tfoot>
	</table>
</div>
</cfoutput>