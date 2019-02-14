<li>
	<label for="attrid">Atrybut obiektu</label>
	<select name="attrid" id="attrid" class="select_box">
		<cfoutput query="attributes">
			<option value="#id#.#attribute_type_id#.#objectid#">#attribute_name#</option>
		</cfoutput>
	</select>
	<a href="#" class="add_object_definition_attribute" title="Dodaj atrybut do obiektu">+</a>
</li>