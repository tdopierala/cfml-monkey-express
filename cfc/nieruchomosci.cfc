<cfscript>
	
	component
		displayname="nieruchomosci"
		output=false
		extends="json"
	{
		
		property name="sourceDataSource" type="String" default="formularz_nieruchomosci";
		property name="sourceTableName" type="string" default="pzwr_nieruchomosci";
		property name="destinationDataSource" type="String" default="intranet";
		property name="destinationTableName" type="String" default="pzwr_nieruchomosci";
		
		variables.instance = {
			sourceDataSource = "formularz_nieruchomosci",
			sourceTableName = "pzwr_nieruchomosci",
			destinationDataSource = "intranet",
			destinationTableName = "pzwr_nieruchomosci"
		};
		
		public function init(
			String sourceDataSource = "",
			String sourceTableName = "",
			String destinationDataSource = "",
			String destinationTableName = "")
		{
			
			if( Len( arguments.sourceDataSource ) )
				variables.instance.sourceDataSource = arguments.sourceDataSource;
			
			if( Len( arguments.sourceTableName ) )
				variables.instance.sourceTableName = arguments.sourceTableName;
				
			if( Len( arguments.destinationDataSource ) )
				variables.instance.destinationDataSource = arguments.destinationDataSource;
				
			if( Len( arguments.destinationTableName ) )
				variables.instance.destinationTableName = arguments.destinationTableName;
				
			return this;
			
		}
		
		public function updateLocalTable()
		{
			
			try {
				
				// transaction {
					
					var qSource = new query(
						sql="
							select 
								id,
								imie_nazwisko, 
								telefon, 
								email, 
								wojewodztwo, 
								miejscowosc, 
								kod_pocztowy, 
								ulica, 
								nr, 
								pow_lokalu, 
								pow_sali, 
								czynsz, 
								wyposazenie, 
								source
							from #variables.instance.sourceTableName#
							where readout = 0
						",
						datasource=variables.instance.sourceDataSource);
						
					r = qSource.execute().getResult();
					
					for( i = 1;
						i LTE r.RecordCount;
					  	i = i + 1 ) {
							
						var qDestination = new query(
							sql="
							insert into #variables.instance.destinationTableName#
							(imie_nazwisko, telefon, email, wojewodztwo, miejscowosc, kod_pocztowy, ulica, nr, pow_lokalu, pow_sali, czynsz, wyposazenie, source) values (
							'#r["imie_nazwisko"][i]#',
							'#r["telefon"][i]#',
							'#r["email"][i]#',
							'#r["wojewodztwo"][i]#',
							'#r["miejscowosc"][i]#',
							'#r["kod_pocztowy"][i]#',
							'#r["ulica"][i]#',
							'#r["nr"][i]#',
							'#r["pow_lokalu"][i]#',
							'#r["pow_sali"][i]#',
							'#r["czynsz"][i]#',
							'#r["wyposazenie"][i]#',
							'#r["source"][i]#'
							
							)
							",
							datasource = variables.instance.destinationDataSource).execute();
						
						var qUpdate = new query(
							sql="
							update #variables.instance.destinationTableName#
							set readout = 1
							where id = #r["id"][i]#",
							datasource = variables.instance.sourceDataSource).execute();
							
					}
					
					return true;
					
				// }
				
			}
			catch( Exception e ) {
				
				// transactionRollback();
				return false;
				
			}
			
		}
		
		public query function getPlaces()
		{
			try
			{
				var service = new query(
					sql="
						select
							id,
							imie_nazwisko, 
							telefon, 
							email, 
							wojewodztwo, 
							miejscowosc, 
							kod_pocztowy, 
							ulica, 
							nr, 
							pow_lokalu, 
							pow_sali, 
							czynsz, 
							wyposazenie, 
							source,
							readout
						from #variables.instance.destinationTableName#
						where imported = 0
						order by id asc",
					datasource=variables.instance.destinationDataSource);
					
				return service.execute().getResult();

			}
			catch( Exception e )
			{
				return false;
			}
		
		}
		
		public any function getColumns(
			boolean jsonFormat = false) 
		{
			try
			{
				var service = new query(
					sql = "SHOW COLUMNS FROM #variables.instance.destinationDataSource#.#variables.instance.destinationTableName#",
					datasource=variables.instance.destinationDataSource);
				
				if ( arguments.jsonFormat )
					return QueryToJSON(Query=service.execute().getResult());
				else
					return service.execute().GetResult();
			}
			catch( Exception e )
			{
				return queryNew("id");
			}
		}
		
		/*
			16.07.2013
			Na tej metodzie praktycznie jest oparty cały import nieruchomości
			ze strony internetowej do Intranetu.
		*/
		public void function movePlaces()
		{
			// Pierwszym krokiem jest wylistowanie wszystkiech niezaimportowanych nieruchomości
			// this.updateLocalTable();
			
			// Przechodzę przez wszystkie niezaimportowane do bazy nieruchomości wpisy
			var localPlaces = new query(sql="
				select
					id,
					imie_nazwisko, 
					telefon, 
					email, 
					wojewodztwo, 
					miejscowosc, 
					kod_pocztowy, 
					ulica, 
					nr, 
					pow_lokalu, 
					pow_sali, 
					czynsz, 
					wyposazenie, 
					source,
					readout
				from #variables.instance.destinationTableName#
				where imported = 0",
				datasource=variables.instance.destinationDataSource);
			
			var exportConnections = new query(sql="
				select id, column_name, formid, fieldid from pzwr_export_mapping",
				datasource=variables.instance.destinationDataSource);
			
			var e = exportConnections.execute().getResult();
			var r = localPlaces.execute().getResult();
			
			for(
				i = 1;
				i LTE r.RecordCount;
				i = i + 1){
				
				// Dla każdego z wpisów tworzę nową strukturę tabel nieruchomości
				var myinstance = new query(sql="
					insert into place_instances (userid, instancecreated, source) values (#session.user.id#, Now(), 1)",
					datasource=variables.instance.destinationDataSource);
				
				var myInstanceResult = myinstance.execute();
				
				// Mając zdefiniowane wszystkie formularze mogę przystąpić
				// do aktualizacji pól.
				// Do aktualizacji pól potrzebne jest zbudowanie zapytań, dla
				// każdego pola
				for(
					j = 1;
					j LTE e.RecordCount;
					j = j + 1){
						
					// Buduję zapytanie UPDATE
					// W tym miejscu jest cała magia inportu danych
					var importPlaces = new query(sql="
						update place_instanceforms set formfieldvalue = '#r['#e['column_name'][j]#'][i]#' where formid = #e['formid'][j]# and formfieldid = #e['fieldid'][j]# and instanceid = #myInstanceResult.GETPREFIX().GENERATEDKEY#",
						datasource=variables.instance.destinationDataSource); 
					
					var imprt = importPlaces.execute();
						
				}
				
				// Aktualizuje informacje o lokalizacji. Ustawiam informację 
				// mówiącą, że zoatała już przeniesiona do modułu nieruchomości
				var updatedPlace = new query(sql="
					update #variables.instance.destinationTableName# set imported = 1 where id = #r['id'][i]#",
					datasource=variables.instance.destinationDataSource);
				
				var updatedPlaceResult = updatedPlace.execute();
				
			}
		}
		
		public boolean function moveSinglePlace(required numeric pzwrid)
		{
			try
			{
			
				var placeToMove = new query(sql="
					select
						id,
						imie_nazwisko, 
						telefon, 
						email, 
						wojewodztwo, 
						miejscowosc, 
						kod_pocztowy, 
						ulica, 
						nr, 
						pow_lokalu, 
						pow_sali, 
						czynsz, 
						wyposazenie, 
						source,
						readout
					from #variables.instance.destinationTableName#
					where id = #arguments.pzwrid#
					limit 1",
					datasource=variables.instance.destinationDataSource);	
				var placeToMoveResult = placeToMove.execute().getResult();
			
				var exportConnections = new query(sql="
					select id, column_name, formid, fieldid from pzwr_export_mapping",
					datasource=variables.instance.destinationDataSource);
				var e = exportConnections.execute().getResult();
			
				var myinstance = new query(sql="
						insert into place_instances (userid, instancecreated, source) values (#session.user.id#, Now(), 1)",
						datasource=variables.instance.destinationDataSource);
				var myInstanceResult = myinstance.execute();
			
				for(
					j = 1;
					j LTE e.RecordCount;
					j = j + 1){
							
					// Buduję zapytanie UPDATE
					// W tym miejscu jest cała magia inportu danych
					var importPlaces = new query(sql="
						update place_instanceforms set formfieldvalue = '#placeToMoveResult['#e['column_name'][j]#'][1]#' where formid = #e['formid'][j]# and formfieldid = #e['fieldid'][j]# and instanceid = #myInstanceResult.GETPREFIX().GENERATEDKEY#",
						datasource=variables.instance.destinationDataSource); 
					
					var imprt = importPlaces.execute();
						
				} // end for
				
				// Aktualizuje informacje o lokalizacji. Ustawiam informację 
				// mówiącą, że zoatała już przeniesiona do modułu nieruchomości
				var updatedPlace = new query(sql="
					update #variables.instance.destinationTableName# set imported = 1 where id = #arguments.pzwrid#",
					datasource=variables.instance.destinationDataSource);
				
				var updatedPlaceResult = updatedPlace.execute();
				
				return true;
				
			} // end try
			catch (any exception)
			{
				return false;
			}
			
		} 
		
	}
	
</cfscript>