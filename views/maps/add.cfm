<cfoutput>

	<div class="wrapper">
	
		<h5>Dodaj mapę</h5>
		
		#startFormTag(controller="Maps",action="actionAdd",multipart=true)#
		<ol class="horizontal">
			<li>
				#textFieldTag(
					name="mapname",
					label="Nazwa mapy",
					labelPlacement="before",
					class="input")#
			</li>
			<li>
				#textFieldTag(
					name="mapaddress",
					label="Adres na mapie",
					labelPlacement="before",
					class="input")#
			</li>
			
			<li>
				#selectTag(
					name="maptype",
					options="",
					label="Typ mapy",
					labelPlacement="before")#
			</li>
			
			<li>
				#selectTag(
					name="mapzoom",
					options="",
					label="Zoom",
					labelPlacement="before")#
			</li>
			
			<li>
				#submitTag(value="Zapisz",class="button redButton")#
			</li>
		
		</ol>
		#endFormTag()#
	
	</div>

</cfoutput>