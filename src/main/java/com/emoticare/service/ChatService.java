package com.emoticare.service;

import com.emoticare.dao.ChatDAO;
import com.emoticare.dao.ChatRiskAlertDAO;
import com.emoticare.model.ChatMessage;
import com.emoticare.model.ChatSession;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.time.Duration;
import java.util.List;
import java.util.Locale;

@Service
public class ChatService {
    private static final Logger logger = LoggerFactory.getLogger(ChatService.class);
    private static final ObjectMapper objectMapper = new ObjectMapper();
    private static final HttpClient httpClient = HttpClient.newBuilder()
            .connectTimeout(Duration.ofSeconds(10))
            .build();
    private static final String GEMINI_MODEL = "gemini-1.5-flash";
    private static final String GEMINI_ENDPOINT =
            "https://generativelanguage.googleapis.com/v1beta/models/" + GEMINI_MODEL + ":generateContent";
    private static final String SAFETY_RESPONSE = String.join("\n",
            "I'm really sorry you're feeling this way. You deserve support.",
            "If you are in immediate danger or might harm yourself or someone else, please contact your local",
            "emergency number or a trusted person right now. You can also reach out to your campus counseling",
            "service or a mental health professional for urgent help.",
            "If you want, you can share what's going on, and I will listen."
    );
    private static final String COMPLEX_RESPONSE = String.join("\n",
            "I cannot provide a diagnosis or medical advice, but I can listen and offer general support.",
            "It may help to talk with a licensed mental health professional or your campus counseling service.",
            "If you'd like, I can help you prepare what to ask them."
    );
    private static final String SYSTEM_PROMPT = String.join("\n",
            "You are EmotiCare, a supportive mental health assistant for university students.",
            "Tone: calm, empathetic, non-judgmental, and encouraging. Use short paragraphs.",
            "Do not diagnose, prescribe, or provide medical or legal advice.",
            "If the user asks about diagnosis, medication, or treatment, encourage consulting a licensed",
            "mental health professional or campus counseling.",
            "If the user mentions self-harm, suicide, harming others, abuse, or immediate danger, respond with",
            "care and urge them to contact local emergency services or a trusted person immediately.",
            "Offer several practical, low-risk coping steps and ask one gentle follow-up question.",
            "",
            "Examples:",
            "User: I'm overwhelmed with assignments and exams.",
            "Assistant: That sounds really heavy. It can help to break tasks into small steps and schedule short",
            "focus blocks with breaks. Would you like help making a simple plan for this week?",
            "User: I feel anxious in class and can't focus.",
            "Assistant: That can be really uncomfortable. A quick grounding exercise might help, like naming five",
            "things you can see and four you can feel. When does the anxiety feel strongest for you?",
            "User: I can't sleep before exams.",
            "Assistant: Pre-exam nights are tough. Keeping a wind-down routine, limiting caffeine, and writing a",
            "short to-do list before bed can help. Do you want a simple bedtime routine idea?",
            "User: I'm feeling lonely after moving away from home.",
            "Assistant: That is a big transition. Reaching out to a classmate or joining a campus club can help",
            "create small connections. Is there a group or activity you might want to try?",
            "User: Should I take medication for anxiety?",
            "Assistant: I can't give medical advice, but a licensed professional can help you decide what is best.",
            "If you want, I can help you list symptoms to discuss with them.",
            "User: I want to hurt myself.",
            "Assistant: I'm really sorry you're feeling this way. You deserve support. Please reach out to local",
            "emergency services, a trusted person, or campus counseling right now. Are you safe at the moment?"
    );
    private static final String STRESS_RESPONSE = String.join("\n",
            "Stress can pile up fast. A few small steps can help you feel more in control:",
            "1) Do a quick brain dump of everything on your mind.",
            "2) Pick the top 1-2 priorities for today and ignore the rest for now.",
            "3) Work in short focus blocks (25-30 minutes) with short breaks.",
            "4) Add a tiny reset like a walk, stretch, or 5 slow breaths.",
            "5) If possible, reduce one commitment or ask for help with one task.",
            "Would you like help turning your tasks into a simple plan?"
    );
    private static final String GRADES_RESPONSE = String.join("\n",
            "If you want to improve grades, start with a simple, realistic study system:",
            "1) Find the biggest gap (missed lectures, weak topics, or practice problems).",
            "2) Use active recall: quiz yourself instead of re-reading notes.",
            "3) Space it out: short sessions over several days beat cramming.",
            "4) After each study block, do 3-5 practice questions.",
            "5) Use office hours or a study group to fix confusion quickly.",
            "6) Protect sleep the night before tests; it helps memory.",
            "Which class or topic feels most difficult right now?"
    );
    private static final String SLEEP_RESPONSE = String.join("\n",
            "For better sleep, try a calm and consistent routine:",
            "1) Keep a steady sleep and wake time (even on weekends).",
            "2) Power down screens 30-60 minutes before bed.",
            "3) Reduce caffeine after early afternoon.",
            "4) Write a quick worry list or to-do list to clear your mind.",
            "5) Use your bed only for sleep so your brain associates it with rest.",
            "6) Get morning light and a little movement during the day.",
            "What is your current sleep schedule like?"
    );
    private static final String ANGER_RESPONSE = String.join("\n",
            "Anger is a normal signal, but it can feel intense. These steps can help:",
            "1) Pause and breathe slowly to lower the physical surge.",
            "2) Name what you feel (hurt, disrespected, overwhelmed) to reduce the heat.",
            "3) Take a short time-out before replying or reacting.",
            "4) Move your body for a few minutes to release tension.",
            "5) When ready, use \"I\" statements to describe what you need.",
            "What usually triggers the anger for you?"
    );

    private final ChatDAO chatDAO = new ChatDAO();
    private final ChatRiskAlertDAO chatRiskAlertDAO = new ChatRiskAlertDAO();

    public int startNewSession(int userId, String firstMessage) throws SQLException {
        // Generate a title from the first message (simple truncation)
        String title = firstMessage.length() > 30 ? firstMessage.substring(0, 27) + "..." : firstMessage;
        ChatSession session = new ChatSession(userId, title);
        int sessionId = chatDAO.createSession(session);
        return sessionId;
    }

    public List<ChatSession> getUserSessions(int userId) throws SQLException {
        return chatDAO.getSessionsByUserId(userId);
    }

    public List<ChatMessage> getSessionMessages(int sessionId) throws SQLException {
        return chatDAO.getMessagesBySessionId(sessionId);
    }

    public void saveMessage(int sessionId, String sender, String content) throws SQLException {
        ChatMessage message = new ChatMessage(sessionId, sender, content);
        chatDAO.saveMessage(message);
    }

    public void recordRiskAlertIfNeeded(int userId, int sessionId, String userMessage) {
        if (userMessage == null || userMessage.trim().isEmpty()) {
            return;
        }
        String normalized = userMessage.toLowerCase(Locale.ROOT);
        if (!isHighRisk(normalized)) {
            return;
        }
        try {
            chatRiskAlertDAO.createAlert(userId, sessionId, "SELF_HARM");
        } catch (SQLException e) {
            logger.warn("Failed to store chat risk alert for userId={}", userId, e);
        }
    }

    public String getAIResponse(String userMessage) {
        if (userMessage == null || userMessage.trim().isEmpty()) {
            return "I'm here to listen. What is on your mind today?";
        }

        String normalized = userMessage.toLowerCase(Locale.ROOT);
        if (isHighRisk(normalized)) {
            return SAFETY_RESPONSE;
        }

        String apiKey = getGeminiApiKey();
        if (apiKey != null) {
            try {
                String aiResponse = callGemini(apiKey, userMessage.trim());
                if (aiResponse != null && !aiResponse.isBlank()) {
                    return aiResponse.trim();
                }
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                logger.warn("Gemini request interrupted", e);
            } catch (Exception e) {
                logger.warn("Gemini request failed, falling back to local responses", e);
            }
        }

        if (isComplex(normalized)) {
            return COMPLEX_RESPONSE;
        }

        String topicResponse = getTopicResponse(normalized);
        if (topicResponse != null) {
            return topicResponse;
        }

        return getFallbackResponse(normalized);
    }

    public void deleteSession(int sessionId) throws SQLException {
        chatDAO.deleteSession(sessionId);
    }

    private String getGeminiApiKey() {
        String key = System.getenv("GEMINI_API_KEY");
        if (key == null || key.isBlank()) {
            key = System.getProperty("gemini.api.key");
        }
        return (key == null || key.isBlank()) ? null : key.trim();
    }

    private String callGemini(String apiKey, String userMessage) throws Exception {
        ObjectNode requestBody = objectMapper.createObjectNode();

        ObjectNode systemInstruction = requestBody.putObject("systemInstruction");
        ArrayNode systemParts = systemInstruction.putArray("parts");
        systemParts.addObject().put("text", SYSTEM_PROMPT);

        ArrayNode contents = requestBody.putArray("contents");
        ObjectNode userContent = contents.addObject();
        userContent.put("role", "user");
        userContent.putArray("parts").addObject().put("text", userMessage);

        ObjectNode generationConfig = requestBody.putObject("generationConfig");
        generationConfig.put("temperature", 0.7);
        generationConfig.put("maxOutputTokens", 512);
        generationConfig.put("topP", 0.9);

        String url = GEMINI_ENDPOINT + "?key=" + URLEncoder.encode(apiKey, StandardCharsets.UTF_8);
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .timeout(Duration.ofSeconds(20))
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(objectMapper.writeValueAsString(requestBody)))
                .build();

        HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
        if (response.statusCode() < 200 || response.statusCode() >= 300) {
            logger.warn("Gemini request failed with status {}", response.statusCode());
            return null;
        }

        JsonNode root = objectMapper.readTree(response.body());
        JsonNode textNode = root.path("candidates")
                .path(0)
                .path("content")
                .path("parts")
                .path(0)
                .path("text");
        if (textNode.isMissingNode()) {
            logger.warn("Gemini response missing text");
            return null;
        }

        return textNode.asText();
    }

    private boolean isHighRisk(String text) {
        return containsAny(text, new String[] {
                "suicide", "kill myself", "end my life", "self-harm", "self harm", "hurt myself",
                "overdose", "no reason to live", "harm myself", "kill someone", "hurt someone",
                "want to die", "wanting to die", "dont want to live", "don't want to live",
                "not want to live", "not wanting to live", "end it all", "life isn't worth living"
        });
    }

    private boolean isComplex(String text) {
        return containsAny(text, new String[] {
                "diagnose", "diagnosis", "medication", "prescribe", "therapy", "therapist",
                "psychiatrist", "psychologist", "treatment plan", "bipolar", "schizophrenia", "adhd"
        });
    }

    private boolean containsAny(String text, String[] keywords) {
        for (String keyword : keywords) {
            if (text.contains(keyword)) {
                return true;
            }
        }
        return false;
    }

    private String getFallbackResponse(String normalizedMessage) {
        if (normalizedMessage.contains("hello") || normalizedMessage.contains("hi")) {
            return "Hello. I'm here to listen and support you. How are you feeling today?";
        }
        if (normalizedMessage.contains("sad") || normalizedMessage.contains("depressed")
                || normalizedMessage.contains("unhappy") || normalizedMessage.contains("down")) {
            return "I'm sorry you're feeling this way. Would you like to share what has been weighing on you?";
        }
        if (normalizedMessage.contains("anxious") || normalizedMessage.contains("anxiety")
                || normalizedMessage.contains("worried")) {
            return "That sounds stressful. A slow breath can help in the moment. What is the main thing causing the stress?";
        }
        if (normalizedMessage.contains("exam") || normalizedMessage.contains("assignment")
                || normalizedMessage.contains("deadline") || normalizedMessage.contains("overwhelmed")) {
            return "That is a lot to carry. Breaking tasks into smaller steps can help. Want to list the top two priorities?";
        }
        if (normalizedMessage.contains("thank")) {
            return "You're welcome. I'm here if you want to talk more.";
        }
        return "Thanks for sharing with me. I'm listening. What feels hardest right now?";
    }

    private String getTopicResponse(String normalizedMessage) {
        if (containsAny(normalizedMessage, new String[] {"stress", "stressed", "overwhelmed"})) {
            return STRESS_RESPONSE;
        }
        if (containsAny(normalizedMessage, new String[] {"grades", "gpa", "study", "studying", "class"})) {
            return GRADES_RESPONSE;
        }
        if (containsAny(normalizedMessage, new String[] {"sleep", "insomnia", "tired"})) {
            return SLEEP_RESPONSE;
        }
        if (containsAny(normalizedMessage, new String[] {"anger", "angry", "mad", "irritable"})) {
            return ANGER_RESPONSE;
        }
        return null;
    }
}
