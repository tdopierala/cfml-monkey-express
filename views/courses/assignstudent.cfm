<cfoutput>
	<div class="wrapper">
		
		<div class="wrapper formbox">
			<h5>Przypisz studenta do kursu</h5>
			#hiddenFieldTag(name="cid",value=params.cid)#
			#selectTag(name="sid", label="Imię i nazwisko kandydata", labelPlacement="before", options=students, includeBlank="-- wybierz --")#
		</div>
		
	</div>
</cfoutput>