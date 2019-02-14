<cfprocessingdirective pageEncoding="utf-8" />

<div class="wrapper">
	<div class="admin_wrapper">
		<h2 class="place_buildings">Raport nieruchomości</h2>
		<div class="admin_submenu_bar">
			<cfform
				action="#URLFor(controller='Place_instances',action='report',params='file=true')#"
				name="place_report_form" >
					
			<ul class="place_filters pad">
				<li>
					<cfinput
						name="report_date_from"
						type="text"
						class="input_small date_picker"
						placeholder="Raport od"
						value="#DateFormat(Now(), 'yyyy-mm-dd')#" /> 
				</li>
				<li>
					<cfinput
						name="report_date_to"
						type="text"
						class="input_small date_picker"
						placeholder="do"
						value="#DateFormat(Now(), 'yyyy-mm-dd')#" />
				</li>
			</ul>
			<ul class="place_filters pad">
				<li class="clearfix">
					<label for="report_output">Eksport do pliku xls</label>
					<cfinput 
						name="report_output"
						type="radio" 
						value="xls"
						checked="true" />
				</li>
				<!---<li>
					<label for="report_output">Eksport do pliku csv</label>
					<cfinput
						name="report_output"
						type="radio"
						value="csv" /> 
				</li>--->
			</ul>
			<ul class="place_filters">
				<li>
					<cfinput
						name="place_report_form_submit"
						type="submit"
						value="Generuj"
						class="admin_button green_admin_button" /> 
				</li>
			</ul>
			
			</cfform>
		</div>
	</div>
</div>