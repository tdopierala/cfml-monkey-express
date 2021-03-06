<cftry>
<cfoutput>

<div class="ajaxcontent">

	<div class="wrapper">
	
		<h3>Potwierdzenie danych wypełnionych we wniosku</h3>
		
		<div class="wrapper">

			<div class="proposalsteps">
				<ul class="step2">
					<li><span>1. Wybór rodzaju dokumentu</span></li>
					<li><span>2. Wypełnienie dokumentu</span></li>
					<li class="selected"><span>3. Potwierdzenie</span></li>
					<li><span>4. Przekazanie do akceptacji</span></li>
				</ul>
			</div>
			
			<div class="wrapper proposalform">
				
				<cfif flashKeyExists("error")>
					<span class="error">#flash("error")#</span>
				</cfif>
				
				#startFormTag(controller="Proposals",action="actionEdit")#
				#hiddenFieldTag(name="proposalid",value=params.proposalid)#
				#hiddenFieldTag(name="proposaltypeid",value=params.proposaltypeid)#
				
				<cfif params.proposaltypeid neq 4>
					#hiddenFieldTag(name="proposalholidayto",value=params.proposalholidayto)#
					#hiddenFieldTag(name="proposalholidayfrom",value=params.proposalholidayfrom)#
				</cfif>
				
				<cfif StructKeyExists(params,"holidaydates")>
					#hiddenFieldTag(name="holidaydates",value=params.holidaydates)#
				</cfif>
				
				<ol class="proposalfields">
					
					<cfloop query="proposalfields">
						<cfset date = 0 />
						<cfloop collection="#params.proposalattributevalue#" item="i">
							
							<cfif id eq i>
									
								<li style="clear:both;height:20px;">
									<label>#attributename#</label>
									
									<cfif (attributeid eq 205 or attributeid eq 225) and StructKeyExists(params.proposalattributevalue[i],'sfilename')>
										
										<span class="proposalattributevalue">
											<a href="./files/proposals/#params.proposalattributevalue[i].sfilename#">
												<img src="./images/file-pdf.png" alt="" /> #params.proposalattributevalue[i].cfilename#
											</a>
										</span>
										
										#hiddenFieldTag(
											name = "proposalattributevalue[#id#]",
											value = params.proposalattributevalue[i].sfilename)#
									
									<cfelseif attributeid neq 205 and attributeid neq 225>
										<span class="proposalattributevalue">#params.proposalattributevalue[i]#</span>
										
										#hiddenFieldTag(
											name="proposalattributevalue[#id#]",
											value=params.proposalattributevalue[i])#
									<cfelse>
										<span class="proposalattributevalue"></span>
									</cfif>
								</li>
								
							<cfelseif attributeid eq 127 and date eq 0>
								
								<cfif StructKeyExists(params,"proposalholidaydate")>
									<li style="clear:both;height:20px;">
										<label>Wyjazd w dniach</label>
																		
										<cfset counter = 1 />	
										<cfset proposaldates = ArrayNew(1) />
										<cfloop collection="#params.proposalholidaydate#" item="j">
											
											#hiddenFieldTag(
												name="proposalholidaydate[#j#][0]",
												value=params.proposalholidaydate[j][0])#
												
											<cfset proposaldates[counter] = params.proposalholidaydate[j][0] />
											<cfset counter = counter + 1 />
										</cfloop>
										
										<cfset strt = ListToArray(proposaldates[1], "-") />
										<cfset stop = ListToArray(proposaldates[2], "-") />
										
										<cfset date_strt = CreateDate( strt[3], strt[2], strt[1] ) />
										<cfset date_stop = CreateDate( stop[3], stop[2], stop[1] ) />
										
										<cfif DateCompare( date_strt, date_stop ) lt 0 >
											<span>od #proposaldates[1]# </span>
											<span>do #proposaldates[2]# </span>
										<cfelse>
											<span>od #proposaldates[2]# </span>
											<span>do #proposaldates[1]# </span>
										</cfif>
										
									</li>
								</cfif>
								
								<cfset date = 1 />
							</cfif>
							
						</cfloop>
						
					</cfloop>
					
					<cfif StructKeyExists(params,"substitutionsearchtext")>
						
						<li style="clear:both;height:20px;">
							<label>Zastępstwo</label>							
							<span>#params.substitutionsearchtext#</span>
							
							#hiddenFieldTag(name="substitutionsearchtext",value=params.substitutionsearchtext)#
						</li>
					</cfif>
					
					<cfif StructKeyExists(params,"attribute")>
						<li style="display:none;">
							<cfloop collection="#params.attribute#" item="a">
								#hiddenFieldTag(
									name="attribute[#a#]",
									value=params.attribute[a])#
							</cfloop>
						</li>
					</cfif>
					
				</ol>
				
				<ol>
					<li>
						#buttonTag(content="Cofnij", type="button", class="smallButton redSmallButton retryProposal")#
						#submitTag(value="Potwierdź",class="smallButton redSmallButton editProposal")#
					</li>
				</ol>
				
				#endFormTag()#
							
			</div>
			
		</div><!-- /wrapper -->
	
	</div><!-- /wrapper -->

</div><!-- /ajaxcontent -->


</cfoutput>
	<cfcatch type="any">
		<cfdump var="#cfcatch#">
	</cfcatch>
</cftry>
<script language="JavaScript">
	$(function() {
		
		$(".retryProposal").click(function(){
			history.back();	
			return false;
		});
	});
</script>