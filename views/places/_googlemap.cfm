<div id="placessearchgooglemap"></div>

<script>
	$(function() {
		var wspolrzedne = new google.maps.LatLng(51.91716758909015, 19.13818359375); <!--- Środek Polski --->
		var opcjeMapy = {
			zoom: 6,
			center: wspolrzedne,
			mapTypeId: google.maps.MapTypeId.ROADMAP
		};
		
		var mapa = new google.maps.Map(document.getElementById("placessearchgooglemap"), opcjeMapy);
		
		<cfoutput>
			<cfloop query="places">
				<cfif step1status eq 1>
				
					dodajPunkt(#lat#, #lng#, "<strong>#cityname#</strong><br/>#address#, #provincename#", mapa, 'http://10.99.0.32/intranet/images/marker_yellow.png');
				
				</cfif>
				
				<cfif step2status eq 1>
				
					dodajPunkt(#lat#, #lng#, "<strong>#cityname#</strong><br/>#address#, #provincename#", mapa, 'http://10.99.0.32/intranet/images/marker_purple.png');
				
				</cfif>
				
				<cfif step3status eq 1>
				
					dodajPunkt(#lat#, #lng#, "<strong>#cityname#</strong><br/>#address#, #provincename#", mapa, 'http://10.99.0.32/intranet/images/marker_blue.png');
				
				</cfif>
				
				<cfif step4status eq 1>
				
					dodajPunkt(#lat#, #lng#, "<strong>#cityname#</strong><br/>#address#, #provincename#", mapa, 'http://10.99.0.32/intranet/images/marker_green.png');
					
				</cfif>
				
				<cfif step5status eq 1>
				
					dodajPunkt(#lat#, #lng#, "<strong>#cityname#</strong><br/>#address#, #provincename#", mapa, 'http://10.99.0.32/intranet/images/marker_red.png');
				
				</cfif>
				
			</cfloop>
		</cfoutput>
		
	});
</script>