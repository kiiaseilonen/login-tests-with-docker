const express = require('express');
const bodyParser = require('body-parser');
const path = require('path');

require('dotenv').config();

const app = express();
const PORT = 5000;
const USERNAME = process.env.USERNAME;
const PASSWORD = process.env.PASSWORD;

app.use(bodyParser.urlencoded({ extended: true }));
app.set('view engine', 'ejs');

app.set('views', path.join(__dirname, 'views'));

app.use(express.static(path.join(__dirname, 'public')));

app.get('/', (req, res) => {
    res.render('login', { error: null });
});

app.post('/login', (req, res) => {
    const { username, password } = req.body;
    if (username === USERNAME && password === PASSWORD) {
        res.render('success', { username });
    } else {
        res.render('login', { error: 'Invalid username or password' });
    }
});

app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).send('Something went wrong!');
});

app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});
