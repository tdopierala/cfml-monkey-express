<cfform name="definicjePol" action="index.cfm?controller=rekrutacja_pola&action=zapisz-pole">
	<ol class="horizontal_right">
		<li>
			<label for="nazwaPola">Nazwa pola</label>
			<cfinput type="text" class="input" name="nazwaPola" />
		</li>
		<li>
			<label for="idTypuPola">Typ pola</label>
			<select name="idTypuPola" class="select_box">
				<cfoutput query="typyPol">
					<option value="#idTypuPola#">#nazwaTypuPola#</option>
				</cfoutput>
			</select>
		</li>
		<li>
			<span class="labelBlock">&nbsp;</span>
			<cfinput type="submit" name="definicjePolSubmit" class="btn btn-green" value="Zapisz" />
		</li>
	</ol>
</cfform>