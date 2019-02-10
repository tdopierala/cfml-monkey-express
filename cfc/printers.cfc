<cfscript>
	
component
	displayname="printers"
	output="false"
	{
		
		property type="String" name="directory" default="/";
		property type="String" name="datasource" default="intranet";
		property type="String" name="reportTable" default="";
		property type="String" name="logFile" default="cfcPrinters";
		
		variables.instance = {
			directory	=	"/var/www/intranet/print/",
			datasource	=	"intranet",
			reportTable	=	"printers_reports",
			logFile		=	"cfcPrinters"
		};
		
		public function init()
		{
			return this;
		}
		
		package function createTable()
		{
			var b = new dbinfo(
				datasource="#variables.instance.datasource#"
				).tables();
			
			var t = ValueList(b.table_name, ",");
			
			if ( not ListFindNoCase(t, "printers_reports") )
			{
				this.createPrintersReports();
			}
			
			/*if ( not ListFindNoCase( t, "printers_alerts" ) )
			{
				this.createPrintersAlerts();
			}*/
		}
		
		package function createPrintersReports()
		{
			var q = new query(
				datasource = variables.instance.datasource
				);
				
			try
			{
				var r = q.execute(sql="
					create table printers_reports (
					id int(11) not null auto_increment,
					printer_name varchar(32) character set utf8 default null,
					formatted_ip_address varchar(32) character set utf8 default null,
					serial_number varchar(32) character set utf8 default null,
					location varchar(32) character set utf8 default null,
					bwpagescounter int(11) default 0,
					totalcounter int(11) default 0,
					device_status varchar(128) character set utf8 default null,
					last_successfully_contacted_utctime datetime,
					last_contacted_utctime datetime,
					primary key(id)
					)engine=innodb default charset=utf8 collate=utf8_unicode_ci
					");
			}
			catch ( Exception e )
			{
				WriteOutput(e);
				abort;
			}
			
		}
		
		/*
			Funkcja listuje katalog, wyciąga wszystkie pliki XML, które się w nim
			znajdują i wrzuca je do bazy danych. Po wykonaniu wszystkich operacji
			usuwa plik z serwera.
		*/
		public function xmlToDatabase()
		{
			this.createTable();
			
			if ( DirectoryExists( variables.instance.directory ) )
			{
				var files = directoryList( variables.instance.directory, false, "query" );
				
				for ( 
					i = 1;
					i LTE files.RecordCount;
					i = i + 1
					 ) {
					
					var f = fileRead(variables.instance.directory & files['name'][i]);
					var nodes = xmlSearch(f, "SiteAudit/Rows/Row");

					// Przechodzę przez wszystkie węzły w pliku i dodaje je do bazy
					for (
						index = 1;
						index LTE arraylen(nodes);
						index = index + 1) {
					
						try 
						{
					
						var xml = xmlParse( nodes[index] );
						var q = new query(
							datasource=variables.instance.datasource);
						
						var sqlQuery = "insert into #variables.instance.reportTable#
						( printer_name,
						formatted_ip_address,
						serial_number,
						location,
						bwpagescounter,
						totalcounter,
						device_status,
						last_successfully_contacted_utctime,
						last_contacted_utctime
						)
						
						values (
						'#xml.Row.printer_name.XmlText#',
						'#xml.Row.formatted_ip_address.XmlText#',
						'#xml.Row.serial_number.XmlText#',
						'#xml.Row.location.XmlText#',
						" & iif( Len(xml.Row.bwpagescounter.XmlText), xml.Row.bwpagescounter.XmlText, 0 ) & ",
						" & iif( Len(xml.Row.totalcounter.XmlText), xml.Row.totalcounter.XmlText, 0 ) & ",
						'#xml.Row.device_status.XmlText#',
						'#xml.Row.last_successfully_contacted_utctime.XmlText#',
						'#xml.Row.last_contacted_utctime.XmlText#'
						)";
						
						q.execute(sql=sqlQuery);
						
						}
						catch ( Exception e )
						{
							writeLog( 
								text = "#e.message#",
								type = "Error",
								file = "#variables.instance.logFile#"
					 		);
							abort;
						}
					} // end for for nodes
					
					fileDelete(variables.instance.directory & files['name'][i]);
					 	 
				} // end for for files
				
			} // end if directoryExists
		}
		
		public function getPrinterByProject(
			String projekt = "")
		{
			var q = new query(
				datasource=variables.instance.datasource);
			q.setcachedwithin( createTimeSpan(0, 1, 0, 0) );
			 
			 q.addParam(name="location",value=arguments.projekt,cfsqltype="cf_sql_varchar");
			 
			 var r = q.execute(sql="
			 	select
			 		p1.location
			 		,p1.serial_number
			 		,p1.printer_name
			 		,p1.bwpagescounter
			 		,DATE_FORMAT(p1.last_successfully_contacted_utctime, '%d-%m-%Y') as last_successfully_contacted_utctime
			 		,p1.totalcounter as printed
			 		
			 	from printers_reports p1
			 	where p1.location = :location
			 	order by p1.last_successfully_contacted_utctime DESC
			 	limit 30");
			 
			 return r.getResult();
		}
		
		public struct function getPrinterStatus(
			String projekt = "")  
		{
			var printerStatus = structNew();
			printerStatus.serial_number = "";
			printerStatus.totalcounter = "";
			printerStatus.printer_name = "";
			printerStatus.last_successfully_contacted_utctime = "";
			
			try
			{
				var service = new query(
					datasource=variables.instance.datasource,
					cachedWithin=createTimeSpan(0, 1, 0, 0)
				);
				
				var serviceData = service.execute(
					sql="
						select
							printer_name
							,serial_number
							,totalcounter
							,DATE_FORMAT(last_successfully_contacted_utctime, '%d-%m-%Y') as last_successfully_contacted_utctime
						from #variables.instance.reportTable#
						where location = '#arguments.projekt#'
						order by last_successfully_contacted_utctime desc
						limit 1
					"
				).getResult();
				
				printerStatus.serial_number = serviceData.serial_number;
				printerStatus.totalcounter = serviceData.totalcounter;
				printerStatus.printer_name = serviceData.printer_name;
				printerStatus.last_successfully_contacted_utctime = serviceData.last_successfully_contacted_utctime;
			
			}
			catch( Exception e )
			{
				writeLog( 
					text = "#e.message#",
					type = "Error",
					file = "#variables.instance.logFile#"
				 );
			}
			
			return printerStatus;
		} 
		
	}
	
</cfscript>