<cfsilent>
	<cfinvoke
		component="controllers.Tree_groupusers"
		method="checkUserTreeGroup"
		returnvariable="usuwanieMaterialow" >

		<cfinvokeargument
			name="groupname"
			value="Usuwanie materiałów" />

	</cfinvoke>
</cfsilent>

<cfoutput>
	
	<div class="new_material_description">
		
		<span class="close_curtain">[zamknij]</span>
		
		<h5>Pliki</h5>
		
		<div class="scroll_materials">
		<table class="admin_table">
			<thead>
				<tr>
					<th class="first">&nbsp;</th>
					<th>Nazwa pliku</th>
					<th>Data dodania</th>
					<!---
						6.08.2013
						Możliwość usunięcia pliku
					--->
					<cfif usuwanieMaterialow is true>
						<th>&nbsp;</th>
					</cfif>
				</tr>
			</thead>
			<tbody>
				<cfloop query="my_files">
					<tr>
						<td class="first">&nbsp;</td>
						<td>
							#linkTo(
								text=filename,
								href="files/materials/#filesrc#",
								target="_blank",
								title="Pobierz plik")#
						</td>
						<td>#DateFormat(created, "dd-mm-yyyy")#</td>
						<cfif usuwanieMaterialow is true>
							<td>
								<a href="javascript:void(0)" onclick="remFile(#fileid#, $(this))" title="Usuń plik" class="remove_material_file">
									<span>Usuń plik</span>
								</a>
							</td>
						</cfif>
					</tr>
				</cfloop>
			</tbody>
		</table>
		</div>
		
	</div>
	
</cfoutput>

<script>
function remFile(Id, El)
{
	$('#flashMessages').show();
	$.ajax({
		type		:	'post',
		dataType	:	'json',
		data		:	{key:Id},
		url			:	'index.cfm?controller=material_materials&action=remove-file',
		async		:	false,
		success		:	function(result){
			El.parent().parent().fadeOut('800', function(){ $(this).remove(); })
			$('#flashMessages').hide();
		}
	});
}
</script>