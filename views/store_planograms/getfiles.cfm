<cfoutput>

	<tr>
		
		<td class="first">&nbsp;</td>
		<td class="admin_submenu_options" colspan="2">
			
			<ul class="store_row_options">
				<li class="title">Pliki</li>
				<cfloop query="my_planogram_files">
					<li>
						
						#linkTo(
							text=filename,
							href="files/planograms/#filename#",
							target="_blank")#
						
					</li>
				</cfloop>
			</ul>
			
		</td>
		
	</tr>

</cfoutput>