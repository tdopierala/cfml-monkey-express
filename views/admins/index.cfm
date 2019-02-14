<cfoutput>

<div class="wrapper">

	<div class="admin_wrapper">

		<h2 class="admin_panel">Panel administracyjny</h2>

		<table class="admin_table">
			<thead>
				<tr>
					<th class="first">&nbsp;</th>
					<th>Nazwa modułu</th>
					<th>Komentarz</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>
						#linkTo(
							text="<span>rozwiń</span>",
							href="javascript:void(0)",
							class="expand_step_forms")#
					</td>
					<td>Moduł nieruchomości</td>
					<td>&nbsp;</td>
				</tr>
				<tr class="hide_admin_step_forms">
					<td>&nbsp;</td>
					<td colspan="2" class="admin_submenu_options">

						<ul class="admin_row_options">
							<li class="title">Formularze</li>
							<li>
								#linkTo(
									text="Lista formularzy",
									controller="Place_forms",
									action="index")#
							</li>
							<li>
								#linkTo(
									text="Lista pól formularzy",
									controller="Place_forms",
									action="fields")#
							</li>
							<li>
								#linkTo(
									text="Nowy formularz",
									controller="Place_forms",
									action="add")#
							</li>
							<li>
								#linkTo(
									text="Nowe pole formularza",
									controller="Place_forms",
									action="addField")#
							</li>
							<li>
								#linkTo(
									text="Przypisz pole do formularza",
									controller="Place_forms",
									action="assignField")#
							</li>
							<li>
								#linkTo(
									text="Przypisz formularz do etapu",
									controller="Place_forms",
									action="assignToStep")#
							</li>

						</ul>

						<ul class="admin_row_options">
							<li class="title">Elementy</li>
							<li>
								#linkTo(
									text="Zdjęcia",
									controller="Place_photos",
									action="index")#
							</li>
							<li>
								#linkTo(
									text="Pliki",
									controller="Place_files",
									action="index")#
							</li>
							<li>
								#linkTo(
									text="Etapy",
									controller="Place_place",
									action="index")#
							</li>
							<li>
								#linkTo(
									text="Raporty",
									controller="Place_reports",
									action="index")#
							</li>
							<li>
								#linkTo(
									text="Lista narzędzi",
									controller="Place_tools",
									action="index")#
							</li>
						</ul>

						<ul class="admin_row_options">
							<li class="title">Zbiory</li>
							<li>
								#linkTo(
									text="Lista zbiorów",
									controller="Place_collections",
									action="index")#
							</li>
							<li>
								#linkTo(
									text="Dodaj zbiór",
									controller="Place_collections",
									action="add")#
							</li>
							<li>
								#linkTo(
									text="Przypisz zbiór do etapu",
									controller="Place_collections",
									action="assignToStep")#
							</li>
							<li>
								#linkTo(
									text="Dodaj pole do zbioru",
									controller="Place_collections",
									action="assignField")#
							</li>
						</ul>

						<ul class="admin_row_options">
							<li class="title">UPRAWNIENIA</li>
							<li>
								#linkTo(
									text="Uprawnienia do formularzy",
									controller="Place_formprivileges",
									action="index")#
							</li>
							<li>
								#linkTo(
									text="Uprawnienia do zbiorów",
									controller="Place_collectionprivileges",
									action="index")#
							</li>
							<li>
								#linkTo(
									text="Uprawnienia do plików",
									controller="Place_filetypeprivileges",
									action="index")#
							</li>
							<li>
								#linkTo(
									text="Uprawnienia do zdjęć",
									controller="Place_phototypeprivileges",
									action="index")#
							</li>
							<li>
								#linkTo(
									text="Uprawnienia do etapów",
									controller="Place_stepprivileges",
									action="index")#
							</li>
							<li>
								#linkTo(
									text="Uprawnienia do raportów",
									controller="Place_reportprivileges",
									action="index")#
							</li>
							<li>
								#linkTo(
									text="Rejonizacja",
									controller="Place_tree_privileges",
									action="index")#
							</li>
						</ul>

					</td>
				</tr>
				<tr>
					<td>
						#linkTo(
							text="<span>rozwiń</span>",
							href="##",
							class="expand_step_forms")#
					</td>
					<td>Protokoły</td>
					<td>&nbsp;</td>
				</tr>
				<tr class="hide_admin_step_forms">
					<td>&nbsp;</td>
					<td colspan="2" class="admin_submenu_options">
						<ul class="admin_row_options">
							<li>
								#linkTo(
									text="Pola protokołów",
									controller="protocol_fields",
									action="index")#
							</li>
							<li>
								#linkTo(
									text="Rodzaje protokołów",
									controller="protocol_types",
									action="index")#
							</li>
						</ul>
					</td>
				</tr>

				<!---
					Konfiguracja sklepów
				--->
				<tr>
					<td>
						#linkTo(
							text="<span>rozwiń</span>",
							href="##",
							class="expand_step_forms")#
					</td>
					<td>Sklepy</td>
					<td>&nbsp;</td>
				</tr>
				<tr class="hide_admin_step_forms">
					<td class="">&nbsp;</td>
					<td class="admin_submenu_options" colspan="2">
						<ul class="admin_row_options">
							<li>
								#linkTo(
									text="Regały",
									controller="Store_shelfs",
									action="index")#
							</li>
							<li>
								#linkTo(
									text="Obiekty",
									controller="Store_objects",
									action="index")#
							</li>
							<li>
								<a 
									href="#URLFor(controller='Store_diagrams',action='index')#"
									class="Planogramy">
								
									<span>Planogramy</span>
										
								</a>
							</li>
						</ul>
					</td>
				</tr>

				<!---
					Grupy uprawnień
				--->
				<tr>
					<td>
						#linkTo(
							text="<span>rozwiń</span>",
							href="##",
							class="expand_step_forms")#
					</td>
					<td>Grupy uprawnień</td>
					<td>&nbsp;</td>
				</tr>
				<tr class="hide_admin_step_forms">
					<td class="">&nbsp;</td>
					<td class="admin_submenu_options" colspan="2">
						<ul class="admin_row_options">
							<li>
								#linkTo(
									text="Uprawnienia",
									controller="Tree_groups",
									action="index")#
							</li>
							<li>
								#linkTo(
									text="Rejonizacja ekspansyjna",
									controller="Place_tree_privileges",
									action="index")#
							</li>
							<li>
								#linkTo(
									text="Rejonizacja sprzedażowa",
									controller="Rejonizacja",
									action="index")#
							</li>
							<li>
								<a href="#URLFor(controller='Workflow_stepusers', action='index')#" title="Użytkownicy w obiegu dokumentów">
									Użytkownicy w obiegu dokumentów
								</a>
							</li>
							<li>
								<a href="index.cfm?controller=folder_users&action=privileges" title="Uprawnienia uzytkoników do teczek">Uprawnienia użytkowników do teczek</a>
							</li>
						</ul>
					</td>
				</tr>
				
				<!---
					Peryferia
				--->
				<tr>
					<td>
						#linkTo(
							text="<span>rozwiń</span>",
							href="javascript:void(0)",
							class="expand_step_forms")#
					</td>
					<td>Peryferia</td>
					<td>&nbsp;</td>
				</tr>
				<tr class="hide_admin_step_forms">
					<td class="">&nbsp;</td>
					<td class="admin_submenu_options" colspan="2">
						<ul class="admin_row_options">
							<li>
								<a href="#URLFor(controller='Application_execute',action='ftp')#">
									FTP
								</a>
							</li>
							<li>
								<a href="#URLFor(controller='Place_pzwr',action='index')#">
									Nieruchomości z formularza
								</a>
							</li>
						</ul>
					</td>
				</tr>
				
				<!---
					Ubezpieczenia
				--->
				<tr>
					<td>
						#linkTo(
							text="<span>rozwiń</span>",
							href="javascript:void(0)",
							class="expand_step_forms")#
					</td>
					<td>Ubezpieczenia</td>
					<td>&nbsp;</td>
				</tr>
				<tr class="hide_admin_step_forms">
					<td class="">&nbsp;</td>
					<td class="admin_submenu_options" colspan="2">
						<ul class="admin_row_options">
							<li>
								<a href="#URLFor(controller='Insurance_questions',action='index')#">
									Pytania
								</a>
							</li>
						</ul>
					</td>
				</tr>
			</tbody>
		</table>

	</div>

</div>

</cfoutput>

<script>
$(function(){
	$('.expand_step_forms,.collapse_step_forms').click(function(){
		$(this).toggleClass('.expand_step_forms').toggleClass('collapse_step_forms');
		$(this).parent().parent().next('tr').toggleClass('hide_admin_step_forms');
	});
});
</script>
