/**
 * index.test.js
 *
 *  Created by cannonrp on 2020/02/20.
 *  Copyright © 2020 The Washington Post. All rights reserved.
 */
const process = require('process');
const cp = require('child_process');
const path = require('path');

// shows how the runner will run a javascript action with env / stdout protocol
test('test runs', () => {
    process.env['INPUT_MILLISECONDS'] = 500;
    const ip = path.join(__dirname, 'index.js');
    console.log(cp.execSync(`node ${ip}`).toString());
})
