<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Heatmapa z notatek</h3>
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			
			<cfform name="note_notes_report_form"
					action="#URLFor(controller='Note_notes',action='report')#">
						
				<ol class="">
					<li>
						<select name="userid" class="select_box">
							<option value="0">[wszyscy]</option>
							<cfoutput query="dkin">
								<option value="#id#" <cfif session.note_notes_report.userid EQ id> selected="selected"</cfif>>#givenname# #sn#</option>
							</cfoutput>
						</select>
					</li>
					<li><cfinput type="submit" name="note_notes_report_form_submit" class="admin_button green_admin_button" value="Filtruj" /></li>
				</ol>
				
			</cfform>
			
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">

			<div id="map-canvas"></div>

			<div class="uiFooter">
				
			</div>
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>

<script type="text/javascript">
	var markers = new Array();
	var markers_visible = true;
	var map, pointarray, heatmap;
	var malpki_dane = [
	<cfloop query="raport">
		<cfif not(Len(latitude) GT 0 and Len(longitude) GT 0)>
			<cfcontinue />
		</cfif>
		
		<cfoutput>[#latitude#, #longitude#, '#projekt#', #c#],</cfoutput>
	</cfloop>
	];
	var malpki = new Array();
	
	function createMarker(lat, lon, html) {
		var newmarker = new google.maps.Marker({position: new google.maps.LatLng(lat, lon),
			map: map,
			title: html,
			icon: "https://chart.googleapis.com/chart?chst=d_map_spin&chld=0.20%7C0%7Ce1e1e1%7C000000",
		});
		
		newmarker['infowindow'] = new google.maps.InfoWindow({
			content: "<div style=\"height:50px;width:120px\">" + html + "</div>",
			
		});
		
		google.maps.event.addListener(newmarker, 'click', function() {
			this['infowindow'].open(map, this);
		});
	}

	function initialize() {
		for (var i = 0; i < malpki_dane.length; i++) {
			var m = malpki_dane[i];
			for(var j = 0; j < m[3]*m[3]*m[3]; j++) {
				var poz = new google.maps.LatLng(m[0],m[1]);
				malpki.push(poz);
			}
		}
		
		var mapOptions = {
			zoom: 6,
			center: new google.maps.LatLng(52.406374,16.9251681),
		};
		map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
		var pointArray = new google.maps.MVCArray(malpki);
		heatmap = new google.maps.visualization.HeatmapLayer({
			data: pointArray
		});
		heatmap.setMap(map);
		heatmap.setOptions({radius: heatmap.get('radius') ? null : 30});
		
		for (var k = 0; k < malpki_dane.length; k++) {
			var m = malpki_dane[k];
			createMarker(m[0], m[1], "Sklep: " + m[2] + "<br/>Liczba notatek: " + m[3] );
			
		}
		
	}
	google.maps.event.addDomListener(window, 'load', initialize);
	
</script>