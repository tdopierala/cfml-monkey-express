<cfprocessingdirective pageEncoding="utf-8" />

<cfsilent>
	<cfinvoke
		component="controllers.Tree_groupusers"
		method="checkUserTreeGroup"
		returnvariable="privUsuniecieSklepu" >

		<cfinvokeargument name="groupname" value="Usunięcie sklepu" />

	</cfinvoke>
</cfsilent>

<div class="cfwindow_container">

	<table class="admin_table">
		<thead>
			<tr>
				<th class="first">&nbsp;</th>
				<th>Typ sklepu</th>
				<th>Projekt</th>
				<th>Adres</th>
				<th>Lokalizacja</th>
				<th>&nbsp;</th>
			</tr>
		</thead>
		<tbody>
			<cfloop query="myStores">
				<tr>
					<td>&nbsp;</td>
					<td><cfoutput>#store_type_name#</cfoutput></td>
					<td><cfoutput>#projekt#</cfoutput>
					<td><cfoutput>#adressklepu#</cfoutput></td>
					<td><cfoutput>#loc_mall_name#</cfoutput></td>
					<td>
						<cfif privUsuniecieSklepu is true>
						<a href="javascript:void(0);" title="Usuń sklep" onclick="removeShelfStore(<cfoutput>#id#</cfoutput>, $(this))" class="remove_shelf_store">
							<span>Usuń sklep</span>
						</a>
						<cfelse>
							&nbsp;
						</cfif>
					</td>
				</tr>
			</cfloop>
		</tbody>
	</table>

</div>


<script type="text/javascript">
$(function(){
	var len = $('script').filter(function () {
		return /^.*intranet\/javascripts\/bodyimport\/store_planograms.*/.test( $(this).attr('src') );
	}).length;
	
	if (len === 0) {
		$.getScript("javascripts/bodyimport/store_planograms.js");
	}
});
</script>