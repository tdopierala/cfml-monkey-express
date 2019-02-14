<cfoutput>
	<div class="wrapper proposalpps">
		<h3>Lista wniosków o wymianę PPS</h3>
		
		<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="_kos" >
			<cfinvokeargument name="groupname" value="KOS" />
		</cfinvoke>
		
		<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="_root" >
			<cfinvokeargument name="groupname" value="root" />
		</cfinvoke>
		
		<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="_personalny" >
			<cfinvokeargument name="groupname" value="Departament Personalny" />
		</cfinvoke>
		
		<cfif flashKeyExists("success")>
			<span class="success">#flash("success")#</span>
		<cfelseif flashKeyExists("error")>
			<span class="error">#flash("error")#</span>
		</cfif>
		
		<cfif _kos is true or _root is true>
			<div class="intranet-backlink">
				<a href="#URLFor(action='add')#">Nowy wniosek</a>
			</div>
		</cfif>
		
		<table id="proposal-table" class="tables proposal-table">
			<thead>
				<tr>
					<th>Nr</th>
					<th>Projekt</th>
					<th>Data dodania</th>
					<th>KOS</th>
					<th>Etap</th>
					<cfif _personalny is true>
						<th>Status wymiany</th>
					</cfif>
					<th></th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="proposals">
					<tr>
						<td>#lp#</td>
						<td>#projekt#</td>
						<td>#DateFormat(createddate, "yyyy-mm-dd")#</td>
						<td>#username#</td>
						<td>
							<cfswitch expression="#statusid#">
								<cfcase value="1">
									<span>oczekuje na akceptację</span>
								</cfcase>
								<cfcase value="2">
									<span class="status_accepted">zaakceptowany</span>
								</cfcase>
								<cfcase value="3">
									<span class="status_rejected">odrzucony</span>
								</cfcase>
							</cfswitch>
						</td>
						<cfif _personalny is true>
							<td style="width:100px;text-align:center;">
								<cfif completed eq 0>
									<img src="images/progress-bar.png" title="w trakcie" class="complete-proposal" data-key="#id#"/>
									<!---#imageTag(source="progress-bar.png", title="w trakcie", class="complete-proposal")#--->
								<cfelse>
									<img src="images/accept.png" title="wymieniony" />
									<!---#imageTag(source="accept.png", title="wymieniony")#--->
								</cfif>
							</td>
						</cfif>
						<td>#linkTo(
							text=imageTag("search_view.png"), 
							action="view", 
							key=id)#</td>
					</tr>
				</cfloop>
			</tbody>
		</table>

	</div>
</cfoutput>
<cfif session.user.id eq 345>
<!---<cfdump var="#proposals#" />--->
</cfif>
<!---<cfdump var="#params#"/>--->
<script>
	$(function(){
		
		$(".complete-proposal").on("click", function(){
			$this = $(this);
			$key = $this.data("key");
			
			if(confirm("Czy na pewno chcesz oznaczyć jako \"wymieniony\"?")){
				$("#flashMessages").show();
				$.ajax({
					url: <cfoutput>"#URLFor(action='confirm')#"</cfoutput>,
					type: "get",
					dataType: "json",
					data: { key: $key },
					success: function( data ) {
						console.log(data);
						$this.prop("src","images/accept.png").removeClass("complete-proposal");
						$("#flashMessages").hide();
					},
					error: function(){
						$("#flashMessages").hide();
						alert("Błąd . Spróbuj ponownie później.");
					}
				});
			}
		});
	});
</script>