pipeline = Source({name:"mongo", tail: true, namespace: "harvester-test.entries"})
  .transform({filename: "/transporter/transformers/transformer.js", namespace: "harvester-test.entries"})
  .save({name:"es", namespace: "harvester-test.entries"});


