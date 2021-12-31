import config from "../utils/database-config.js";
import sql from "mssql";

export default {
    async findOrderByOrderID(orderid) {
        try{
            let pool = await sql.connect(config);
            let result = await pool.request()
                .input('orderid', sql.Int, orderid)
                .query("SELECT orderID, uID, discount, dateBill,total FROM [Order] where orderID = @orderid");

            return result.recordset;
        }catch(err){
            console.log(err)
            return null;
        }
    },
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
    },
    async findOrderByStoredID(storeid) {
        try{
            let pool = await sql.connect(config);
            let result = await pool.request()
                .input('storeid', sql.Int, storeid)
                .execute("SelectOrderByStoredID");

            return result.recordset;
        }catch(err){
            console.log(err)
            return null;
        }
    },
    async updateOrderWithEmpID(entity){
        try{
            let pool = await sql.connect(config);
            let result = await pool.request()
                .input('orderid', sql.Int, entity.orderID)
                .input('empid', sql.Int, entity.empid)
                .execute("updateOrderWithEmpID");

            console.log(result);
            return true;
        }catch(err){
            console.log(err)
            return null;
        }
    },
    async findDetailOrderByOrderID(orderID){
        try{
            let pool = await sql.connect(config);
            let result = await pool.request()
                .input('orderID', sql.Int, orderID)
                .query("SELECT o.proID,p.pname, o.quantity, o.price,o.discount,o.total FROM Order_detail o "
                    + "join Product p on p.proID = o.proID where orderID = @orderID")
            return result.recordset;
        }catch(err){
            console.log(err)
            return null;
        }
    },
    async findTotalDetailOrderID(orderID){
        try{
            let pool = await sql.connect(config);
            let result = await pool.request()
                .input('orderID', sql.Int, orderID)
                .query("SELECT sum(total) as totaldetail FROM Order_detail "
                    + "where orderID = @orderID")
            return result.recordset;
        }catch(err){
            console.log(err)
            return null;
        }
    },
};

