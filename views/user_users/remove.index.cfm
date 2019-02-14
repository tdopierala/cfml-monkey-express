<cfsilent>
</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Lista użytkowników</h3>
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">
			
			<cfdiv id="usersTable" bind="url:index.cfm?controller=user_users&action=users_table&strona=#r.STRONA#&elementy=#r.ELEMENTY#"></cfdiv>
			
			<cfoutput>
			<a href="javascript:ColdFusion.navigate('index.cfm?controller=user_users&action=index&page=#r.STRONA+1#', 'strona-#r.STRONA+1#')">Pobierz więcej</a>
			</cfoutput>
			<div class="uiFooter">
			</div>
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>