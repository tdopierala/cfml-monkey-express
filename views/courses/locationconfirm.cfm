<div class="wrapper courses">
	
	<h3>Status rekrutacji</h3> 
	<cfoutput>
		<form action="#URLFor(controller='Courses', action='locationConfirm')#" method="post" id="location-form">
			<div>#hiddenFieldTag(name="key", value=location.id, class="formfield")#</div>
						
			<div class="wrapper formbox">				
				<ol>
					<li class="text-field">
						#selectTag(name="loc_contract", options=contractstatus, selected=location.contract, includeBlank="-- wybierz --", label="Status umowy", labelPlacement="before", class="formfield")#
					</li>
					<li class="text-field">
						<cfif location.asseco eq 1>
							<cfset checked = true />
						<cfelse>
							<cfset checked = false />
						</cfif>
						#checkBoxTag(name="loc_asseco", label="Wprowadzony do asseco", labelPlacement="before", value="1", uncheckedValue="0", checked=checked, class="formfield")#
					</li>
					<li class="text-field">
						#textFieldTag(name="loc_planneddate", label="Data przęjcia sklepu", labelPlacement="before", value=DateFormat(location.planneddate, "dd.mm.yyyy"), class="formfield input text-field-tag date_picker")#
					</li>
					<li class="text-field">
						#textFieldTag(name="loc_dsdate", label="Data przekazania do DS", labelPlacement="before", value=DateFormat(location.dsdate, "dd.mm.yyyy"), class="formfield input text-field-tag date_picker")#
					</li>
				</ol>

			</div>
		
		</form>
	</cfoutput>
</div>
<script>
	$(function(){		
		$('.date_picker').datepicker({
			showOn: "both",
			buttonImage: "images/schedule.png",
			buttonImageOnly: true,
			dateFormat: 'dd.mm.yy',
			monthNames: ['Styczeń', 'Luty', 'Marzec', 'Kwiecień', 'Maj', 'Czerwiec', 'Lipiec', 'Sierpień', 'Wrzesień', 'Październik', 'Listopad', 'Grudzień'],
			dayNamesMin: ['Ni', 'Po', 'Wt', 'Śr', 'Cz', 'Pt', 'So'],
			firstDay: 1
		});
	});
</script>