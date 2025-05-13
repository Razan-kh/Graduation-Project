const natural = require('natural');
const tokenizer = new natural.WordTokenizer();

function extractKeywords(cvText) {
  if (typeof cvText !== "string") {
    throw new TypeError("Input to extractKeywords must be a string.");
  }

  // Tokenize the text
  const tokens = tokenizer.tokenize(cvText.toLowerCase());

  // Use a custom stopword list
  const customStopwords = new Set([
    ...natural.stopwords,
    "experience",
    "skills",
    "responsibilities",
    "work",
    "contact",
  ]);

  // Filter tokens and apply stemming
  const stemmer = natural.PorterStemmer;
  const keywords = tokens
    .filter((token) => /^[a-z]{2,}$/.test(token) && !customStopwords.has(token)) // Exclude short words and stopwords
    .map((token) => stemmer.stem(token)); // Reduce to base form

  return Array.from(new Set(keywords)); // Remove duplicates
}

function extractKeywordsFromCV(cv) {
  let combinedText = (cv.name || "") + " " + (cv.contactInfo || "");

  if (Array.isArray(cv.components)) {
    cv.components.forEach((component) => {
      combinedText += " " + (component.title || "");
      if (Array.isArray(component.entries)) {
        component.entries.forEach((entry) => {
          combinedText += " " + (entry.title || "") + " " + (entry.subtitle || "");
          if (Array.isArray(entry.bulletPoints)) {
            entry.bulletPoints.forEach((bullet) => {
              combinedText += " " + (bullet.content || "");
            });
          }
        });
      }
    });
  }

  return extractKeywords(combinedText);
}

module.exports = extractKeywordsFromCV;
