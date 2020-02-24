/**
 * index.js
 *
 *  Created by cannonrp on 2020/02/20.
 *  Copyright © 2020 The Washington Post. All rights reserved.
 */
const path = require('path');

const core = require('@actions/core');
const exec = require('@actions/exec');

// most @actions toolkit packages have async methods
async function run() {
  try {
    let output = '';
    let error = '';

    const options = {
      listeners: {
        stdout: (data) => { output += data.toString(); },
        stderr: (data) => { error += data.toString() }
      }
    };

    const scriptFilename = path.join(__dirname, 'git-version.sh');
    const success = await exec.exec(`bash ${scriptFilename}`, [], options);

    if (error) {
      console.log('ERROR', error);
    }

    if (success == 0) {
      const lines = output.split('\n');
      const dict = lines.reduce((dict, text) => {
        if (!text) {
          return dict;
        }

        const parts = text.trim().split('=', 2);

        if (parts.length !== 2) {
          console.log(`Warning: could not parse '${text}'`);
          return dict;
        }

        const key = parts[0];
        const value = parts[1];

        return { ...dict, [key]: value };
      }, {});

      Object.keys(dict).forEach((key) => {
        const name = `git_${key}`;
        const value = dict[key];
        console.log(`Set Output '${name}' = '${value}'`)
        core.setOutput(name, value);
      })

      console.log('Finished');
    } else {
      console.log(`Error Returned ${success}!`);
    }
  }
  catch (error) {
    core.setFailed(error.message);
  }
}

run()
