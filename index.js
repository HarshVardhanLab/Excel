const wait = require('wait')
require('dotenv').config()
require('module-alias/register')
const path = require('path')
const Excel = require(`./structures/Excel.js`)
const client = new Excel()
const healthcheck = require('./healthcheck')

;(async () => {
    await client.initializeMongoose()
    await client.initializedata()
    await wait(3000);
    (await client.loadEvents() - (await client.loadlogs()) - (await client.SQL()))
    await client.loadMain()
    await client.login(client.config.TOKEN)
    
    // Start health check API after bot is ready
    healthcheck(client)
})()
