<cfoutput>

	<div class="wrapper">
	
		<h3>Lista dokumentów</h3>
		
		<div class="wrapper">
			<table class=" flexigrid" id="documentsTable">
				<thead>
					<tr>
						<th width="25">ID</th>
						<th width="300">Nazwa</th>
						<th width="75">Numer faktury</th>
						<th width="75">Data dodania</th>
						<th width="100">Data wystawienia</th>
						<th width="100">Status</th>
						<th width="100">Dekret dokumentu</th>
					</tr>
				</thead>
				<tbody>
					<cfset index = 0>
					<cfloop collection="#documents#" item="i">
						<tr>
							<td>#documents[index].documentid#</td>
							<td>
								#linkTo(
									text=documents[index].documentname,
									controller="Documents",
									action="view",
									key=documents[index].documentid,
									title="Podgląd dokumentu",
									class="documentPreview {id:#documents[index].documentid#}")#
							</td>
							<td>#documents[index]["Numer faktury"]#</td>
							<td>#DateFormat(documents[index].documentcreated, "dd/mm/yy")#</td>
							<td>#DateFormat(documents[index]["Data wystawienia"], "dd/mm/yy")#</td>
							<td></td>
							<td></td>
						</tr>
					<cfset index++>
					</cfloop>
				</tbody>
			</table>
			
			<div class="documentsPagination">
			#paginationLinks()#
			</div>
			
			<div class="wrapper documentPreviewArea">
			</div>
		</div>
	</div>

</cfoutput>

<script type="text/javascript">
$(function () {
	$('.flexigrid').flexigrid({
		height:'auto',
		striped:false,
		width:'auto',
		searchitems : [
			{display: 'Nazwa', name : 'Nazwa'}],
		resizable:false
	});
	
	$('.documentPreview').live('click', function (e) {
		e.preventDefault();
	});
})
</script>