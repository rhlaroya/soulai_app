// In functions/index.js
const {onCall} = require("firebase-functions/v2/https");
const {GoogleGenerativeAI} = require("@google/generative-ai");
const {defineSecret} = require("firebase-functions/params");

// Define the secret so Firebase knows about it
const geminiApiKey = defineSecret("GEMINI_API_KEY");

exports.generatePrayer = onCall({secrets: [geminiApiKey]}, async (request) => {
  // Ensure the user is authenticated.
  if (!request.auth) {
    throw new Error("User must be authenticated.");
  }
  const prompt = request.data.prompt;
  if (!prompt) {
    throw new Error("No prompt provided.");
  }

  try {
    // Access the secret's value inside the function
    const genAI = new GoogleGenerativeAI(geminiApiKey.value());
    const model = genAI.getGenerativeModel({model: "gemini-pro"});

    const result = await model.generateContent(prompt);
    const response = result.response;
    const text = response.text();
    return {prayerText: text};
  } catch (error) {
    console.error("Error calling Gemini API:", error);
    throw new Error("Failed to generate prayer.");
  }
});
