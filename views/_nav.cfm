<cfoutput>
	<ul class="ul_bar">

		<li class="monkeylogo">
			<cfif structKeyExists(session, "user") and structKeyExists(session.user, "id")>

				#linkTo(
					text="<span>Monkey Express</span>",
					controller="Users",
					action="view",
					key=session.user.id,
					title="Profil użytkownika #session.user.givenname# #session.user.sn#")#

			<cfelse>

				#linkTo(
					text="<span>Monkey Express</span>",
					controller="Users",
					action="logIn",
					title="Zaloguj się")#

			</cfif>
		</li>
		<li class="noRightMargin">
			<cfif structKeyExists(session, "user") and structKeyExists(session.user, "id")>
				<a href="#URLFor(controller='Users',action='logOut')#" title="Wyloguj się" class="logOut">
					<span>Wyloguj się</span>
				</a>
			</cfif>
		</li>
		
		<!---<cfinvoke
			component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="__root" >
			<cfinvokeargument name="groupname" value="root" />
		</cfinvoke>
		
		<cfif __root is true>--->
			<cfif structKeyExists(session, "user") and structKeyExists(session.user, "id")>
				<li class="noMargin">
					<p class="noticeCounter"></p>
					<a href="##" title="Powiadomienia" class="noticeBox" title="Powiadomienia">
						<span>Powiadomienia</span>
					</a>
					<div id="noticeList">
						<div class="noticeListBox"></div>
						<div class="readAll">Odznacz wszystkie</div>
						<div class="clearAll">Usuń wszystkie</div>
						<div style="clear:both;"></div>
					</div>
				</li>
			</cfif>
		<!---</cfif>--->
		
		<cfinvoke
			component="controllers.Tree_groupusers"
			method="checkUserTreeGroup"
			returnvariable="rootPriv" >

			<cfinvokeargument
				name="groupname"
				value="root" />

		</cfinvoke>
		
		<cfif rootPriv is true>
			<li class="noLeftMargin">
				<a href="#URLFor(controller='Admins',action='index')#" title="Panel administracyjny" class="adminPanel">
					<span>Panel administracyjny</span>
				</a>
			</li>
		</cfif>

		<cfif structKeyExists(session, "user") and structKeyExists(session.user, "id")>

			<cfinvoke
				component="controllers.Tree_groupusers"
				method="checkUserTreeGroup"
				returnvariable="priv" >

				<cfinvokeargument
					name="groupname"
					value="Centrala" />

			</cfinvoke>
			
			<cfinvoke
				component="controllers.Tree_groupusers"
				method="checkUserTreeGroup"
				returnvariable="pps" >

				<cfinvokeargument
					name="groupname"
					value="Partner prowadzący sklep" />

			</cfinvoke>

			<cfif priv is true>

				<li class="monkeysearch">
	
					<cftry>
						
						<!---user_profile_cfdiv--->
			
						<cfform
							name="search_form"
							action="#URLFor(controller='Search',action='find')#"
							onsubmit="javascript:ColdFusion.navigate('#URLFor(controller='Search',action='find')#', 'search_result_cfdiv', null, null, 'POST', 'search_form');return false;" >
			
							<div class="search_category_div">
			
								<select
									name="search_category"
									class="search_select_box">
			
									<cfloop  collection="#searchCategories#" item="i">
										<option value="#i#" <cfif i IS "WORKFLOWS" >selected</cfif>>
											#searchCategories[i]#
										</option>
									</cfloop>
			
								</select>
			
							</div>
			
			
							<cfinput
								name="search"
								type="text"
								class="input search"
								placeholder="Wyszukaj..." />
			
							<cfinput
								name="search_submit"
								type="submit"
								value=" " />
			
						</cfform>
		
						<cfcatch type="any" >
		
							</select>
							</form>
		
						</cfcatch>
		
					</cftry>
	
				</li>
			
			<cfelseif pps is true>
				
				<li class="monkeysearch">
	
					<cftry>
						
						<!---user_profile_cfdiv--->
			
						<cfform
							name="search_form"
							action="#URLFor(controller='Search',action='find')#"
							onsubmit="javascript:ColdFusion.navigate('#URLFor(controller='Search',action='find',params='search_category=INSTRUCTIONS')#', 'search_result_cfdiv', null, null, 'POST', 'search_form');return false;" >
			
							<cfinput
								name="search"
								type="text"
								class="input search"
								placeholder="Wyszukaj akty prawne..." />
			
							<cfinput
								name="search_submit"
								type="submit"
								value=" " />
			
						</cfform>
		
						<cfcatch type="any" >
		
							</select>
							</form>
		
						</cfcatch>
		
					</cftry>
	
				</li>
				
			</cfif>

		<cfelse>

			<li class="profile_login">

			<cfform
				action="#URLFor(controller='Users',action='actionLogIn')#"
				name="profile_login_form" >

				<cfinput
					name="user.login"
					type="text"
					class="input"
					placeholder="Login" />

				<cfinput
					name="user.password"
					type="password"
					class="input"
					placeholder="Hasło" />

				<cfinput
					name="profile_submit"
					type="submit"
					class="small_admin_button red_admin_button profile_login_button"
					value="Zaloguj"
					title="Zaloguj" />

			</cfform>

			</li>

		</cfif>

	</ul>
</cfoutput>

<cfif StructKeyExists(session, "userid")>
	<script>
		$(function(){
			var _timeout,_flag=true;
			$(document).tooltip({
				items		: '.search-result-table .photo',
			    tooltipClass: 'preview-tooltp',
				position	: { my: "left+100 top", at: "left top+30" },
				show		: { effect: "fadeIn", duration: 200 },
				content		: function(callback) {
					$(".preview-tooltp").hide();
					//if(_flag) {
						var id = $(this).data("id");
						clearTimeout(_timeout);
						_timeout = setTimeout(function() {
							//_flag = false;														
							$.get("<cfoutput>#URLFor(controller='company_structure', action='users-struct-details')#</cfoutput>" + "&key=" + id,{}, function(data) {
								callback(data);
								//_flag = true;
							});
						},500);
						
					//}
				},
				close		: function( event, ui ){
					clearTimeout(_timeout);
					$(document).tooltip( "close" );
				}
			});
			
			$(document).on("mouseenter",".userAvatar",function(){
				clearTimeout(_timeout);
				$(document).tooltip( "close" );
			});
			
			$(document).on("mouseleave",".userAvatar",function(){
				clearTimeout(_timeout);
				$(document).tooltip( "close" );
			});
		});
	</script>
</cfif> 

<script>
	$(function(){
		$("#search_form").on("submit", function(){
			$("#slide-down-content").show();
			$(".search-result-button").hide();
			$("#search_result_cfdiv").slideDown();
		});
		
		$(".search-result-button").on("click", function(event){
			event.stopPropagation();
			$(".search-result-button").fadeOut();
			$("#search_result_cfdiv").slideDown();
		});
		
		$(document).click(function() {
			if($("#search_result_cfdiv").is(':visible')){
				$(".search-result-button").fadeIn();
			}
			$("#search_result_cfdiv").slideUp();
		});
		
		$(document).on("click", "#search_result_cfdiv", function(event) {
			event.stopPropagation();
		});
		
		$("#search_result_cfdiv").on("click", ".navigateout", function(event) {
    		$(".search-result-button").fadeIn();
			$("#search_result_cfdiv").slideUp();
		});

		$("#search_result_cfdiv").on("click", ".searchparamlink, .paginationlink", function(event) {
    		event.stopPropagation();
		});
		
		$("#search_result_cfdiv").on("click", ".navigate", function(){
			
			var url = $(this).attr("href");
			var container = $(this).data("container");
			
			$("#flashMessages").show();
			
			$.ajax({
				type	: 'GET',
				url		: url,
				dataType: "html",
				success	: function(data, status, xhr) {
						
					$(document).find("#"+container).html(data);
					$("#flashMessages").hide();
				}
			});
			
			return false;
		});
		
		$(document).on("mouseleave",".preview-tooltp",function(){
			$(this).hide();
		});
	
	});
</script>