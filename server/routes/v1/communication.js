import express, { raw } from 'express';
import { Sequelize, Op, fn } from 'sequelize';
import initModels from "../../models/init-models.js";
import dotenv from 'dotenv';
import nodemailer from 'nodemailer';

dotenv.config();

const sequelize = new Sequelize(process.env.DATABASE_URL, { dialect: 'mysql', logging: console.log });
const models = initModels(sequelize);
const router = express.Router();

const transporter = nodemailer.createTransport({
    host: process.env.AWS_SMTP_HOST,  // Replace with your AWS SES SMTP endpoint
    port: 587,
    secure: false,  // true for 465, false for other ports
    auth: {
        user: process.env.AWS_SMTP_USER,  
        pass: process.env.AWS_SMTP_PASSWORD  
    }
});

router.post('/send-email', (req, res) => {
    console.log(req.body);
    const { to, subject, text } = req.body;
    const mailOptions = {
        from: 'contact@binga.network',  // Your verified email in AWS SES
        to: to,  // Recipient email
        subject: subject,
        text: text,
    };

    transporter.sendMail(mailOptions, function(error, info){
        if (error) {
            console.log(error);
            res.status(500).json({
                success: false,
                message: "Error sending email: " + error.message
            });
        } else {
            console.log('Email sent: ' + info.response);
            res.json({
                success: true,
                message: 'Email sent successfully!'
            });
        }
    });
});

export default router;