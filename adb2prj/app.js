import express from 'express';
import {engine} from "express-handlebars";
import sections from "express-handlebars-sections";
import morgan from 'morgan';
import orderModels from "./models/orders.model.js";
import accountModels from "./models/accounts.model.js";

const app = express();
app.use('/public', express.static('public'));
app.use(morgan('dev'));
app.use(express.urlencoded({
    extended:true
}));
app.set('view engine', 'hbs');
app.set('views', './views');
app.engine('hbs', engine({
    defaultLayout: 'home.hbs',
    helpers:{
        section: sections(),
        formatMoney(val){
            return  val.toLocaleString('vi', {style : 'currency', currency : 'VND'});
        },
        formatDateTime(d){
            return d.toLocaleString('vi');
        }
    }
}));

app.get('/login', function (req, res) {

    res.render('vwAccounts/login-register', {
        layout: 'accounts.hbs'
    });
});

app.post('/login', async function (req, res) {
    let entity = req.body;
    let account = await accountModels.findAccount(entity.username);
    if (entity.password === account.password) {
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
    let ret = await accountModels.addAccount(account);
    res.render('vwAccounts/login-register', {
        layout: 'accounts.hbs'
    });
});

app.get('/dashboard', async function (req, res) {
    let list = await orderModels.findOrderByID(315);
    let total = await orderModels.statisticRevenue();
    res.render('vwStaff/dashboard', {
        layout: 'staff.hbs',
        list,
        total
    });
});

const port = 3000;
app.listen(port, function ()  {
    console.log(`Example app listening at http://localhost:${port}`)
})