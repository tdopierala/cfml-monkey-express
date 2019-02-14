<cfoutput>
	
	<div class="wrapper lessons">
		<h3>Formularz oceny egzaminu</h3>
		
		#hiddenFieldTag(name="lessonid", value=lessonStudent.id)#
		
		<!---<div class="wrapper formbox">
			<h5>Ocena z egzaminu: <span class="strong">#lesson.topic.subject#</span></h5>
			
			#hiddenFieldTag(name="lesson", value=lessonStudent.id)#
			
			<ol class="rate-list">
				<li>
					#radioButtonTag(name="rate_0", value="1", label="1", labelPlacement="before")#
				</li>
				<li>
					#radioButtonTag(name="rate_0", value="2", label="2", labelPlacement="before")#
				</li>
				<li>
					#radioButtonTag(name="rate_0", value="3", label="3", labelPlacement="before")#
				</li>
				<li>
					#radioButtonTag(name="rate_0", value="4", label="4", labelPlacement="before")#
				</li>
				<li>
					#radioButtonTag(name="rate_0", value="5", label="5", labelPlacement="before")#
				</li>
				<li>
					#radioButtonTag(name="rate_0", value="6", label="6", labelPlacement="before")#
				</li>
			</ol>
			
		</div>--->
		
		<cfif IsDefined("lessonRates") and lessonRates.RecordCount gt 0>
			<cfquery dbtype="query" name="dRate"> 
				SELECT Max(ratedate) as uDate FROM lessonRates
			</cfquery>
			
			<span id="update-time" style="display:none;">#DateDiff( "s", Now(), DateAdd( "n", 30, dRate.uDate ) )#</span>
		</cfif>
		
		<div class="wrapper formbox">
			
			<div class="timebox"></div>
			
			<cfloop query="lessonQuestions">
				<div class="rate-wrapper">
					<label>
						<span>#question#</span>
						
						<cfif id eq 1>
							<span class="strong">: #lesson.topic.subject#</span>
						</cfif>
					</label>
					
					<cfif IsDefined("lessonRates") and lessonRates.RecordCount gt 0>
					
						<cfquery dbtype="query" name="rate"> 
					    	SELECT id, rate, description, ratedate FROM lessonRates
					    	WHERE questionid=<cfqueryparam value="#id#" cfsqltype="cf_sql_integer">
						</cfquery>
						
						<cfset ratevalue = rate.rate />
						<cfset ratedesc = rate.description />
						
						<!---<p>#DateAdd( "n", 30, rate.ratedate )# #Now()# #DateCompare( DateAdd( "n", 30, rate.ratedate ), Now() )#</p>--->
						<cfif DateCompare( DateAdd( "n", 30, rate.ratedate ), Now() ) gt 0>
							<cfset updateAllow = 'false' />
						<cfelse>
							<cfset updateAllow = 'true' />
						</cfif>
						
					<cfelse>
						
						<cfset updateAllow = 'false' />
						<cfset ratevalue = 0 />
						<cfset ratedesc = '' />
											
					</cfif>
					
					<ol class="rate-list">
						<li>
							<cfif ratevalue eq 1>
								<cfset checked = 'true' />
							<cfelse>
								<cfset checked = 'false' />
							</cfif>
							#radioButtonTag(name="rate_#id#", value="1", label="1", checked=checked, labelPlacement="before", disabled=updateAllow)#
						</li>
						<li>
							<cfif ratevalue eq 2>
								<cfset checked = 'true' />
							<cfelse>
								<cfset checked = 'false' />
							</cfif>
							#radioButtonTag(name="rate_#id#", value="2", label="2", checked=checked, labelPlacement="before", disabled=updateAllow)#
						</li>
						<li>
							<cfif ratevalue eq 3>
								<cfset checked = 'true' />
							<cfelse>
								<cfset checked = 'false' />
							</cfif>
							#radioButtonTag(name="rate_#id#", value="3", label="3", checked=checked, labelPlacement="before", disabled=updateAllow)#
						</li>
						<li>
							<cfif ratevalue eq 4>
								<cfset checked = 'true' />
							<cfelse>
								<cfset checked = 'false' />
							</cfif>
							#radioButtonTag(name="rate_#id#", value="4", label="4", checked=checked, labelPlacement="before", disabled=updateAllow)#
						</li>
						<li>
							<cfif ratevalue eq 5>
								<cfset checked = 'true' />
							<cfelse>
								<cfset checked = 'false' />
							</cfif>
							#radioButtonTag(name="rate_#id#", value="5", label="5", checked=checked, labelPlacement="before", disabled=updateAllow)#
						</li>
						<li>
							<cfif ratevalue eq 6>
								<cfset checked = 'true' />
							<cfelse>
								<cfset checked = 'false' />
							</cfif>
							#radioButtonTag(name="rate_#id#", value="6", label="6", checked=checked, labelPlacement="before", disabled=updateAllow)#
						</li>
					</ol>
					
					<cfif isDesc eq 1>
						<div class="rate-description">
							#textAreaTag(name="desc_#id#", label="Ocena opisowa", labelPlacement="before", content=ratedesc, class="textarea", disabled=updateAllow)#
						</div>
					</cfif>
					
				</div>
			</cfloop>
			
		</div>
			
	</div>
</cfoutput>
<!---<cfdump var="#lessonQuestions#">--->

<script>
	
	function pad ( num, size ) {
  		return ( Math.pow( 10, size ) + ~~num ).toString().substring( 1 );
	}

	$(function(){
		
		var time = $("#update-time").text();
		time = parseInt(time);
		
		var timer;
		
		clearInterval(timer);
		if(time > 0){
			
			timer = setInterval(function(){
				time--;
				
				$("#update-time").text(time);
				
				if(time <= 0) 
					clearInterval(timer);
				
				if(time>60) min = Math.floor(time/60);
				else min=0;
				
				var sec = time%60;
				
				$(".timebox").html("Pozostały czas: " + pad(min, 2) + ":" + pad(sec, 2));
			}, 1000);
			
		}
		
	});
</script>