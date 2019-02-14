<cfoutput>
	<tr>
		<td>&nbsp;</td>
		<td>Plik</td>
		<td>
			<input
				type="file"
				name="phototypefile[#i#]"
				accept="image/jpg,image/png,application/pdf" />

			<span class="info">Maksymalna wielkość przesłanego pliku to 750KB</span>
		</td>
		<td>
			#linkTo(
				text="+",
				controller="Place_photos",
				action="addFileRow",
				key=i,
				class="add_file_row small_admin_button green_admin_button")#
		</td>
	</tr>
</cfoutput>