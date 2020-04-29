
----------------------Обновление технических таблиц----------------------

DO $do$
	declare
	arrow record;
	
BEGIN

----------------------Обновляем записи у обновлённых экземпляров сущности----------------------

	update tech.bonds_tech a
	
	set hash = b.ods_hash,
	dml_type = 'U',
	update_dttm = now()
	
	
	from (
	
		with base as (select 
			a.isin,
			md5 (
			coalesce(a.name, 'none')        								  ||
			coalesce(a.type, 'none')        	  							  ||
			coalesce(a.nominal, 0)          								  ||
			coalesce(a.coupon_amount, 0)   									  ||
			coalesce(to_date(a.coup_paym_date, 'dd.mm.yyyy'), '5999-01-01')   ||
			coalesce(to_date(a.exp_date, 'dd.mm.yyyy'), '5999-01-01') 
			) as ods_hash 
		from ods.quik_bonds a )
		
		select 
			b.src_id,
			a.ods_hash
		from base a 
		
		inner join tech.bonds_tech b 
		on a.isin = b.src_id 
		
		where a.ods_hash <> b.hash
	
	) b
	
	where a.src_id = b.src_id
	
	;
	
----------------------Обновляем записи у удалённых экземпляров сущности----------------------

	update tech.bonds_tech a
	
	set dml_type = 'D',
	update_dttm = now()

	from (
		select 
			a.src_id
		from tech.bonds_tech a
		
		left join ods.quik_bonds b 
		on a.src_id = b.isin
		
		where b.isin is null 
	) b
	
	where a.src_id = b.src_id
	
	;
	
	
----------------------Выделение не обновлённых экземпляров сущности----------------------

	update tech.bonds_tech a
	
	set dml_type = 'NC'

	from (
		with base as (select 
			a.isin,
			md5 (
			coalesce(a.name, 'none')        								  ||
			coalesce(a.type, 'none')        	  							  ||
			coalesce(a.nominal, 0)          								  ||
			coalesce(a.coupon_amount, 0)   									  ||
			coalesce(to_date(a.coup_paym_date, 'dd.mm.yyyy'), '5999-01-01')   ||
			coalesce(to_date(a.exp_date, 'dd.mm.yyyy'), '5999-01-01') 
			) as ods_hash 
		from ods.quik_bonds a )
		
		select 
			b.src_id
		from base a 
		
		inner join tech.bonds_tech b 
		on a.isin = b.src_id 
		and a.ods_hash = b.hash		
		
	) b
	
	where a.src_id = b.src_id
	
	;
 
----------------------Добавление новых экземпляров сущности---------------------- 
	

	
	FOR arrow IN (select max(bond_id) from tech.bonds_tech bt)..((select max(bond_id) from tech.bonds_tech bt) + (select count(*) from ods.quik_bonds a
																													left join tech.bonds_tech b 
																													on a.isin = b.src_id 
																													where b.src_id is null))
	LOOP
	
	
	
	INSERT INTO tech.bonds_tech
		select 
			(select max(bond_id) from tech.bonds_tech bt) + 1 as bond_id,
			a.isin as src_id,
			md5 (
			coalesce(a.name, 'none')        								  ||
			coalesce(a.type, 'none')        	  							  ||
			coalesce(a.nominal, 0)          								  ||
			coalesce(a.coupon_amount, 0)   									  ||
			coalesce(to_date(a.coup_paym_date, 'dd.mm.yyyy'), '5999-01-01')   ||
			coalesce(to_date(a.exp_date, 'dd.mm.yyyy'), '5999-01-01') 
			) as hash,
			'quik' as system_name,
			'I' as dml_type,
			now() as update_dttm
		
		from ods.quik_bonds a
		
		left join tech.bonds_tech b 
		on a.isin = b.src_id 
		
		where b.src_id is null	
		limit 1
	;
	
	commit;
	
	
END LOOP;
 
 
END;
$do$ 
 
 
 