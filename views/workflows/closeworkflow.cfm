<cfoutput>

	<div class="wrapper">
		
		<h3>Zamknięto obieg dokumentu</h3>
		
		<div class="wrapper">
		
			<cfoutput>#includePartial(partial="/workflows/previewsubnav")#</cfoutput>
		
		</div>
		
		<div class="wrapper">
			#imageTag(source="unknown.png",class="accessdeny")#
			
			<div class="autherrorinfo">
				Nie masz więcej dokumentów przypisanych do siebie.<br/>
				Możesz przejść do #linkTo(text="swojego profilu",controller="Users",action="view",key=session.userid)# lub bezpośrednio do #linkTo(text="listy aktywnych dokumentów",controller="Users",action="getUserActiveWorkflow",key=session.userid,class="ajaxlink")#.
			</div>
		</div>
	</div>
	

	
</cfoutput>