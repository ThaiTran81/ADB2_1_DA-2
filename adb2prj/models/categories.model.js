import config from "../utils/database-config.js";
import sql from "mssql";

export default {
    async findAllCategories() {
        try {
            let pool = await sql.connect(config);
            let result = await pool.request()
                .query("SELECT top 20 * FROM Category");
            return result.recordset;

        } catch (err) {
            console.log(err)
            return null;
        }
    },
    async findAllTypeOfCategory(cid) {
        try {
            let pool = await sql.connect(config);
            let result = await pool.request()
                .input('category', sql.Int, cid)
                .query("SELECT tId,tName FROM ProductType where category = @category");
            return result.recordset;
        } catch (err) {
            console.log(err)
            return null;
        }
    }

}