let express = require('express');
let app = express();
const request = require('request');
const fs = require('fs');
const {google} = require('googleapis');
const { exit } = require('process');
require('dotenv').config()


app.set('view engine', 'ejs');

app.use('/assets', express.static('public'));
app.use(express.urlencoded({ extended: false}));
app.use(express.json());

const CREDENTIALS = JSON.parse(process.env.CREDENTIALS);
const calendarId = process.env.CALENDAR_ID;

const SCOPES = 'https://www.googleapis.com/auth/calendar';
const calendar = google.calendar({version : "v3"});

const auth = new google.auth.JWT(
    CREDENTIALS.client_email,
    null,
    CREDENTIALS.private_key,
    SCOPES
);

function get_data_from_Epitech() {
    const start = Date.now()
    var date = new Date();
    var d = date.getDate();
    var m = date.getMonth();
    var y = date.getFullYear();
    request(`${process.env.EPILINK}planning/load?format=json&onlymypromo=true&onlymymodule=true&onlymyevent=true&semester=0,1,2&register_student=true&start=${y}-${m}-${d}`, {json: true}, (err, resp, body) => {
        if (err) { return console.log(err);}
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
            if (i < body.length)
                fs.appendFileSync("public/event.json", `,\n`, "UTF-8",{'flags': 'a+'});
            i++;
        }
    });
    const stop = Date.now()
    console.log(`Time Taken to execute = ${(stop - start)/1000} seconds`);
}

async function get_data_from_GoogleCalandar(dateTimeStart, dateTimeEnd) {
    try {
        const start = Date.now()
        let response = await calendar.events.list({
            auth: auth,
            calendarId: calendarId,
            timeMin: dateTimeStart,
            timeMax: dateTimeEnd,
            timeZone: 'Europe/France'
        });
        let items = response['data']['items'];
        for (let i = 0; i < items.length; i++) {
            if (items[i].start.dateTime == undefined) {
                let start = items[i].start.date;
                let end = items[i].end.date;
                tabstart = start.split('-');
                tabend = end.split('-');
                if (tabend[2] - tabstart[2] == 1)
                    tabend[2] = tabstart[2];
                end = tabend.join('-')
                var jsonData = `{"title": "${items[i].summary}", "start": "${items[i].start.date}", "end": "${end}", "className": "chill"}`;
            } else {
                let start = items[i].start.dateTime;
                let end = items[i].end.dateTime;
                tabstart = start.split('T')[0].split('-');
                tabend = end.split('T')[0].split('-');
                if (tabend[2] - tabstart[2] == 1)
                    tabend[2] = tabstart[2];
                end = tabend.join('-')
                var jsonData = `{"title": "${items[i].summary}", "start": "${items[i].start.dateTime}", "end": "${end}", "className": "chill"}`;
            }
            fs.appendFileSync("public/event.json", `${jsonData}`, "UTF-8",{'flags': 'a+'});
            if (i < items.length - 1) {
                fs.appendFileSync("public/event.json", `,\n`, "UTF-8",{'flags': 'a+'});
            }
        }
        fs.appendFileSync("public/event.json", '\n]\n', "UTF-8",{'flags': 'a+'});
        const stop = Date.now()
        console.log(`Time Taken to execute = ${(stop - start)/1000} seconds`);
    } catch (error) {
        console.log(`Error at getEvents --> ${error}`);
        return 0;
    }
};

function to_do() {
    setTimeout(() => {
        get_data_from_Epitech();
        let start = '2022-05-23T00:00:00.000Z';
        let end = '2022-05-30T00:00:00.000Z';
        get_data_from_GoogleCalandar(start, end);
        setTimeout(() => {console.log("TIMEOUT OK\n")}, 2000);
        to_do();
    }, 2000);
}
to_do();

app.get('/', function(req, res) {
    res.render('calendar');
});

app.listen(5000);