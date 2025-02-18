require('dotenv').config()

const express = require("express");
const app = express();

const bp = require("body-parser");

const amqp = require("amqplib");
const amqpServer = process.env.AMQP_URL;
var channel, connection;

async function connectToQueue() {
    const maxRetries = 5;
    const retryDelay = 5000;
    let retries = 0;

    while (retries < maxRetries) {
        try {
            console.log(`Attempting to connect to RabbitMQ (attempt ${retries + 1}/${maxRetries})...`);
            connection = await amqp.connect(amqpServer);
            
            connection.on('error', (err) => {
                console.error('Connection error:', err);
                setTimeout(connectToQueue, retryDelay);
            });

            connection.on('close', () => {
                console.log('Connection closed, attempting to reconnect...');
                setTimeout(connectToQueue, retryDelay);
            });

            channel = await connection.createChannel();
            await channel.assertQueue("order");
            
            console.log('Successfully connected to RabbitMQ');
            
            channel.consume("order", data => {
                console.log(`Order received: ${Buffer.from(data.content)}`);
                console.log("** Will be shipped soon! **\n")
                channel.ack(data);
            });

            return; // Success, exit the retry loop
        } catch (ex) {
            retries++;
            console.error(`Failed to connect (attempt ${retries}/${maxRetries}):`, ex.message);
            if (retries < maxRetries) {
                console.log(`Retrying in ${retryDelay/1000} seconds...`);
                await new Promise(resolve => setTimeout(resolve, retryDelay));
            } else {
                console.error('Max retries reached, giving up.');
            }
        }
    }
}

// Start the connection process
connectToQueue();

app.listen(process.env.PORT, () => {
    console.log(`Server running at ${process.env.PORT}`);
});
