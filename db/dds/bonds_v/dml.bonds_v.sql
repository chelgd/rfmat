DO $do$
BEGIN

----------------------Обновлённие версионных данных----------------------

----------------------Обновляем записи у обновлённых экземпляров сущности----------------------

	update dds.bonds_v a
	
	set valid_to_dt = DATE(now()),
	act_flg = 0
	
	from (
	
	select 
		bond_id,
		update_dttm
	from tech.bonds_tech
	where  dml = 'U'
	
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
		'U' as dml,
		1 as act_flg

	from tech.bonds_tech a
	
	left join ods.quik_bonds b
	on a.src_id = b.isin
	
	where a.dml = 'U'
	
	;	
		
----------------------Удаление версионных данных----------------------
	
----------------------Обновляем записи у удалённых экземпляров сущности----------------------
	
	update dds.bonds_v a
	
	set valid_to_dt = DATE(now()),
	act_flg = 0
	
	from (
	
	select 
		bond_id
	from tech.bonds_tech
	where  dml = 'D'
	
	) b
	
	where a.bond_id = b.bond_id

	; 

----------------------Вставляем удаливший флаг удалённых экземпляров сущности----------------------

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
		'D' as dml,
		0 as act_flg

	from tech.bonds_tech a
	
	left join ods.quik_bonds b
	on a.src_id = b.isin
	
	where a.dml = 'D'
	
	;	


----------------------Вставка новых или заново появившихся версионных данных----------------------

----------------------Обновляем флаг удалённых и заново появившихся экземпляров сущности----------------------

	update dds.bonds_v a
	
	set valid_to_dt = DATE(now())

	from tech.bonds_tech b
	
	where b.dml = 'I'
	and a.dml = 'D'
	
	;

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
	
	left join ods.quik_bonds b 
	on a.src_id = b.isin
	;
	


 
END;
$do$ 
 