<li>
	<label for="attrid">Atrybut</label>
	<select name="attrid" class="select_box">
		<cfoutput query="attributes">
			<option value="#id#.#attribute_type_id#">#attribute_name#</option>
		</cfoutput>
	</select>
	<a href="#" class="add_object_attribute" title="Dodaj atrybut do obiektu">+</a>
</li>