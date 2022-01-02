import express from 'express';
import {engine} from "express-handlebars";
import sections from "express-handlebars-sections";
import morgan from 'morgan';
// import bcrypt from "bcryptjs"
import {dirname} from "path";
import {fileURLToPath} from "url";
import asyncErrors from "express-async-errors";

import active_middleware_session from "./middlewares/session.mdw.js";
import active_middleware_local from "./middlewares/local.mdw.js";

import orderModels from "./models/orders.model.js";
import accountModels from "./models/accounts.model.js";
import staffModels from "./models/staff.model.js";
import salaryModels from "./models/salary.model.js";
import userModels from "./models/user.model.js";
import productsModels from "./models/products.model.js";


const app = express();
app.use('/assets', express.static('assets'));
app.use(morgan('dev'));
app.use(express.urlencoded({
    extended: true
}));
const __dirname = dirname(fileURLToPath(import.meta.url));

// express session mdw
active_middleware_session(app);


// view mdw
app.set('view engine', 'hbs');
app.set('views', './views');
app.engine('hbs', engine({
    defaultLayout: 'home.hbs',
    helpers: {
        section: sections(),
        formatMoney(val) {
            return val.toLocaleString('vi', {
                style: 'currency',
                currency: 'VND'
            });
        },
        formatDateTime(d) {
            return d.toLocaleString('vi');
        },
        formatDate(d) {
            return d.toDateString('vi');
        },
        increase_1(value) {
            return value + 1;
        },
        isZero(value) {
            return options.fn(value <= 0);
        },
        equal(varr, value, options) {
            return options.fn(varr == value);
        },
        diff(varr, value, options) {
            return varr !== value;
        },
    }
}));


// locals view;
active_middleware_local(app);

// routes

app.get('/', async function (req, res) {
    // let products = await productsModels.findAllProduct();
    let limit = 15
    let curPage = parseInt(req.query.page) || 1;
    if (curPage <= 0) {
        res.redirect('/');
        return;
    }

    let productNum = await productsModels.findQuantity();
    let pageNum = Math.floor(productNum.soluong / limit);
    if (productNum.soluong % limit > 0)
        pageNum++;

    let listPages = getListPage(curPage, pageNum);

    let products = await productsModels.findAllProductsWithLimitOffset(limit, (curPage - 1) * limit);
    // console.log(products);

    res.render('home', {
        layout: 'home.hbs',
        products, listPages, curPage, limit
    });
});

app.get('/search/:page', async function (req, res) {

    let limit = 15
    let curPage = parseInt(req.params.page) || 1;
    if (curPage <= 0) {
        res.redirect('/');
        return;
    }

    let productNum = await productsModels.findQuantityBySearch(req.query.key);
    // console.log(productNum);
    let pageNum = Math.floor(productNum.soluong / limit);
    if (productNum.soluong % limit > 0)
        pageNum++;
    let keySearch = req.url.split('?')[1];

    let listPages = getListSearchPage(curPage, pageNum, keySearch);

    let products = await productsModels.findAllProductsBySearch(req.query.key, limit, (curPage - 1) * limit);

    res.render('vwProducts/search', {
        layout: 'home.hbs',
        products, listPages
    });
});

app.post('/search', async function (req, res) {
    res.redirect('/search/1?key=' + req.body.search);
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
        req.session.cart = [];
        console.log(account)
        res.redirect('/');
        return;

    }

    res.render('vwAccounts/login-register', {
        layout: 'accounts.hbs'
    });

});


app.get('/logout', async function (req, res) {

    req.session.login = false;
    req.session.account = null;
    req.session.cart = [];

    res.redirect('/');
});

app.post('/register', async function (req, res) {
    let account = req.body;
    account.datefounded = new Date().toISOString();
    account.role = 3;
    // let salt = bcrypt.genSaltSync(10);
    // account.password = bcrypt.hashSync(account.password, salt);
    await accountModels.addAccount(account);
    res.render('vwAccounts/login-register', {
        layout: 'accounts.hbs'
    });
});

app.get('/cart/add', async function (req, res) {

    let productsItem = req.query;
    let check = false;
    for (const item of req.session.cart) {
        if(item.productsItem.proID === productsItem.proID) {
            check = true;
            item.productsItem.quantity += 1;
        }
    }
    if (check === false) {
        productsItem.quantity = 1;
        req.session.cart.push({
            productsItem
        });
    }

    console.log(req.session.cart);
    res.redirect("/");
});

app.get('/dashboard/:oid', async function (req, res) {
    if (req.session.account === null) {
        res.redirect('/');
    } else {
        let oid = req.params.oid || 0;
        console.log(oid);
        if (oid !== 0) {
            let list = await orderModels.findOrderByOrderID(oid);
            res.render('vwStaff/dashboard', {
                layout: 'staff.hbs',
                list
            });
        } else {
            let total = await orderModels.statisticRevenue();
            let list = await orderModels.findOrderByID(req.session.account.userid);
            res.render('vwStaff/dashboard', {
                layout: 'staff.hbs',
                list,
                total
            });
        }

    }
});

app.get('/dashboard', async function (req, res) {
    if (req.session.account === null) {
        res.redirect('/');
    } else {

        let total = await orderModels.statisticRevenue();
        let list = await orderModels.findOrderByID(req.session.account.userid);

        // let list = await orderModels.findAllOrder();
        // console.log(list)

        res.render('vwStaff/dashboard', {
            layout: 'staff.hbs',
            list,
            total
        });
    }
});

app.post('/dashboard', async function (req, res) {
    console.log(req.body);
    res.redirect('/dashboard/' + req.body.search);
});

app.get('/attendance', async function (req, res) {

    let userid = req.session.account.userid;
    let list = await staffModels.findAttendanceByID(userid);
    let date = new Date().toISOString();
    let attendance = await staffModels.findAttendance({uid: userid, timeStart: date});
    let checkEnd = await staffModels.checkEndDateAttendance({uid: userid, timeStart: date});

    res.render('vwStaff/attendance', {
        layout: 'staff.hbs',
        list,
        attendance,
        checkEnd,
        userid
    })
})

app.get('/attendance/add', async function (req, res) {
    let attendance = req.body;
    attendance.uid = req.query.uid;
    attendance.timeStart = new Date().toLocaleString();

    let hour = new Date(attendance.timeStart).getHours();

    if (hour < 8) {
        attendance.status = 0;
    } else {
        attendance.status = 1;
    }

    await staffModels.addAttendance(attendance);
    res.redirect('/attendance');
})

app.get('/salary', async function (req, res) {
    let year = req.query.year || 0;
    let list;
    if (parseInt(year) === 0) {
        list = await salaryModels.findAllByStaffID(req.session.account.userid);
    } else {
        list = await salaryModels.findAllByYear({userid: req.session.account.userid, year: year});
    }
    res.render('vwStaff/salary', {
        layout: 'staff.hbs',
        list
    })
})


app.post('/salary', function (req, res) {
    res.redirect('/salary?year=' + req.body.year);
})

app.get('/attendance/update', async function (req, res) {
    let attendance = req.body;
    attendance.uid = req.query.uid;
    attendance.timeStart = new Date().toLocaleString();
    attendance.timeEnd = new Date().toLocaleString();
    let hour = new Date(attendance.timeEnd).getHours();

    if (hour < 18) {
        attendance.status = 1;
    } else {
        attendance.status = 0;
    }

    await staffModels.updateAttendance(attendance);
    res.redirect('/attendance');
})

app.get('/statistic', async function (req, res) {

    let items = await orderModels.statisticAll();
    res.render('vwStaff/sales', {
        layout: 'staff.hbs', items
    })
})

app.get('/inventory', async function (req, res) {

    let storedID = await staffModels.findStaffStoredID(req.session.account.userid);
    let list = await productsModels.findAllProductsAvailableWithStoreID(storedID[0].storeID);
    console.log(storedID)
    res.render('vwStaff/inventory', {
        layout: 'staff.hbs',
        list, storedID: storedID[0].storeID
    })
})

app.get('/order-processing', async function (req, res) {
    let storedID = await staffModels.findStaffStoredID(req.session.account.userid);
    let list = await orderModels.findOrderByStoredID(storedID[0].storeID);
    res.render('vwStaff/order-processing', {
        layout: 'staff.hbs',
        list
    })
})

app.get('/orders/confirm', async function (req, res) {
    let userid = parseInt(req.session.account.userid);
    let orderID = parseInt(req.query.orderID);

    await orderModels.updateOrderWithEmpID({orderID, userid});
    res.redirect('/order-processing');

})

app.get('/orders/detail', async function (req, res) {
    // let userid = req.session.account.userid;
    let orderID = req.query.orderID;
    let order = await orderModels.findOrderByOrderID(orderID);
    let address = await userModels.findAddressByUID(order[0].uID);
    let details = await orderModels.findDetailOrderByOrderID(orderID);
    let totalDetail = await orderModels.findTotalDetailOrderID(orderID);
    res.render('vwOrders/detail', {
        layout: 'staff.hbs',
        order: order[0], address: address[0].address, details,
        totalDetail: totalDetail[0].totaldetail
    })
})

app.get('/products/byType/:tid', async function (req, res) {
    // let userid = req.session.account.userid;
    let tid = req.params.tid;

    let limit = 15;
    let curPage = parseInt(req.query.page) || 1;

    if (curPage <= 0) {
        res.redirect('/');
        return;
    }

    let productNum = await productsModels.findQuantityTypeID(tid);
    let pageNum = Math.floor(productNum.soluong / limit);
    if (productNum.soluong % limit > 0)
        pageNum++;
    let listPages = getListPage(curPage, pageNum);
    let products = await productsModels.findProductsByTypeID(tid, limit, (curPage - 1) * limit);

    // console.log(products)
    let url = req.url.split("?")[0];
    let tName = await productsModels.getTypeName(tid);
    res.render('vwProducts/byType', {
        layout: 'home.hbs',
        products, listPages, url, tName
    })
})

app.get('/checkout', async function (req, res) {
    let total = 0;
    let products = req.session.cart;
    // console.log(products);
    for (const product of products) {
        total += parseInt(product.productsItem.price) * product.productsItem.quantity;
        product.productsItem.total =  parseInt(product.productsItem.price) * product.productsItem.quantity;
    }
    // console.log(total)
    res.render('vwOrders/checkout', {
        layout: 'checkout.hbs',
        products, total
    })
})

// app.post('/checkout', async function (req, res) {
//
//     // console.log(req.body);
//
//     res.render('vwOrders/checkout', {
//         layout: 'checkout.hbs'
//     })
//
// })

app.post('/checkout/update', async function (req, res) {

    let products = req.session.cart;

    for (let product of products) {
        if (product.productsItem.proID === req.body.proID){
            product.productsItem.quantity = req.body.quantity;
        }
    }

    res.redirect('/checkout');
})

app.get('/checkout/delete', async function (req, res) {

    let products = req.session.cart;

    let index=0;
    for (let product of products) {
        if (product.productsItem.proID === req.query.proID)
            products.splice(index,1);
        index++;
    }

    res.redirect('/checkout');
})

app.post('/checkout', async function (req, res) {

    let products = req.session.cart;
    console.log(products);

    res.render('vwOrders/checkout', {
        layout: 'checkout.hbs',
        products
    })
})


app.get('/checkout/confirm', async function (req, res) {

    let products = req.session.cart;
    if (products.length === 0){
        res.redirect('/checkout');
    }else{
        let date = new Date().toLocaleString();
        let result = await orderModels.createNewOrder(req.session.account.userid,date);
        let orderid = (result[0].orderID);
        for (const product of req.session.cart) {
            await orderModels.createNewOrderDetail(orderid,product.productsItem);
        }

        req.session.cart = [];

        res.redirect('/checkout');
    }

})


const port = 3000;
app.listen(port, function () {
    console.log(`Example app listening at http://localhost:${port}`)
})

function getListPage(curPage, pageNum) {

    let listPages = [];
    let i = curPage - 2;
    let endPage = curPage + 2;
    if (i <= 0) {
        i = 1;
        endPage += 2;
    } else if (i >= 3) {
        listPages.push({
            value: 1, isCur: false
        });
        listPages.push({
            value: "...", isCur: false
        })
    } else if (i == 2) {
        listPages.push({
            value: 1, isCur: false
        });
    }
    for (i; i < endPage + 1; i++) {
        if (i > pageNum)
            break;
        listPages.push({
            value: i, isCur: i === curPage
        })
    }
    if (i === pageNum) {
        listPages.push({
            value: i, isCur: false
        });
    }
    if (i <= pageNum - 1) {
        listPages.push({
            value: "...", isCur: false
        });
        listPages.push({
            value: pageNum, isCur: false
        });
    }
    return listPages;
}


function getListSearchPage(curPage, pageNum,key) {

    let listPages = [];
    let i = curPage - 2;
    let endPage = curPage + 2;
    if (i <= 0) {
        i = 1;
        endPage += 2;
    } else if (i >= 3) {
        listPages.push({
            value: 1, isCur: false, url: '/search/' + i + '?' + key
        });
        listPages.push({
            value: "...", isCur: false, url: '/search/' + i + '?' + key
        })
    } else if (i == 2) {
        listPages.push({
            value: 1, isCur: false, url: '/search/' + i + '?' + key
        });
    }
    for (i; i < endPage + 1; i++) {
        if (i > pageNum)
            break;
        listPages.push({
            value: i, isCur: i === curPage, url: '/search/' + i + '?' + key
        })
    }
    if (i === pageNum) {
        listPages.push({
            value: i, isCur: false, url: '/search/' + i + '?' + key
        });
    }
    if (i <= pageNum - 1) {
        listPages.push({
            value: "...", isCur: false, url: '/search/' + i + '?' + key
        });
        listPages.push({
            value: pageNum, isCur: false, url: '/search/' + i + '?' + key
        });
    }
    return listPages;
}

app.get('/err', function(req,res){
    throw new Error('Error!');
})

app.use(function (req,res, next){
    res.render('404', {
        layout:false
    })
})

app.use(function (err, req,res, next){
    res.render('500', {
        layout:false
    })
})
