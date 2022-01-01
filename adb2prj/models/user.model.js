import config from "../utils/database-config.js";
import sql from "mssql";

export default {
    async findAddressByUID(uid) {
        try{
            let pool = await sql.connect(config);
            let result = await pool.request()
                .input('uid', sql.Int, uid)
                .query("SELECT address FROM dbo.[User] where uid = @uid");

            return result.recordset;
        }catch(err){
            console.log(err)
            return null;
        }
    }
};

