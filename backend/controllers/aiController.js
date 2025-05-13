const axios = require('axios');
const getSuggestions = async (req, res) => {
  try {
    const { text } = req.body;

    // Access the Hugging Face API key from environment variables
    const apiKey = process.env.HF_API_KEY;

    if (!apiKey) {
      return res.status(500).json({ error: 'API key is not configured' });
    }

    // Refined, clear and concise prompt
    const prompt = `
    Improve the following CV bullet point by enhancing the action verbs and keywords. Make the sentence more professional and impactful. Only return the improved bullet point.

    "${text}"
    `;

    // API request to Hugging Face GPT-Neo model for text improvement
    const response = await axios.post(
      'https://api-inference.huggingface.co/models/EleutherAI/gpt-neo-1.3B', 
      {
        inputs: prompt,
      },
      {
        headers: {
          Authorization: `Bearer ${apiKey}`,
        },
      }
    );

    // Log the full API response for debugging
    console.log('API Response:', response.data);

    // Validate and return the response
    if (response.data && Array.isArray(response.data) && response.data[0]?.generated_text) {
      return res.json({ suggestion: response.data[0].generated_text.trim() });
    } else {
      return res.status(500).json({ error: 'No suggestion returned' });
    }

  } catch (error) {
    // Handle errors gracefully
    console.error('Error getting suggestion from GPT-Neo:', error.response?.data || error.message);
    return res.status(500).json({
      error: error.response?.data?.error || 'Failed to get suggestion',
    });
  }
};




checkGrammar = async (req, res) => {
    try {
      const { text } = req.body;
  
      const response = await axios.post(
        'https://api.languagetool.org/v2/check',
        null,
        {
          params: {
            text: text,
            language: 'en-US',
          },
        }
      );
  
      // Process the response to assemble the corrected text
      let correctedText = text;
      const matches = response.data.matches;
  
      // Apply corrections in reverse order to avoid offset issues
      for (let i = matches.length - 1; i >= 0; i--) {
        const match = matches[i];
        if (match.replacements && match.replacements.length > 0) {
          const replacement = match.replacements[0].value;
          correctedText =
            correctedText.substring(0, match.offset) +
            replacement +
            correctedText.substring(match.offset + match.length);
        }
      }
  
      res.json({ correction: correctedText });
    } catch (error) {
      console.error('Error checking grammar:', error);
      res.status(500).json({ error: 'Failed to check grammar' });
    }
  };
  

 coverLetterGenerator = async (req, res) => {
  const { cvContent, position, userName, companyName } = req.body;

  if (!cvContent || !position || !userName || !companyName) {
    return res.status(400).json({ error: 'Missing required fields' });
  }

  const prompt = `
  Use the following CV content to generate a professional cover letter.

  CV Content:
  ${cvContent}

  Position: ${position}
  Applicant Name: ${userName}
  Company Name: ${companyName}

  Generate a professional and concise cover letter:
  `;

  try {
    const response = await axios.post(
      'https://api.cohere.ai/v1/generate',
      {
        model: 'command-xlarge-nightly',
        prompt: prompt,
        max_tokens: 300,
        temperature: 0.7,
      },
      {
        headers: {
          Authorization: `Bearer ${process.env.COHERE_API_KEY}`,
          'Content-Type': 'application/json',
        },
      }
    );

    if (response.data.generations && response.data.generations.length > 0) {
      return res.status(200).json({ coverLetter: response.data.generations[0].text.trim() });
    } else {
      return res.status(500).json({ error: 'Failed to generate cover letter' });
    }
  } catch (error) {
    console.error('Error generating cover letter:', error.message);
    return res.status(500).json({ error: 'Failed to generate cover letter' });
  }
};

module.exports = { getSuggestions, checkGrammar, coverLetterGenerator};
