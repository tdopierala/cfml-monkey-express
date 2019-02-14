<cfoutput>

	<div class="wrapper">
		
		<ol class="mapnav">
			<!---<li>
				#linkTo(
				text="<span>Nowa mapa</span>",
				controller="Maps",
				action="add",
				class="ajaxlink newmap")#
			</li>--->
			
			<cfif IsDefined("place")>
				<li>
					#linkTo(
						text="<span>Lista map</span>",
						controller="Maps",
						action="list",
						key=place.id,
						class="ajaxlink maplist")#
				</li>
			</cfif>
			
			<cfif IsDefined("place")>
				<li>
					#linkTo(
						text="<span>Zapisz mapę</span>",
						controller="Maps",
						action="savePlace",
						key=place.id,
						class="togglemapname save")#
				</li>
			</cfif>
		</ol>
	
		<div class="clear"></div>
	
		<div class="mapnameelement" style="display:none;">
			<ol class="mapnav">
				<li>
					#textFieldTag(
						name="mapname",
						label=false,
						placeholder="Proszę podać nazwę mapy",
						class="input mapname",
						id="mapname")#
				</li>
				<li>
					#linkTo(
						text="<span>>></span>",
						controller="Maps",
						action="savePlace",
						key=place.id,
						class="savemap")#
				</li>
			</ol>
		</div>
	
	</div>

</cfoutput>