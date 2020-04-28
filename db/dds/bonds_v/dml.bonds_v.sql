DO $do$
BEGIN

----------------------Обновлённие версионных данных----------------------

----------------------Обновляем записи у обновлённых экземпляров сущности----------------------

	update dds.bonds_v a
	
	set valid_to_dt = DATE(now()),
	dml = 'U',
	act_flg = 0
	
	from (
	
	select 
		bond_id,
		update_dttm
	from tech.bonds_tech
	where  dml_type = 'U'
	
	) b
	
	where a.bond_id = b.bond_id

	;

----------------------Вставляем новые версии экземпляров сущности----------------------
	
	insert into dds.bonds_v
	select 
	
		a.bond_id,
		b.isin,
		b.name,
		b.type,
		b.nominal,
		b.coupon_amount,
		to_date(b.coup_paym_date, 'dd.mm.yyyy') as coup_paym_date,
		to_date(b.exp_date, 'dd.mm.yyyy') as exp_date,
		DATE(now()) as valid_from_dt,
		'5999-01-01' as valid_to_dt,
		'I' as dml,
		1 as act_flg

	from tech.bonds_tech a
	
	left join ods.bonds b
	on a.src_id = b.isin
	
	where a.dml_type = 'U'
	
	;	
		
----------------------Удаление версионных данных----------------------
	
----------------------Обновляем записи у удалённых экземпляров сущности----------------------
	
	update dds.bonds_v a
	
	set valid_to_dt = DATE(now()),
	dml = 'D',
	act_flg = 0
	
	from (
	
	select 
		bond_id
	from tech.bonds_tech
	where  dml_type = 'D'
	
	) b
	
	where a.bond_id = b.bond_id

	; 


----------------------Вставка версионных данных----------------------

----------------------Вставляем новые экземпляры сущности---------------------- 

	INSERT INTO dds.bonds_v 

	with base as (select 
						bond_id,
						src_id
				from tech.bonds_tech bt 
					
				where bond_id > (select max(bond_id) from dds.bonds_v)
					)
	
	select 
		a.bond_id,
		b.isin,
		b.name,
		b.type,
		b.nominal,
		b.coupon_amount,   
		to_date(b.coup_paym_date, 'dd.mm.yyyy') as coup_paym_date,
		to_date(b.exp_date, 'dd.mm.yyyy') as exp_date,
		date(now()) as valid_to_dt,
		'5999-01-01' as valid_to_dt,
		'I' as dml,
		1 as act_flg		
		
	from base a
	
	left join ods.bonds b 
	on a.src_id = b.isin
	;
	


 
END;
$do$ 
 