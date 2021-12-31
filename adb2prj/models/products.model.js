import config from "../utils/database-config.js";
import sql from "mssql";

export default {
    async findAllProduct() {
        try{
            let pool = await sql.connect(config);
            let result = await pool.request()
                .query("SELECT top 30 * FROM dbo.[Product]");

            return result.recordset;
        }catch(err){
            console.log(err)
            return null;
        }
    },
    async findAllProductsWithLimitOffset(limit, offset) {
        try{
            let pool = await sql.connect(config);
            let result = await pool.request()
                .input('limit',sql.Int, limit)
                .input('offset',sql.Int, offset)
                .execute("SelectProductWithOffset");

            return result.recordset;
        }catch(err){
            console.log(err)
            return null;
        }
    },
    async findQuantity() {
        try {
            let pool = await sql.connect(config);
            let result = await pool.request()
                .query("SELECT count(*) as soluong from product");
            return result.recordset[0];
        } catch (err) {
            console.log(err)
            return null;
        }
    },
};

