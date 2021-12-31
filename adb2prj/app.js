import express from 'express';
import {engine} from "express-handlebars";
import sections from "express-handlebars-sections";
import morgan from 'morgan';
// import bcrypt from "bcryptjs"

import active_middleware_session from "./middlewares/session.mdw.js";
import active_middleware_local from "./middlewares/local.mdw.js";

import orderModels from "./models/orders.model.js";
import accountModels from "./models/accounts.model.js";
import staffModels from "./models/staff.model.js";
import salaryModels from "./models/salary.model.js";
import userModels from "./models/user.model.js";


const app = express();
app.use('/assets', express.static('assets'));
app.use(morgan('dev'));
app.use(express.urlencoded({
    extended:true
}));

// express session mdw
active_middleware_session(app);


// view mdw
app.set('view engine', 'hbs');
app.set('views', './views');
app.engine('hbs', engine({
    defaultLayout: 'home.hbs',
    helpers:{
        section: sections(),
        formatMoney(val){
            return  val.toLocaleString('vi', {
                style : 'currency',
                currency : 'VND'});
        },
        formatDateTime(d){
            return d.toLocaleString('vi');
        },
        formatDate(d){
            return d.toDateString('vi');
        },
        increase_1(value){
            return value+1;
        }

    }
}));


// locals view;
active_middleware_local(app);

// routes

app.get('/', function (req, res) {
    res.render('home', {
        layout: 'home.hbs'
    });
});


app.get('/login', function (req, res) {
    res.render('vwAccounts/login-register', {
        layout: 'accounts.hbs'
    });
});

app.post('/login', async function (req, res) {

    let entity = req.body;
    let account = await accountModels.findAccount(entity.username);
    // let isTrue = bcrypt.compareSync(req.body.password, account.password);
    let isTrue = account.password === entity.password;
    if (isTrue) {

        req.session.login = isTrue;
        req.session.account = account;

        res.redirect('/');
        return;

    }

    res.render('vwAccounts/login-register', {
        layout: 'accounts.hbs'
    });

});

app.post('/register',async function (req, res) {
    let account = req.body;
    account.datefounded = new Date().toISOString();
    account.role = 3;
    // let salt = bcrypt.genSaltSync(10);
    // account.password = bcrypt.hashSync(account.password, salt);
    let ret = await accountModels.addAccount(account);
    res.render('vwAccounts/login-register', {
        layout: 'accounts.hbs'
    });
});

app.get('/dashboard', async function (req, res) {
    if (req.session.account === null) {
        res.redirect('/');
    }else {
        console.log(req.session.account.userid);
        let list = await orderModels.findOrderByID(req.session.account.userid);
        let total = await orderModels.statisticRevenue();
        res.render('vwStaff/dashboard', {
            layout: 'staff.hbs',
            list,
            total
        });

    }
});

app.get('/attendance',async function(req, res){

    let userid = req.session.account.userid;
    console.log(req.session.account.userid)
    let list = await staffModels.findAttendanceByID(userid);
    let date = new Date().toISOString();
    let attendance = await staffModels.findAttendance({ uid: userid, timeStart: date });
    let checkEnd = await staffModels.checkEndDateAttendance({ uid: userid, timeStart: date });

    res.render('vwStaff/attendance',{
        layout: 'staff.hbs',
        list,
        attendance,
        checkEnd,
        userid
    })
})

app.get('/attendance/add', async function(req, res){
    let attendance = req.body;
    attendance.uid = req.query.uid;
    attendance.timeStart = new Date().toLocaleString();

    let hour = new Date(attendance.timeStart).getHours();

    if(hour < 8){
        attendance.status = 0;
    }else {
        attendance.status = 1;
    }

    await staffModels.addAttendance(attendance);
    res.redirect('/attendance');
})

app.get('/salary',async function(req, res){
    let year = req.query.year || 0;
    let list = null;
    if (parseInt(year) === 0){
        list = await salaryModels.findAllByStaffID(req.session.account.userid);
    }else{
        list = await salaryModels.findAllByYear({userid: req.session.account.userid, year: year});
    }
    res.render('vwStaff/salary',{
        layout: 'staff.hbs',
        list
    })
})


app.post('/salary', function(req, res){
    res.redirect('/salary?year=' + req.body.year);
})

app.get('/attendance/update', async function(req, res){
    let attendance = req.body;
    attendance.uid = req.query.uid;
    attendance.timeStart = new Date().toLocaleString();
    attendance.timeEnd = new Date().toLocaleString();
    let hour = new Date(attendance.timeEnd).getHours();

    if(hour < 18){
        attendance.status = 1;
    }else {
        attendance.status = 0;
    }

    await staffModels.updateAttendance(attendance);
    res.redirect('/attendance');
})

app.get('/sales', function(req, res){
    res.render('vwStaff/sales',{
        layout: 'staff.hbs'
    })
})

app.get('/inventory', function(req, res){
    res.render('vwStaff/inventory',{
        layout: 'staff.hbs'
    })
})

app.get('/order-processing',async function(req, res){
    let storedID = await staffModels.findStaffStoredID(req.session.account.userid);
    let list = await orderModels.findOrderByStoredID(storedID[0].storeID);
    res.render('vwStaff/order-processing',{
        layout: 'staff.hbs',
        list
    })
})

app.get('/orders/confirm',async function(req, res){
    let userid = req.session.account.userid;
    let orderID = req.query.orderID;

    await orderModels.updateOrderWithEmpID({orderID: orderID, userid: userid});
    res.redirect('/order-processing');
})

app.get('/orders/detail',async function(req, res){
    // let userid = req.session.account.userid;
    let orderID = req.query.orderID;
    let order = await orderModels.findOrderByOrderID(orderID);
    let address = await userModels.findAddressByUID(order[0].uID);
    let details = await orderModels.findDetailOrderByOrderID(orderID);
    let totalDetail = await orderModels.findTotalDetailOrderID(orderID);
    res.render('vwOrders/detail',{
        layout: 'staff.hbs',
        order: order[0], address: address[0].address, details,
        totalDetail: totalDetail[0].totaldetail
    })
})

const port = 3000;
app.listen(port, function ()  {
    console.log(`Example app listening at http://localhost:${port}`)
})