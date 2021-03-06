
<cfcache 
	key="#params.projekt#" 
	timespan=#createtimespan(0,1,0,0)# > 
      
      <cfif session.user.id eq 345>
	  	  <cfoutput><p>#now()#</p></cfoutput>
      </cfif>

<!---
<cfdump var="#qPayment#" >
<cfdump var="#qFv#" >
<cfdump var="#qCard#" >
<cfdump var="#qExp#" >

<cfdump var="#dates#" >
--->
	
	<cfset sum_oczekiwana = 0.0 />
	<cfset sum_wplata = 0.0 />
	<cfset sum_karty = 0.0 />
	<cfset sum_faktury = 0.0 />
	
	<cfset flag = false />
	
	<cfif not IsNumeric(qStore.starter) or qStore.starter eq ''>
		<cfset qStore.starter = 0 />
	</cfif>
	
	<cfif not IsNumeric(qStore.sumpayment) or qStore.sumpayment eq ''>
		<cfset qStore.sumpayment = 0 />
	</cfif>
	
	<cfif not IsNumeric(qStore.expected_ratio) or qStore.expected_ratio eq ''>
		<cfset qStore.expected_ratio = 0 />
	</cfif>
	
	<cfif not IsNumeric(qStore.expected) or qStore.expected eq ''>
		<cfset qStore.expected = 0 />
	</cfif>
	
	<cfif not IsNumeric(qStore.payment) or qStore.payment eq ''>
		<cfset qStore.payment = 0 />
	</cfif>
	
	<cfif not IsNumeric(qStore.card) or qStore.card eq ''>
		<cfset qStore.card = 0 />
	</cfif>
	
	<cfif not IsNumeric(qStore.fv) or qStore.fv eq ''>
		<cfset qStore.fv = 0 />
	</cfif>
	
	<cfif not IsNumeric(qStore.ratio) or qStore.ratio eq ''>
		<cfset qStore.ratio = 0 />
	</cfif>
	
	<cfset full_debt = qStore.fv - qStore.sumpayment />
	
	<!---<cfif session.user.id eq 345>
		<cfdump var="#qStore#" />
		<cfabort />
	</cfif>--->
	
	<table class="tables details2-table">
		<thead>
			<cfoutput>
	        	<tr>
					<th rowspan="3" colspan="2" class="tdprojekt">#qStore.projekt#</th>
					<th colspan="3" class="tdcenter">Wskażnik zadłużenia</th>
				</tr>
				<tr>
					<th class="tdcenter">starter</th>
					<th class="tdcenter">zł</th>
					<th class="tdcenter">%</th>
				</tr>
				<tr>
					<th class="tdbold tdnum">#Replace(NumberFormat(qStore.starter, "__,___.__"), ",", " ", "ALL")#</th>
					<th class="tdbold tdnum tdmark">#Replace(NumberFormat(full_debt, "__,___.__"), ",", " ", "ALL")#</th>
					<th class="tdbold tdnum">
						<cfif (qStore.ratio*100) gt session.debtrate>
							<span class="markred">#Replace(NumberFormat(qStore.ratio*100, "__,___"), ",", " ", "ALL")#</span>
						<cfelse>
							<span class="markgreen">#Replace(NumberFormat(qStore.ratio*100, "__,___"), ",", " ", "ALL")#</span>
						</cfif>
					</th>
				</tr>
				<tr>
					<th colspan="7" class="tdcenter">Pieniądz narastająco</th>
					<th rowspan="2" class="tdbold tdcenter">Faktury</th>
				</tr>
				<tr>
					<th class="tdbold tdcenter">Data</th>
					<th class="tdbold tdcenter">Oczekiwana</th>
					<th class="tdbold tdcenter">Wpłata</th>
					<th rowspan="3" colspan="2" class="tdborder tdcenter">Opis</th>
					<th class="tdbold tdcenter tdwsk">Wskażnik wpłat (niedpołata)</th>
					<th class="tdbold tdcenter">Karty</th>
				</tr>
				<tr>
					<th></th>
					<th class="tdcenter">zł</th>
					<th class="tdcenter">zł</th>
					<th class="tdnum tdmark">
						<cfif qStore.expected_ratio gt 100>
							<span class="markgreen">#NumberFormat(qStore.expected_ratio, "___.__")#%</span>
						<cfelse>
							<span class="markred">#NumberFormat(qStore.expected_ratio, "___.__")#%</span>
						</cfif>
					</th>
					<th class="tdcenter">zł</th>
					<th class="tdcenter">zł</th>
				</tr>
				<tr>
					<th class="tdbold tdborder">Suma ---></th>
					<th class="tdbold tdnum tdborder">#Replace(NumberFormat(qStore.payment - qStore.expected, "__,___.__"), ",", " ", "ALL")#</th>
					<th class="tdbold tdnum tdborder">#Replace(NumberFormat(qStore.payment, "__,___.__"), ",", " ", "ALL")#</th>
					<th class="tdborder tdnum"></th>
					<th class="tdbold tdnum tdborder">#Replace(NumberFormat(qStore.card*(-1), "__,___.__"), ",", " ", "ALL")#</th>
					<th class="tdbold tdnum tdborder">#Replace(NumberFormat(qStore.fv, "__,___.__"), ",", " ", "ALL")#</th>
				</tr>
	        </cfoutput>
		</thead>
		<tbody>
			<cfloop index="i" from="1" to=#ArrayLen(dates)#>
				
				<cfset StructDelete(Variables, "r") />
		
				<cfquery dbtype="query" name="detail"> 
			    	SELECT count(d) AS c FROM qPayment
			    	WHERE d=<cfqueryparam value="#dates[i]#" cfsqltype="cf_sql_char" maxLength="20">
				</cfquery>
				
				<cfoutput query=detail>
					<cfset r = c />
				</cfoutput>
				
				<cfif IsDefined("r")>
					<cfset rows = r />
				<cfelse>
					<cfset rows = 1 />
				</cfif>
				
				<cfoutput>
					<tr>
						<!--- Data --->
						<cfset _date = Insert("-", Insert("-", dates[i], 4), 7) />
						<td rowspan="#rows#" class="dtdate tdcenter">#_date#</td>
						
						
						<!--- Oczekiwana wpłata --->
						<cfset expIdx = ArrayFind(qExp['d'], dates[i]) />
						
						<cfif not IsNumeric(qExp['expected'][expIdx]) or qExp['expected'][expIdx] eq '' >
							<cfset qExp['expected'][expIdx] = 0 /> 
						</cfif>
						
						<cfif expIdx gt 0>
							<cfset exp = Replace(NumberFormat(qExp['expected'][expIdx], "__,___.__"), ",", " ", "ALL") />
							<cfset sum_oczekiwana = sum_oczekiwana + qExp['expected'][expIdx] />
							
							<cfif qExp['expected'][expIdx] lt 0>
								<cfset _class = "minus" />
							<cfelse>
								<cfset _class = "plus" />
							</cfif>

						<cfelse>
							<cfset exp = "--" />
							<cfset _class = "plus" />
						</cfif>
						
						<td rowspan="#rows#" class="tdnum tdexpected #_class#">#exp#</td>
						
						
						
						<!--- Wpłata i opis --->
						<cfset wplIdx = ArrayFind(qPayment['d'], dates[i]) />
						
						<cfif wplIdx gt 0>
							<cfset wpl = Replace(NumberFormat(qPayment['wplata'][wplIdx], "__,___.__"), ",", " ", "ALL") />
							<cfset opis = qPayment['opis'][wplIdx] />
							<cfset sum_wplata = sum_wplata + qPayment['wplata'][wplIdx] />
						<cfelse>
							<cfset wpl = "--" />
							<cfset opis = "" />
						</cfif>
						
						<td class="tdnum tdpayment">#wpl#</td>
						
						<!--- Opis --->
						<td colspan="3" title="#opis#">
							<cfif Len(opis) gt 80>
								#Left(opis, 80)#...
							<cfelse>
								#opis#
							</cfif>
						</td>
						
						<!--- Płatności kartą --->
						<cfset cardIdx = ArrayFind(qCard['d'], dates[i]) />
						
						<cfif cardIdx gt 0>
							<cfset card = Replace(NumberFormat(qCard['card'][cardIdx]*(-1), "__,___.__"), ",", " ", "ALL") />
							<cfset sum_karty = sum_karty + qCard['card'][cardIdx]*(-1) />
						<cfelse>
							<cfset card = "--" />
						</cfif>
						
						<td rowspan="#rows#" class="tdnum tdcard">#card#</td>
						
						<!--- Faktury --->
						
						<td rowspan="#rows#" class="tdnum tdfv">
							<table class="inner-table">
								<cfquery dbtype="query" name="subqfv"> 
					    			SELECT fv, nrdok FROM qFv
					    			WHERE d=<cfqueryparam value="#dates[i]#" cfsqltype="cf_sql_char" maxLength="20">
								</cfquery>
							
								<cfset fvIdx = ArrayFind(qFv['d'], dates[i]) />
								
								<cfif fvIdx gt 0>									
									<cfloop query="subqfv">
										<cfset sum_faktury = sum_faktury + fv />
										<tr>
											<cfif fv lt 0>
												<td class="minus" title="#nrdok#">#Replace(NumberFormat(fv, "__,___.__"), ",", " ", "ALL")#</td>
											<cfelse>
												<td title="#nrdok#">#Replace(NumberFormat(fv, "__,___.__"), ",", " ", "ALL")#</td>
											</cfif>
										</tr>
									</cfloop>									
								<cfelse>
									<tr>
										<td>--</td>
									</tr>
								</cfif>
							</table>
						</td>
					</tr>
					
					<cfif rows gt 1>
						<cfloop index="x" from="2" to=#rows#>
							<cfset y=x-1 />
							<tr>
								<!--- Wpłata i opis --->
								<cfset wplIdx = ArrayFind(qPayment['d'], dates[i]) />
								
								<cfif wplIdx gt 0>
									<cfset wpl = Replace(NumberFormat(qPayment['wplata'][wplIdx+y], "__,___.__"), ",", " ", "ALL") />
									<cfset opis = qPayment['opis'][wplIdx+y] />
									<cfset sum_wplata = sum_wplata + qPayment['wplata'][wplIdx+y] />
								<cfelse>
									<cfset wpl = "--" />
									<cfset opis = "" />
								</cfif>
								
								<td class="tdnum">#wpl#</td>
								
								<!--- Opis --->
								<td colspan="3" title="#opis#">
									<cfif Len(opis) gt 80>
										#Left(opis, 80)#...
									<cfelse>
										#opis#
									</cfif>
								</td>
							</tr>
						</cfloop>
					</cfif>
					
				</cfoutput>
			</cfloop>
		
			<cfoutput>
	        	<tr>
					<td></td>
					<td class="tdbold tdnum">#Replace(NumberFormat(sum_oczekiwana, "__,___.__"), ",", " ", "ALL")#</td>
					<td class="tdbold tdnum">#Replace(NumberFormat(sum_wplata, "__,___.__"), ",", " ", "ALL")#</td>
					<td colspan="3"></td>
					<td class="tdbold tdnum">#Replace(NumberFormat(sum_karty, "__,___.__"), ",", " ", "ALL")#</td>
					<td class="tdbold tdnum">#Replace(NumberFormat(sum_faktury, "__,___.__"), ",", " ", "ALL")#</td>
				</tr>
	        </cfoutput>
		</tbody>
	</table>

</cfcache>