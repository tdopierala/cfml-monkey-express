<cfsilent>
	<cfquery name="raport" dbtype="query">
		select *
		from obroty, sklepy
		where obroty.loc = sklepy.projekt
	</cfquery>
</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />



<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Obroty sklepów</h3>
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			
			<cfform name="obroty_sklepow_form"
					action="index.cfm?controller=raporty&action=obroty-sklepow&t=true" >
				<ol class="horizontal">
					<li>
						<label for="miesiac">Miesiąc</label>
						<select name="miesiac" class="select_box">
							<option value="styczen" <cfif session.raporty.miesiac EQ 'styczen'> selected="selected"</cfif>>Styczeń</option>
							<option value="luty" <cfif session.raporty.miesiac EQ 'luty'> selected="selected"</cfif>>Luty</option>
							<option value="marzec" <cfif session.raporty.miesiac EQ 'marzec'> selected="selected"</cfif>>Marzec</option>
							<option value="kwiecien" <cfif session.raporty.miesiac EQ 'kwiecien'> selected="selected"</cfif>>Kwiecień</option>
							<option value="maj" <cfif session.raporty.miesiac EQ 'maj'> selected="selected"</cfif>>Maj</option>
							<option value="czerwiec" <cfif session.raporty.miesiac EQ 'czerwiec'> selected="selected"</cfif>>Czerwiec</option>
							<option value="lipiec" <cfif session.raporty.miesiac EQ 'lipiec'> selected="selected"</cfif>>Lipiec</option>
							<option value="sierpien" <cfif session.raporty.miesiac EQ 'sierpien'> selected="selected"</cfif>>Sierpień</option>
							<option value="wrzesien" <cfif session.raporty.miesiac EQ 'wrzesien'> selected="selected"</cfif>>Wrzesień</option>
							<option value="pazdziernik" <cfif session.raporty.miesiac EQ 'pazdziernik'> selected="selected"</cfif>>Październik</option>
							<option value="listopad" <cfif session.raporty.miesiac EQ 'listopad'> selected="selected"</cfif>>Listopad</option>
							<option value="grudzien" <cfif session.raporty.miesiac EQ 'grudzien'> selected="selected"</cfif>>Grudzień</option>
						</select>
					</li>
					<li>
						<label for="rok">Rok</label>
						<select name="rok" class="select_box">
							<option value="2012" <cfif session.raporty.rok EQ '2012'> selected="selected"</cfif>>2012</option>
							<option value="2013" <cfif session.raporty.rok EQ '2013'> selected="selected"</cfif>>2013</option>
							<option value="2014" <cfif session.raporty.rok EQ '2014'> selected="selected"</cfif>>2014</option>
						</select>
					</li>
					<li>
						<input type="submit" class="admin_button green_admin_button" value="Filtruj" />
					</li>
				</ol>			
			</cfform>
			
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">

			<div id="map-canvas">
			</div>

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
		<cfif not(Len(latitude) GT 0 and Len(longitude) GT 0) or NumberFormat(ReReplace(obrot, ",", "."), '9.99') EQ 0>
			<cfcontinue />
		</cfif>
		
		<cfoutput>[#latitude#, #longitude#, '#projekt#', #NumberFormat(ReReplace(obrot, ",", "."), '9.99')#, '#ReReplace(adres, "'", "", "all")#'],</cfoutput>
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
			content: "<div style=\"height:80px;width:180px\">" + html + "</div>",
			
		});
		
		google.maps.event.addListener(newmarker, 'click', function() {
			this['infowindow'].open(map, this);
		});
	}

	function initialize() {
		for (var i = 0; i < malpki_dane.length; i++) {
			var m = malpki_dane[i];
			// for(var j = 0; j < m[3]*m[3]*m[3]; j++) {
				var poz = new google.maps.LatLng(m[0],m[1]);
				malpki.push(poz);
			// }
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
			createMarker(m[0], m[1], "Sklep: " + m[2] + "<br/> Obrót: " + m[3] + "<br />" + m[4]);
			
		}
		
	}
	google.maps.event.addDomListener(window, 'load', initialize);
	
</script>