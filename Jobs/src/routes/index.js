const express = require('express');
const cron = require('node-cron');
const mysql = require('mysql');
const config = require('../../config.json')

var db = config.mysql.database
var user = config.mysql.user
var port = config.mysql.port
var host = config.mysql.host
var pass = config.mysql.password

const pool = mysql.createPool({
    connectionLimit: 10,
    password: pass,
    user: user,
    database: db,
    host: host,
    port: port

});

const router = express.Router();
router.get('/', function (req, res, next) {
    task.start();
    res.status(200).send({
        title: "Jobs Himalaia",
        version: "0.0.1"
    });
});

var task = cron.schedule('*/10 * * * * *', () => {
    let data = new Date()
    queryReturnStatus();
    createJobs();
});

queryReturnStatus = () => {
    return new Promise((resolve, reject) => {
        pool.query("SELECT * from emp_user WHERE  dataInicio  < DATE_FORMAT(NOW() ,'%Y-%m-%d')", (error, elements) => {
            if (error) {
                return reject(error);
            }
            for (var i = 0; i < elements.length; i++) {
                console.log(elements[i]);
                var sql = "DELETE FROM emp_user  WHERE id = '" + elements[i].id + "'";
                pool.query(sql, function (err, result) {
                    if (err) throw err;
                });
            }
            return resolve(elements);
        });
    });
};

createJobs = () => {
    return new Promise((resolve, reject) => {
        pool.query("SELECT * from emp_user WHERE  ativo = 'S'", (error, elements) => {
            if (error) {
                return reject(error);
            }
            if (elements.length > 0) {
                pool.query("SELECT * from emp_diario WHERE  emp_user_id = 0 ", (error, jobs) => {
                    if (error) {
                        return reject(error);
                    }
                    if (jobs.length <= elements.length) {
                        const now = new Date();
                        const minut = now.getMinutes()
                        const seconds = now.getSeconds()
                        const current = now.getHours() + ':' + seconds.toString().padStart("0", 2) + ':' + seconds.toString().padStart("0", 2);
                        let name = 'entrega das ' + current;
                        console.log(name)
                        var sql = "INSERT INTO emp_diario(dataInicio, nome, emp_user_id) VALUES (DATE_FORMAT(NOW() ,'%Y-%m-%d'), '" + name + "', 0)";
                        console.log(sql);
                        pool.query(sql, function (err, result) {
                            if (err) throw err;
                        });
                    }
                })
        }
            return resolve(elements);
        });
    });
};

module.exports = router;

