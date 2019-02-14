<cfprocessingdirective pageencoding="utf-8" />
	
<div class="wrapper">

	<div class="admin_wrapper">
		<h2 class="admin_assign">Nieruchomości z formularza na stronie</h2>
		
		<div class="tree_group_admin">
			<div class="inner">
				<ul class="pzwr_admin_nav">
					<li>
						<a href="javascript:void(0)" class="place_options place_connect_fields" onclick="javascript:showCFWindow('placeConnectFields', 'Skojarz formularze', <cfoutput>'#URLFor(controller='Place_pzwr',action='assignFields')#'</cfoutput>, 500, 750);">
							<span>Skojarz formularze</span>
						</a>
					</li>
					<!---<li>
						<a href="<cfoutput>#URLFor(controller='Place_pzwr',action='importPlaces')#</cfoutput>" class="place_options place_import_elements" title="Importuj nieruchomości do obiegu">
							<span>Importuj nieruchomości do obiegu</span>
						</a>
					</li>--->
					<li>
						<a href="javascript:void(0)" class="place_options place_import_elements" title="Importuj zaznaczone nieruchomości">
							<span>Importuj zaznaczone nieruchomości</span>
						</a>
					</li>
					<li>
						<a href="<cfoutput>#URLFor(controller='Place_pzwr',action='getFromInternet')#</cfoutput>" class="place_options place_import_from_internet_elements" title="Importuj nieruchomości z Internetu">
							<span>Importuj nieruchomości z Internetu</span>
						</a>
					</li>

				</ul>
			</div>
		</div>
		
		<div class="tree_group_admin place_tree_privileges">
			<div class="inner">
				<table class="admin_table"><cfoutput>
					<thead>
						<tr>
							<th class="first">&nbsp;</th>
							<th class="c">Imię i nazwisko</th>
							<th class="c">Telefon</th>
							<th class="c">Email</th>
							<th class="c">Województwo</th>
							<th class="c">Miejscowość</th>
							<th class="c">Kod pocz.</th>
							<th class="c">Ulica i nr</th>
						</tr>
					</thead>
					<tbody>
						<cfset index = 1 />
						<cfloop query="places">
							<tr>
								<td class="first c">
									<input 
										type="checkbox"
										name="pzwr-#id#"
										value="#id#" />
								</td>
								<td>#imie_nazwisko#</td>
								<td>#telefon#</td>
								<td>#email#</td>
								<td>#wojewodztwo#</td>
								<td>#miejscowosc#</td>
								<td>#kod_pocztowy#</td>
								<td>#ulica# #nr#</td>
							</tr>
							<cfset index = index + 1 />
						</cfloop>
					</tbody>
				</cfoutput></table>
			</div>
		</div>
		
		
	</div>

</div>

<script>
$(function(){
	$('.place_import_elements').on('click', function(e){
		$('table tbody input[type=checkbox]:checked').each(function(){
			var thisChckbx = $(this);
			$('#flashMessages').show();
			$.ajax({
				data		: {key:thisChckbx.val()},
				dataType	: 'json',
				type		: 'post',
				url			: 'index.cfm?controller=place_pzwr&action=import-single-place',
				async		: false,
				success		: function(result){
					thisChckbx.parent().parent().remove();
					$('#flashMessages').hide();
				}
			});
		});
	});
});
</script>