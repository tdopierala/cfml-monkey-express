<cfoutput>
	
	<tr>
		<td class="first">&nbsp;</td>
		<td colspan="5" class="admin_submenu_options">
			
			<table class="admin_table">
				<thead>
					<tr>
						<th class="first">&nbsp;</th>
						<th style="width:60%;">Komentarz</th>
						<th>Data Dodania</th>
						<th>Użytkownik</th>
					</tr>
				</thead>
				<tbody>
						<tr>
							<td colspan="4" class="field_comment_form">
								
								#startFormTag(controller="Place_files",action="actionAddComments",class="comments_form")#
								#hiddenFieldTag(name="instanceid",value=myinstancefiletype.instanceid)#
								#hiddenFieldTag(name="instancefiletypeid",value=myinstancefiletype.id)#
								#hiddenFieldTag(name="filetypeid",value=myinstancefiletype.filetypeid)#
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
							<td class="first">&nbsp</td>
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