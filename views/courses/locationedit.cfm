<div class="wrapper courses">
	
	<h3>Edycja lokalizacji</h3> 
	<cfoutput>
		<form action="#URLFor(controller='Courses', action='locationAdd')#" method="post" id="location-form">
			<div>#hiddenFieldTag(name="key", value=location.id, class="formfield")#</div>
			
			<div class="wrapper formbox">				
				<ol>
					<li class="text-field">
						#textFieldTag(name="loc_projekt", label="Nr projektu/sklepu", labelPlacement="before", value=location.projekt, class="formfield input text-field-tag")#
					</li>
					<li class="text-field">
						#textFieldTag(name="loc_city", label="Miejscowość", labelPlacement="before", value=location.city, class="formfield input text-field-tag")#
					</li>
					<li class="text-field">
						#textFieldTag(name="loc_street", label="Ulica i numer", labelPlacement="before", value=location.adress, class="formfield input text-field-tag")#
					</li>
					<li class="text-field">
						#textFieldTag(name="loc_postcode", label="Kod pocztowy", labelPlacement="before", value=location.postcode, class="formfield input text-field-tag")#
					</li>
				</ol>

			</div>
		
		</form>
	</cfoutput>
</div>
<!---<cfdump var="#location#" />--->