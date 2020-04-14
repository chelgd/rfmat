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
		bond_id
	from tech.bonds_tech
	where  dml_type = 'U'
	
	) b
	
	where a.bond_id = b.bond_id

	;

----------------------Вставляем новые версии экземпляров сущности----------------------
	
	insert into dds.bonds_v
	select 
	
		a.bond_id,
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
	on a.src_id = b.name
	
	where a.dml_type = 'U'
	
	;	
		
	
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


----------------------Вставляем новые экземпляры сущности---------------------- 
 
END;
$do$ 
 