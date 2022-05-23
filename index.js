let express = require('express');
let app = express();
const request = require('request');
const fs = require('fs');
require('dotenv').config()


app.set('view engine', 'ejs');

app.use('/assets', express.static('public'));
app.use(express.urlencoded({ extended: false}));
app.use(express.json());

function get_data_from_epitech() {
    var date = new Date();
    var d = date.getDate();
    var m = date.getMonth();
    var y = date.getFullYear();
    request(`${process.env.EPILINK}planning/load?format=json&onlymypromo=true&onlymymodule=true&onlymyevent=true&semester=0,1,2&register_student=true&start=${y}-${m}-${d}`, { json: true }, (err, resp, body) => {
        if (err) { return console.log(err);}
        console.log(body);
        var i = 0;
        fs.writeFileSync("public/event.json", `[\n`, "UTF-8",{'flags': 'a+'}, function (err){
            if (err) throw err;
        });
        while (i < body.length) {
            var jsonData = `{"title": "${body[i].acti_title}", "start": "${body[i].start}", "end": "${body[i].end}", "className": "info"}`;
            var jsonObj = JSON.parse(jsonData);
            var jsonContent = JSON.stringify(jsonObj);
            fs.appendFileSync("public/event.json", `${jsonContent}`, "UTF-8",{'flags': 'a+'}, function (err) {
                if (err) throw err;
            });
            if (i < body.length - 1) {
                fs.appendFileSync("public/event.json", `,\n`, "UTF-8",{'flags': 'a+'});
            }
            i++;
        }
        fs.appendFileSync("public/event.json", `\n]\n`, "UTF-8",{'flags': 'a+'}, function (err){
            if (err) throw err;
        });
    });
}

app.get('/', function(req, res) {
    get_data_from_epitech();
    res.render('calendar');
});

app.listen(5000);