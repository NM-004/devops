const express = require("express");

const app = express();
const port = process.env.PORT || 3001;

app.use(express.json());

const orders = [
  { id: "ord-1001", customer: "Ava", restaurantId: "rest-2001", status: "received" }
];

app.get("/health", (req, res) => {
  res.json({ service: "order-service", status: "ok" });
});

app.get("/orders", (req, res) => {
  res.json(orders);
});

app.post("/orders", (req, res) => {
  const newOrder = {
    id: `ord-${Date.now()}`,
    customer: req.body.customer || "unknown",
    restaurantId: req.body.restaurantId || "unknown",
    status: "received"
  };

  orders.push(newOrder);
  res.status(201).json(newOrder);
});

app.listen(port, () => {
  console.log(`order-service listening on port ${port}`);
});
