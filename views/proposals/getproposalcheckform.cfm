<cfoutput>
	<div class="wrapper proposalcheck">
		<h3>Rozliczenie wyjazdu służbowego - edycja</h3>
		
		<div class="wrapper proposalpreview">
			<ol>
				<cfloop query="proposalattr">
			
					<li><span>#attributename#</span>#proposalattributevaluetext#</li>
				
				</cfloop>
			</ol>
		</div>
		
		<form action="#URLFor(controller='Proposals',action='sendProposalCheckForm')#" method="post" id="form-body">
			<input type="hidden" name="proposalid" value="#proposal.id#" />
			<input type="hidden" name="businesstripid" value="#businesstrip.id#" />
			<table class="tables travels">
			
			<thead>
				<tr>
					<th class="btop" colspan="3">wyjazd</th>
					<th class="btop" colspan="3">przyjazd</th>
					<th class="btop" rowspan="2">środki lokomocji</th>
					<th class="btop bright" rowspan="2" colspan="2">koszty przejazdu</th>
				</tr>
				<tr>
					<th>miejscowość</th>
					<th>data</th>
					<th>godz.</th>
					<th>miejscowość</th>
					<th>data</th>
					<th>godz.</th>
				</tr>
			</thead>
			
			<tbody>
				<!---<cfif IsQuery(businesstriproute) and businesstriproute.RecordCount gt 0>--->

					<cfloop query="businesstriproute">
						
						<tr>
							<input type="hidden" name="id" value="#businesstriproute.id#" />
							<td class="autotext"><input type="text" name="beginCity" class="autotextval" value="#businesstriproute.begincity#" /></td>
							<td class="datebox"><input type="text" name="beginDate" class="dateboxval"  value="#DateFormat(businesstriproute.begindate, 'dd-mm-yyyy')#" /></td>
							<td class="timebox"><input type="text" name="beginHour" class="timeboxval"  value="#TimeFormat(businesstriproute.begintime, 'HH:mm')#" /></td>
							
							<td class="autotext"><input type="text" name="endCity" class="autotextval" value="#businesstriproute.endcity#" /></td>
							<td class="datebox"><input type="text" name="endDate" class="dateboxval"  value="#DateFormat(businesstriproute.enddate, 'dd-mm-yyyy')#" /></td>
							<td class="timebox"><input type="text" name="endHour" class="timeboxval"  value="#TimeFormat(businesstriproute.endtime, 'HH:mm')#" /></td>
							
							<td class="select">
								<select name="transport">
									<option value="null"> --- </option>
									<option value="pkp"<cfif businesstriproute.transport eq 'pkp'> selected="selected" </cfif>>PKP</option>
									<option value="samolot"<cfif businesstriproute.transport eq 'samolot'> selected="selected" </cfif>>Samolot</option>
									<option value="samochod"<cfif businesstriproute.transport eq 'samochod'> selected="selected" </cfif>>Samochód</option>
								</select>
							</td>
							<td class="cost"><input type="text" name="cost" value="#businesstriproute.cost#" /></td>
							<td class="bright action" valign="center" align="center">
								#linkTo(
									text=imageTag("remove_cell.png"),
									anchor="remove",
									title="Usuń wiersz")#
							</td>
						</tr>
						
					</cfloop>
					
				<!---<cfelse>
					
						<tr>
							<td class="autotext"><input type="text" name="beginCity" class="autotextval" value="Poznań" /></td>
							<td class="datebox"><input type="text" name="beginDate" class="dateboxval"  value="#beginDate#" /></td>
							<td class="timebox"><input type="text" name="beginHour" class="timeboxval"  value="08:00" /></td>
							
							<td class="autotext"><input type="text" name="endCity" class="autotextval" value="#destination#" /></td>
							<td class="datebox"><input type="text" name="endDate" class="dateboxval"  value="" /></td>
							<td class="timebox"><input type="text" name="endHour" class="timeboxval"  value="" /></td>
							
							<td class="select">
								<select name="transport">
									<option value="0"> --- </option>
									<option value="pkp">PKP</option>
									<option value="samolot">Samolot</option>
									<option value="samochod">Samochód</option>
								</select>
							</td>
							<td class="cost bright"><input type="text" name="cost" value="" /></td>
						</tr>
						
						<tr>
							<td class="autotext"><input type="text" name="beginCity" class="autotextval" value="" /></td>
							<td class="datebox"><input type="text" name="beginDate" class="dateboxval"  value="" /></td>
							<td class="timebox"><input type="text" name="beginHour" class="timeboxval"  value="" /></td>
							
							<td class="autotext"><input type="text" name="endCity" class="autotextval" value="" /></td>
							<td class="datebox"><input type="text" name="endDate" class="dateboxval"  value="#endDate#" /></td>
							<td class="timebox"><input type="text" name="endHour" class="timeboxval"  value="" /></td>
							
							<td class="select">
								<select name="transport">
									<option value="0"> --- </option>
									<option value="pkp">PKP</option>
									<option value="samolot">Samolot</option>
									<option value="samochod">Samochód</option>
								</select>
							</td>
							<td class="cost bright"><input type="text" name="cost" value="" /></td>
						</tr>
					
				</cfif>--->
				
			</tbody>
			
		</table>
		
		<div><a href="./" id="newRowLink">Dodaj nowy wiersz</a></div>
		
		<table class="tables summary">
			<tr>
				<th class="btop">Ryczałty za dojazd</th>
				<td class="btop bright cost">
					<cfif StructKeyExists(businesstrip, "tripcost1")>
						<input type="text" name="artibiute" value="#businesstrip.tripcost1#" />
					<cfelse>
						<input type="text" name="artibiute" value="" />
					</cfif>
				
				</td>
			</tr>
			<tr>
				<th>Dojazdy udokumentowane</th>
				<td class="cost bright">
					<cfif StructKeyExists(businesstrip, "tripcost2")>
						<input type="text" name="artibiute" value="#businesstrip.tripcost2#" />
					<cfelse>
						<input type="text" name="artibiute" value="" />
					</cfif>
				</td>
			</tr>
			<tr>
				<th>Razem przejazdy, dojazdy</th>
				<td class="cost bright">
					<cfif StructKeyExists(businesstrip, "tripcost3")>
						<input type="text" name="artibiute" value="#businesstrip.tripcost3#" />
					<cfelse>
						<input type="text" name="artibiute" value="" />
					</cfif>
				</td>
			</tr>
			<tr>
				<th>Diety</th>
				<td class="cost bright">
					<cfif StructKeyExists(businesstrip, "tripcost4")>
						<input type="text" name="artibiute" value="#businesstrip.tripcost4#" id="diet" />
					<cfelse>
						<input type="text" name="artibiute" value="" id="diet" />
					</cfif>
				</td>
			</tr>
			<tr>
				<th>Noclegi - ryczałt</th>
				<td class="cost bright">
					<cfif StructKeyExists(businesstrip, "tripcost5")>
						<input type="text" name="artibiute" value="#businesstrip.tripcost5#" />
					<cfelse>
						<input type="text" name="artibiute" value="" />
					</cfif>
				</td>
			</tr>
			<tr>
				<th>Noclegi wg rach.</th>
				<td class="cost bright">
					<cfif StructKeyExists(businesstrip, "tripcost6")>
						<input type="text" name="artibiute" value="#businesstrip.tripcost6#" />
					<cfelse>
						<input type="text" name="artibiute" value="" />
					</cfif>
				</td>
			</tr>
			<tr>
				<th>Inne wydatki wg zał.</th>
				<td class="cost bright">
					<cfif StructKeyExists(businesstrip, "tripcost7")>
						<input type="text" name="artibiute" value="#businesstrip.tripcost7#" />
					<cfelse>
						<input type="text" name="artibiute" value="" />
					</cfif>
				</td>
			</tr>
			<tr>
				<th>Firmowa karta kredytowa</th>
				<td class="cost bright">
					<cfif StructKeyExists(businesstrip, "tripcost8")>
						<input type="text" name="artibiute" value="#businesstrip.tripcost8#" />
					<cfelse>
						<input type="text" name="artibiute" value="" />
					</cfif>
				</td>
			</tr>
			<tr>
				<th>Pobrana zaliczka</th>
				<td class="cost bright">
					<cfif StructKeyExists(businesstrip, "tripcost9")>
						<input type="text" name="artibiute" value="#businesstrip.tripcost9#" />
					<cfelse>
						<input type="text" name="artibiute" value="" />
					</cfif>
				</td>
			</tr>
			<tr>
				<th>Suma</th>
				<td class="bright"><input type="text" name="artibiute" value="0" id="sum" /></td>
			</tr>
		</table>
		</form>
		<div id="_serialize"></div>
		<div id="serialize"></div>
		
		<div id="form-submit" class="delegation-submit">
			#submitTag(value="Zatwierdź i wyślij", class="formButton button redButton proposalSend")#
			#submitTag(value="Zapisz zmiany", class="formButton button redButton proposalSave")#
		</div>
	</div>
	

</cfoutput>

 <script language="JavaScript">
$(document).ready(function(){
	dietCost();
	
	$(".proposalSave").click(function(){
		var html = serializeEmpty("#form-body");
		$("#flashMessages").html('<img width="16" height="16" src="/intranet/images/ajax-loader-1.gif" alt="Ajax loader 1">Zapisuje dane…');
		
		$.ajax({
			type: 'POST',
			url: "<cfoutput>#URLFor(controller='Proposals',action='saveProposalCheckForm')#</cfoutput>",
			data: serializeEmpty("#form-body"),
			success: function(data){
				$("#flashMessages").hide();
				//$("#serialize").html(data);
			},
			error: function(e){
				alert("Zapisanie nie powiodło się. Spróbuj ponownie później.");
				$("#flashMessages").hide();
			}
		});
	});
	
	$(".proposalSend").click(function(){
		var html = serializeEmpty("#form-body");
		$("#flashMessages").html('<img width="16" height="16" src="/intranet/images/ajax-loader-1.gif" alt="Ajax loader 1">Zapisuje dane…');
		
		$.ajax({
			type: 'POST',
			url: "<cfoutput>#URLFor(controller='Proposals',action='saveProposalCheckForm')#</cfoutput>",
			data: serializeEmpty("#form-body"),
			success: function(data){
				$("#flashMessages").hide();
				
				if(confirm("Jesteś pewny, że chcesz wysłać wypełniony formularz?"))
					$('#form-body').submit();
			},
			error: function(e){
				alert("Zapisanie nie powiodło się. Spróbuj ponownie później.");
				$("#flashMessages").hide();
			}
		});
	});
});
$(function() {
	var availableTags = ["Poznań","Bydgoszcz","Warszawa","Wrocław","Gdańsk","Gdynia","Sopot","Kraków","Olsztyn","Gorzów Wielkopolski","Pabianice","Kielce","Sosnowiec","Gliwice","Bytom","Ostrowiec Świetokrzyski","Siemanowice Ślaskie"];
	$( ".autotext input" ).autocomplete({
		 source: function( request, response ) {
		 	//var value = $(this).val();
			$.ajax({
				type: 'GET',
				dataType: "json",
				url: "<cfoutput>#URLFor(controller='Proposals',action='citySearch')#</cfoutput>",
				data: { "phrase" : request.term },
				success: function( data ) {
					response(data);
				}
			});
		},
		minLength: 2
	});
	$.widget("ui.timespinner", $.ui.spinner, {
		options: { step: 60*1000, page: 60 },
		 _parse: function( value ) {
		 	Globalize.culture("pl-PL");
			if ( typeof value === "string" ) {
				if ( Number( value ) == value ) return Number( value );
				return +Globalize.parseDate( value );
			}
			return value;
		},
		_format: function( value ) { return Globalize.format( new Date(value), "t" ); }
	});
	$(".datebox input").datepicker({ dateFormat: "dd-mm-yy" });
	$(".timebox input").timespinner();
	$('.cost input').filter_input({regex:'^[0-9.,-]'});
	$('.cost input').attr("readonly",true);
	
	/*$('.cost input').live("dblclick",function(){
		var value = $(this).val().replace(",",".");
		if( value.substr(-2,2) == 'zł') $(this).val(value.substr(0,value.length - 3));
		$(this).attr("readonly",false).css("border-color","000000");
	});*/
	
	$('tr').on({
		mouseenter:function(){
			$(this).children("td.action").children().children().css("visibility","visible");
		},
		mouseleave:function(){
			$(this).children("td.action").children().children().css("visibility","hidden");
		}
	});
	
	$('td.action a').on('click',function(){
		var obj = $(this).parent().parent();
		
		if( obj.parent().children().length > 1 ) {
			$.ajax({
				type: 'GET',
				url: "<cfoutput>#URLFor(controller='Proposals',action='saveProposalTripRoute')#</cfoutput>",
				data: { "id" : obj.children("input").val(), "method" : "remove" },
				success: function(data){
					obj.remove();
					$("#flashMessages").hide();
				},
				error: function(e){
					alert("Nie można usunąć wiersza. Spróbuj ponownie później.");
					$("#flashMessages").hide();
				}
			});	
		} else {
			alert("Nie można usunąć ostatniego wiersza.");
		}
		
		return false;
	});
	
	$('.cost input').on("focusout",function(){
		$(this).val($(this).val().replace(",","."));
		summaryCost();
		$(this).attr("readonly",true).css("border-color","ffffff");
	});
	$('.cost input').on("focusin",function(){
		var value = $(this).val().replace(",",".");
		if( value.substr(-2,2) == 'zł') $(this).val(value.substr(0,value.length - 3));
		$(this).attr("readonly",false).css("border-color","000000");
		//if( value.substr(-2,2) == 'zł') $(this).val(value.substr(0,value.length - 3));
	});
	
	$('select[name=transport]').change(function(){
		if($(this).val() == 'samochod'){
			$(this).parent().next().children().val(null);
			//$(this).parent().next().children().attr();
		}
		else
			$(this).parent().next().children().show();
		
		summaryCost();
	});
	
	$('.dateboxval').on("change", dietCost);
	$('.timeboxval').on("change", dietCost);
	$('.timebox a').on("click", dietCost);
	
	$("#newRowLink").click(function(){
		$("#flashMessages").show();
		
		$.ajax({
			type: 'GET',
			url: "<cfoutput>#URLFor(controller='Proposals',action='saveProposalTripRoute')#</cfoutput>",
			data: { "id" : $("input[name=businesstripid]").val(), "method" : "create" },
			success: function(data){
				
				html = '<tr>' +
					'<input type="hidden" name="id" value="' + data + '" />' +
					'<td class="autotext"><input type="text" name="beginCity" class="autotextval" value="" /></td>' +
					'<td class="datebox"><input type="text" name="beginDate" class="dateboxval" value="" /></td>' +
					'<td class="timebox"><input type="text" name="beginHour" class="timeboxval" value="" /></td>' +
					'<td class="autotext"><input type="text" name="endCity" class="autotextval" value="" /></td>' +
					'<td class="datebox"><input type="text" name="endDate" class="dateboxval" value="" /></td>' +
					'<td class="timebox"><input type="text" name="endHour" class="timeboxval" value="" /></td>' +
					'<td class="select"><select name="transport"><option value="null"> --- </option><option value="pkp">PKP</option><option value="samolot">Samolot</option><option value="samochod">Samochód</option></select></td>' +
					'<td class="cost"><input type="text" name="cost" value="" /></td>' +
					'<td class="bright action" valign="center" align="center"><cfoutput>#linkTo(text=imageTag("remove_cell.png"),anchor="remove",title="Usuń wiersz")#</cfoutput></td>' +
				'</tr>';
				
				$("#flashMessages").hide();
				
				$(".travels tbody").append(html);		
				$(".datebox input").datepicker({ dateFormat: "dd-mm-yy" });
				$(".timebox input").timespinner();
				$('.cost input').filter_input({regex:'[0-9.,-]'});
				$( ".autotext input" ).autocomplete({source: availableTags});
				$('tr').on({
					mouseenter:function(){
						$(this).children("td.action").children().children().css("visibility","visible");
					},
					mouseleave:function(){
						$(this).children("td.action").children().children().css("visibility","hidden");
					}
				});
				
				$('td.action a').on('click',function(){
					var obj = $(this).parent().parent();
					
					if( obj.parent().children().length > 1 ) {
						$.ajax({
							type: 'GET',
							url: "<cfoutput>#URLFor(controller='Proposals',action='saveProposalTripRoute')#</cfoutput>",
							data: { "id" : obj.children("input").val(), "method" : "remove" },
							success: function(data){
								obj.remove();
								$("#flashMessages").hide();
							},
							error: function(e){
								alert("ajax error: " + e);
								$("#flashMessages").hide();
							}
						});	
					} else {
						alert("Nie można usunąć ostatniego wiersza.");
					}
		
					return false;
				});
			},
			error: function(e){
				alert("ajax error: " + e);
				$("#flashMessages").hide();
			}
		});
		
		return false;
	});
	
});

function serializeEmpty(obj) {
	$(obj + " input").each(function(){		
		var val = $(this).val();
		if(val=='') 
			$(this).val('null');
		else 
			if( val.substr(-2,2) == 'zł') 
				$(this).val(val.substr(0,val.length - 3));
	});
	
	var result = $(obj).serialize();
	
	$(obj + " input").each(function(){		
		var val = $(this).val();
		if(val=='null') $(this).val('');
	});
	
	formatCurrency();
	return result;
}

function formatCurrency() {
	$(".cost input").each(function(){
		if( $(this).val().substr(-2,2) != 'zł' && $(this).val() != '') {
			var value = $(this).val();
			value = parseFloat(value);
			$(this).val( value.toFixed(2) + ' zł');
		}
	});
	
	if( $("#sum").val().substr(-2,2) != 'zł' && $("#sum").val() != '') {
		var value = $("#sum").val();
		value = parseFloat(value);
		$("#sum").val( value.toFixed(2) + ' zł');
	}
}

function summaryCost() {
	$("#sum").val(0);
	$(".cost").children("input").each(function(){

		var sum = $("#sum").val();
		var value = $(this).val().replace(",", ".");
			
		if (value.substr(-2, 2) == 'zł') 
			value = value.substr(0, value.length - 3);
		if (value.length > 0) 
			value = parseFloat(value);
		else 
			value = 0;
			
		if (sum.substr(-2, 2) == 'zł') 
			sum = sum.substr(0, sum.length - 3);
		if (sum.length > 0) 
			sum = parseFloat(sum);
		else 
			sum = 0;
			
		sum = sum + value;
		sum = sum.toFixed(2);
		$("#sum").val(sum + ' zł');
		
	});
	
	formatCurrency();
}

function dietCost(){
	
	var start 	= $(".travels tbody tr").children("td.datebox").first().children("input").val().split("-");
	var stop 	= $(".travels tbody tr").children("td.datebox").last().children("input").val().split("-");
	
	start 	= new Date(start[2], Number(start[1])-1, Number(start[0]), 0,0,0,0);
	stop 	= new Date(stop [2], Number(stop [1])-1, Number(stop [0]), 0,0,0,0);
	
	var days_count = Math.round((stop - start) / (1000*60*60*24));
	$("#diet").val( 30 * (days_count - 1) );
	
	$(".travels tbody tr").each(function(){
		var diet = $("#diet").val();
		
		if( isNaN( diet ) || diet == '' ) diet = 0;
		else parseFloat(diet);			
		
		var obj = $(this).children("td");			
		if ( $(this).is(":first-child") ){
			var time = obj.children("span").children().attr("aria-valuenow");
			time = Globalize.format( new Date(Number(time)),"t").split(":");
			
			if (time[0] < 12) 
				$("#diet").val( parseFloat(diet) + parseFloat(30) );
			else 
				if (time[0] >= 12 && time[0] < 16) 
					$("#diet").val( parseFloat(diet) + parseFloat(15) );			
			
		} else 
			if ( $(this).is(":last-child") ){
				var time = obj.slice(5,6).children("span").children().attr("aria-valuenow");
				time = Globalize.format( new Date(Number(time)),"t").split(":");				
			
				if (time[0] >= 8) 
					$("#diet").val( parseFloat(diet) + parseFloat(30) );
				else 
					$("#diet").val( parseFloat(diet) + parseFloat(15) );
			} 
	});
		
	summaryCost();
}
</script>