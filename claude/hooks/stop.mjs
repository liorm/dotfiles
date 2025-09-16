#! /usr/bin/env -S node --no-warnings

// Exec "say" command with the text "input needed".
import { exec } from 'child_process';

// list of phrases to notify the user about work done.
const phrases = [
    "העבודה הושלמה בהצלחה.",
    "המשימה הסתיימה.",
    "כל הפעולות הושלמו.",
    "העבודה שלך בוצעה בהצלחה.",
    "התהליך הושלם.",
    "הכל בוצע כמצופה.",
    "המשימה הושגה.",
];
const randomPhrase = phrases[Math.floor(Math.random() * phrases.length)];

async function notifyInputNeeded() {
    return new Promise((resolve, reject) => {
        exec(`/usr/bin/say -v "Carmit" "${randomPhrase}"`, (error, stdout, stderr) => {
            if (error) {
                console.error(`Error executing say command: ${error.message}`);
                reject(error);
                return;
            }
            if (stderr) {
                console.error(`Error in say command: ${stderr}`);
                reject(new Error(stderr));
                return;
            }
            resolve(0);
        });
    });
}

// notifyInputNeeded().then((code) => { process.exit(code); });
