const express = require("express");

const app = express();
const port = process.env.PORT || 3002;

const restaurants = [
  { id: "rest-2001", name: "Pasta Point", cuisine: "Italian" },
  { id: "rest-2002", name: "Spice Route", cuisine: "Indian" }
];

app.get("/health", (req, res) => {
  res.json({ service: "restaurant-service", status: "ok" });
});

app.get("/restaurants", (req, res) => {
  res.json(restaurants);
});

app.listen(port, () => {
  console.log(`restaurant-service listening on port ${port}`);
});
