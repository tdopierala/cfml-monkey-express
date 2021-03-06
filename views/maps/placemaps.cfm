<cfoutput>

	<div class="wrapper">
	
		#includePartial(partial="header")#	
	
	</div>
	
	<div class="results"></div>
	<div id="resultmap" style="width:925px;height:500px;"></div>
	
</cfoutput>

<script>
$(function() {

	var map;
	var service;
	var geocoder = new google.maps.Geocoder();
	var markers = new Array();
	var infowindows = new Array();
	var infowindow = null;
	var frog_service;
	var ladybird_service;
	var index = 0;
	
	geocoder.geocode({'address':'<cfoutput>#place.address# #place.cityname# #place.provincename#</cfoutput>'}, function(results, status) {
	
		var centerLatLng = results[0].geometry.location;
		
		map = new google.maps.Map(document.getElementById('resultmap'), {
			zoom: 14,
			center: results[0].geometry.location,
			mapTypeId: google.maps.MapTypeId.ROADMAP
		});
		
		new google.maps.Circle({
			strokeColor: "#f8e21d",
			strokeOpacity: 0.8,
			strokeWeight: 2,
			fillColor: "#f8e21d",
			fillOpacity: 0.35,
			map: map,
			center: results[0].geometry.location,
			radius: 1000
		});
		
		new google.maps.Circle({
			strokeColor: "#73146b",
			strokeOpacity: 0.8,
			strokeWeight: 2,
			fillColor: "#73146b",
			fillOpacity: 0.35,
			map: map,
			center: results[0].geometry.location,
			radius: 300
		});
		
		var monkey = new google.maps.Marker({
			position: results[0].geometry.location,
			map: map,
			title: 'Monkey Express',
			icon: 'http://10.99.0.32/dev/images/pinezka_otwarta_1.png'
		});
		
		var frog_request = {
			location: results[0].geometry.location,
			radius: '1000',
			name: 'Żabka'
		};
		
		var ladybird_request = {
			location: results[0].geometry.location,
			radius: '1000',
			name: 'Biedronka'

		};
		
		frog_service = new google.maps.places.PlacesService(map);
		frog_service.search(frog_request, function(results, status) {
			for (var i = 0; i < results.length; i++) {
				var popupContent = '';
				markers[index] = new google.maps.Marker({
					position: results[i].geometry.location,
					map: map,
					title:results[i].name,
					address:results[i].vicinity,
					icon: 'http://10.99.0.32/dev/images/zabka-polska-sa.png'
				});
				
				popupContent += '<b>'+results[i].name + '</b><br/>' + results[i].vicinity;
				createInfoWindow(map, markers[index], popupContent);
				index++;
			}
		});
		
		ladybird_service = new google.maps.places.PlacesService(map);
		ladybird_service.search(ladybird_request, function(results, status) {
		
			for (var i = 0; i < results.length; i++) {
				var popupContent = '';
				markers[index] = new google.maps.Marker({
					position: results[i].geometry.location,
					map: map,
					title:results[i].name,
					address:results[i].vicinity,
					icon: 'http://10.99.0.32/dev/images/biedronka.png'
				});
				
				popupContent += '<b>'+results[i].name + '</b><br/>' + results[i].vicinity;
				createInfoWindow(map, markers[index], popupContent);
			}
			index++;
		});
	
		
	});
	
	$('.savemap').live('click', function(e) {
		
		e.preventDefault();
		$('#flashMessages').show();
		
		var parsed_data = [];
		
		for (var i = 0; i < markers.length; i++) {
			parsed_data.push({title:markers[i].title,address:markers[i].address,lat:markers[i].position.Xa,lng:markers[i].position.Ya,icon:markers[i].icon});
		}
		
		$.ajax({
			data		:		{'map':JSON.stringify({mapname:$('#mapname').val(),mapzoom:map.zoom,maplat:map.center.Xa,maplng:map.center.Ya,maptypeid:map.mapTypeId,placeid:<cfoutput>#place.id#</cfoutput>}),'marker':JSON.stringify(parsed_data)},
			type		:		"post",
			url			:		$(this).attr('href'),
			success		:		function(data) {
				$('.ajaxcontent').html(data);
				$('#flashMessages').hide();
			}

		});

	});
	
});

var infoWindow = new google.maps.InfoWindow();
function createInfoWindow(map, marker, popupContent) 
{
    google.maps.event.addListener(marker, 'click', function () {
        infoWindow.setContent(popupContent);
        infoWindow.open(map, this);
    });
}



</script>