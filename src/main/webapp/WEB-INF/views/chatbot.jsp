<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AI Support Chat - EmotiCare</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #6366f1;
            --primary-hover: #4f46e5;
            --bg-dark: #1a1d2e;
            --bg-card: #242838;
            --bg-input: #2d3142;
            --text-main: #ffffff;
            --text-muted: #9ca3af;
            --border: #2d3142;
            --sender-bg: #6366f1;
            --receiver-bg: #2d3142;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Inter', sans-serif;
            background: var(--bg-dark);
            color: var(--text-main);
            height: 100vh;
            display: flex;
            overflow: hidden;
        }

        /* Sidebar Styles */
        .sidebar {
            width: 300px;
            background: var(--bg-card);
            border-right: 1px solid var(--border);
            display: flex;
            flex-direction: column;
            transition: transform 0.3s ease;
        }

        .sidebar-header {
            padding: 24px;
            border-bottom: 1px solid var(--border);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .new-chat-btn {
            width: 100%;
            padding: 12px;
            background: var(--primary);
            color: white;
            border: none;
            border-radius: 12px;
            font-weight: 600;
            cursor: pointer;
            margin-top: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: background 0.2s;
        }

        .new-chat-btn:hover { background: var(--primary-hover); }

        .chat-list {
            flex: 1;
            overflow-y: auto;
            padding: 16px;
        }

        .chat-item {
            padding: 12px;
            border-radius: 12px;
            margin-bottom: 8px;
            cursor: pointer;
            transition: background 0.2s;
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: relative;
        }

        .chat-item:hover { background: var(--bg-input); }
        .chat-item.active { background: var(--bg-input); border-left: 4px solid var(--primary); }

        .chat-info { flex: 1; overflow: hidden; }
        .chat-title { font-weight: 500; font-size: 14px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .chat-date { font-size: 11px; color: var(--text-muted); }

        .delete-btn {
            background: transparent;
            border: none;
            color: #ef4444;
            opacity: 0;
            cursor: pointer;
            transition: opacity 0.2s;
            padding: 4px;
        }

        .chat-item:hover .delete-btn { opacity: 1; }

        /* Main Chat Styles */
        .main-chat {
            flex: 1;
            display: flex;
            flex-direction: column;
            background: var(--bg-dark);
            position: relative;
        }

        .chat-header {
            padding: 16px 24px;
            background: var(--bg-card);
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .chat-messages {
            flex: 1;
            overflow-y: auto;
            padding: 24px;
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        .message {
            max-width: 80%;
            padding: 12px 16px;
            border-radius: 16px;
            font-size: 15px;
            line-height: 1.5;
            position: relative;
            white-space: pre-wrap;
        }

        .message.user {
            align-self: flex-end;
            background: var(--sender-bg);
            border-bottom-right-radius: 4px;
        }

        .message.ai {
            align-self: flex-start;
            background: var(--receiver-bg);
            border-bottom-left-radius: 4px;
        }

        .message-time {
            font-size: 10px;
            color: rgba(255, 255, 255, 0.6);
            margin-top: 4px;
            text-align: right;
        }

        /* Input Styles */
        .chat-input-area {
            padding: 24px;
            background: var(--bg-card);
            border-top: 1px solid var(--border);
        }

        .input-wrapper {
            max-width: 800px;
            margin: 0 auto;
            position: relative;
            display: flex;
            gap: 12px;
        }

        #message-input {
            flex: 1;
            background: var(--bg-input);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 14px 20px;
            color: white;
            font-family: inherit;
            font-size: 15px;
            resize: none;
            outline: none;
            transition: border-color 0.2s;
        }

        #message-input:focus { border-color: var(--primary); }

        .send-btn {
            background: var(--primary);
            color: white;
            border: none;
            border-radius: 12px;
            padding: 0 24px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s;
        }

        .send-btn:hover { background: var(--primary-hover); }
        .send-btn:disabled { opacity: 0.5; cursor: not-allowed; }

        .back-btn {
            text-decoration: none;
            color: var(--text-muted);
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: color 0.2s;
        }

        .back-btn:hover { color: var(--text-main); }

        /* Animations */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .message { animation: fadeIn 0.3s ease forwards; }

        .typing-indicator {
            align-self: flex-start;
            background: var(--receiver-bg);
            padding: 12px 16px;
            border-radius: 16px;
            display: none;
            align-items: center;
            gap: 4px;
        }

        .dot {
            width: 6px;
            height: 6px;
            background: var(--text-muted);
            border-radius: 50%;
            animation: bounce 1.4s infinite ease-in-out;
        }

        .dot:nth-child(2) { animation-delay: 0.2s; }
        .dot:nth-child(3) { animation-delay: 0.4s; }

        @keyframes bounce {
            0%, 80%, 100% { transform: scale(0); }
            40% { transform: scale(1); }
        }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="sidebar-header">
            <h2 style="font-size: 18px;">Chat History</h2>
            <a href="${pageContext.request.contextPath}/student/dashboard" class="back-btn">
                <span>&lt;</span> Exit
            </a>
        </div>
        <div style="padding: 0 16px;">
            <button class="new-chat-btn" type="button" onclick="startNewChat()">
                <span>+</span> New Chat
            </button>
        </div>
        <div class="chat-list" id="chat-list">
            <c:forEach var="session" items="${sessions}">
                <div class="chat-item" data-id="${session.id}" onclick="loadChat(${session.id})">
                    <div class="chat-info">
                        <div class="chat-title">${session.title}</div>
                        <div class="chat-date">${session.createdAt}</div>
                    </div>
                    <button class="delete-btn" type="button" onclick="deleteHistory(event, ${session.id})">
                        Delete
                    </button>
                </div>
            </c:forEach>
        </div>
    </aside>

    <!-- Main Chat Area -->
    <main class="main-chat">
        <header class="chat-header">
            <div id="current-chat-title" style="font-weight: 600;">EmotiCare Assistant</div>
            <div style="font-size: 13px; color: var(--text-muted);">Mental Health Support</div>
        </header>

        <div class="chat-messages" id="chat-messages">
            <div class="message ai">
                Hello! I'm your EmotiCare assistant. How can I help you today?
            </div>
            <!-- Messages will be loaded here -->
        </div>

        <div class="typing-indicator" id="typing-indicator">
            <div class="dot"></div>
            <div class="dot"></div>
            <div class="dot"></div>
        </div>

        <div class="chat-input-area">
            <div class="input-wrapper">
                <textarea id="message-input" placeholder="Type your message here..." rows="1"></textarea>
                <button class="send-btn" id="send-btn" type="button" onclick="sendMessage()">Send</button>
            </div>
        </div>
    </main>

    <script>
        let currentSessionId = null;
        const supportBaseUrl = '${pageContext.request.contextPath}/ai/support';
        const defaultGreeting = "Hello! I'm your EmotiCare assistant. How can I help you today?";
        const messagesContainer = document.getElementById('chat-messages');
        const messageInput = document.getElementById('message-input');
        const sendBtn = document.getElementById('send-btn');
        const chatList = document.getElementById('chat-list');
        const typingIndicator = document.getElementById('typing-indicator');

        // Auto-resize textarea
        messageInput.addEventListener('input', function() {
            this.style.height = 'auto';
            this.style.height = (this.scrollHeight) + 'px';
        });

        messageInput.addEventListener('keydown', function(e) {
            if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault();
                sendMessage();
            }
        });

        async function sendMessage() {
            const message = messageInput.value.trim();
            if (!message) return;

            // Clear input
            messageInput.value = '';
            messageInput.style.height = 'auto';
            
            // Add user message to UI
            appendMessage('user', message);
            
            // Show typing indicator
            typingIndicator.style.display = 'flex';
            messagesContainer.scrollTop = messagesContainer.scrollHeight;
            sendBtn.disabled = true;

            try {
                const formData = new URLSearchParams();
                if (currentSessionId) formData.append('sessionId', currentSessionId);
                formData.append('message', message);

                const response = await fetch(supportBaseUrl + '/send', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: formData
                });

                if (!response.ok) {
                    throw new Error(`Request failed: ${response.status}`);
                }

                const data = await response.json();
                
                if (!data.success) {
                    throw new Error(data.error || 'Request failed');
                }

                // Add AI response to UI
                appendMessage('ai', data.aiResponse);
                
                if (data.newSession) {
                    currentSessionId = data.sessionId;
                    addSessionToList(data.sessionId, data.title);
                }
            } catch (error) {
                console.error('Error:', error);
                appendMessage('ai', 'Sorry, I encountered an error. Please try again.');
            } finally {
                typingIndicator.style.display = 'none';
                sendBtn.disabled = false;
                messageInput.focus();
            }
        }

        function formatTime(date) {
            return date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
        }

        function appendMessage(sender, content) {
            const div = document.createElement('div');
            div.className = `message ${sender}`;
            div.textContent = content;
            
            const timeDiv = document.createElement('div');
            timeDiv.className = 'message-time';
            timeDiv.textContent = formatTime(new Date());

            div.appendChild(timeDiv);
            messagesContainer.appendChild(div);
            messagesContainer.scrollTop = messagesContainer.scrollHeight;
        }

        async function loadChat(sessionId) {
            currentSessionId = sessionId;
            
            // Highlight active chat
            document.querySelectorAll('.chat-item').forEach(item => {
                item.classList.remove('active');
                if (item.dataset.id == sessionId) item.classList.add('active');
            });

            // Clear messages
            messagesContainer.innerHTML = '';
            
            try {
                const response = await fetch(supportBaseUrl + '/' + sessionId);
                if (!response.ok) {
                    throw new Error(`Request failed: ${response.status}`);
                }
                const messages = await response.json();
                
                if (Array.isArray(messages)) {
                    messages.forEach(msg => {
                        appendMessage(msg.sender.toLowerCase(), msg.content);
                    });
                }
                
                // Update title if needed
                const sessionItem = document.querySelector('.chat-item[data-id="' + sessionId + '"]');
                if (sessionItem) {
                    document.getElementById('current-chat-title').textContent = sessionItem.querySelector('.chat-title').textContent;
                }
            } catch (error) {
                console.error('Error loading chat:', error);
                appendMessage('ai', 'Sorry, I could not load this chat. Please try again.');
            }
        }

        function startNewChat() {
            currentSessionId = null;
            messagesContainer.innerHTML = '';
            appendMessage('ai', defaultGreeting);
            document.querySelectorAll('.chat-item').forEach(item => item.classList.remove('active'));
            document.getElementById('current-chat-title').textContent = 'New Chat';
            typingIndicator.style.display = 'none';
            messageInput.focus();
        }

        function addSessionToList(id, title) {
            document.querySelectorAll('.chat-item').forEach(item => item.classList.remove('active'));

            const item = document.createElement('div');
            item.className = 'chat-item active';
            item.dataset.id = id;
            item.addEventListener('click', () => loadChat(id));

            const info = document.createElement('div');
            info.className = 'chat-info';

            const titleDiv = document.createElement('div');
            titleDiv.className = 'chat-title';
            titleDiv.textContent = title;

            const dateDiv = document.createElement('div');
            dateDiv.className = 'chat-date';
            dateDiv.textContent = 'Just now';

            info.appendChild(titleDiv);
            info.appendChild(dateDiv);

            const deleteBtn = document.createElement('button');
            deleteBtn.className = 'delete-btn';
            deleteBtn.type = 'button';
            deleteBtn.textContent = 'Delete';
            deleteBtn.addEventListener('click', (event) => deleteHistory(event, id));

            item.appendChild(info);
            item.appendChild(deleteBtn);

            chatList.prepend(item);
        }

        async function deleteHistory(event, sessionId) {
            event.stopPropagation();
            if (!confirm('Are you sure you want to delete this chat history?')) return;

            try {
                const response = await fetch(supportBaseUrl + '/' + sessionId, {
                    method: 'DELETE'
                });
                
                if (!response.ok) {
                    throw new Error(`Request failed: ${response.status}`);
                }

                const data = await response.json();
                if (data.success) {
                    const item = document.querySelector('.chat-item[data-id="' + sessionId + '"]');
                    if (item) {
                        item.remove();
                    }
                    
                    if (currentSessionId === sessionId) {
                        startNewChat();
                    }
                } else {
                    throw new Error(data.error || 'Delete failed');
                }
            } catch (error) {
                console.error('Error deleting chat:', error);
                appendMessage('ai', 'Sorry, I could not delete this chat. Please try again.');
            }
        }
    </script>
</body>
</html>


