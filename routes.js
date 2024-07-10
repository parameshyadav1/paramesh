// src/routes.js
const express = require('express');
const admin = require('firebase-admin');

const routes = (db) => {
    const router = express.Router();

    // Serve the HTML form
    router.get('/', (req, res) => {
        res.sendFile('index.html', { root: 'public' });
    });

    // Handle form submission
    router.post('/submit', async (req, res) => {
        const { name, email, message } = req.body;

        if (!name || !email || !message) {
            return res.status(400).send('All fields are required');
        }

        try {
            await db.collection('submissions').add({
                name,
                email,
                message,
                timestamp: admin.firestore.FieldValue.serverTimestamp()
            });
            res.status(200).send('Submission successful');
        } catch (error) {
            res.status(500).send('Error saving data: ' + error.message);
        }
    });

    return router;
};

module.exports = routes;
