import config from "../utils/database-config.js";
import sql from "mssql";

export default {
    async findOrderByID(empid) {
        try{
            let pool = await sql.connect(config);
            let result = await pool.request()
                .input('input_id', sql.Int, empid)
                .query("SELECT * FROM [Order] where empID = @input_id");

            return result.recordset;
        }catch(err){
            console.log(err)
            return null;
        }
    },
    async statisticRevenue() {
        try{
            let pool = await sql.connect(config);
            let result = await pool.request()
                .query("SELECT SUM(total) as total FROM [Order]");

            return result.recordset;
        }catch(err){
            console.log(err)
            return null;
        }
    }
};

