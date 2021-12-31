import ___models_categories_model_js from "../models/categories.model.js";

export default function (app) {

    app.use(async function (req, res, next) {

        if (typeof (req.session.login) == 'undefined') {
            req.session.login = false;
        }

        if (typeof (req.session.account) == 'undefined') {
            req.session.login = null;
        }
        res.locals.account = req.session.account;
        res.locals.login = req.session.login;

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