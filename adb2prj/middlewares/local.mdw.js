import ___models_categories_model_js from "../models/categories.model.js";

export default function (app) {

    app.use(async function (req, res, next) {

        if (typeof (req.session.login) == 'undefined') {
            req.session.login = false;
        }

        if (typeof (req.session.account) == 'undefined') {
            req.session.login = null;
        }

        if (typeof (req.session.cart) == 'undefined') {
            req.session.cart = [];
        }

        let total = 0;
        for (const element of req.session.cart) {
            total+= element.price;
        }

        res.locals.account = req.session.account;
        res.locals.login = req.session.login;
        res.locals.cart = req.session.cart;
        res.locals.cartLength = req.session.cart.length;
        res.locals.total = total;

        next();
    });


    app.use(async function (req, res, next) {

        let categories = await ___models_categories_model_js.findAllCategories();
        for (let category of categories) {
            let types = await ___models_categories_model_js.findAllTypeOfCategory(category.categoryId);
            category.type = types;
        }

        res.locals.categories = categories;
        next();
    });

}