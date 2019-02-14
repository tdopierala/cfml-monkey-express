<cfoutput>

<div class="wrapper">

	<div class="admin_wrapper">

		<h2 class="place_buildings">Nieruchomości</h2>
		
		<cfif flashKeyExists("success")>
			<span class="success">#flash("success")#</span>
		</cfif>

		#includePartial(partial="subnav")#

		<div class="admin_submenu_bar">
			<ul class="place_filters">
				<li class="title">
					Status
				</li>
				<li <cfif session.places_filter.status eq 1> class="selected" </cfif>>
					#linkTo(
						text="W trakcie",
						controller="Place_instances",
						action="index",
						params="statusid=1")#
				</li>
				<li>|</li>
				<li <cfif session.places_filter.status eq 2> class="selected" </cfif>>
					#linkTo(
						text="Zaakceptowany",
						controller="Place_instances",
						action="index",
						params="statusid=2")#
				</li>
				<li>|</li>
				<li <cfif session.places_filter.status eq 3> class="selected" </cfif>>
					#linkTo(
						text="Odrzucony",
						controller="Place_instances",
						action="index",
						params="statusid=3")#
				</li>
				<li>|</li>
				<li <cfif session.places_filter.status eq 5> class="selected" </cfif>>
					#linkTo(
						text="Archiwum",
						controller="Place_instances",
						action="index",
						params="statusid=5")#
				</li>
				<li>|</li>
				<li <cfif session.places_filter.status eq 6> class="selected" </cfif>>
					#linkTo(
						text="Zawieszone przez Controlling",
						controller="Place_instances",
						action="index",
						params="statusid=6")#
				</li>
				<li>|</li>
				<li <cfif session.places_filter.status eq 7> class="selected" </cfif>>
					#linkTo(
						text="Komitet odwoławczy",
						controller="Place_instances",
						action="index",
						params="statusid=7")#
				</li>
				<li>|</li>
				<li <cfif session.places_filter.status eq 8> class="selected" </cfif>>
					#linkTo(
						text="Zawieszone przez DT",
						controller="Place_instances",
						action="index",
						params="statusid=8")#
				</li>
				<!---<li>|</li>
				<li>
					#linkTo(
						text="Zaakceptowany warunkowo",
						controller="Place_instances",
						action="index",
						params="statusid=4")#
				</li>--->
			</ul>

			<div class="clear"></div>

			<cfform
				action="#URLFor(controller='Place_instances',action='index')#" >

				<ul class="place_filters">
					<li class="title">Filtr</li>
					<li>Etap</li>
					<li>
						<cfselect
							name="stepid"
							query="steps"
							display="stepname"
							value="id"
							queryPosition="below"
							selected="#session.places_filter.stepid#"
							class="select_box" >

							<option value="0"></option>

						</cfselect>
					</li>

					<cfif structKeyExists(session, "places_filter") and
						(session.places_filter.status eq 3 or session.places_filter.status eq 5)>

						<li>Powód odrzucenia</li>
						<li>
							<cfselect
								name="instancereasonid"
								query="reasons"
								value="id"
								display="reasonname"
								class="select_box"
								selected="#session.places_filter.instancereasonid#"
								queryPosition="below" >

								<option value="0"></option>

							</cfselect>
						</li>

					</cfif>
				</ul>
				
				<div class="clear"></div>
				
				<ul class="place_filters">
					<li class="title">Data utworzenia etapu</li>
					<li>
						<cfinput
							type="checkbox"
							name="step_order"
							value="asc"
							checked="#iif(isDefined('session.places_filter.step_order') and session.places_filter.step_order eq 'asc', 'true', 'false')#" /> <p>Rosnąco</p>

						<cfinput
							type="checkbox"
							name="step_order"
							value="desc"
							checked="#iif(isDefined('session.places_filter.step_order') and session.places_filter.step_order eq 'desc', 'true', 'false')#" /> <p>Malejąco</p>
					</li>

				</ul>

				<div class="clear"></div>
				
				<ul class="place_filters">
					<li class="title">Przeznaczenie</li>
					<li>
						<cfselect
							name="destination"
							query="selectBoxValues"
							value="val"
							display="val"
							class="select_box"
							selected="#session.places_filter.destination#"
							queryPosition="below" >

							<option value="0"></option>

						</cfselect>
					</li>
				</ul>
				
				<div class="clear"></div>

				<ul class="place_filters">
					<li class="title">Szukaj</li>
					<li>
						<cfinput
							type="text"
							name="placesearch"
							class="input"
							value="#session.places_filter.placesearch#" />
					</li>
					<li>
						<cfinput
							type="submit"
							name="filtersubmit"
							value="Znajdź"
							class="small_admin_button green_admin_button" >
					</li>
				</ul>

			</cfform>

		</div>
		
		<!--- div do wyświetlania ajaxowego filtrowania --->
		<cfdiv id="place_instances_index"> 

			<cfinclude template="_place_index_table.cfm" />
		
		</cfdiv>

		#includePartial(partial="subnav")#

	</div>

</div>

</cfoutput>

<script>
$(function() {
	$('.expand_step_forms').live('click', function(e) {
		e.preventDefault();
		$("#flashMessages").show();
		var _link		=	$(this);
		var _point		=	$(this).parent().parent();
		$.ajax({
			type		:		'get',
			dataType	:		'html',
			url			:		$(this).attr('href'),
			success		:		function(data) {
				_link.removeClass('expand_step_forms').addClass('collapse_step_forms');
				_point.after(data);
				$("#flashMessages").hide();
			}
		});
	});

	$('.collapse_step_forms').live('click', function(e) {
		e.preventDefault();

		var _link		=	$(this);
		var _point		=	$(this).parent().parent();

		_point.next().remove();
		_link.removeClass('collapse_step_forms').addClass('expand_step_forms');
	});


	$("#place_instance_table tbody>tr:has(td)").each(function() {
		var t = $(this).text().toLowerCase();
		$("<td class='indexColumn'></td>").hide().text(t).appendTo(this);
	});

	$("#tablesearch").live("keyup", function(e) {
		var s = $(this).val().toLowerCase().split(" ");
		$("#place_instance_table tbody>tr:hidden").show();
		$.each(s, function() {
			$("#place_instance_table tbody>tr:visible .indexColumn:not(:contains('" + this + "'))").parent().hide();
		});
	});

	$(':checkbox').on('change',function(){
		var th = $(this), name = th.attr('name'); 
		if(th.is(':checked')){
			$(':checkbox[name="'  + name + '"]').not(th).prop('checked',false);   
		}
	});


});
</script>
