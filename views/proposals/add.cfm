<cfsilent>
	<!---<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="root" >
		<cfinvokeargument name="groupname" value="root" />
	</cfinvoke>--->
			
	<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="_centrala" >
		<cfinvokeargument name="groupname" value="Centrala" />
	</cfinvoke>
			
	<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="_pds" >
		<cfinvokeargument name="groupname" value="Partner ds sprzedaży" />
	</cfinvoke>
			
	<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="_pps" >
		<cfinvokeargument name="groupname" value="Partner prowadzący sklep" />
	</cfinvoke>
		
	<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="_ds" >
		<cfinvokeargument name="groupname" value="Wnioski dla kandydata na PPS" />
	</cfinvoke>
	
	<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="_kos" >
		<cfinvokeargument name="groupname" value="KOS" />
	</cfinvoke>
</cfsilent>

<cfoutput>

<div class="ajaxcontent">

	<div class="wrapper">
	
		<h3>Wybór rodzaju dokumentu</h3>
		
		<div class="wrapper">
	
			<div class="proposalsteps">
				<ul class="step1">
					<li class="selected"><span>1. Wybór rodzaju dokumentu</span></li>
					<li><span>2. Wypełnienie dokumentu</span></li>
					<li><span>3. Potwierdzenie</span></li>
					<li><span>4. Przekazanie do akceptacji</span></li>
				</ul>
			</div>
			
			<cfif flashKeyExists("error")>
				<span class="error">#flash("error")#</span>
			</cfif>
			
			<div class="wrapper proposaltypes">
			
				#startFormTag(controller="Proposals",action="actionAdd")#
					
					<ol>
						<cfloop query="proposaltypes">
							
							<cfswitch expression="#type#">
								
								<cfcase value="1" >
									
									<cfif _centrala is true>
										<li class="proposaltypesthumbnail">
											<span>#proposaltypename#</span>
											#imageTag(thumbnail)#
											#radioButtonTag(name="proposaltypeid", value=id)#
										</li>
									</cfif>
									
								</cfcase>
								
								<cfcase value="2">
									
									<cfif _pds is true or _ds is true>
										<li class="proposaltypesthumbnail">
											<span>#proposaltypename#</span>
											#imageTag(thumbnail)#
											#radioButtonTag(name="proposaltypeid", value=id)#
										</li>
									</cfif>
									
								</cfcase>
								
								<cfcase value="3">
									
									<cfif _pps is true>
										<li class="proposaltypesthumbnail">
											<span>#proposaltypename#</span>
											#imageTag(thumbnail)#
											#radioButtonTag(name="proposaltypeid", value=id)#
										</li>
									</cfif>
									
								</cfcase>
								
								<cfcase value="5">
									<cfif _kos is true>
										<li class="proposaltypesthumbnail">
											<span>#proposaltypename#</span>
											#imageTag(thumbnail)#
											#radioButtonTag(name="proposaltypeid", value=id)#
										</li>
									</cfif>
								</cfcase>
								
							</cfswitch>
							
							<!---<cfif  (id eq 1 and centrala is true)
								or (id eq 2 and centrala is true)
								or (id eq 3 and centrala is true)
								or (id eq 4 and pds is true)
								or (id eq 4 and ds is true)>
							
								<li class="proposaltypesthumbnail">
									<span>#proposaltypename#</span>
									#imageTag(thumbnail)#
									#radioButtonTag(
										name="proposaltypeid",
										value=id)#
								</li>
							
							</cfif>--->
											
						</cfloop>
						
						<li class="clear">#submitTag(value="Wypełnij wniosek",class="smallButton redSmallButton")#</li>
					</ol>
				
				#endFormTag()#
			
			</div>

		</div><!-- /wrapper -->
	
	</div><!-- /wrapper -->

</div><!-- /ajaxcontent -->

</cfoutput>

<script type="text/javascript">

$(function() {

	$('.proposaltypes img').live('click', function() {
		$(this).parent().find(':radio').attr('checked', true);
	});

});

</script>