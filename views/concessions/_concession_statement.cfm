<cfoutput>
	<div class="concesssion-statement">
		
		#startFormTag(action="save-document", id="document-form")#
		
			#hiddenFieldTag(name="document[id]", value=document.id)#
			#hiddenFieldTag(name="document[type]", value=document.type)#
			#hiddenFieldTag(name="document[proposalurl]", value=URLFor(controller="Concessions", action="edit-proposal", key=document.proposalid))#
			
			#hiddenFieldTag(name=attributes[33].id, value=document.created)#
			#hiddenFieldTag(name=attributes[34].id, value=user.givenname&" "&user.sn)#
			#hiddenFieldTag(name=attributes[35].id, value=store.projekt)#
			
			<p class="document-header">Załącznik nr 3 do Instrukcji nr 3/2012/DF</p>
			<br />
			<p class="document-header">Poznań, dnia #DateFormat(document.created, "dd.mm.yyyy")# r.</p>
			<br />
			<h4>OŚWIADCZENIE</h4>
			<br />
			<p>Ja niżej podpisany / podpisana <strong>#user.givenname# #user.sn#</strong></p>
			
			<p>niniejszym oświadczam, że w chwili wygaśnięcia lub rozwiązania Umowy o Współdziałaniu i Współpracy ze Spółką Monkey Group 
			rezygnuję z działalności dotyczącej handlu napojami alkoholowymi w sklepie o numerze <strong>#store.projekt#</strong> położonym w:</p>
			<br />
			<p>
			<cfif attributes[37].value eq ''>
				<cfset adres = store.adressklepu />
			<cfelse>
				<cfset adres = attributes[37].value />
			</cfif>
			#textFieldTag(
				name=attributes[37].id,
				value=adres,
				label="adres sklepu",
				labelPlacement="after",
				class="text"
			)#
			</p>
			<br />
			<p>należącym do sieci handlowej Monkey Group i jednocześnie upoważniam Spółkę Monkey Group do zdania 
			oryginału Zezwolenia na handel napojami alkoholowymi w organie, który to zezwolenie wydał.</p>
			
		#endFormTag()#
			
	</div>
</cfoutput>
<script>
	$(function(){
		
		$('#document-form').ajaxForm({
			dataType	: 'json',
			type		: 'post',
			beforeSubmit: function(arr, $form, options){
				
				
			},
			success: function (responseText, statusText, xhr, $form){
								
				$.get(<cfoutput>"#URLFor(controller='Concessions', action='view-document', key=document.id, params='mod=true')#"</cfoutput>,
					function() {
						
						$("#flashMessages").hide();
						document.location = $("#document-proposalurl").val();
						
					}
				);
			}
		});
		
	});
</script>