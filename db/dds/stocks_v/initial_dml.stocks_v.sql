DO $do$
BEGIN
	
	truncate dds.bonds_v
	;
	
	insert into dds.bonds_v
	select
		row_number () over () as bond_id,
		name,
		tool_code,
		lot,
		class_code,
		date(now()) as valid_from_dt,
		date('5999-01-01') as valid_to_dt,
		'I' as dml,
		1 as act_flg
	from ods.quik_stocks
	;

 
END;
$do$ 	
