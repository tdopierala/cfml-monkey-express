<cfoutput>
		
		<div class="wrapper formbox">
			<h5>Przeniesienie na inne szkolenie</h5>
			<div class="move-form" data-ocid="#params.cid#" data-sid="#student.id#">
				<div>
					<label>Imię i nazwisko</label>
					<span>#student.name#</span>
				</div>
				
				<div>
					#selectTag(name="courseid", options=courses, label="Przenieś na szkolenie", labelPlacement="before", includeBlank="-- wybierz --")#
				</div>
			</div>
		</div>
		

</cfoutput>