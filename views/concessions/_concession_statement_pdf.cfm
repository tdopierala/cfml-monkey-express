<cfdocument format="pdf" fontEmbed="yes" pageType="A4" name="protocolpdf">

<style type="text/css" media="screen">
<!--
  @import url("stylesheets/concessionpdf.css");
-->
</style>
	<cfoutput>
		<div class="warpper pdf concesssion-statement">
					
			<p class="document-header">Załącznik nr 3 do Instrukcji nr 3/2012/DF</p>
			<br />
			<p class="document-header right">Poznań, dnia #DateFormat(document.created, "dd.mm.yyyy")# r.</p>
			<br />
			<h4><center>OŚWIADCZENIE</center></h4>
			<br />
			<p>Ja niżej podpisany / podpisana <strong>#user.givenname# #user.sn#</strong></p>
			
			<p>niniejszym oświadczam, że w chwili wygaśnięcia lub rozwiązania Umowy o Współdziałaniu i Współpracy ze Spółką Monkey Group 
			rezygnuję z działalności dotyczącej handlu napojami alkoholowymi w sklepie o numerze <strong>#store.projekt#</strong> położonym w:</p>
			<br />
			<p>
			#attributes[37].value#
			</p>
			<br />
			<p>należącym do sieci handlowej Monkey Group i jednocześnie upoważniam Spółkę Monkey Group do zdania 
			oryginału Zezwolenia na handel napojami alkoholowymi w organie, który to zezwolenie wydał.</p>
			
		</div>
	</cfoutput>
</cfdocument>