<cfoutput>

	<div class="wrapper">
	
		<h3>Formularz zgłoszenia lokalizacji</h3>
		
		<div class="wrapper">
		
			<div class="informations refuse">
				Warunkiem koniecznym jest aby każda zgłoszona lokalizacja miała potwierdzoną możliwość uzyskania koncesji. Lokaliacja, której sala sprzedażowa ma poniżej 70m2 nie jest brana pod uwagę.
			</div>
			
			#startFormTag(controller="places",action="actionNewPlaceForm")#
				<ol class="horizontal placesform">
					<li>
						#textArea(
							objectName="place",
							property="formularz_adres_lokalizacji",
							label="Adres lokalizacji",
							labelPlacement="before",
							class="textarea required")#
					</li>
					<li>
						#textField(
							objectName="place",
							property="formularz_czynsz",
							label="Czynsz",
							labelPlacement="before",
							class="input required")#
					</li>
					<li>
						#textField(
							objectName="place",
							property="formularz_powierzchnia_lokalu",
							label="Powierzchnia lokalu",
							labelPlacement="before",
							class="input required")#
					</li>
					<li>
						#textField(
							objectName="place",
							property="formularz_powierzchnia_sali_sprzedazowej",
							label="Powierzchnia sali sprzedażowej",
							labelPlacement="before",
							class="input required")#
					</li>
					<li>
						#textField(
							objectName="place",
							property="formularz_konkurencja",
							label="Znacząca konkurencja",
							labelPlacement="before",
							class="input required")#
					</li>
					<li>
						#textField(
							objectName="place",
							property="formularz_typ_lokalizacji",
							label="Typ lokalizacji",
							labelPlacement="before",
							class="input required")#
					</li>
					<li>
						#textArea(
							objectName="place",
							property="formularz_osoba_kontaktowa",
							label="Osoba kontaktowa",
							labelPlacement="before",
							class="textarea required")#
					</li>
					<li>
						#checkBoxTag(
							name="concession",
							checked=false,
							value=1,
							label=false,
							class="required")#
						Potwierdzona możliwość uzyskania koncesji.
					</li>
					<li>
						#submitTag(value="Zapisz",class="button redButton")#
					</li>
					
				</ol>
			#endFormTag()#
		
		</div>
	
	</div>

</cfoutput>

<script>

$(function() {
	/*
	 * Dodaje gwiazdki przy wymaganych polach formularza.
	 */
	$('.required').each(function (index) {
		$(this).parent().append("<span class=\"requiredfield\">*</span>");
	});
});

</script>