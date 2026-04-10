const express = require("express");

const app = express();
const port = process.env.PORT || 3003;

const deliveries = [
  { id: "del-3001", orderId: "ord-1001", rider: "Noah", status: "assigned" }
];

app.get("/health", (req, res) => {
  res.json({ service: "delivery-service", status: "ok" });
});

app.get("/deliveries", (req, res) => {
  res.json(deliveries);
});

app.listen(port, () => {
  console.log(`delivery-service listening on port ${port}`);
});
