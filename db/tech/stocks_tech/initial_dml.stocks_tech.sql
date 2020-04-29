DO $do$
BEGIN

	truncate tech.stocks_tech ;
	
/* 	insert into tech.stocks_tech 
	select 
		stocks_id,
		name as src_id,
		md5(tool_code  ||
		lot            ||
		class_code) as hash,
		'quik' as system_name,
		'I' as dml,
		now() as update_dttm
	from dds.stocks_v
	; */
	
 
END;
$do$
