<cfoutput>

	<tr class="start">
		<cfloop query="protocolfields">
			<td class="c bottomBorder leftBorder <cfif attributeid eq 119>rightBorder</cfif>">
				<cfset inputclass = "" />
				<cfset inputvalue = "" />
				
				<cfif attributetypeid eq 4>
					
					<cfset inputclass &= " date_picker " />
				
				</cfif>
				
				<cfif attributeid eq 114>
						
					<cfset inputclass &= " autocompleteindex " />
				
				</cfif>
				
				<cfif attributeid eq 115>
							
					<cfset inputclass &= " autocompleteproduct " />
							
				</cfif>
				
				<cfif attributeid eq 120>
				
					<cfset inputclass &= " verySmallProtocolInput c " />
					<cfset inputvalue = session.protocol.lp />
					
				<cfelse>
				
					<cfset inputclass &= " smallProtocolInput " />
				
				</cfif>
				
				<cfif attributeid eq 116>
						
					#selectTag(
						name="protocolcontent[#random#][#attributeid#]",
						options=selectoptions,
						class="#inputclass#")#
				
				<cfelseif attributeid eq 119>
				
					#selectTag(
						name="protocolcontent[#random#][#attributeid#]",
						options=returnselectoptions,
						class="#inputclass#")#

				<cfelse>
				
					#textFieldTag(
						name="protocolcontent[#random#][#attributeid#]",
						value="#inputvalue#",
						class="#inputclass#")#
				
				</cfif>
						
			</td>
		</cfloop>
	</tr>

</cfoutput>