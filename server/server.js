import dotenv from "dotenv";
import express from "express";
import cors from "cors";
import initModels from "./models/init-models.js";
import Sequelize from "sequelize";
import passport from "passport";
import session from "express-session";
//import * as Sentry from "@sentry/node";
//import { ProfilingIntegration } from "@sentry/profiling-node";

const sequelize = new Sequelize(process.env.DATABASE_URL, {
  dialect: "postgres",
  logging: false,
  dialectOptions: {
    ssl: {
      require: true,
      rejectUnauthorized: false  // Note: This setting can expose you to man-in-the-middle attacks.
    }
  }
});
const models = initModels(sequelize);

/* sequelize.sync({ alter: true, logging: console.log })
  .then(() => console.log("Synchronization successful"))
  .catch(err => console.error("Synchronization failed:", err)); */


dotenv.config();

const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Create an instance of express

// Increase the limit for JSON payloads
app.use(express.json({ limit: '50mb' }));  

// Increase the limit for URL-encoded payloads
app.use(express.urlencoded({ limit: '50mb', extended: true }));


if (process.env.NODE_ENV === 'local') { 
app.use(cors({
  origin: process.env.CLIENT_URL, // specify the origin
  credentials: true, // this allows the session cookie to be sent back and forth
  methods: "GET,HEAD,PUT,PATCH,POST,DELETE,OPTIONS",
  allowedHeaders: "Origin, X-Requested-With, Content-Type, Accept",
  optionsSuccessStatus: 204
}));
}


app.use(session({
  name: 'hotel_prive.sid',
  secret: process.env.SESSION_SECRET,
  resave: false,
  saveUninitialized: false,
  cookie: {
    maxAge: 24 * 60 * 60 * 1000 
  }
}));

app.get('/config', (req, res) => {
  res.json({
    apiUrl: process.env.API_URL,
  });
});

// Initialize Passport and the session
app.use(passport.initialize());
app.use(passport.session());

//routes
app.use('/v1', authRouter); import authRouter from './routes/v1/auth.js'; //Auth Management
app.use('/v1', profile); import profile from './routes/v1/profile.js';//User profile endpoints
app.use('/v1', search); import search from './routes/v1/search.js';//search endpoint
app.use('/v1', communications); import communications from './routes/v1/communication.js' //transactions import and processing back end

/* //Logging through Sentry 
Sentry.init({
  dsn: 'https://9795366f2c4dd2ff68a6379087bcde35@o4506230124511232.ingest.sentry.io/4506230126149632',
  integrations: [
    // enable HTTP calls tracing
    new Sentry.Integrations.Http({ tracing: true }),
    // enable Express.js middleware tracing
    new Sentry.Integrations.Express({ app }),
    new ProfilingIntegration(),
  ],
  // Performance Monitoring
  tracesSampleRate: 1,
  // Set sampling rate for profiling - this is relative to tracesSampleRate
  profilesSampleRate: 1,
});

// The request handler must be the first middleware on the app
app.use(Sentry.Handlers.requestHandler());

// TracingHandler creates a trace for every incoming request
app.use(Sentry.Handlers.tracingHandler());

// All your controllers should live here
app.get("/", function rootHandler(req, res) {
  res.end("Hello world!");
});

app.use(Sentry.Handlers.errorHandler())

//sentry test
app.get("/debug-sentry", function mainHandler(req, res) {
  throw new Error("My first Sentry error!");
}); */

//Start the server
app.listen(process.env.PORT, "0.0.0.0", () => {
  console.log(`Server has started on port:${process.env.PORT}`);
});

