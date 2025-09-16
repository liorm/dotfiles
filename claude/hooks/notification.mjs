#! /usr/bin/env -S node --no-warnings

// Exec "say" command with the text "input needed".
import { exec } from 'child_process';

// list of phrases to notify the user about input needed
const phrases = [
    "אנא ספק את הקלט הנדרש.",
    "הקלט שלך דרוש כדי להמשיך.",
    "אנחנו צריכים את הקלט שלך כדי להמשיך.",
    "נדרש קלט כדי להתקדם.",
    "אנא ספק את הקלט המבוקש.",
    "הקלט שלך חיוני לשלב הבא.",
    "נדרש קלט להשלמת התהליך.",
    "אנא הזן את המידע הנדרש.",
    "אנחנו ממתינים לקלט שלך.",
    "הקלט שלך קריטי לפעולה הבאה.",
    "נדרש קלט לסיום המשימה.",
    "אנא שלח את הקלט הנדרש.",
    "לא ניתן להמשיך ללא הקלט שלך.",
    "הקלט שלך חשוב לשלב הבא.",
    "נדרש קלט כדי לפתוח את השלב הבא.",
    "אנא ספק את הקלט כדי להמשיך.",
    "הקלט שלך נחוץ להתקדמות.",
    "אנחנו מוכנים לקלט שלך.",
    "נדרש קלט כדי להמשיך בפעולה.",
    "אנא הזן את הקלט כדי להתקדם.",
    "הקלט שלך דרוש להשלמת הפעולה."
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
