<cfprocessingdirective pageencoding="utf-8" />

<cfsilent>
</cfsilent>

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Brak pliku PDF faktury</h3>
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">
			
			W systemie nie odnaleziono pliku PDF dla faktury o numerze Intranetowym <cfoutput>#dokument.getDocumentname()#</cfoutput>.<br />
			<cfif Len( dokument.getSys() )>
				
				Aby dodać brakujący plik proszę go pozyskać z serwisu <a href="http://afaktury.pl">afaktury.pl</a> lub skontaktować się z <a href="mailto:testuser@monkey.xyz">Jarosławem Deresińskim</a>.<br />
				Pozyskany plik winien mieć nazwę <cfoutput>#dokument.getDocument_file_name()#</cfoutput>. Taki plik proszę przesłać na adres <a href="mailto:webmaster@monkey.xyz">webmaster@monkey.xyz</a> lub <a href="mailto:admin@monkey.xyz">admin@monkey.xyz</a>.
				
			<cfelse>
					
				Aby dodać brakujący plik, proszę do ponownie zeskanować i przesłać na adres <a href="mailto:webmaster@monkey.xyz">webmaster@monkey.xyz</a> lub <a href="mailto:admin@monkey.xyz">admin@monkey.xyz</a>.
			<br />
				Plik powinien mieć nazwę <cfoutput>#replace(dokument.getDocumentname(), "/", "_", "ALL")#.pdf</cfoutput>.
					
			</cfif> 
			<div class="uiFooter">
			</div>
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>