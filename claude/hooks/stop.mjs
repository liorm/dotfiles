#! /usr/bin/env -S node --no-warnings

// Exec "say" command with the text "input needed".
import { exec } from 'child_process';

// list of phrases to notify the user about work done.
const phrases = [
    "Work completed successfully.",
    "The task has been finished.",
    "All operations are done.",
    "Your work has been successfully executed.",
    "The process has been completed.",
    "Everything is done as expected.",
    "The task has been accomplished.",
];
const randomPhrase = phrases[Math.floor(Math.random() * phrases.length)];

async function notifyInputNeeded() {
    return new Promise((resolve, reject) => {
        exec(`/usr/bin/say "${randomPhrase}"`, (error, stdout, stderr) => {
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

notifyInputNeeded().then((code) => { process.exit(code); });

