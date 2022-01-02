import config from "../utils/database-config.js";
import sql from "mssql";

export default {
    async findAllOrder() {
        try{
            let pool = await sql.connect(config);
            let result = await pool.request()
                .query("SELECT * FROM [Order]");

            return result.recordset;
        }catch(err){
            console.log(err)
            return null;
        }
    },
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
            console.log(entity);
            let pool = await sql.connect(config);
            let result = await pool.request()
                .input('orderid', sql.Int, entity.orderID)
                .input('empid', sql.Int, entity.userid)
                .execute("updateOrderWithEmpID");

            console.log(result.rowsAffected);


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
    async createNewOrder(orderID, date){
        try{
            let pool = await sql.connect(config);
            let result = await pool.request()
                .input('date', sql.DateTime, date)
                .input('uid', sql.Int, orderID)
                .execute("InsertOrder");

            return result.recordset;

        }catch(err){
            console.log(err)
            return null;
        }
    },
    async createNewOrderDetail(orderid,entity){
        try{
            let pool = await sql.connect(config);
            let result = await pool.request()
                .input('orderid', sql.Int,orderid )
                .input('proID', sql.Int, parseInt(entity.proID))
                .input('quantity', sql.Int, entity.quantity)
                .input('price', sql.Float, entity.price)
                .input('discount', sql.Float, 0)
                .execute("InsertOrderDetail");

            return result.recordset;

        }catch(err){
            console.log(err)
            return null;
        }
    },
    async statisticAll(){
        try{
            let pool = await sql.connect(config);
            let result = await pool.request()
                .execute("DoanhThuThang")
            return result.recordset;
        }catch(err){
            console.log(err)
            return null;
        }
    }
};

