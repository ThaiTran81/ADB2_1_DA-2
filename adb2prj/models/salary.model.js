import config from "../utils/database-config.js";
import sql from "mssql";

export default {
    async findAllByStaffID(userid) {
        try{
            let pool = await sql.connect(config);
            let result = await pool.request()
                .input('uid', sql.Int, userid)
                .execute("FindAllSalaryStaffID");
            return result.recordset;
        }catch(err){
            console.log(err)
            return null;
        }
    },
    async findAllByYear(entity) {
        try{
            let pool = await sql.connect(config);
            let result = await pool.request()
                .input('uid', sql.Int, entity.userid)
                .input('year', sql.Int, entity.year)
                .execute("FindAllSalaryByYear");
            return result.recordset;
        }catch(err){
            console.log(err)
            return null;
        }
    },
};

