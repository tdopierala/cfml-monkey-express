<cfscript>
	
	component
		displayname="email"
		output="false" {
	
		property type="String" name="messageSubject" default="";
		property type="String" name="messageBody" default="";
		property type="Struct" name="to";
		property type="String" name="from" default="INTRANET <intranet@monkey.xyz>";
		property type="String" name="replyTo" default="";
		property type="String" name="bcc" default="";
		
		variables.instance = {
			messageSubject = "Powiadomienie z Intranetu",
			messageBody = ":)",
			to = arrayNew(2),
			from = "INTRANET <intranet@monkey.xyz>",
			replyTo = "",
			bcc = ""
		};
		
		public function init()
		{
			return this;
		}
		
		public function setTo(
			 required Query users)
		{
		
			arrayClear(variables.instance.to);
			
			for(
				i = 1;
				i LTE users.RecordCount;
				i = i + 1)
			{
				arrayAppend( 
					variables.instance.to, 
					[users['GIVENNAME'][i] & " " & users['SN'][i], users['MAIL'][i]]
				);
			}
			
			return this;
			
		}
		
		public function setSubject(
			String subject = "")
		{
			if( Len( arguments.subject ) )
			{
				variables.instance.messageSubject = arguments.subject;
			}
			return this;
		}
		
		public function setBody(
			String body = "")
		{
			if( Len( arguments.body ) )
			{
				variables.instance.messageBody = arguments.body;
			}
			return this;
		}
		
		public boolean function send()
		{
			for( 
				i = 1;
				i LTE arraylen(variables.instance.to);
				i = i + 1 )
			 {
			 	try
			 	{
			 		var message = new mail();
			 	
			 		message.setTo(variables.instance.to[i][2]);
			 		message.setFrom(variables.instance.from);
			 		
			 		if (Len(variables.instance.bcc) GT 0) {
			 			message.setBcc(variables.instance.bcc);
			 		}
			 		
			 		if (Len(variables.instance.replyTo) GT 0) {
			 			message.setReplyTo(variables.instance.replyTo);
			 		}
					
			 		message.setSubject(variables.instance.messageSubject);
				 	message.setType("html");
				 	message.send(body=variables.instance.messageBody);
				 	
			 	}
			 	catch( Exception e )
			 	{
			 		writeDump(e);
			 		abort;
			 	} 
			 }
			 
			 return true;
		}
			
	}
	
</cfscript>