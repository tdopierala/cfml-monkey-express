<cfoutput>
	
	<div class="wrapper">
	
		<h3>Dodaj nieruchomość</h3>
		
		<div class="wrapper">
		
			<div class="forms horizontal block">
			
				<div id="googlemap"></div>
			
				#startFormTag(controller="places",action="actionAdd",id="geolocalizationform",multipart=true)#
				#hiddenFieldTag(name="lat",value="")#
				#hiddenFieldTag(name="lng",value="")#
					<h5>Dane administracyjne</h5>
					<ol>
						<li>
							#selectTag(
								name="provinceid",
								options=provinces,
								includeBlank="true",
								label="Województwo",
								labelPlacement="before")#
						</li>
						<li>
							<label for="district">Powiat</label><select id="districtid" name="district"><option value="" selected="selected>"</option></select>
						</li>
						<li>
							#textFieldTag(
								name="cityid",
								class="input",
								label="Miasto/miejscowość",
								labelPlacement="before"
							)#
						</li>
						<li>
							#textFieldTag(
								name="address",
								class="input",
								label="Ulica i numer",
								labelPlacement="before")#

							#linkTo(
								text="<span>sprawdź</span>",
								controller="Places",
								action="geolocalization",
								class="geolocalization")#
						</li>
						<!---
						<li>
							#selectTag(
								name="population",
								options="",
								includeBlank="true",
								label="Liczba mieszkańców",
								labelPlacement="before")#
						</li>
						--->
						<!---
						<li>
							#selectTag(
								name="unemployment",
								options="",
								includeBlank=true,
								label="Bezrobocie",
								labelPlacement="before")#
						</li>
						--->
						
						<li	class="placeinformations">
						
						</li>
					</ol>
					
					
					<ol class="clear">
						<li>#submitTag(value="Zapisz",class="button redButton addPlacement")#</li>
					</ol>
				
				#endFormTag()#
			
				<div class="clear"></div>
			
			</div>
		
		</div>
	
	</div>
	
</cfoutput>

<script>
$(function() {
	
	/**
	*
	* Po wpisaniu danych mogę wstawić marker na mapie
	*
	*/
	$('.geolocalization').live('click', function(e) {
		e.preventDefault();
		$('#flashMessages').show();
		
		<!--- Pobranie mapy do lokalizacji --->
		$.ajax({
			type		:	'post',
			dataType	:	'xml',
			data		:	{cityname:$('#cityid').val(),streetname:$('#address').val(),provincename:$('#provinceid :selected').text()},
			url			:	<cfoutput>"#URLFor(controller='Places',action='geolocalization',format='xml')#"</cfoutput>,
			success		:	function(data) {
<!--- 				var xmlDoc = $.parseXML(data, "GeocodeResponse"); --->
				var lat = $(data).find('location lat').text();
				var lng = $(data).find('location lng').text();
				
				// Definiuje mapę do wyświetlenia
    			var wspolrzedne = new google.maps.LatLng(lat,lng);
				var opcjeMapy = {
					zoom: 16,
					center: wspolrzedne,
					mapTypeId: google.maps.MapTypeId.ROADMAP
				};
				var mapa = new google.maps.Map(document.getElementById("googlemap"), opcjeMapy);  
				
				var marker = dodajPunkt(lat, lng, "<strong>"+$('#cityid').val()+"</strong><br/>"+$('#address').val(), mapa);
				google.maps.event.trigger(marker,'click');
				
				$('#flashMessages').hide();
				
				// Podstawiam dane tal i lng do ukrytych pól formularza
				$('#lat').val(lat);
				$('#lng').val(lng);
			}
		});
		
		<!--- Sprawdzenie, czy istnieje już taka lokalizacja w bazie --->
		$.ajax({
			type		:		'post',
			dataType	:		'html',
			data		:		{cityname:$('#cityid').val(),address:$('#address').val()},
			url			:		<cfoutput>"#URLFor(controller='Places',action='checkPlace',params='cfdebug')#"</cfoutput>,
			success		:		function(data) {
				$('.placeinformations').html(data);
				$('#flashMessages').hide();
			}
		});
	});
		
	$('#provinceid').live('change', function(e) {
		e.preventDefault();
		$('#flashMessages').show();
		
		$.ajax({
			type		:		'get',
			dataType	:		'html',
			data		:		{key:$(this).val()},
			url			:		<cfoutput>"#URLFor(controller='Places',action='getDistricts')#"</cfoutput>,
			success		:		function(data) {
				$('#districtid').html(data);
				
				$('#flashMessages').hide();
			}
		});
	});
	
	$('#cityid').live('keyup', function (e) {
	
		var provinceid = ($('#provinceid :selected').val() != undefined) ? $('#provinceid :selected').val() : "";
		var districtid = ($('#districtid :selected').val() != undefined) ? $('#districtid :selected').val() : "";
	
		$(this).autocomplete({
			source		:		function(request, response) {
				$.getJSON(<cfoutput>"#URLFor(controller='Places',action='getCities',params='cfdebug')#"</cfoutput>, {search: request.term+":"+provinceid+":"+districtid}, response);				
			},
			select		:		function(element, ui) {
				$(this).parent().parent().find('.autocompleteproduct').val(ui.item.label);
			}
		});
	});

});
</script>