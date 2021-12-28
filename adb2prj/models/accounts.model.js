import config from "../utils/database-config.js";
import sql from "mssql";

export default {
    async findAccount(username) {
        try{
            let pool = await sql.connect(config);
            let result = await pool.request()
                .input('input_username', sql.VarChar, username)
                .query("SELECT * FROM Account where username = @input_username");
            return result.recordset[0];

        }catch(err){
            console.log(err)
            return null;
        }
    },
    async addAccount(entity){
        try{
            let pool = await sql.connect(config);
            let result = await pool.request()
                .input('fullname', sql.NVarChar, entity.fullname)
                .input('dob', sql.Date, entity.dob)
                .input('address', sql.NVarChar, entity.address)
                .input('telephone', sql.Char, entity.telephone)
                .input('email', sql.VarChar, entity.email)
                .input('datefounded', sql.DateTime, entity.datefounded)
                .execute("InsertUser");

            let userid = await pool.request()
                .input('fullname', sql.NVarChar, entity.fullname)
                .input('dob', sql.Date, entity.dob)
                .input('address', sql.NVarChar, entity.address)
                .input('telephone', sql.Char, entity.telephone)
                .input('email', sql.VarChar, entity.email)
                .input('datefounded', sql.DateTime, entity.datefounded)
                .execute("SelectUID");

            let account = await pool.request()
                .input('username', sql.VarChar, entity.username)
                .input('password', sql.VarChar, entity.password)
                .input('role', sql.Int, entity.role)
                .input('userid', sql.Int, userid.returnValue)
                .execute("InsertAccount");

            return account;
        }catch(err){
            console.log(err)
            return null;
        }
    }
};

