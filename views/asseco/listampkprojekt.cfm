<cfprocessingdirective pageencoding="utf-8" />
	
<div class="headerArea">
	<div class="headerArea uiHeader">
		<h3 class="uiHeaderTitle">Lista MPK</h3>
	</div>
</div>

<div class="contentArea">
	<div class="contentArea uiContent">
		<div class="uiWorkflow">
			<div class="uiWorkflowBigBox clearfix">
				<div class="uiWorkflowBigBoxStepContent workflowTable">
					
					<table class="uiTable uiAssecoTable" id="mpkTable">
						<thead>
							<tr>
								<th colspan="2">
									<input
										type="text"
										class="input mpkSearch"
										placeholder="Wyszukaj" />	
								</th>
							</tr>
							<tr>
								<th class="c">MPK</th>
								<th class="c">Nazwa</th>
							</tr>
						</thead>
						<tbody>
							
						</tbody>
					</table>

				</div>
			</div>
		</div>
		<div class="uiFooter">
		</div>
	</div>
</div>

<div class="headerArea">
	<div class="headerArea uiHeader">
		<h3 class="uiHeaderTitle">Lista Projektów</h3>
	</div>
</div>

<div class="contentArea">
	<div class="contentArea uiContent">
		<div class="uiWorkflow">
			<div class="uiWorkflowBigBox clearfix">
				<div class="uiWorkflowBigBoxStepContent workflowTable">

					<table class="uiTable uiAssecoTable" id="projektTable">
						<thead>
							<tr>
								<th colspan="5">
									<input
										type="text"
										class="input projektSearch"
										placeholder="Wyszukaj" />
								</th>
							</tr>
							<tr>
								<th>Projekt</th>
								<th>Miejsce realizacji</th>
								<th>Typ projektu</th>
								<th>Nazwa</th>
								<th>Opis</th>
							</tr>
						</thead>
						<tbody></tbody>
					</table>
					
				</div>
			</div>
		</div>
		<div class="uiFooter">
		</div>
	</div>
</div>

<div class="footerArea">

</div>

<cfset ajaxOnLoad("assecoSearchInit") />