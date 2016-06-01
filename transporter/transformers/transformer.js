module.exports = function(doc) {
  delete doc._id; 
  console.log("transformer: " + JSON.stringify(doc));
  return doc;
};
