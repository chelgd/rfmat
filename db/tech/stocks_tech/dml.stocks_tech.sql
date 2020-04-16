DO $do$
BEGIN

----------------------Обновлённые технических таблиц----------------------

----------------------Обновляем записи у обновлённых экземпляров сущности----------------------

	update tech.stocks_tech a
	
	set hash = b.ods_hash,
	dml_type = 'U',
	update_dttm = now()
	
	
	from (
	
		with base as (select 
			a.name,
			md5(a.tool_code  ||
                a.lot            ||
                a.class_code) as ods_hash 
		from ods.stocks a )
		
		select 
			b.src_id,
			a.ods_hash
		from base a 
		
		inner join tech.stocks_tech b 
		on a.name = b.src_id 
		
		where a.ods_hash <> b.hash
	
	) b
	
	where a.src_id = b.src_id
	
	;
	
----------------------Обновляем записи у удалённых экземпляров сущности----------------------

	update tech.stocks_tech a
	
	set dml_type = 'D',
	update_dttm = now()

	from (
		select 
			a.src_id
		from tech.stocks_tech a
		
		left join ods.stocks b 
		on a.src_id = b.name
		
		where b.name is null 
	) b
	
	where a.src_id = b.src_id
	
	;
 
----------------------Добавление новых экземпляров сущности---------------------- 
	insert into tech.stocks_tech
	
	select 
		null as stocks_id,
		a.name as src_id,
		md5(a.tool_code  ||
                a.lot            ||
                a.class_code) as hash,
		'quik' as system_name,
		'I' as dml_type,
		now() as update_dttm
	
	from ods.stocks a
	
	left join tech.stocks_tech b 
	on a.name = b.src_id 
	
	where b.src_id is null
	
	;	
 
 
 
END;
$do$ 
 
 
 