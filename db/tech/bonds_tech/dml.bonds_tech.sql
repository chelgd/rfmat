DO $do$
BEGIN

----------------------Обновлённые технических таблиц----------------------

----------------------Обновляем записи у обновлённых экземпляров сущности----------------------

	update tech.bonds_tech a
	
	set hash = b.ods_hash,
	dml_type = 'U',
	update_dttm = now()
	
	
	from (
	
		with base as (select 
			a.name,
			md5 (a.type         ||
			a.nominal          ||
			a.coupon_amount    ||
			to_date(a.coup_paym_date, 'dd.mm.yyyy')   ||
			to_date(a.exp_date, 'dd.mm.yyyy')) as ods_hash 
		from ods.bonds a )
		
		select 
			b.src_id,
			a.ods_hash
		from base a 
		
		inner join tech.bonds_tech b 
		on a.name = b.src_id 
		
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
		
		left join ods.bonds b 
		on a.src_id = b.name
		
		where b.name is null 
	) b
	
	where a.src_id = b.src_id
	
	;
 
----------------------Добавление новых экземпляров сущности---------------------- 
	insert into tech.bonds_tech
	
	select 
		null as bond_id,
		a.name as src_id,
		md5 (a.type         ||
		a.nominal          ||
		a.coupon_amount    ||
		to_date(a.coup_paym_date, 'dd.mm.yyyy')   ||
		to_date(a.exp_date, 'dd.mm.yyyy')) as hash,
		'quik' as system_name,
		'I' as dml_type,
		now() as update_dttm
	
	from ods.bonds a
	
	left join tech.bonds_tech b 
	on a.name = b.src_id 
	
	where b.src_id is null
	
	;	
 
 
 
END;
$do$ 
 
 
 