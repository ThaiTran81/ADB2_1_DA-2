import config from "../utils/database-config.js";
import sql from "mssql";

export default {
    async findAttendanceByID(empid) {
        try{
            let pool = await sql.connect(config);
            let result = await pool.request()
                .input('uid', sql.Int, empid)
                .execute("SelectAttendanceUID");
            return result.recordset;
        }catch(err){
            console.log(err)
            return null;
        }
    },
    async addAttendance(entity) {
        try{
            let pool = await sql.connect(config);
            let result = await pool.request()
                .input('uid', sql.Int, entity.uid)
                .input('timeStart', sql.DateTime, entity.timeStart)
                .input('status', sql.Bit, entity.status)
                .execute("InsertAttendance");
            return true;
        }catch(err){
            console.log(err)
            return false;
        }
    },
    async updateAttendance(entity){
        try{
            let pool = await sql.connect(config);
            let result = await pool.request()
                .input('uid', sql.Int, entity.uid)
                .input('timeStart', sql.DateTime, entity.timeStart)
                .input('timeEnd', sql.DateTime, entity.timeEnd)
                .input('status', sql.Bit, entity.status)
                .execute("UpdateAttendance");
            return true;
        }catch(err){
            console.log(err)
            return false;
        }
    },
    async findAttendance(entity){
        try{
            let pool = await sql.connect(config);
            let result = await pool.request()
                .input('uid', sql.Int, entity.uid)
                .input('timeStart', sql.DateTime, entity.timeStart)
                .execute("SelectSpecificAttendance");

            let length = result.recordset.length;
            return (length !== 0);
        }catch(err){
            console.log(err)
            return false;
        }
    },
    async checkEndDateAttendance(entity){
        try{
            let pool = await sql.connect(config);
            let result = await pool.request()
                .input('uid', sql.Int, entity.uid)
                .input('timeStart', sql.DateTime, entity.timeStart)
                .execute("SelectSpecificAttendance");
            if (result.recordset.length === 0)
                return true;
            let rs = result.recordset[0].timeEnd === null;
            return rs;
        }catch(err){
            console.log(err)
            return false;
        }
    },
    async findStaffStoredID(uid){
        try{
            let pool = await sql.connect(config);
            let result = await pool.request()
                .input('uid', sql.Int, uid)
                .execute("SelectStaffStoredID");
            return result.recordset;
        }catch(err){
            console.log(err)
            return false;
        }
    }
};

