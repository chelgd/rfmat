DO $do$
BEGIN

----------------------Обновлённие версионных данных----------------------

----------------------Обновляем записи у обновлённых экземпляров сущности----------------------

	update dds.stocks_v a
	
	set valid_to_dt = DATE(now()),
	dml = 'U',
	act_flg = 0
	
	from (
	
	select 
		stocks_id
	from tech.stocks_tech
	where  dml_type = 'U'
	
	) b
	
	where a.stocks_id = b.stocks_id

	;

----------------------Вставляем новые версии экземпляров сущности----------------------
	
	insert into dds.stocks_v
	select 
	
		a.stocks_id,
		b.name,
        b.tool_code,
        b.lot,
        b.class_code,
		DATE(now()) as valid_from_dt,
		'5999-01-01' as valid_to_dt,
		'I' as dml,
		1 as act_flg

	from tech.stocks_tech a
	
	left join ods.stocks b
	on a.src_id = b.name
	
	where a.dml_type = 'U'
	
	;	
		
	
----------------------Обновляем записи у удалённых экземпляров сущности----------------------
	
	update dds.stocks_v a
	
	set valid_to_dt = DATE(now()),
	dml = 'D',
	act_flg = 0
	
	from (
	
	select 
		stocks_id
	from tech.stocks_tech
	where  dml_type = 'D'
	
	) b
	
	where a.stocks_id = b.stocks_id

	; 


----------------------Вставляем новые экземпляры сущности---------------------- 
 
END;
$do$ 
 