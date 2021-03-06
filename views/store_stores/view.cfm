<style>
	#monkey-map { height: 300px; }
	.user-details { margin: 5px; } 
	.user-details li { padding: 5px 0; min-height: 20px; }
	.user-details li img { margin: 5px; }
	.user-details label { float: left; font-weight: bold; width: 100px; padding-right: 10px; }
</style>
<cfoutput>
	<div class="wrapper store">
		<h3>Sklep #store.projekt#, #store.miasto#</h3>
		
		<div class="wrapper formbox">
			
			<div class="store-column">
				
				<ol class="store-details">
					<li>
						<label>Nr sklepu</label>
						<span>#store.projekt#</span>
					</li>
					<li>
						<label>Adres sklepu</label>
						<span>#store.miasto# #store.kodpsklepu#, #store.ulica#</span>
					</li>
					<li>
						<label>Lokalizacja</label>
						<span>#store.loc_mall_name#</span>
					</li>
					<li>
						<label>Grupa sklepu</label>
						<span>#store.grupasklepu#</span>
					</li>
					<li>
						<label>Powierzchnia</label>
						<span>#store.m2_sale_hall# m&sup2; (#store.m2_all# m&sup2;)</span>
					</li>
				</ol>
				
				<ol class="store-details">
					<li>
						<label>Imię i nazwisko ajenta</label>
						<span data-logo="#store.ajent#">#linkTo(text=store.nazwaajenta,href="##",title="#store.nazwaajenta#",class="tooltip")#</span>
					</li>
					<li>
						<label>Adres ajenta</label>
						<span>#store.adresrejajenta#</span>
					</li>
					<li>
						<label>Nip</label>
						<span>#store.nip#</span>
					</li>
					<li>
						<label>Regon</label>
						<span>#store.regon#</span>
					</li>
				</ol>
				
				<ol class="store-details">
					<li>
						<label>Imię i nazwisko KOSa</label>
						<span data-key="#store.partnerid#">
							<!---#linkTo(text=store.partner.givenname, href="##",title="#store.partner.givenname#",class="tooltip")#--->
						</span>
					</li>
					<li>
						<label>Adres email</label>
						<span><!---#store.partner.mail#---></span>
					</li>
				</ol>
			</div>
			
			<div class="store-column" id="monkey-map"></div>
			
			<div style="clear:both"></div>
		</div>
		
		<div class="wrapper formbox">
			
			<div class="widgetHeaderArea uiWidgetHeader">
				<h4 class="uiWidgetHeaderTitle">Obroty sklepu</h4>
			</div>
			
			<cfquery dbtype="query" name="store_sale"> 
			   	select * from qSales
			   	order by mmyy asc
			</cfquery>
			
			<cfchart
						format="png"
						showmarkers="false"
						showlegend="false"
				        scalefrom="0"
						scaleto="120000"
						chartWidth="900">
							
						<cfchartseries
							type="bar"
							serieslabel="Obroty sklepu"
							seriescolor="##ffcc00">
							
							<cfloop query="store_sale">
								
								<cfif val neq 0>
									<cfchartdata item="#mm# #yy#" value="#val#">
								</cfif>
								
							</cfloop>
					    	
						</cfchartseries>
						
					</cfchart>
			
		</div>
		
		<div class="wrapper formbox">
			
			<div class="widgetHeaderArea uiWidgetHeader">
				<h4 class="uiWidgetHeaderTitle">Wskaźnik zadłużenia</h4>
			</div>
			
			<cfif not IsNumeric(ratio.fv) or ratio.fv eq ''>
				<cfset _fv = "brak danych" />
			<cfelse>
				<cfset _fv = Replace(NumberFormat(ratio.fv, "__,___.__"), ",", " ", "ALL") & ' zł' />
			</cfif>
			
			<cfif not IsNumeric(ratio.sumpayment) or ratio.sumpayment eq ''>
				<cfset _sumpayment = "brak danych" />
			<cfelse>
				<cfset _sumpayment = Replace(NumberFormat(ratio.sumpayment, "__,___.__"), ",", " ", "ALL") & ' zł' />
			</cfif>
			
			<cfif not IsNumeric(ratio.starter) or ratio.starter eq ''>
				<cfset _starter = "brak danych" />
			<cfelse>
				<cfset _starter = Replace(NumberFormat(ratio.starter, "__,___.__"), ",", " ", "ALL") & ' zł' />
			</cfif>
			
			<cfif not IsNumeric(ratio.ratio) or ratio.ratio eq ''>
				<cfset _ratio = "--" />
			<cfelse>
				<cfset _ratio = Replace(NumberFormat((ratio.ratio*100), "___"), ",", " ", "ALL") & "%"/>
			</cfif>
			
			<cfset expected_class = 'plus' />
			<cfif not IsNumeric(ratio.expected) or ratio.expected eq ''>
				<cfset _expected = "--" />
			<cfelse>
				<cfif ratio.expected lt 0>
					<cfset expected_class = 'minus' />
				</cfif>
						
				<cfset _expected = Replace(NumberFormat(ratio.expected, "__,___.__"), ",", " ", "ALL") & ' zł' />
			</cfif>
					
			<cfif not IsNumeric(ratio.expected_ratio) or ratio.expected_ratio eq ''>
				<cfset _expected_ratio = "--" />
			<cfelse>
				<cfset _expected_ratio = Replace(NumberFormat((ratio.expected_ratio), "__,___.__"), ",", " ", "ALL") & "%" />
			</cfif>
			
			<table class="store-details">
				<thead>
					<tr>
						<th colspan="2">wartość</th>
						<th rowspan="2">starter</th>
						<th rowspan="2">wskaźnik zadłużenia</th>
						<th rowspan="2">bilans wpłat</th>
						<th rowspan="2">wskaźnik wpłat</th>
					</tr>
					<tr>
						<th>faktury</th>
						<th>płatności</th>						
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>#_fv#</td>
						<td>#_sumpayment#</td>
						<td>#_starter#</td>
						<td>#_ratio#</td>
						<td>#_expected#</td>
						<td>#_expected_ratio#</td>
					</tr>
				</tbody>
			</table>
			
		</div>
		
	</div>
</cfoutput>

<script>
	
	$(function(){
		
		$(".tooltip").tooltip({
			position: { my: "left+50 top+5" },
			open: function( event, ui ) {
				
				var $this = $(ui.tooltip);
				
				if(typeof $(this).parent().data("logo") === 'undefined')
					$(this).parent().data("logo", '');
				
				if(typeof $(this).parent().data("key") === 'undefined')
					$(this).parent().data("key", '');
				
				$.ajax({
					type: 'GET',
					url: '<cfoutput>#URLFor(controller="Users", action="find")#</cfoutput>',
					data: { 
						key	: $(this).parent().data("key"),
						logo: $(this).parent().data("logo") 
					},
					dataType: "json",
				
					success: function(data, status, xhr){
					
						if(data.photo == '') data.photo = 'monkeyavatar.png';
						
						$this.html(
							$("<div>").addClass("user-details").append(
								$("<ol>")
									.append( $("<li>").append( $("<img>").attr("src", '/intranet/images/avatars/' + data.photo).attr("alt", '/intranet/images/' + data.photo) ))
									.append( 
										$("<li>")
											.append($("<label>").text("Imię i nazwisko"))
											.append($("<span>").text(data.givenname + " " + data.sn))
									)
									.append( 
										$("<li>")
											.append($("<label>").text("Adres e-mail"))
											.append($("<span>").text(data.mail))
									)
									.append( 
										$("<li>")
											.append($("<label>").text("Ostatnio aktywny"))
											.append($("<span>").text(data.last_login))
									)
						));
					},
				
					error: function(){
					
						alert("Pobranie danych nie powiodło się. Spróbuj ponownie później.");
						
					}
				});
				
			}
		});	
		
	});
	
	function ConvertDMSToDD(input) {
		
		if( input.indexOf( 'N' ) == -1 && input.indexOf( 'S' ) == -1 && input.indexOf( 'W' ) == -1 && input.indexOf( 'E' ) == -1 ) {
    		return input.split(',');
		}

		var parts = input.split(/[°'"]+/).join(' ').split(/[^\w\S]+/);

		var directions = [];
		var coords = [];
		var dd = 0;
		var pow = 0;

		for( i in parts ) {
			
			if( isNaN( parts[i] ) ) {
				
				var _float = parseFloat( parts[i] );
        		var direction = parts[i];

        		if( !isNaN(_float ) ) {
            		dd += ( _float / Math.pow( 60, pow++ ) );
            		direction = parts[i].replace( _float, '' );
        		}

        		direction = direction[0];

				if( direction == 'S' || direction == 'W' )
					dd *= -1;

				directions[ directions.length ] = direction;

				coords[ coords.length ] = dd;
				dd = pow = 0;
    		
			} else {
        		
				dd += ( parseFloat(parts[i]) / Math.pow( 60, pow++ ) );
			}
		}
		
		return coords[1];
	}
	
	var map;
	
	var lat = <cfoutput>"#lat#"</cfoutput>;
	var lng = <cfoutput>"#lng#"</cfoutput>;
	
	var LatLng = new google.maps.LatLng(ConvertDMSToDD(lat), ConvertDMSToDD(lng));
	
	var mapOptions = {
			zoom: 16,
			center: LatLng
		};
		
	map = new google.maps.Map(document.getElementById('monkey-map'),mapOptions);
	
	//google.maps.event.addDomListener(window, 'load', initialize);
	
	var marker = new google.maps.Marker({
		position: LatLng,
		map: map,
		title:"<cfoutput>#store.projekt#</cfoutput>"
	});
	
	marker.setMap(map);
</script>
<!---<cfdump var="#store#">--->
<!---<cfdump var="#qSales#" />--->
<!---<cfdump var="#sales#">--->