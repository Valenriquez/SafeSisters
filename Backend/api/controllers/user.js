const pg = require("../db/pg");

class User {
    async getData(req, res) {
        res.send('Hello World');
    }
}

const userController = new User();
module.exports = userController;