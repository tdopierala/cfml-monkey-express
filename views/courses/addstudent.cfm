<cfoutput>
	<div class="wrapper">
		
		<div class="wrapper proposalform">
			#selectTag(name="students",label="Imię i nazwisko kandydata",labelPlacement="before",options=students,includeBlank="-- wybierz --")#
		</div>
		
		<div class="wrapper proposalform">
			
			#hiddenFieldTag(name="proposalid",value="")#
			
			#textFieldTag(name="nip", label="Nip", labelPlacement="before", class="student_input")#
			
			#textFieldTag(name="regon", label="Regon", labelPlacement="before", class="student_input")#
			
			#textFieldTag(name="docid", label="Nr dowodu", labelPlacement="before", class="student_input")#
			
			#textFieldTag(name="adress", label="Adres zamieszkania", labelPlacement="before", class="student_input")#
			
			#textFieldTag(name="email", label="Adres email", labelPlacement="before", class="student_input")#
			
			#textFieldTag(name="phone", label="Nr telefonu", labelPlacement="before", class="student_input")#
			
			#textFieldTag(name="kod", label="Kod", labelPlacement="before", class="student_input")#
			
			#textFieldTag(name="mpk", label="MPK", labelPlacement="before", class="student_input")#
			
		</div>
		
	</div>
</cfoutput>