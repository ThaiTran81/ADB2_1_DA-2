import express from 'express';
import {engine} from "express-handlebars";
import sections from "express-handlebars-sections";
import morgan from 'morgan';
import orderModels from "./models/orders.model.js";




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

app.get('/',async function (req, res) {
    let lst = await orderModels.findOrderByID();
    console.log(lst);
    res.render('home', {
        layout: 'home.hbs',
        lst
    });
});

app.get('/dashboard', async function (req, res) {
    let list = await orderModels.findOrderByID(315);
    let total = await orderModels.statisticRevenue();
    console.log(list);
    console.log(total)
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