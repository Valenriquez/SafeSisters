const pg = require("../db/pg");


class Circle {
    async add2Circle(req, res){
        res.send("Hello World");
    }
    async removeFromCircle(req, res){
        res.send("Hello World");
    }
    async notifyCircle(req, res){
        res.send("Hello World");
    }
    async createCircle(req, res){
        res.send("Hello World");
    }
}

const circleController = new Circle();
module.exports = circleController;