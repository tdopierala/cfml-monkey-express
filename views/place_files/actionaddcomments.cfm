<cfoutput>

	<tr>
		<td class="first">&nbsp;</td>
		<td>#mycomment.comment#</td>
		<td>#imageTag(source="clock.png",alt="Data i godzina")# #DateFormat(mycomment.commentcreated, "yyyy-mm-dd")# #TimeFormat(mycomment.commentcreated, "HH:mm")#</td>
		<td>#myuser.givenname# #myuser.sn#<br/><span class="i">#myuser.position#</span></td>
	</tr>

</cfoutput>