const express = require('express');
const mongoose = require('mongoose')
const Account = require('./models/account.model')
const FlashCard = require('./models/flashcard.model')
const app = express();
app.use(express.json());
try {
    const connection = mongoose.connect('mongodb://localhost:27017/ct484');
    console.log("Connected database.")
    app.listen(3000, () => console.log('Listening on port 3000'))
} catch (error) {
    console.log(error);
}

app.get("/api/flashCard", async (req, res) => {
    var flashCards = await FlashCard.find({ email: req.query.email });
    console.log(flashCards)
    res.json(flashCards);
})

app.get("/api/flashCard/favorite", async (req, res) => {
    var flashCards = await FlashCard.find({ email: req.query.email, isFavorite: true });
    res.json(flashCards);
})

app.post("/api/flashCard", async (req, res) => {
    req.body.id = (flashCards.length +1).toString();
    req.body.account_email = req.query.email;
    await FlashCard.create(req.body)
    
    res.status(200).json(req.body);
})

app.put("/api/flashCard/favorite/:id", async (req, res) => {
    await FlashCard.updateOne(
        { id: req.params.id }, 
        { $set: { isFavorite: !isFavorite } }
    );

    res.status(200).json("Toggle favorite successfully!");
})

app.put("/api/flashCard/:id",async  (req, res) => {
    // await FlashCard.updateOne(
    //     { id: req.params.id }, 
    //     { $set: { word:  } }
    // );
    await FlashCard.findByIdAndUpdate(req.params.id, req.body)
    res.status(200).json(req.body);
})

app.delete("/api/flashCard/:id",async  (req, res) => {
    await FlashCard.findByIdAndDelete(req.params.id);
    res.status(200).json("Delete successfully!");
})

app.post("/api/login", async (req, res) => {
    try {
        const account = await Account.findOne({email: req.body.email, password: req.body.password});
        if(account){
            return res.status(200).json(account.email);
        }
    } catch (error) {
        console.log(error)
    }

    res.status(200).json(null);
})

app.post("/api/signup", (req, res) => {
    try {
        var account = Account.create(req.body);
    } catch (error) {
        console.log(error)
        return res.status(200).json(false);  
    }
    
    return res.status(200).json(true);  
})