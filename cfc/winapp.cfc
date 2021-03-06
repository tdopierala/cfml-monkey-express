component 
	displayname="winnapp" 
	hint="Komponent odpowiedzialny za połączenie z bazą WIN APP 10.99.0.5"
	output="false"  {
	
	property string winnapp;
	property string intranet; 
	
	variables = {
		winapp = "WIN_APP",
		intranet = "intranet"
	};
	
/*	public any function init(){
		
		variables.winapp = "WIN_APP";
		variables.intranet = "intranet";
		
		return this;
	}*/
	
	public any function indexList(){
		
		qStarter = new Query();
			
		qStarter.setDatasource(variables.winapp);
		
		qStarter.cachedwithin=createTimeSpan(0,0,60,0);
		
		qStarter.setSQL("
		
			select 
				vss.Sklep AS projekt
				,vss.Ajent AS logo
				,vss.Starter_brutto AS starter
				
				,(select sum(brutto) 
					from v_dok_FA_FV AS vdfv 
					where 
						vdfv.Logo = vss.Ajent 
						and vdfv.Projekt = vss.Sklep
				) AS fv
				
				,(select sum(WPLATALIN) 
					from v_wplaty AS vw 
					where 
						vw.Logo = vss.Ajent
						and vw.Loc = vss.Sklep
				) AS payment
				
				,(select sum(trans_karta) 
					from v_trans_karta AS vtk 
					where 
						vtk.ajent_id = vss.Ajent
						and vtk.loc = vss.Sklep 
				) AS card
				
			from v_startery_sklepy AS vss
			-- where vss.Sklep NOT IN(SELECT TOP 60 Sklep FROM v_starter_sklepy order by Sklep ASC)
			
			order by vss.Sklep DESC
		");
			
		return qStarter.execute().getResult();

	}
	
	public any function indexList2(){
		
		qStarter = new Query();
			
		qStarter.setDatasource(variables.winapp);
		
		qStarter.setSQL("
		
			declare @vdfv table (logo varchar(255), projekt varchar(255), brutto float, primary key (logo, projekt));
      
			declare @vw table (logo varchar(255), loc varchar(255), brutto float, primary key (logo, loc));
			
			declare @vtk table (ajent_id varchar(255), loc varchar(255), suma float, primary key (ajent_id, loc));

			insert into @vdfv
				select logo, projekt, sum(brutto) as brutto	
				from v_dok_FA_FV AS vdfv 
        		where projekt is not null
				group by logo, projekt;
      
			insert into @vw
				select logo, loc, sum(WPLATALIN) as brutto
				from v_wplaty AS vw 
       			where logo is not null
				group by logo, loc;
			
			insert into @vtk
				select ajent_id, loc, sum(trans_karta) as suma
		        from v_trans_karta AS vtk 
		        where ajent_id is not null
		        group by ajent_id, loc;

			select 
		       vss.Sklep AS projekt
		       ,vss.Ajent AS logo
		       ,vss.Starter_brutto AS starter
		       
		       ,vdfv.brutto AS fv
		       ,vw.brutto AS payment
		       ,vtk.suma AS card
		       
			from v_startery_sklepy AS vss
			
			left join @vdfv vdfv
				on vdfv.logo = vss.Ajent
				and vdfv.projekt = vss.Sklep
			
			left join @vw vw
				on vw.logo = vss.Ajent
				and vw.loc = vss.Sklep
				
			left join @vtk vtk
				on vtk.ajent_id = vss.Ajent
				and vtk.loc = vss.Sklep
		
			order by vss.Sklep DESC

		");
			
		return qStarter.execute().getResult();

	}
	
	public any function paymentList(logo, projekt, types, lgt){
		
		var query='';
		for(i=1; i<=ArrayLen(types); i=i+1){
			
			if(i neq 1)
				query = query & ' union ';
				
			switch(types[i]){
				
				case "wplaty": 
					query &= "
						select vw.Logo AS logo, vw.Data AS data, vw.OPIS AS opis, vw.OPISNAG AS opisnag, vw.WPLATALIN AS kwota, 1 AS typ
						from v_wplaty AS vw
						where vw.Logo = ? and vw.Loc = ?
						and vw.Data <= CONVERT(date, GETDATE()-1) ";
						
					if(lgt>0) query &= " and vw.Data > CONVERT(date, GETDATE()-30) ";
					
				break;
				
				case "fv":
					query &= "
						select vdfv.Logo AS logo, vdfv.Data AS data, vdfv.NumerFK AS opis, '' as opisnag, vdfv.Brutto AS kwota, 2 AS typ
						from v_dok_FA_FV AS vdfv 
						where vdfv.Logo = ? and vdfv.Projekt = ?
						and vdfv.Data <= CONVERT(date, GETDATE()-1) ";
					
					if(lgt>0) query &= " and vdfv.Data > CONVERT(date, GETDATE()-30) ";
					
				break;
				
				case "karty":
					query &= "
						select vtk.ajent_id AS logo, vtk.calendar_date AS data, 'Transakcja kartą' AS opis, '' as opisnag, vtk.trans_karta AS kwota, 3 AS typ
						from v_trans_karta AS vtk 
						where vtk.ajent_id = ? and vtk.loc = ?
						and vtk.calendar_date < CONVERT(date, GETDATE()-1) ";
					
					if(lgt>0) query &= " and vtk.calendar_date > CONVERT(date, GETDATE()-30) ";
					
				break;
			} 
			
		}
		
		qStarter = new Query();
			
		qStarter.setDatasource(variables.winapp);
		
		qStarter.addParam(value="#logo#", CFSQLTYPE="CF_SQL_VARCHAR");
		qStarter.addParam(value="#projekt#", CFSQLTYPE="CF_SQL_VARCHAR");
		qStarter.addParam(value="#logo#", CFSQLTYPE="CF_SQL_VARCHAR");
		qStarter.addParam(value="#projekt#", CFSQLTYPE="CF_SQL_VARCHAR");
		qStarter.addParam(value="#logo#", CFSQLTYPE="CF_SQL_VARCHAR");
		qStarter.addParam(value="#projekt#", CFSQLTYPE="CF_SQL_VARCHAR");
		
		qStarter.setSQL("
		
			select * from (	#query#	) t
			
			order by t.data DESC
			
		");
			
		return qStarter.execute().getResult();
		
	}
	
	public any function ratioList(from, amount, orderby, order){
		
		switch(orderby){
			case 'sklep': orderby = 'vss.Sklep'; break;
			case 'starter': orderby = 'vss.Starter_brutto'; break;
			case 'fv': orderby = 'fv'; break;
			default: orderby = 'vss.Sklep';
		}
		
		if(order eq 'desc') order = 'desc';
		else order = 'asc';
		
		qStarter = new Query();
			
		qStarter.setDatasource(variables.winapp);
		//orderby, order
		qStarter.addParam(value="#amount#", CFSQLTYPE="CF_SQL_INTEGER");
		qStarter.addParam(value="#from#", CFSQLTYPE="CF_SQL_INTEGER");
		qStarter.addParam(value="#orderby#", CFSQLTYPE="CF_SQL_VARCHAR");
		qStarter.addParam(value="#order#", CFSQLTYPE="CF_SQL_VARCHAR");
		
		qStarter.setSQL("
		
			select TOP #amount#
				vss.Sklep as projekt
				,vss.Ajent as logo
				,vss.Starter_brutto as starter
				
				,(select sum(brutto) 
					from v_dok_FA_FV AS vdfv 
					where 
						vdfv.Logo = vss.Ajent 
						and vdfv.Projekt = vss.Sklep
				) AS fv
				
				,(select sum(WPLATALIN) 
					from v_wplaty AS vw 
					where 
						vw.Logo = vss.Ajent
						and vw.Loc = vss.Sklep
				) AS payment
				
				,(select sum(trans_karta) 
					from v_trans_karta AS vtk 
					where 
						vtk.ajent_id = vss.Ajent
						and vtk.loc = vss.Sklep
				) AS card
				
				
			from v_startery_sklepy as vss
			where vss.Sklep NOT IN(SELECT TOP #from# Sklep FROM v_startery_sklepy order by Sklep DESC)
			
			order by #orderby# #order#
				
		");
			
		return qStarter.execute().getResult();

	}
	
	public any function ratioList2(from, amount, orderby, order, sklep){
		
		switch(orderby){
			case 'sklep': orderby = 'vss.Sklep'; break;
			case 'starter': orderby = 'vss.Starter_brutto'; break;
			case 'fv': orderby = 'fv'; break;
			default: orderby = 'vss.Sklep';
		}
		
		if(order eq 'desc') order = 'desc';
		else order = 'asc';
		
		qStarter = new Query();
			
		qStarter.setDatasource(variables.winapp);

		qStarter.addParam(value="#amount#", CFSQLTYPE="CF_SQL_INTEGER");
		qStarter.addParam(value="#from#", CFSQLTYPE="CF_SQL_INTEGER");
		qStarter.addParam(value="#orderby#", CFSQLTYPE="CF_SQL_VARCHAR");
		qStarter.addParam(value="#order#", CFSQLTYPE="CF_SQL_VARCHAR");
		qStarter.addParam(value="#sklep#", CFSQLTYPE="CF_SQL_VARCHAR");
		
		qStarter.setSQL("
		
				declare @vdfv table (logo varchar(255), projekt varchar(255), brutto float);
      
				declare @vw table (logo varchar(255), loc varchar(255), brutto float);
				
				declare @vtk table (ajent_id varchar(255), loc varchar(255), suma float);
	
				insert into @vdfv
					select logo, substring(projekt, 2, len(Projekt)) as projekt, sum(brutto) as brutto	
					from v_dok_FA_FV AS vdfv 
	        		where projekt is not null
					group by logo, projekt;
	      
				insert into @vw
					select logo, substring(loc, 2, LEN(loc) ) as loc, sum(WPLATALIN) as brutto
					from v_wplaty AS vw 
	        		where logo is not null and Loc <> ''
					group by logo, loc;
				
				insert into @vtk
					select ajent_id, substring(loc, 2, len(loc)) as loc, sum(trans_karta) as suma
	        		from v_trans_karta AS vtk 
	        		where ajent_id is not null
	        		group by ajent_id, loc;
	
				select
			        vss.Sklep AS projekt
			       ,vss.Ajent AS logo
			       ,vss.Starter_brutto AS starter
			       
			       ,vdfv.brutto AS fv
			       ,vw.brutto AS payment
			       ,vtk.suma AS card
		           ,(vw.brutto + vtk.suma*(-1)) as sumpayment
		           ,(vdfv.brutto - (vw.brutto + vtk.suma*(-1))) as substract
		           ,(vss.Starter_brutto + (vdfv.brutto - (vw.brutto + vtk.suma*(-1))))/vss.Starter_brutto as ratio
	      
				from v_startery_sklepy AS vss
				
				left join @vdfv vdfv
					on vdfv.logo = vss.Ajent
					and vdfv.projekt = substring(vss.Sklep, 2, len(vss.Sklep))
				
				left join @vw vw
					on vw.logo = vss.Ajent
					and vw.loc = substring(vss.Sklep, 2, len(vss.Sklep))
	      
				left join @vtk vtk
					on vtk.ajent_id = vss.Ajent
					and vtk.loc = substring(vss.Sklep, 2, len(vss.Sklep))
	      
				where 
					vss.Sklep NOT IN(SELECT TOP #from# Sklep FROM v_startery_sklepy order by #orderby# #order#)
					and vss.Sklep like '%#sklep#%'
			
				order by #orderby# #order#
				
		");
			
		return qStarter.execute().getResult();

	}
	
	public any function ratioList3(from, amount, orderby, order, sklep){
		
		switch(orderby){
			case 'sklep'	: orderby = 'projekt'; break;
			case 'starter'	: orderby = 'starter'; break;
			case 'fv'		: orderby = 'fv'; break;
			case 'payment'	: orderby = 'sumpayment'; break;
			case 'substract': orderby = 'substract'; break;
			case 'ratio'	: orderby = 'ratio'; break;
			case 'exp'		: orderby = 'expected'; break;
			case 'expratio'	: orderby = 'expected_ratio'; break;
			default			: orderby = 'ratio';
		}
		
		if(order eq 'asc') order = 'asc';
		else order = 'desc';
		
		qStarter = new Query();
			
		qStarter.setDatasource(variables.winapp);

		qStarter.addParam(value="#amount#",	CFSQLTYPE="CF_SQL_INTEGER");
		qStarter.addParam(value="#from#",	CFSQLTYPE="CF_SQL_INTEGER");
		qStarter.addParam(value="#orderby#",CFSQLTYPE="CF_SQL_VARCHAR");
		qStarter.addParam(value="#order#",	CFSQLTYPE="CF_SQL_VARCHAR");
		qStarter.addParam(value="#sklep#",	CFSQLTYPE="CF_SQL_VARCHAR");
		
		qStarter.setSQL("
		
			select TOP #amount# 
				projekt ,logo ,starter ,fv ,payment ,card ,sumpayment ,substract ,ratio ,expected ,expected_ratio
			
			from RAP_STARTER_INTRANET
			
			where 
				projekt NOT IN(SELECT TOP #from# projekt FROM RAP_STARTER_INTRANET order by #orderby# #order#)
				and projekt like '%#sklep#%'
			
			order by #orderby# #order#
				
		");
			
		return qStarter.execute().getResult();

	}
	
	public any function ratioList3Count(sklep){
		
		qStarter = new Query();
			
		qStarter.setDatasource(variables.winapp);

		qStarter.addParam(value="#sklep#",	CFSQLTYPE="CF_SQL_VARCHAR");
		
		qStarter.setSQL("
			select count(*) as c from RAP_STARTER_INTRANET where projekt like '%#sklep#%'
		");
			
		return qStarter.execute().getResult();

	}
	
	public any function findOne(string project){
		
		qStarter = new Query();
			
		qStarter.setDatasource(variables.winapp);
		
		qStarter.addParam(name="project", value="#project#", CFSQLTYPE="CF_SQL_VARCHAR");
		
		qStarter.setSQL("
		
			select top 1
				vss.Sklep AS projekt
				,vss.Starter_brutto AS starter
				
				,(select sum(brutto) 
					from v_dok_FA_FV AS vdfv 
					where 
						vdfv.Projekt = vss.Sklep 
						-- and vdfv.Data <= '2013-11-30' 
				) AS fv
				
				,(select sum(wplata) 
					from v_wplaty AS vw 
					where 
						vw.Loc = vss.Sklep
						-- and vw.Data <= '2013-11-30' 
				) AS payment
				
				,(select sum(trans_karta) 
					from v_trans_karta AS vtk 
					where 
						vtk.loc = vss.Sklep
						-- and vtk.calendar_date < '20131130' 
				) AS card
				
			from v_starter_sklepy AS vss
			where vss.Sklep = ':project'
			
			order by vss.Sklep DESC
				
		");
			
		return qStarter.execute().getResult();

	}
	
	public any function test(){
		
		qStarter = new Query();
			
		qStarter.setDatasource(variables.winapp);
		
		qStarter.setSQL("
		
			select 
				vss.Sklep AS projekt
				,vss.Ajent AS logo
				,vss.Starter_brutto AS starter
				
				,(select sum(brutto) 
					from v_dok_FA_FV AS vdfv 
					where 
						vdfv.Logo = vss.Ajent 
						and vdfv.Projekt = vss.Sklep
				) AS fv
				
				,(select sum(WPLATALIN) 
					from v_wplaty AS vw 
					where 
						vw.Logo = vss.Ajent
						and vw.Loc = vss.Sklep
				) AS payment
				
				,(select sum(trans_karta) 
					from v_trans_karta AS vtk 
					where 
						vtk.ajent_id = vss.Ajent
						and vtk.loc = vss.Sklep 
				) AS card
				
			from v_startery_sklepy AS vss
			
			order by starter desc
			
		");
			
		return qStarter.execute().getResult();

	}
	
	public any function wplaty(logo, projekt, lgt){
		
		qPayment = new Query();
			
		qPayment.setDatasource(variables.winapp);
		
		qPayment.cachedwithin=createTimeSpan(0,1,0,0);
		
		query="
			select
				 vw.logo as logo
				,vw.loc as projekt
				,CONVERT(VARCHAR(30), vw.Data, 112) as d
				,vw.Data as data
				,sum(vw.WPLATALIN) as wplata
				,max(vw.OpisNag) as opis
			from v_wplaty AS vw
			where 
				vw.logo is not null 
				and vw.logo = #logo#
				and (
					vw.Loc = '#projekt#' 
					or (vw.Loc = '' and vw.LocOld = '#projekt#')
				)
				and vw.Data <= CONVERT(date, GETDATE()-1)
			";
		
		if(lgt>0) query &= " and vw.Data > CONVERT(date, GETDATE()-30) ";
		
		query &= " 
			group by Data, Logo, Loc
			order by vw.Data desc ";
		
		qPayment.setSQL(query);
			
		return qPayment.execute().getResult();
		
	}
	
	public any function faktury(logo, projekt, lgt){
		
		qFv = new Query();
			
		qFv.setDatasource(variables.winapp);
		
		qFv.cachedwithin=createTimeSpan(0,1,0,0);
		
		query="
			select 
				-- vdfv.Logo as logo
				-- ,vdfv.Projekt as projekt
				CONVERT(VARCHAR(30), vdfv.Data, 112) as d
				,vdfv.Data as data
				-- ,sum(vdfv.Brutto) as fv
				,vdfv.Brutto as fv
				,vdfv.NumerDok as nrdok
			from v_dok_FA_FV AS vdfv 
			where 
				vdfv.Projekt is not null
				and vdfv.Projekt = '#projekt#'
				and vdfv.Logo = #logo#
				and vdfv.Data <= CONVERT(date, GETDATE()-1)
		";
		
		if(lgt>0) query &= " and vdfv.Data > CONVERT(date, GETDATE()-30) ";
		
		query &= "
			-- group by vdfv.Data
			order by vdfv.Data desc ";

		qFv.setSQL(query);
			
		return qFv.execute().getResult();
		
	}
	
	public any function karta(logo, projekt, lgt){
		
		qCard = new Query();
			
		qCard.setDatasource(variables.winapp);
		
		qCard.cachedwithin=createTimeSpan(0,1,0,0);
		
		query = "
			select 
				-- vtk.loc as projekt
				-- ,vtk.ajent_id as logo
				vtk.calendar_date as d
				,sum(vtk.trans_karta) as card
			from v_trans_karta AS vtk 
			where 
				vtk.ajent_id = #logo#
				and vtk.loc = '#projekt#'
				and vtk.calendar_date < CONVERT(date, GETDATE()-1)
		";
		
		if(lgt>0) query &= " and vtk.calendar_date > CONVERT(date, GETDATE()-30) ";
		
		query &= "
			group by vtk.calendar_date
			order by vtk.calendar_date desc
		";
		
		qCard.setSQL(query);
			
		return qCard.execute().getResult();
		
	}
	
	public any function oczekiwane(logo, projekt, lgt){
		
		qStarter = new Query();
			
		qStarter.setDatasource(variables.winapp);
		
		qStarter.cachedwithin=createTimeSpan(0,1,0,0);
		
		/*query = "
			select
			  -- vpw.loc as projekt
			  vpw.ajent_id as logo
			  ,vpw.calendar_date as d
			  -- ,sum(vpw.do_zaplaty) as expected
			  ,sum(vpw.DZ_algorytm) as expected
			from v_planowane_wplaty AS vpw 
			where 
			  vpw.ajent_id = #logo#
			  -- and vpw.loc = '#projekt#' 
			  and vpw.calendar_date < CONVERT(date, GETDATE()-2)
		";*/
		
		query="
			select
			  vpw.ajent_id as logo
			  -- ,vpw.calendar_date as d
			  ,CONVERT(VARCHAR(30), convert(date, cast(vpw.calendar_date as datetime)+1), 112) as d
			  -- ,sum(vpw.do_zaplaty) as expected
			  ,sum(vpw.DZ_algorytm) as expected
			from PLANOWANE_WPLATY as vpw 
			where
				vpw.ajent_id = #logo#
				and vpw.loc = '#projekt#' 
				and vpw.calendar_date < CONVERT(date, GETDATE()-2)
		";
		
		if(lgt>0) query &= " and vpw.calendar_date > CONVERT(date, GETDATE()-30) ";
		
		query &= "
			group by vpw.calendar_date, vpw.ajent_id
      		order by vpw.calendar_date desc
		";
		
		qStarter.setSQL(query);
			
		return qStarter.execute().getResult();
		
	}
	
	public any function store_repo(logo, projekt){
		
		qStore = new Query();
			
		qStore.setDatasource(variables.winapp);
		
		qStore.cachedwithin=createTimeSpan(0,1,0,0);
		
		qStore.setSQL("
			select 
				projekt ,logo ,starter ,fv ,payment ,card ,sumpayment ,substract ,ratio ,expected ,expected_ratio
			
			from RAP_STARTER_INTRANET
			
			where 
				logo = #logo#
				and projekt = '#projekt#'
			
		");
			
		return qStore.execute().getResult();
		
	}
	
	public any function startery(){
		
		qStarter = new Query();
			
		qStarter.setDatasource(variables.winapp);
		
		qStarter.setSQL("
			SELECT * FROM v_startery_sklepy where Sklep = 'C13081'
		");
			
		return qStarter.execute().getResult();
		
	}
	
	public any function daylyUpdate(){
		
		qStarter = new Query();
			
		qStarter.setDatasource(variables.winapp);
		
		qStarter.setSQL("
		
	     BEGIN TRANSACTION [WSK_INTRANET]

  	  BEGIN TRY
  
      delete from RAP_STARTER_INTRANET;
      
      declare @starter table (logo varchar(255), projekt varchar(255), brutto float, primary key (logo, projekt));
      
      declare @vdfv table (logo varchar(255), projekt varchar(255), brutto float);
      
      declare @vwtmp table (logo varchar(255), loc varchar(255), old varchar(255), brutto float);
      
      declare @vw table (logo varchar(255), loc varchar(255), brutto float);
			
	  declare @vtk table (ajent_id varchar(255), loc varchar(255), suma float);
      
      declare @vpw table (ajent_id varchar(255), loc varchar(255), suma float);
      
      -- declare @vfex table (count integer(11), loc varchar(255), primary key (loc));
      
      insert into @starter
        select 
           vss1.Ajent as logo
          ,vss1.Sklep as projekt
          ,case
            when vss3.Starter_brutto is not null then vss3.Starter_brutto
            when vss1.Starter_brutto is null then vss2.starter
            when vss1.Starter_brutto is not null then vss1.Starter_brutto
          end as brutto
          --,vss1.Starter_brutto as brutto1
          --,vss2.starter as brutto2
        from v_startery_sklepy as vss1
        left join v_startery_sklepy_FV as vss2 on vss2.logo = vss1.Ajent and vss2.Projekt = vss1.Sklep
        left join STARTER_MOD as vss3 on vss3.Ajent = vss1.Ajent and vss3.Sklep = vss1.Sklep
        where vss1.Ajent is not null
      
		insert into @vdfv
		select 
          logo as loc
          ,substring(projekt,2,len(projekt)) as projekt
          ,sum(brutto) as brutto	
				from v_dok_FA_FV AS vdfv 
        where 
          projekt is not null                                                                                              
          and data <= CONVERT(date, GETDATE()-1)
				group by logo, projekt;
        
      insert into @vwtmp
       select 
          vw1.logo as logo
          ,substring(vw1.loc,2,len(vw1.loc)) as loc
          ,vw1.LocOld as old
          ,sum(vw1.WPLATALIN) as brutto
				from v_wplaty AS vw1
        where 
          vw1.logo is not null 
          -- and ((vw1.loc = '' and vw1.LocOld is not null) or (vw1.loc <> '' and vw1.LocOld is null))
          and substring(vw1.loc,1,1) = 'B'
          and vw1.data <= CONVERT(date, GETDATE()-1)
				group by vw1.logo, vw1.loc, vw1.LocOld
        order by vw1.logo desc;
      
			insert into @vw
         select 
          v1.logo
          ,v1.loc
          ,case
            when v2.brutto is null then v1.brutto
            when v2.brutto is not null then (v1.brutto + v2.brutto)
          end as brutto
        from @vwtmp v1
        left join @vwtmp v2 on v1.loc = v2.old and v1.logo = v2.logo
        where v1.loc <> '';
			
			insert into @vtk
				select ajent_id, substring(loc,2,len(loc)) as loc, sum(trans_karta) as suma
        from v_trans_karta AS vtk 
        where 
          ajent_id is not null
          and vtk.calendar_date < CONVERT(date, GETDATE()-1)
          and substring(loc,1,1) = 'B'
        group by ajent_id, loc;
        
      insert into @vpw
           select ajent_id, substring(loc,2,len(loc)) as loc, sum(DZ_algorytm) as suma
          from PLANOWANE_WPLATY AS vpw 
          where 
            ajent_id is not null
            and vpw.calendar_date < CONVERT(date, GETDATE()-2)
            and substring(loc,1,1) = 'B'
          group by ajent_id, loc;
      
      insert into RAP_STARTER_INTRANET
			select 
		    vss.projekt AS projekt
            ,vss.logo AS logo
            ,vss.brutto AS starter
		       
            ,vdfv.brutto AS fv
            ,vw1.brutto AS payment
            ,vtk.suma AS card
            ,((vw1.brutto) + vtk.suma*(-1)) as sumpayment
            ,(vdfv.brutto - ((vw1.brutto) + vtk.suma*(-1))) as substract
            ,(vdfv.brutto - (vw1.brutto + vtk.suma*(-1)))/vss.brutto as ratio
            ,vw1.brutto - vpw.suma AS expected
            ,CASE 
              WHEN vpw.suma <> 0 THEN (vw1.brutto/vpw.suma)
              WHEN vpw.suma = 0 THEN NULL
            END * 100 AS expected_ratio
            ,0
      
			from @starter AS vss
			
			left join @vdfv vdfv
				on vdfv.logo = vss.logo
				and vdfv.projekt = substring(vss.projekt,2,len(vss.projekt))
			
			left join @vw vw1
				on vw1.logo = vss.logo
				and vw1.loc = substring(vss.projekt,2,len(vss.projekt))
      
			left join @vtk vtk
				on vtk.ajent_id = vss.logo
				and vtk.loc = substring(vss.projekt,2,len(vss.projekt))
        
      left join @vpw vpw
				on vpw.ajent_id = vss.logo
        and vpw.loc = substring(vss.projekt,2,len(vss.projekt))
      
			-- where vss.Sklep = 'C12069'
      
  COMMIT TRANSACTION [WSK_INTRANET]

  END TRY
    
    BEGIN CATCH
      ROLLBACK TRANSACTION [WSK_INTRANET]
      
  END CATCH
		");
			
		return qStarter.execute().getResult();
		
	}

	// Funkcja pobierająca obroty sklepów na podstawie miesiąca i roku
	// Miesiac i rok sa konkatenowane i stanowią nazwę kolumny, z której 
	// pobierane są dane
	public query function obroty(
		required string nazwaKolumny) {

		testQuery = new Query();
		testQuery.setDatasource(variables.winapp);
		testQuery.setSQL("select top 0 * from Obroty");
		testResult = testQuery.execute().getResult();

		obrotyQuery = new Query();
		obrotyQuery.setDatasource(variables.winapp);

		if (ListFindNoCase(testResult.columnList, arguments.nazwaKolumny)) {
			obrotyQuery.setSQL("
				select LOC, ADRES, ISNULL(#arguments.nazwaKolumny#, 0) as obrot
				from Obroty
			");
		} else {
			obrotyQuery.setSQL("
				select LOC, ADRES, '' as obrot
				from Obroty
				where 1 = 0
			");
		}

		return obrotyQuery.execute().getResult();		

	}
	
	//Pobiera obroty dla danego sklepu
	public query function obroty2(
		required string sklep) {

		qSales = new Query();
		qSales.setDatasource(variables.winapp);
		
		qSales.setSQL("
			select * from Obroty where LOC like '#arguments.sklep#'");

		return qSales.execute().getResult();		

	}
	
	public query function towaryWSieci() {
		var zapytanie = new query();
		zapytanie.setDatasource(variables.winapp);
		zapytanie.setSQL("select * from v_mg_kar_intra where Superkategoria not like 'DODO' and Superkategoria not like 'monkey' and Superkategoria not like 'PRODUKTY REGIONALNE' and Superkategoria not like 'DOŁADOWANIA' and Status <> 'W' and Symkar not like '7%' and Symkar not like '6%' and Symkar not like '5%' and (LEN(Kodkres) = 8 or LEN(Kodkres) = 13)");
		
		var result = zapytanie.execute().getResult();
		
		return result;
	}
}