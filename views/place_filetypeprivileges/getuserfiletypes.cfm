<cfoutput>

	<tr>

		<td class="first">&nbsp;</td>
		<td colspan="2" class="admin_submenu_options">

			<table class="admin_table">

				<thead>
					<tr>
						<th class="first">&nbsp</th>
						<th>Typ pliku</th>
						<th class="c">Odczyt</th>
						<th class="c">Zapis</th>
						<th class="c">Usunięcie</th>
					</tr>
				</thead>
				<tbody>

					<cfloop query="filetypes">

						<tr>

							<td class="first"></td>
							<td>#filetypename#</td>
							<td class="c">

								#checkBoxTag(
									name="readprivilege",
									class="readprivilege {id:#id#}",
									checked=YesNoFormat(readprivilege))#

							</td>
							<td class="c">

								#checkBoxTag(
									name="writeprivilege",
									class="writeprivilege {id:#id#}",
									checked=YesNoFormat(writeprivilege))#

							</td>
							<td class="c">

								#checkBoxTag(
									name="deleteprivilege",
									class="deleteprivilege {id:#id#}",
									checked=YesNoFormat(deleteprivilege))#

							</td>
						</tr>

					</cfloop>

				</tbody>

			</table>

		</td>

	</tr>

</cfoutput>