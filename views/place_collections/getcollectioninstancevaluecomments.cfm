<cfoutput>
	
	<tr>
		<td class="first">&nbsp;</td>
		<td colspan="3" class="admin_submenu_options">
			
			<table class="admin_table">
				<thead>
					<tr>
						<th class="first">&nbsp;</th>
						<th style="width:60%;">Komentarz</th>
						<th>Data dodania</th>
						<th>Użytkownik</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td colspan="4" class="field_comment_form">
							#startFormTag(controller="Place_collectioninstancevaluecomments",action="actionAdd",class="comments_form")#
							#hiddenFieldTag(name="instanceid",value=myinstance.instanceid)#
							#hiddenFieldTag(name="collectionid",value=myinstance.collectionid)#
							#hiddenFieldTag(name="collectioninstanceid",value=myinstance.collectioninstanceid)#
							#hiddenFieldTag(name="collectioninstancevalueid",value=myinstance.id)#
							<ol>
								<li>
									#textAreaTag(
										name="comment",
										class="textarea")#
								</li>
								<li>
									#submitTag(value="Zapisz",class="admin_button green_admin_button submit_comment_form")#
								</li>
							</ol>
							#endFormTag()#
						</td>
					</tr>
					<cfloop query="mycomments">
						<tr>
							<td class="first">&nbsp;</td>
							<td>#comment#</td>
							<td>#imageTag(source="clock.png",alt="Data i godzina")# #DateFormat(commentcreated, "yyyy-mm-dd")# #TimeFormat(commentcreated, "HH:mm")#</td>
							<td>#givenname# #sn#<br/><span class="i">#position#</span></td>
						</tr>
					</cfloop>
				</tbody>
			</table>
			
		</td>
	</tr>
	
</cfoutput>