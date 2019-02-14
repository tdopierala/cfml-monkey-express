<li>
	<label for="attrid">Atrybut</label>
	<select name="attrid" id="attrid" class="select_box">
		<cfoutput query="attributes">
			<option value="#id#.#attribute_type_id#.#formid#">#attribute_name#</option>
		</cfoutput>
	</select>
	<a href="#" class="add_form_definition_attribute" title="Dodaj atrybut">+</a>
</li>