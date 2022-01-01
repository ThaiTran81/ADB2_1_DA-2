import config from "../utils/database-config.js";
import sql from "mssql";

export default {
    async findAllProduct() {
        try {
            let pool = await sql.connect(config);
            let result = await pool.request()
                .query("SELECT top 30 * FROM dbo.[Product]");

            return result.recordset;
        } catch (err) {
            console.log(err)
            return null;
        }
    },
    async findAllProductsWithLimitOffset(limit, offset) {
        try {
            let pool = await sql.connect(config);
            let result = await pool.request()
                .input('limit', sql.Int, limit)
                .input('offset', sql.Int, offset)
                .execute("SelectProductWithOffset");

            return result.recordset;
        } catch (err) {
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
    async findCurPriceProduct(proID) {
        try {
            let pool = await sql.connect(config);
            let result = await pool.request()
                .input('proID', sql.Int, proID)
                .execute("SelectPriceProductByProID");

            return result.recordset[0];
        } catch (err) {
            console.log(err)
            return null;
        }
    }
    ,
    async findProductsByTypeID(tid, limit, offset) {
        try {
            let pool = await sql.connect(config);
            let result = await pool.request()
                .input('tid', sql.Int, tid)
                .input('limit', sql.Int, limit)
                .input('offset', sql.Int, offset)
                .execute("SelectProductWithSpecificType");

            for (const record of result.recordset) {
                let list = await this.findCurPriceProduct(record.proID);
                if (typeof (list) === 'undefined') {
                    record.isCurr = false;
                } else {
                    record.isCurr = true;
                    record.price = list.price;
                    record.date = list.date;
                    record.discount = list.discount;
                }
            }

            return result.recordset;
        } catch (err) {
            console.log(err)
            return null;
        }
    },
    async findQuantityTypeID(tid) {
        try {
            let pool = await sql.connect(config);
            let result = await pool.request()
                .input('tid', sql.Int, tid)
                .query("SELECT count(*) as soluong from product where ptype=@tid");

            return result.recordset[0];
        } catch (err) {
            console.log(err)
            return null;
        }
    }
};

