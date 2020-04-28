DO $do$
BEGIN

	insert into dds.bonds_v
	select
		row_number () over () as bond_id,
		isin,
		name,
		type,
		nominal,
		coupon_amount,   
		to_date(coup_paym_date, 'dd.mm.yyyy') as coup_paym_date,
		to_date(exp_date, 'dd.mm.yyyy') as exp_date,
		date(now()) as valid_from_dt,
		date('5999-01-01') as valid_to_dt,
		'I' as dml,
		1 as act_flg
	from ods.quik_bonds
	;
	


 
END;
$do$