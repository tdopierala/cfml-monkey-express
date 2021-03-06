<cfcomponent 
	displayname="numbersconverter"
	hint="Komponent zmieniający kwoty w zapis słowny"
	output="false">
		
	<cfproperty 
		name="digits"
		type="string"
		default="abc"/>
		
	<cfproperty 
		name="result"
		type="struct"/>
		
	<cffunction name="init">
		
		<!---<cfargument 
			name="digits"
			type="string"
			required="true" />
			
		<cfset THIS.digits = arguments.digits />--->
			
		<cfreturn THIS/>
		
	</cffunction>
	
	<cffunction name="convertdigit">
		
		<cfargument 
			name="digits"
			type="string"
			required="true" />
			
		<cfscript>
			THIS.result = StructNew();
			
			StructInsert(THIS.result, "digits", arguments.digits);
			StructInsert(THIS.result, "len", Len(arguments.digits));
			
			list = listToArray(arguments.digits,'.');
			StructInsert(THIS.result, "list", list);
			
			if(Int(list[1] / 1000) > 0){
				subdigit = Mid(list[1],Len(list[1])-2,3);
				StructInsert(THIS.result, "subdigit", subdigit);
				
				_subdigit = Mid(subdigit,1,1);
				
				
				StructInsert(THIS.result, "_subdigit", _subdigit);
			}
			
			arr = ArrayNew(1);
			counter=1;
			for(i=1000000; i>=10; i=i/10){
				
				arr[counter] = Int(list[1] / i);
				if(counter>99) break;
				
				if( arr[counter] > 0){
					
				}
				
				counter++;
			}
			
			StructInsert(THIS.result, "arr", arr);
			
		</cfscript>
		
		<cfreturn THIS.result />
		
	</cffunction>

</cfcomponent>