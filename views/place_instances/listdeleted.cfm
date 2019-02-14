<cfprocessingdirective pageencoding="utf-8" />

<cfoutput>
<div class="wrapper">
	<div class="admin_wrapper">
		<h2 class="place_buildings">Usunięte nieruchomości</h2>
		
		<cfif flashKeyExists("success")>
	    	<span class="success">#flash("success")#</span>
		</cfif>
		
		<div class="admin_submenu_bar">
			<cfform
				name="deleted_place_filter_form"
				action="#URLFor(controller='Place_instances',action='listDeleted')#" >
				
				<ul class="place_filters">
					<li class="title"Etap></li>
					<li>
						<cfselect
							name="stepid"
							query="steps"
							display="stepname"
							value="id"
							queryPosition="below"
							selected="#session.places_filter.step#"
							class="select_box" >

							<option value=""></option>

						</cfselect>
					</li>
					<li>
						<cfinput
							type="submit"
							name="deleted_place_filter_form_submit"
							class="admin_button green_admin_button"
							value="Filtruj" />
					</li>
				</ul>
				
			</cfform>
		</div>
		
		<cfdiv id="deleted_places_list" class="">
			<cfinclude template="_place_deleted_table.cfm" />
		</cfdiv>
		
	</div>
</div>
</cfoutput>