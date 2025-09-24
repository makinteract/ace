#!/usr/bin/env -S deno run --allow-read --allow-write --allow-env

import { parse, stringify } from 'jsr:@std/csv';
import inquirer from 'npm:inquirer';

// Helper functions
export async function convertCSVToTXT(filename: string, fileOutput: string) {
  const text = await Deno.readTextFile(filename);

  const data = parse(text, {
    skipFirstRow: false,
    strip: true,
  });
  const tsv = stringify(data, { separator: '\t' });

  await Deno.writeTextFile(fileOutput, tsv);
}

// delete files in the current directory by name
function deleteFileByName(filename: string) {
  try {
    Deno.removeSync(filename);
    console.log(`Deleted file: ${filename}`);
  } catch (error) {
    if (error instanceof Deno.errors.NotFound) {
      console.log(`File not found: ${filename}`);
    } else {
      console.error(`Error deleting file ${filename}:`, error);
    }
  }
}

// Main execution

// await convertCSVToTXT('chi26c_committee_bidding.csv', 'PCS-bids.txt');

// use inquirer to prompt user for a filename and search among the files in the current directory
const files = Array.from(Deno.readDirSync('.'))
  .filter((file) => file.isFile)
  .map((file) => file.name);

const answers = await inquirer.prompt([
  {
    type: 'list',
    name: 'filename',
    message: 'Select a CSV file to convert:',
    choices: files,
  },
]);

console.log(`You selected: ${answers.filename}`);
deleteFileByName('PCS-bids.txt');

await convertCSVToTXT(answers.filename, 'PCS-bids.txt');
console.log('Conversion complete! Output written to PCS-bids.txt');
