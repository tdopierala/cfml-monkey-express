<div class="wrapper courses">
	
	<h3>Dodawanie nowej lokalizacji</h3>
	<cfoutput>
		<form action="#URLFor(controller='Courses', action='locationAdd')#" method="post" id="location-form">
			
			<div class="wrapper formbox">
				<h4>Projekt</h4>
				
				<ol>
					<li class="text-field">
						#textFieldTag(name="loc_projekt", label="Nr projektu/sklepu", labelPlacement="before", class="input text-field-tag")#
					</li>
				</ol>
			</div>
			
			<div class="wrapper formbox">
				<h4>Lokalizacja</h4>
				
				<ol style="margin-bottom: 30px;">
					<li class="text-field">
						#textFieldTag(name="loc_search", label="Wyszukaj lokalizację", labelPlacement="before", class="input text-field-tag", placeholder="Miejscowość, Adres")#
					</li>					
				</ol>
				
				<ol>
					<li class="text-field">
						#hiddenFieldTag(name="loc_id")#
					</li>
					<li class="text-field">
						#textFieldTag(name="loc_city", label="Miejscowość", labelPlacement="before", class="input text-field-tag")#
					</li>
					<li class="text-field">
						#textFieldTag(name="loc_street", label="Ulica i numer", labelPlacement="before", class="input text-field-tag")#
					</li>
					<li class="text-field">
						#textFieldTag(name="loc_postcode", label="Kod pocztowy", labelPlacement="before", class="input text-field-tag")#
					</li>
				</ol>

			</div>
			
			<div class="wrapper formbox">
				<h4>Kandydat na PPS</h4>
				
				<ol>
					<li class="text-field">
						#textFieldTag(name="usr_search", label="Wyszukaj kandydata", labelPlacement="before", class="input text-field-tag", placeholder="Imię, nazwisko")#
					</li>
					<li class="text-field">
						#hiddenFieldTag(name="usr_id")#
					</li>
				</ol>
			</div>
			
			<div class="wrapper formbox">
				#submitTag(value="Zapisz", class="formButton button redButton")#
			</div>
		
		</form>
	</cfoutput>
</div>

<cfdump var="#FORM#" />
<script>
	$(function(){
		
		var t_timeout;
		
		var _loc_options = {
			source	:
				function( request, response ) {
					clearTimeout(t_timeout);
					
					t_timeout = setTimeout(function() {
										
						$.ajax({
							url			: <cfoutput>"#URLFor(controller='Place_instances',action='searchplace')#"</cfoutput> + "&q=" + request.term,
							type		: "get",
							dataType	: "json",
							success		: function(data) {
								
								console.log(data);
								
								response( $.map( data.DATA, function(item) {
									
									if(!isNaN(parseFloat(item[4])) && isFinite(item[4]) && item[4]>0) 
										streetnbr = item[3] + "/" + item[4];
									else
										streetnbr = item[3];
										
									return {
										label: item[1] + ", " + item[2] + " " + streetnbr + ", " + item[5],
										value: item[1] + ", " + item[2],
										id: item[0],
										loc_city: item[1],
										loc_street: item[2] + " " + streetnbr,
										loc_postcode: item[5]
									}
								}));
							},
							error		: function(jqxhr, status, error){
								console.log(jqxhr);
								console.log(status);
								console.log(error);								
							}
						});
					}, 500);
				}
			,minLength: 3
			,select: function( event, ui ) {
				$("#location-form").find("#loc_id").val(ui.item.id);
				$("#location-form").find("#loc_city").val(ui.item.loc_city);
				$("#location-form").find("#loc_street").val(ui.item.loc_street);
				$("#location-form").find("#loc_postcode").val(ui.item.loc_postcode);
			}
		};
		
		$("#loc_search").autocomplete(_loc_options);
		
		var _usr_options = {
			source	:
				function( request, response ) {
					clearTimeout(t_timeout);
					
					t_timeout = setTimeout(function() {
										
						$.ajax({
							url			: <cfoutput>"#URLFor(controller='Courses',action='studentSearch')#"</cfoutput> + "&q=" + request.term,
							type		: "get",
							dataType	: "json",
							success		: function(data) {
								
								response( $.map( data.DATA, function(item) {
									return {
										label: item[1] + " (" + item[2] + ") ",
										value: item[1],
										id: item[0]
									}
								}));
							},
							error		: function(jqxhr, status, error){
								console.log(jqxhr);
								console.log(status);
								console.log(error);								
							}
						});
					}, 500);
				}
			,minLength: 3
			,select: function( event, ui ) {
				$("#location-form").find("#usr_id").val(ui.item.id);
			}
		};
		
		$("#usr_search").autocomplete(_usr_options);
	});
</script>