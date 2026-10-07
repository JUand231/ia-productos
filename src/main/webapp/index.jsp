<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Nexus</title>
        <style>
            :root {
                /* PALETA AZUL NEXUS */
                --bg-main: #F3F8FC;
                --bg-sidebar: #DCEBF5;
                --bg-card: #FFFFFF;
                --border-color: #C5D9E8;
                --text-main: #29465B;
                --text-muted: #7893A6;
                --accent-blue: #3F6F8F;
                --accent-blue-hover: #315A76;
                --chat-user-bg: #D9EAF5;
            }

            /* CONFIGURACIÓN GENERAL */
            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            body {
                background-color: var(--bg-main);
                color: var(--text-main);
                display: flex;
                height: 100vh;
                overflow: hidden;
            }

            /* BARRA LATERAL */
            sidebar {
                width: 280px;
                min-width: 280px;
                background-color: var(--bg-sidebar);
                border-right: 1px solid var(--border-color);
                display: flex;
                flex-direction: column;
                justify-content: space-between;
                padding: 20px;
                transition: transform 0.3s ease;
            }

            .sidebar-header {
                display: flex;
                align-items: center;
                gap: 12px;
                margin-bottom: 25px;
            }

            .app-brand-svg {
                width: 32px;
                height: 32px;
                color: var(--accent-blue);
                flex-shrink: 0;
            }

            .app-brand-text {
                display: flex;
                flex-direction: column;
            }

            .app-brand-text h1 {
                font-family: 'Georgia', serif;
                font-size: 1.4rem;
                font-weight: 500;
                font-style: italic;
                color: var(--accent-blue);
                letter-spacing: 0.5px;
                line-height: 1.1;
            }

            .app-brand-text span {
                font-size: 0.72rem;
                color: var(--text-muted);
                margin-top: 2px;
                letter-spacing: 0.2px;
            }

            /* BOTÓN NUEVO CHAT */
            .new-chat-btn {
                width: 100%;
                background-color: var(--accent-blue);
                color: #FFFFFF;
                border: none;
                border-radius: 8px;
                padding: 10px 15px;
                font-size: 0.9rem;
                font-weight: 500;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
                margin-bottom: 20px;
                transition: background 0.2s, transform 0.15s;
            }

            .new-chat-btn:hover {
                background-color: var(--accent-blue-hover);
                transform: translateY(-1px);
            }

            .new-chat-btn:active {
                transform: scale(0.98);
            }

            /* HISTORIAL */
            .history-list {
                list-style: none;
                overflow-y: auto;
                flex-grow: 1;
                margin-right: -10px;
                padding-right: 10px;
            }

            .history-category {
                font-size: 0.75rem;
                text-transform: uppercase;
                color: var(--text-muted);
                margin: 15px 0 8px 5px;
                font-weight: 600;
                letter-spacing: 0.4px;
            }

            .history-item {
                padding: 10px 12px;
                border-radius: 7px;
                font-size: 0.9rem;
                cursor: pointer;
                color: var(--text-main);
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
                margin-bottom: 4px;
                transition: background 0.2s, color 0.2s;
            }

            .history-item:hover,
            .history-item.active {
                background-color: #C9DFED;
                color: var(--text-main);
            }

            /* PIE DE LA BARRA LATERAL */
            .sidebar-footer {
                border-top: 1px solid var(--border-color);
                padding-top: 15px;
                font-size: 0.85rem;
                color: var(--text-muted);
                display: flex;
                align-items: center;
                justify-content: space-between;
            }

            /* CHAT PRINCIPAL */
            .chat-container {
                flex-grow: 1;
                display: flex;
                flex-direction: column;
                height: 100vh;
                background-color: var(--bg-main);
                position: relative;
                min-width: 0;
            }

            /* CABECERA DEL CHAT */
            .chat-header {
                padding: 15px 25px;
                border-bottom: 1px solid var(--border-color);
                display: flex;
                align-items: center;
                justify-content: space-between;
                background-color: var(--bg-main);
            }

            .chat-title {
                font-size: 1rem;
                font-weight: 500;
                color: var(--text-main);
            }

            /* MENSAJES */
            .chat-messages {
                flex-grow: 1;
                overflow-y: auto;
                padding: 20px;
                display: flex;
                flex-direction: column;
                gap: 20px;
                align-items: center;
            }

            .message-wrapper {
                width: 100%;
                max-width: 750px;
                display: flex;
                gap: 15px;
            }

            .message-wrapper.user {
                justify-content: flex-end;
            }

            .message-bubble {
                padding: 12px 18px;
                border-radius: 12px;
                font-size: 0.95rem;
                line-height: 1.5;
                max-width: 80%;
                word-wrap: break-word;
            }

            .message-wrapper.ai .message-bubble {
                background-color: var(--bg-card);
                border: 1px solid var(--border-color);
                color: var(--text-main);
                box-shadow: 0 2px 8px rgba(63, 111, 143, 0.04);
            }

            .message-wrapper.user .message-bubble {
                background-color: var(--chat-user-bg);
                color: var(--text-main);
                border: 1px solid #C8DDEB;
            }

            /* PANTALLA DE BIENVENIDA */
            .welcome-screen {
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                height: 100%;
                text-align: center;
                gap: 15px;
                max-width: 600px;
                margin: auto;
                padding: 20px;
            }

            .welcome-screen h2 {
                font-size: 2rem;
                color: var(--accent-blue);
                font-weight: 600;
            }

            .welcome-screen p {
                color: var(--text-muted);
                font-size: 1.05rem;
            }

            /* ZONA DEL INPUT */
            .chat-input-area {
                padding: 15px 20px 20px;
                display: flex;
                justify-content: center;
                background: linear-gradient(to top, var(--bg-main) 75%, rgba(243, 248, 252, 0));
            }

            .input-box-wrapper {
                position: relative;
                width: 100%;
                max-width: 750px;
                background-color: var(--bg-card);
                border: 1px solid var(--border-color);
                border-radius: 16px;
                padding: 14px 14px 42px 16px;
                box-shadow: 0 4px 12px rgba(63, 111, 143, 0.06);
                transition: border-color 0.2s, box-shadow 0.2s;
            }

            .input-box-wrapper:focus-within {
                border-color: #8FB6D0;
                box-shadow: 0 4px 15px rgba(63, 111, 143, 0.12);
            }

            .input-box-wrapper textarea {
                display: block;
                width: 100%;
                background: transparent;
                border: none;
                outline: none;
                resize: none;
                font-size: 0.95rem;
                line-height: 1.5;
                color: var(--text-main);
                min-height: 24px;
                max-height: 150px;
                overflow-y: auto;
                padding: 0;
                padding-right: 45px;
            }

            .input-box-wrapper textarea::placeholder {
                color: var(--text-muted);
                opacity: 0.8;
            }

            .input-watermark {
                position: absolute;
                left: 16px;
                bottom: 11px;
                font-size: 0.72rem;
                color: var(--text-muted);
                opacity: 0.65;
                pointer-events: none;
                user-select: none;
            }

            .send-btn {
                position: absolute;
                right: 12px;
                bottom: 8px;
                width: 34px;
                height: 34px;
                background-color: var(--accent-blue);
                color: #FFFFFF;
                border: none;
                border-radius: 9px;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                transition: background 0.2s, transform 0.15s;
            }

            .send-btn:hover {
                background-color: var(--accent-blue-hover);
                transform: scale(1.04);
            }

            .send-btn:active {
                transform: scale(0.96);
            }

            .send-btn svg {
                width: 16px;
                height: 16px;
            }

            /* SCROLLBARS */
            .chat-messages::-webkit-scrollbar,
            .history-list::-webkit-scrollbar,
            textarea::-webkit-scrollbar {
                width: 6px;
            }

            .chat-messages::-webkit-scrollbar-track,
            .history-list::-webkit-scrollbar-track,
            textarea::-webkit-scrollbar-track {
                background: transparent;
            }

            .chat-messages::-webkit-scrollbar-thumb,
            .history-list::-webkit-scrollbar-thumb,
            textarea::-webkit-scrollbar-thumb {
                background-color: #B8D0E0;
                border-radius: 10px;
            }

            .chat-messages::-webkit-scrollbar-thumb:hover,
            .history-list::-webkit-scrollbar-thumb:hover,
            textarea::-webkit-scrollbar-thumb:hover {
                background-color: #9DBACD;
            }

            /* RESPONSIVE */
            @media (max-width: 700px) {
                sidebar {
                    width: 220px;
                    min-width: 220px;
                    padding: 15px;
                }
                .chat-header {
                    padding: 15px;
                }
                .chat-messages {
                    padding: 15px;
                }
                .chat-input-area {
                    padding: 10px;
                }
                .input-box-wrapper {
                    max-width: 100%;
                }
                .message-bubble {
                    max-width: 90%;
                }
            }
        </style>
    </head>
    <body>
        <!-- BARRA LATERAL -->
    <sidebar>
        <div>
            <div class="sidebar-header">
                <svg class="app-brand-svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M12 2L2 7l10 5 10-5-10-5z M2 17l10 5 10-5 M2 12l10 5 10-5"/>
                </svg>
                <div class="app-brand-text">
                    <h1>Nexus</h1>
                    <span>Tu asistente inteligente</span>
                </div>
            </div>
            <button class="new-chat-btn" onclick="startNewChat()">
                <span>+</span> Nuevo chat
            </button>
            <div class="history-category">Hoy</div>
            <ul class="history-list">
                <li class="history-item active">Audifonos inalambricos análisis</li>
                <li class="history-item">Estructura de base de datos</li>
                <div class="history-category">Ayer</div>
                <li class="history-item">Generación de prompts técnicos</li>
                <li class="history-item">Revisión de código Java Web</li>
                <li class="history-item">Optimización de consultas SQL</li>
            </ul>
        </div>
        <div class="sidebar-footer">
            <span>Sofia</span>
            <span>⚙️</span>
        </div>
    </sidebar>

    <!-- CHAT PRINCIPAL -->
    <div class="chat-container">
        <div class="chat-header">
            <span class="chat-title">Audifonos inalambricos análisis</span>
        </div>

        <!-- MENSAJES -->
        <div class="chat-messages" id="chatMessages">
            <div class="welcome-screen" id="welcomeScreen">
                <h2>¡Hola, Sofia!</h2>
                <p>Escribe lo que necesitas y deja que Nexus haga su magia.</p>
            </div>
        </div>

        <!-- INPUT DEL CHAT -->
        <div class="chat-input-area">
            <div class="input-box-wrapper">
                <textarea placeholder="Envía un mensaje a Nexus..." rows="1" id="userInput"></textarea>

                <!-- MARCA DE AGUA -->
                <div class="input-watermark">
                    Nexus es una IA y puede cometer errores.
                </div>

                <!-- BOTÓN ENVIAR -->
                <button class="send-btn" onclick="sendMessage()" aria-label="Enviar mensaje">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="22" y1="2" x2="11" y2="13"></line>
                    <polygon points="22 2 15 22 11 13 2 9 22 2"></polygon>
                    </svg>
                </button>
            </div>
        </div>
    </div>

    <!-- JAVASCRIPT -->
    <script>
        function startNewChat() {
            const messages = document.getElementById('chatMessages');
            messages.innerHTML = `
                <div class="welcome-screen" id="welcomeScreen">
                    <h2>¡Hola, Sofia!</h2>
                    <p>Escribe lo que necesitas y deja que la IA haga su magia.</p>
                </div>
            `;
            document.getElementById('userInput').value = '';
            document.getElementById('userInput').style.height = 'auto';
        }

        function sendMessage() {
            const input = document.getElementById('userInput');
            const text = input.value.trim();
            if (!text)
                return;

            const welcome = document.getElementById('welcomeScreen');
            if (welcome)
                welcome.remove();

            const messagesContainer = document.getElementById('chatMessages');

            const userMsgDiv = document.createElement('div');
            userMsgDiv.className = 'message-wrapper user';
            const userBubble = document.createElement('div');
            userBubble.className = 'message-bubble';
            userBubble.textContent = text;
            userMsgDiv.appendChild(userBubble);
            messagesContainer.appendChild(userMsgDiv);

            input.value = '';
            input.style.height = 'auto';
            messagesContainer.scrollTop = messagesContainer.scrollHeight;

            setTimeout(() => {
                const aiMsgDiv = document.createElement('div');
                aiMsgDiv.className = 'message-wrapper ai';
                const aiBubble = document.createElement('div');
                aiBubble.className = 'message-bubble';
                aiBubble.textContent = 'Espera un momento...';
                aiMsgDiv.appendChild(aiBubble);
                messagesContainer.appendChild(aiMsgDiv);
                messagesContainer.scrollTop = messagesContainer.scrollHeight;
            }, 600);
        }

        const textarea = document.getElementById('userInput');
        textarea.addEventListener('input', function () {
            this.style.height = 'auto';
            this.style.height = Math.min(this.scrollHeight, 150) + 'px';
        });

        textarea.addEventListener('keydown', function (e) {
            if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault();
                sendMessage();
            }
        });
    </script>
</body>
</html>