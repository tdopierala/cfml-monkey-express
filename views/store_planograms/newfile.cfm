<cfoutput>
	<tr>
		<td>&nbsp;</td>
		<td>Plik</td>
		<td>
			<input type="file" id="file[#number#]" name="file[#number#]" />
		</td>
		<td>
			#linkTo(
				text="+",
				controller="Store_planograms",
				action="newFile",
				key=number,
				class="small_admin_button green_admin_button add_file")#
		</td>
	</tr>				
</cfoutput>