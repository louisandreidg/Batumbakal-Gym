const modulePath=process.argv[2];
const exported=require(modulePath);
const pool=exported.pool||exported;
(async()=>{try{const r=await pool.query('SELECT current_database() AS database,current_user AS account');console.log(JSON.stringify(r.rows[0]));}finally{await pool.end();}})().catch(e=>{console.error(e.code||e.name);process.exitCode=1;});
