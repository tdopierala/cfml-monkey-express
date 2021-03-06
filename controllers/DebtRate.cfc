component 
	extends="Controller" {
		
		function init(){
			
			super.init();
			filters(through="authentication");
			
		}
		
		function authentication(){
			
			/*<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="priv" >
				<cfinvokeargument name="groupname" value="root" />
			</cfinvoke>*/
			
			var obj = createObject("component","Tree_groupusers");
			var method = "checkUserTreeGroup";  
			var args = {groupname="Wskaźnik zadłużenia"};
			
			result = evaluate("obj.#method#(argumentCollection=args)");
			
			if(not result) {
				renderPage(template="/autherror");
			}
			
		} 
		
		function index(){

			if(StructKeyExists(session, "debtrate")){
				minratio = session.debtrate;
			} else {
				StructInsert(session, "debtrate", 130);
				minratio = session.debtrate;
			}
			
		}
		
		function payment(){
			starter = application.cfc.winapp.paymentList();
		}
		
		function ratio(){			
		}
		
		function setMaxRatio() {
			
			if(StructKeyExists(params, "max")){
				session.debtrate = params.max;
			}
			
			json = 'ok';
			renderWith(data="json",template="/json",layout=false);
			
		}
		
		function genereRatio(){
			
			minratio = session.debtrate;
			
			if(StructKeyExists(params, "orderby")){
				orderby = params.orderby;
			} else {
				orderby = 'exp';
			}
			
			if(StructKeyExists(params, "order")){
				order = params.order;
			} else {
				order = 'desc';
			}
			
			if(StructKeyExists(params,"page")){
				page = LSParseNumber(params.page);
			} else {
				page = 1;
			}
			
			if(StructKeyExists(params,"projekt")){
				projekt = params.projekt;
			} else {
				projekt = '';
			}
			
			amount = 20;
			
			from = ((page-1)*amount);
			
			ratioList = application.cfc.winapp.ratioList3(from, amount, orderby, order, projekt);
			ratioListCount = application.cfc.winapp.ratioList3Count(projekt);
			
			qStores = model("Store_store").findAll(select="projekt, TRIM(miasto) as miasto, TRIM(ulica) as ulica", group="projekt");
			
			stores = StructNew();
			for( i=1; i lte qStores.RecordCount; i=i+1 ){
				
				ulica = Replace(qStores["ulica"][i], "ul. ", "");
				ulica = Replace(ulica, "al. ", "");
				ulica = Replace(ulica, "pl. ", "");
				//ulica = Replace(ulica, ",", ", ");
				
				StructInsert(stores, qStores["projekt"][i], qStores["miasto"][i] & ', ' & ulica, true);
				
			}
			
			renderPartial("index");
			
			//variable = starterList;
			//renderWith(data="variable",template="/dump",layout=false);
			
		}
		
		function details(){
			
			if(StructKeyExists(params, "logo") and StructKeyExists(params, "projekt")){
				
				types = ArrayNew(1);
				tablen = 1;
				
				if(StructKeyExists(params, "wplaty")){
					types[tablen] = "wplaty";
					tablen = tablen+1;
				}
				
				if(StructKeyExists(params, "fv")){
					types[tablen] = "fv";
					tablen = tablen+1;
				}
				
				if(StructKeyExists(params, "karty")){
					types[tablen] = "karty";
					tablen = tablen+1;
				}
				
				if(ArrayLen(types) eq 0){
					types[1] = "wplaty";
					_wplaty_check = true;
					types[2] = "fv";
					_fv_check = true;
					types[3] = "karty";
					_karty_check = true;
				}
				
				if(StructKeyExists(params, "full")){
					lgt = 0;
				} else {
					lgt = 1;
				}
				
				qStarter = application.cfc.winapp.paymentList(params.logo, params.projekt, types, lgt);
				
				//variable = types;
				//renderWith(data="variable",template="/dump",layout=false);
			}
			
		}
		
		function details2(){
			
			if(StructKeyExists(params, "logo") and StructKeyExists(params, "projekt")){
				
				types = ArrayNew(1);
				tablen = 1;
				
				if(StructKeyExists(params, "wplaty")){
					types[tablen] = "wplaty";
					tablen = tablen+1;
				}
				
				if(StructKeyExists(params, "fv")){
					types[tablen] = "fv";
					tablen = tablen+1;
				}
				
				if(StructKeyExists(params, "karty")){
					types[tablen] = "karty";
					tablen = tablen+1;
				}
				
				if(ArrayLen(types) eq 0){
					types[1] = "wplaty";
					_wplaty_check = true;
					types[2] = "fv";
					_fv_check = true;
					types[3] = "karty";
					_karty_check = true;
				}
				
				if(StructKeyExists(params, "full")){
					lgt = 0;
				} else {
					lgt = 0;
				}
				
				qPayment = application.cfc.winapp.wplaty(params.logo, params.projekt, lgt);
				qFv = application.cfc.winapp.faktury(params.logo, params.projekt, lgt);
				qCard = application.cfc.winapp.karta(params.logo, params.projekt, lgt);
				qExp = application.cfc.winapp.oczekiwane(params.logo, params.projekt, lgt);
				
				qStore = application.cfc.winapp.store_repo(params.logo, params.projekt);
				
				var j = 0;
				
				dates = ArrayNew(1);
				
				for(a=1; a<=qPayment.RecordCount; a++){
					if(ArrayFind(dates, qPayment['d'][a]) eq 0){
						j++;
						dates[j] = qPayment['d'][a];
					}
				}
				
				for(b=1; b<=qFv.RecordCount; b++){					
					if(ArrayFind(dates, qFv['d'][b]) eq 0){
						j++;
						dates[j] = qFv['d'][b];
					}
				}
				
				for(d=1; d<=qCard.RecordCount; d++){					
					if(ArrayFind(dates, qCard['d'][d]) eq 0){
						j++;
						dates[j] = qCard['d'][d];
					}
				}
				
				for(e=1; e<=qExp.RecordCount; e++){					
					if(ArrayFind(dates, qExp['d'][e]) eq 0){
						j++;
						dates[j] = qExp['d'][e];
					}
				}
				
				ArraySort(dates, "numeric", "desc");
			}
			
		}
		
	} 