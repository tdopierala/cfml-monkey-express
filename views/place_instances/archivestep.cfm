<cfoutput>

	<div class="wrapper">
		
		<div class="admin_wrapper">
			
			<h2 class="admin_changestatus">Zmiana statusu: #myinstance.street# #myinstance.streetnumber#, #myinstance.postalcode# #myinstance.city#</h2>
			
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
						<td>#myinstance.street#</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td>Nr domu</td>
						<td>#myinstance.streetnumber#</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td>Miasto</td>
						<td>#myinstance.city#</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td>Kod pocztowy</td>
						<td>#myinstance.postalcode#</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td>Dodane przez</td>
						<td>#myinstance.givenname# #myinstance.sn#<br/><span class="i">#myinstance.position#</span></td>
					</tr>
				</tbody>
			</table>
			
			<div class="admin_submenu_options">
				
				<cfform
					action="#URLFor(controller='Place_instances',action="actionArchiveStep")#" >
					
					<cfinput
						type="hidden"
						name="instanceid"
						value="#myworkflow.instanceid#" />
					
					<cfinput
						type="hidden"
						name="stepid"
						value="#myworkflow.stepid#" />
					
					<cfinput
						type="hidden" 
						name="key"
						value="#myworkflow.id#" />
					
					<table class="admin_table">
						<thead>
							<tr>
								<th class="first">&nbsp;</th>
								<th colspan="2">Informacje do etapu</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td class="first">&nbsp;</td>
								<td>Powód przeniesienia do archiwum</td>
								<td>
									<cfselect
										name="instancereasonid"
										query="myreasons"
										value="id"
										display="reasonname"
										class="selectbox"
										queryPosition="below" >
									
										<option value="0"></option>
										
									</cfselect>
									
								</td>
							</tr>
							<tr>
								<td class="first">&nbsp;</td>
								<td>Twoja notatka</td>
								<td>
									
									<cftextarea 
										name="workflownote"
										class="textarea" />
									
								</td>
							</tr>
						</tbody>
						<tfoot>
							<tr>
								<td colspan="3" class="r">
									
									<cfinput
										name="submit"
										type="submit"
										class="admin_button red_admin_button"
										value="Do archiwum" />
										
								</td>
							</tr>
						</tfoot>
					</table>
				
				</cfform>
				
			</div>
			
		</div>
		
	</div>
	
</cfoutput>