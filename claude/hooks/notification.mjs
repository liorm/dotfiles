#! /usr/bin/env -S node --no-warnings

// Exec "say" command with the text "input needed".
import { exec } from 'child_process';

// list of phrases to notify the user about input needed
const phrases = [
    "Please provide the necessary input.",
    "Your input is required to proceed.",
    "We need your input to continue.",
    "Input needed to move forward.",
    "Kindly provide the required input.",
    "Your input is essential for the next step.",
    "Input required to complete the process.",
    "Please enter the necessary information.",
    "We are waiting for your input.",
    "Your input is crucial for the next action.",
    "Input needed to finalize the task.",
    "Please submit the required input.",
    "We cannot proceed without your input.",
    "Your input is important for the next phase.",
    "Input needed to unlock the next step.",
    "Please provide the input to continue.",
    "Your input is necessary to advance.",
    "We are ready for your input.",
    "Input required to proceed with the operation.",
    "Please enter the input to move forward.",
    "Your input is needed to complete the action."
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
