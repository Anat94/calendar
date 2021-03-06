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
const GOOGLE_CALENDAR_ID = process.env.CALENDAR_ID;

const SCOPES = 'https://www.googleapis.com/auth/calendar';
const calendar = google.calendar({version : "v3"});

const auth = new google.auth.JWT(
    CREDENTIALS.client_email,
    null,
    CREDENTIALS.private_key,
    SCOPES
);


let my_epitab = [];
let my_googletab = [];
app.get('/', async function(req, res) {
    let epitech = await new Promise(function (resolve, reject) {
        const start = Date.now()
        let date = new Date();
        let d = date.getDate();
        let m = date.getMonth();
        let y = date.getFullYear();
        let jsonContent = 12;
        request(`${process.env.EPILINK}planning/load?format=json&onlymypromo=true&onlymymodule=true&onlymyevent=true&semester=0,1,2&register_student=true&start=${y}-${m}-${d}`, {json: true}, (err, body) => {
            if (err) { return console.log(err);}
            let i = 0;
            while (i < body.body.length) {
                let jsonData = `{"Subject": "${body.body[i].acti_title}", "StartTime": "${body.body[i].start}", "EndTime": "${body.body[i].end}", "className": "info", "AllDay": false}`;
                let jsonObj = JSON.parse(jsonData);
                my_epitab[i] = jsonObj;
                i++;
            }
            const stop = Date.now();
            console.log("FINIS A  => ", ((stop - start) / 1000));
            resolve("Success");
        });
    });
    let googleCalendar = await new Promise(function (resolve, reject) {
        const start_2 = Date.now();
        const start = Date.now()
        let date = new Date();
        let d = date.getDate();
        let m = date.getMonth();
        let y = date.getFullYear();
        if (m == 12){
            d = 30;
            m = 1;
        }
        console.log(d, m, y);
        calendar.events.list({
                auth: auth,
                calendarId: calendarId,
            timeMin: `${y}-${m}-${d}T00:00:00.000Z`,
            timeMax: `${y}-${m + 2}-${d}T00:00:00.000Z`,
            timeZone: 'Europe/France'
        }, async function (error, result) {
            if (error) {
                console.log(" = ", error);
                return (JSON.stringify({ error: error }));
            } else {
                if (result.data.items.length) {
                    let items = result.data.items;
                    let jsonData;
                    for (let i = 0; i < items.length; i++) {
                        if (items[i].start.dateTime == undefined) {
                            console.log("JE SUIS ICI");
                            let start = items[i].start.date;
                            let end = items[i].end.date;
                            console.log(start, end);
                            jsonData = `{"Subject": "${items[i].summary}", "StartTime": "${start}", "EndTime": "${end}", "className": "chill", "AllDay": true}`;
                        } else {
                            let start = items[i].start.dateTime;
                            let end = items[i].end.dateTime;
                            let end2 = end.split('T')[1].split('+')[0];
                            let start2 = start.split('T')[1].split('+')[0];
                            tabstart = start.split('T')[0].split('-');
                            tabend = end.split('T')[0].split('-');
                            if (tabend[2] - tabstart[2] == 1)
                                tabend[2] = tabstart[2];
                            end = tabend.join('-');
                            start = tabstart.join('-');
                            let endDate = end.concat(' ').concat(end2);
                            let startDate = start.concat(' ').concat(start2);
                            console.log(startDate);
                            console.log(endDate);
                            jsonData = `{"Subject": "${items[i].summary}", "StartTime": "${startDate}", "EndTime": "${endDate}", "className": "chill", "AllDay": false}`;
                        }
                        let jsonObj = JSON.parse(jsonData);
                        console.log(items[i]);
                        console.log(jsonData);
                        my_googletab[i] = jsonObj;
                    }
                    const stop_2 = Date.now()
                    console.log(`Time Taken by calendar to execute = ${(stop_2 - start_2)/1000} seconds`);
                    resolve("Success");
                } else {
                    console.log('No upcoming events found.');
                    return(JSON.stringify({ message: 'No upcoming events found.' }));
                }
            }
        });
    });
    let json = my_epitab.concat(my_googletab);
    console.log(json);
    res.json(json);
});

app.listen(5000);