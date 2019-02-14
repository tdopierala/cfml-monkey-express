<cfoutput>
	
	<div class="wrapper">
		<div class="admin_wrapper">
			
			<h2 class="admin_reports">Lista raportów</h2>
			
			<table class="admin_table">
				<thead>
					<tr>
						<th class="first">&nbsp;</th>
						<th>Nazwa etapu</th>
						<th>Liczba raportów</th>
					</tr>
				</thead>
				<tbody>
					<cfloop query="mysteps">
						<tr>
							<td class="first">
								#linkTo(
									text="<span>pobierz raporty dla etapu</span>",
									controller="Place_reports",
									action="getStepReports",
									key=id,
									class="expand_step_forms")#
							</td>
							<td>#stepname#</td>
							<td>#reportcount#</td>
						</tr>
					</cfloop>
				</tbody>
			</table>
			
			<!---
				Nowy raport
			--->
			
			<h2 class="admin_reports">Dodaj nowy raport</h2>
			
			<cfform
				action="#URLFor(controller='Place_reports',action='addReport')#" >
					
			<table class="admin_table">
				<thead>
					<tr>
						<th class="first">&nbsp;</th>
						<th>Nazwa pola</th>
						<th>Wartość pola</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td class="first">&nbsp;</td>
						<td>Nazwa raportu</td>
						<td>
							<cfinput
								type="text" 
								name="reportname"
								class="input" />
						</td>
					</tr>
				</tbody>
				<tfoot>
					<tr>
						<td colspan="3" class="r">
							<cfinput 
								name="submitaddreport"
								type="submit"
								class="admin_button green_admin_button"
								value="Zapisz" />
						</td>
					</tr>
				</tfoot>
			</table>
			
			</cfform>
			
			<!---
				Przypisanie raportu do etapu
			--->
			
			<h2 class="admin_reports">Przypisz raport do etapu</h2>
			
			<cfform
				action="#URLFor(controller='Place_reports',action='addReportToStep')#" >
			
			<table class="admin_table">
				<thead>
					<tr>
						<th class="first">&nbsp;</th>
						<th>Nazwa pola</th>
						<th>Wartość pola</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td class="first">&nbsp;</td>
						<td>Nazwa etapu</td>
						<td>
							<cfselect
								name="stepid"
								query="mysteps"
								display="stepname"
								value="id"
								class="selectbox" >
							
							</cfselect>	
						</td>
					</tr>
					<tr>
						<td class="first">&nbsp;</td>
						<td>Nazwa raportu</td>
						<td>
							<cfselect
								name="reportid"
								query="myreports"
								display="reportname"
								value="reportid"
								class="selectbox" >
									
							</cfselect>
						</td>
					</tr>
				</tbody>
				<tfoot>
					<tr>
						<td colspan="3" class="r">
							<cfinput
								type="submit" 
								name="submitreporttostep"
								class="admin_button green_admin_button"
								value="Zapisz" /> 
						</td>
					</tr>
				</tfoot>
			</table>
			
			</cfform>
			
			<!--- 
				Przypisanie grupy do raportu
			--->
			
			<h2 class="admin_report">Przypisz grupę do raportu</h2>
			
			<cfform 
				action="#URLFor(controller='Place_reports',action='addGroupToReport')#">
			
			<table class="admin_table">
				<thead>
					<tr>
						<th class="first">&nbsp;</th>
						<th>Nazwa pola</th>
						<th>Wartość pola</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td class="first">&nbsp;</td>
						<td>Nazwa grupy</td>
						<td>
							<cfselect 
								name="groupid"
								query="mygroups"
								display="groupname"
								value="groupid"
								class="selectbox" >
									
							</cfselect>
						</td>
					</tr>
					<tr>
						<td class="first">&nbsp;</td>
						<td>Nazwa raportu</td>
						<td>
							<cfselect
								name="reportid"
								query="myreports"
								display="reportname"
								value="reportid"
								class="selectbox" >
									
							</cfselect>
						</td>
					</tr>
				</tbody>
				<tfoot>
					<tr>
						<td colspan="3" class="r">
							<cfinput
								type="submit" 
								name="submitgrouptoreport"
								value="Zapisz"
								class="admin_button green_admin_button" /> 
						</td>
					</tr>
				</tfoot>
			</table>
			
			</cfform>
			
			<!---
				Lista grup pól
			--->
			
			<h2 class="admin_reports">Grupy pól</h2>
			<table class="admin_table">
				<thead>
					<tr>
						<th class="first">&nbsp;</th>
						<th>Nazwa grupy</th>
						<th>Liczba pól</th>
					</tr>
				</thead>
				<tbody>
					<cfloop query="mygroups">
						<tr>
							<td class="first">
								
								#linkTo(
									text="<span>pobierz pola grup</span>",
									controller="Place_reports",
									action="getGroupFields",
									key=groupid,
									class="expand_step_forms")#
								
							</td>
							<td>#groupname#</td>
							<td>#fieldcount#</td>
						</tr>
					</cfloop>
				</tbody>
			</table>
			
			<!---
				Nowa grupa pól
			--->
			
			<h2 class="admin_report">Nowa grupa pól</h2>
			
			<cfform
				action="#URLFor(controller='Place_reports',action='addGroup')#" >
					
			<table class="admin_table">
				<thead>
					<tr>
						<th class="first">&nbsp;</th>
						<th>Nazwa pola</th>
						<th>Wartość pola</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td class="first">&nbsp</td>
						<td>Nazwa grupy</td>
						<td>
							
							<cfinput 
								name="groupname"
								type="text"
								class="input" />
							
						</td>	
					</tr>
				</tbody>
				<tfoot>
					<tr>
						<td colspan="3" class="r">
							<cfinput 
								name="sugmitgroup"
								type="submit"
								value="Dodaj grupę"
								class="admin_button green_admin_button" />
						</td>
					</tr>
				</tfoot>
			</table>
			
			</cfform>
			
		</div>
	</div>
	
</cfoutput>

<script>
$(function() {
	$('.expand_step_forms').live('click', function(e) {
		e.preventDefault();
		$("#flashMessages").show();
		
		var _link		=	$(this);
		var _point		=	$(this).parent().parent();
		$.ajax({
			type		:		'get',
			dataType	:		'html',
			url			:		$(this).attr('href'),
			success		:		function(data) {
				_link.removeClass('expand_step_forms').addClass('collapse_step_forms');
				_point.after(data);
				$("#flashMessages").hide();
			}
		});
	});
	
	$('.collapse_step_forms').live('click', function(e) {
		e.preventDefault();
		
		var _link		=	$(this);
		var _point		=	$(this).parent().parent();
		
		_point.next().remove();
		_link.removeClass('collapse_step_forms').addClass('expand_step_forms');
	});
	
	$('.reportfieldaccess').live('click', function(e) {
		$.ajax({
			type		:		'post',
			dataType	:		'html',
			data		:		{key:$(this).metadata().id},
			url			:		"<cfoutput>#URLFor(controller="Place_reports",action='updateGroupFieldAccess')#</cfoutput>",
			success		:		function(data) {
			}
		});
	});
	
	$('.defaultreport').live('click', function(e){
		$.ajax({
			type		:		'post',
			dataType	:		'html',
			data		:		{id:$(this).metadata().id},
			url			:		"<cfoutput>#URLFor(controller="Place_reports",action='defaultReport')#</cfoutput>",
			success		:		function(data) {
			}
		})
	});
});
</script>