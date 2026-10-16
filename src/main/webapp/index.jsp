<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List,com.adso.ia.model.MensajeChat" %>
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

            /* MODO OSCURO: solo cambia las variables, todo lo demás se adapta */
            body.dark {
                --bg-main: #16222C;
                --bg-sidebar: #1C2C38;
                --bg-card: #22333F;
                --border-color: #33505F;
                --text-main: #DCEBF5;
                --text-muted: #8FA9BC;
                --accent-blue: #6FA3C4;
                --accent-blue-hover: #8AB8D4;
                --chat-user-bg: #2A4252;
            }
            body.dark .history-item.active {
                background-color: #2A4252;
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
                -webkit-font-smoothing: antialiased;
            }

            /* ÍCONOS (base común) */
            .icon {
                width: 18px;
                height: 18px;
                flex-shrink: 0;
                stroke: currentColor;
                fill: none;
                stroke-width: 1.7;
                stroke-linecap: round;
                stroke-linejoin: round;
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
                padding: 24px 18px 18px;
                transition: transform 0.3s ease;
            }

            /* El bloque de arriba hace scroll si no cabe; el pie (Equipo + tema) siempre visible.
               Sin barras visibles: la de abajo salía por un margen negativo, la vertical se oculta. */
            sidebar > div:first-child {
                min-height: 0;
                overflow-y: auto;
                overflow-x: hidden;
                scrollbar-width: none;
            }
            sidebar > div:first-child::-webkit-scrollbar {
                display: none;
            }

            .sidebar-header {
                display: flex;
                align-items: center;
                gap: 12px;
                margin-bottom: 12px;
                padding: 0 6px 12px;
                border-bottom: 1px solid var(--border-color);
            }

            .app-brand-svg {
                width: 36px;
                height: 36px;
                color: var(--accent-blue);
                flex-shrink: 0;
            }

            .app-brand-text {
                display: flex;
                flex-direction: column;
            }

            .app-brand-text h1 {
                font-family: 'Georgia', serif;
                font-size: 1.45rem;
                font-weight: 500;
                font-style: italic;
                color: var(--accent-blue);
                letter-spacing: 0.5px;
                line-height: 1.1;
            }

            .app-brand-text span {
                font-size: 0.72rem;
                color: var(--text-muted);
                margin-top: 3px;
                letter-spacing: 0.3px;
            }

            .new-chat-btn:hover {
                background-color: var(--accent-blue-hover);
                transform: translateY(-1px);
            }

            .new-chat-btn:active {
                transform: scale(0.98);
            }

            /* MENÚ / HISTORIAL */
            .history-list {
                list-style: none;
                overflow-y: auto;
                flex-grow: 1;
                margin-right: -10px;
                padding-right: 10px;
            }

            .history-category {
                display: flex;
                align-items: center;
                gap: 8px;
                font-size: 0.68rem;
                text-transform: uppercase;
                color: var(--text-muted);
                margin: 12px 0 6px 6px;
                font-weight: 600;
                letter-spacing: 0.8px;
            }

            .history-category .icon {
                width: 14px;
                height: 14px;
            }

            .history-list + .history-category {
                margin-top: 12px;
            }

            .history-item {
                position: relative;
                border-radius: 7px;
                font-size: 0.8rem;
                cursor: pointer;
                color: var(--text-main);
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
                margin-bottom: 2px;
                transition: background 0.2s, color 0.2s;
            }

            .history-item a {
                display: flex;
                align-items: center;
                gap: 8px;
                padding: 6px 8px;
                color: inherit;
                text-decoration: none;
            }

            .history-item .icon {
                width: 14px;
                height: 14px;
                color: var(--text-muted);
                transition: color 0.2s;
            }

            .history-item:hover,
            .history-item.active {
                background-color: #C9DFED;
                color: var(--text-main);
            }

            .history-item:hover .icon,
            .history-item.active .icon {
                color: var(--accent-blue);
            }

            .history-item.active {
                font-weight: 600;
            }

            .history-item.active::before {
                content: "";
                position: absolute;
                left: 0;
                top: 20%;
                height: 60%;
                width: 3px;
                border-radius: 0 3px 3px 0;
                background-color: var(--accent-blue);
            }

            /* PERSONALIZACIÓN (opciones) - compacto 40% para dar aire al Historial */
            /* PERSONALIZACIÓN (lista de opciones) */
            .option-group {
                display: flex;
                flex-direction: column;
                gap: 2px;
            }

            .option-row {
                position: relative;
                cursor: pointer;
            }

            .option-row input {
                position: absolute;
                opacity: 0;
                pointer-events: none;
            }

            .option-row .row-body {
                display: flex;
                align-items: center;
                gap: 7px;
                padding: 5px 8px;
                border: 1px solid transparent;
                border-radius: 7px;
                transition: background 0.2s, border-color 0.2s, box-shadow 0.2s;
            }

            .option-row .dot {
                width: 10px;
                height: 10px;
                flex-shrink: 0;
                border: 1px solid var(--text-muted);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                transition: border-color 0.2s;
            }

            .option-row .dot::after {
                content: "";
                width: 5px;
                height: 5px;
                border-radius: 50%;
                background-color: var(--accent-blue);
                transform: scale(0);
                transition: transform 0.15s ease;
            }

            .option-row .row-text {
                display: flex;
                flex-direction: column;
                line-height: 1.2;
            }

            .option-row .row-title {
                font-size: 0.78rem;
                color: var(--text-main);
            }

            .option-row .row-desc {
                display: none;
            }

            .option-row:hover .row-body {
                background-color: var(--bg-card);
            }

            .option-row input:checked + .row-body {
                background-color: var(--bg-card);
                border-color: var(--accent-blue);
                box-shadow: 0 3px 8px rgba(63, 111, 143, 0.12);
            }

            .option-row input:checked + .row-body .dot {
                border-color: var(--accent-blue);
            }

            .option-row input:checked + .row-body .dot::after {
                transform: scale(1);
            }

            .option-row input:checked + .row-body .row-title {
                font-weight: 600;
            }

            .option-row input:focus-visible + .row-body {
                outline: 2px solid var(--accent-blue);
                outline-offset: 2px;
            }

            /* PIE DE LA BARRA LATERAL */
            .sidebar-footer {
                border-top: 1px solid var(--border-color);
                padding-top: 16px;
                margin-top: 16px;
                font-size: 0.86rem;
                color: var(--text-main);
                display: flex;
                align-items: center;
                justify-content: space-between;
            }

            .user-chip {
                display: flex;
                align-items: center;
                gap: 11px;
            }

            .user-avatar {
                width: 36px;
                height: 36px;
                border-radius: 50%;
                background-color: var(--bg-card);
                border: 1px solid var(--border-color);
                color: var(--accent-blue);
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .user-avatar .icon {
                width: 19px;
                height: 19px;
            }

            .user-name {
                font-weight: 600;
                line-height: 1.2;
            }

            .theme-btn {
                width: 36px;
                height: 36px;
                background: transparent;
                border: 1px solid transparent;
                border-radius: 10px;
                color: var(--text-muted);
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                transition: background 0.2s, color 0.2s, border-color 0.2s;
            }

            .theme-btn:hover {
                background-color: var(--bg-card);
                border-color: var(--border-color);
                color: var(--accent-blue);
            }

            .theme-btn .icon-sun {
                display: none;
            }
            body.dark .theme-btn .icon-sun {
                display: block;
            }
            body.dark .theme-btn .icon-moon {
                display: none;
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
                padding: 16px 28px;
                border-bottom: 1px solid var(--border-color);
                display: flex;
                align-items: center;
                justify-content: space-between;
                background-color: var(--bg-main);
            }

            .chat-title {
                display: flex;
                align-items: center;
                gap: 10px;
                font-size: 1rem;
                font-weight: 600;
                color: var(--text-main);
                letter-spacing: 0.2px;
            }

            .chat-title .icon {
                color: var(--accent-blue);
            }

            /* MENSAJES */
            .chat-messages {
                flex-grow: 1;
                overflow-y: auto;
                padding: 28px 20px;
                display: flex;
                flex-direction: column;
                gap: 22px;
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
                padding: 14px 20px;
                border-radius: 16px;
                font-size: 0.95rem;
                line-height: 1.6;
                max-width: 80%;
                word-wrap: break-word;
            }

            .message-wrapper.ai .message-bubble {
                background-color: var(--bg-card);
                border: 1px solid var(--border-color);
                border-top-left-radius: 4px;
                color: var(--text-main);
                box-shadow: 0 2px 10px rgba(63, 111, 143, 0.06);
            }

            .message-wrapper.user .message-bubble {
                background-color: var(--chat-user-bg);
                color: var(--text-main);
                border: 1px solid #C8DDEB;
                border-top-right-radius: 4px;
            }

            /* PANTALLA DE BIENVENIDA */
            .welcome-screen {
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                height: 100%;
                text-align: center;
                gap: 14px;
                max-width: 600px;
                margin: auto;
                padding: 20px;
            }

            .welcome-icon {
                width: 68px;
                height: 68px;
                border-radius: 20px;
                background-color: var(--bg-card);
                border: 1px solid var(--border-color);
                box-shadow: 0 6px 18px rgba(63, 111, 143, 0.10);
                color: var(--accent-blue);
                display: flex;
                align-items: center;
                justify-content: center;
                margin-bottom: 6px;
            }

            .welcome-icon .icon {
                width: 32px;
                height: 32px;
                stroke-width: 1.5;
            }

            .welcome-screen h2 {
                font-family: 'Georgia', serif;
                font-size: 2rem;
                color: var(--accent-blue);
                font-weight: 500;
                font-style: italic;
                letter-spacing: 0.3px;
            }

            .welcome-screen p {
                color: var(--text-muted);
                font-size: 1.02rem;
                line-height: 1.6;
                max-width: 460px;
            }

            /* ZONA DEL INPUT */
            .chat-input-area {
                padding: 15px 20px 24px;
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
                border-radius: 18px;
                padding: 16px 16px 44px 20px;
                box-shadow: 0 4px 14px rgba(63, 111, 143, 0.07);
                transition: border-color 0.2s, box-shadow 0.2s;
            }

            .input-box-wrapper:focus-within {
                border-color: #8FB6D0;
                box-shadow: 0 6px 20px rgba(63, 111, 143, 0.14);
            }

            .input-box-wrapper textarea {
                display: block;
                width: 100%;
                background: transparent;
                border: none;
                outline: none;
                resize: none;
                font-size: 0.96rem;
                line-height: 1.5;
                color: var(--text-main);
                min-height: 24px;
                max-height: 150px;
                overflow-y: auto;
                padding: 0;
                padding-right: 50px;
            }

            .input-box-wrapper textarea::placeholder {
                color: var(--text-muted);
                opacity: 0.8;
            }

            .input-watermark {
                position: absolute;
                left: 20px;
                bottom: 13px;
                font-size: 0.72rem;
                color: var(--text-muted);
                opacity: 0.7;
                pointer-events: none;
                user-select: none;
                letter-spacing: 0.2px;
            }

            .send-btn {
                position: absolute;
                right: 12px;
                bottom: 10px;
                width: 38px;
                height: 38px;
                background-color: var(--accent-blue);
                color: #FFFFFF;
                border: none;
                border-radius: 11px;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                box-shadow: 0 3px 8px rgba(63, 111, 143, 0.25);
                transition: background 0.2s, transform 0.15s, box-shadow 0.2s;
            }

            .send-btn:hover {
                background-color: var(--accent-blue-hover);
                transform: translateY(-1px) scale(1.03);
                box-shadow: 0 5px 12px rgba(63, 111, 143, 0.3);
            }

            .send-btn:active {
                transform: scale(0.96);
            }

            .send-btn svg {
                width: 17px;
                height: 17px;
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
                    padding: 18px 14px 14px;
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

            /* PANTALLAS BAJITAS: compacta las opciones para que quepa el pie sin scroll */
            @media (max-height: 720px) {
                .row-desc {
                    display: none;
                }
                .sidebar-header {
                    margin-bottom: 14px;
                    padding-bottom: 12px;
                }
                .history-category {
                    margin: 12px 0 8px 6px;
                }
                .sidebar-footer {
                    padding-top: 10px;
                    margin-top: 10px;
                }
            }
        </style>
    </head>
    <body>
        <!-- BARRA LATERAL -->
    <sidebar>
        <div>
            <div class="sidebar-header">
                <svg class="app-brand-svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linejoin="round" stroke-linecap="round">
                <path d="M12 2L2 7l10 5 10-5-10-5z M2 17l10 5 10-5 M2 12l10 5 10-5"/>
                </svg>
                <div class="app-brand-text">
                    <h1>Nexus</h1>
                    <span>Tu asistente de productos</span>
                </div>
            </div>

            <div class="history-category">Menú</div>
            <ul class="history-list">
                <li class="history-item active">
                    <a href="index.jsp">
                        <svg class="icon" viewBox="0 0 24 24"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
                        Pregunta libre
                    </a>
                </li>
                <li class="history-item">
                    <a href="comparar.jsp">
                        <svg class="icon" viewBox="0 0 24 24"><path d="M16 3h5v5"/><path d="M21 3l-7 7"/><path d="M8 21H3v-5"/><path d="M3 21l7-7"/><path d="M21 16v5h-5"/><path d="M3 8V3h5"/></svg>
                        Comparador
                    </a>
                </li>
                <li class="history-item">
                    <a href="prompts.jsp">
                        <svg class="icon" viewBox="0 0 24 24"><path d="M9 18h6"/><path d="M10 22h4"/><path d="M12 2a7 7 0 0 0-4 12.7c.6.5 1 1.2 1 2V17h6v-.3c0-.8.4-1.5 1-2A7 7 0 0 0 12 2z"/></svg>
                        Prompts
                    </a>
                </li>
            </ul>
            <% String tipoSel = (String) request.getAttribute("tipoSel"); if (tipoSel == null) tipoSel = "normal"; %>

            <div class="history-category">
                <svg class="icon" viewBox="0 0 24 24"><path d="M4 21v-7"/><path d="M4 10V3"/><path d="M12 21v-9"/><path d="M12 8V3"/><path d="M20 21v-5"/><path d="M20 12V3"/><path d="M1 14h6"/><path d="M9 8h6"/><path d="M17 16h6"/></svg>
                Personalización
            </div>
            <div class="option-group">
                <label class="option-row">
                    <input type="radio" name="tipoRespuesta" form="iaForm" value="normal" <%= "normal".equals(tipoSel) ? "checked" : "" %>>
                    <div class="row-body">
                        <span class="dot"></span>
                        <div class="row-text">
                            <span class="row-title">Normal</span>
                            <span class="row-desc">Respuesta directa y clara</span>
                        </div>
                    </div>
                </label>
                <label class="option-row">
                    <input type="radio" name="tipoRespuesta" form="iaForm" value="tecnico" <%= "tecnico".equals(tipoSel) ? "checked" : "" %>>
                    <div class="row-body">
                        <span class="dot"></span>
                        <div class="row-text">
                            <span class="row-title">Técnico</span>
                            <span class="row-desc">Especificaciones y detalles</span>
                        </div>
                    </div>
                </label>
                <label class="option-row">
                    <input type="radio" name="tipoRespuesta" form="iaForm" value="publicitario" <%= "publicitario".equals(tipoSel) ? "checked" : "" %>>
                    <div class="row-body">
                        <span class="dot"></span>
                        <div class="row-text">
                            <span class="row-title">Publicitario</span>
                            <span class="row-desc">Tono comercial y persuasivo</span>
                        </div>
                    </div>
                </label>
                <label class="option-row">
                    <input type="radio" name="tipoRespuesta" form="iaForm" value="resena" <%= "resena".equals(tipoSel) ? "checked" : "" %>>
                    <div class="row-body">
                        <span class="dot"></span>
                        <div class="row-text">
                            <span class="row-title">Reseña</span>
                            <span class="row-desc">Opinión del producto</span>
                        </div>
                    </div>
                </label>
                <label class="option-row">
                    <input type="radio" name="tipoRespuesta" form="iaForm" value="seo" <%= "seo".equals(tipoSel) ? "checked" : "" %>>
                    <div class="row-body">
                        <span class="dot"></span>
                        <div class="row-text">
                            <span class="row-title">SEO</span>
                            <span class="row-desc">Optimizado para buscadores</span>
                        </div>
                    </div>
                </label>
            </div>

            <div class="history-category">
                <svg class="icon" viewBox="0 0 24 24"><path d="M3 12a9 9 0 1 0 3-6.7"/><path d="M3 4v5h5"/><path d="M12 7v5l4 2"/></svg>
                Historial
            </div>
            <ul class="history-list" style="max-height:260px;flex-grow:1;min-height:100px;">
                <% List<MensajeChat> hSide = (List<MensajeChat>) session.getAttribute("historial");
                   if (hSide == null || hSide.isEmpty()) { %>
                <li class="history-item"><a style="cursor:default;opacity:.7;">Sin chats aún</a></li>
                <% } else { for (int hi = hSide.size() - 1; hi >= 0; hi--) { MensajeChat mh = hSide.get(hi); %>
                <li class="history-item" title="<%= mh.getPreguntaHtml().replace("\"", "'") %>">
                    <a href="#msg-<%= hi %>">
                        <svg class="icon" viewBox="0 0 24 24"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
                        <%= mh.getTituloCorto().replace("<", "&lt;").replace(">", "&gt;") %>
                    </a>
                </li>
                <% } } %>
            </ul>

        </div>

        <div class="sidebar-footer">
            <div class="user-chip">
                <div class="user-avatar">
                    <svg class="icon" viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                </div>
                <span class="user-name">Equipo ADSO</span>
            </div>
            <button id="themeBtn" class="theme-btn" onclick="toggleTheme()" title="Cambiar entre modo claro y oscuro" aria-label="Cambiar tema">
                <svg class="icon icon-moon" viewBox="0 0 24 24"><path d="M21 12.8A9 9 0 1 1 11.2 3a7 7 0 0 0 9.8 9.8z"/></svg>
                <svg class="icon icon-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2"/><path d="M12 20v2"/><path d="M4.9 4.9l1.4 1.4"/><path d="M17.7 17.7l1.4 1.4"/><path d="M2 12h2"/><path d="M20 12h2"/><path d="M4.9 19.1l1.4-1.4"/><path d="M17.7 6.3l1.4-1.4"/></svg>
            </button>
        </div>
    </sidebar>

    <!-- CHAT PRINCIPAL -->
    <div class="chat-container">
        <div class="chat-header">
            <span class="chat-title">
                <svg class="icon" viewBox="0 0 24 24"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
                Pregunta libre
            </span>
            <div style="margin-left:auto;display:flex;flex-direction:column;align-items:flex-end;gap:2px;">
            <a href="ia?limpiar=1" title="Borrar el historial y empezar de cero" style="background:var(--bg-card);border:1px solid var(--border-color);border-radius:20px;padding:5px 14px;font-size:0.8rem;color:var(--accent-blue);text-decoration:none;">Limpiar</a>
            <% Object cR = session.getAttribute("consultasRestantes"); Object cL = session.getAttribute("limiteConsultas"); %>
            <small style="color:var(--text-muted);font-size:0.72rem;" title="Dato real enviado por Groq en cada respuesta">⏳ <%= (cR instanceof Integer && (Integer) cR >= 0) ? cR + "/" + cL + " consultas restantes hoy" : "Cuota: 1000 consultas por día" %></small>
            </div>
        </div>

        <!-- MENSAJES: historial completo de la sesión, lo último abajo -->
        <div class="chat-messages" id="chatMessages">
            <% List<MensajeChat> historial = (List<MensajeChat>) session.getAttribute("historial");
               if (historial == null || historial.isEmpty()) { %>
            <div class="welcome-screen" id="welcomeScreen">
                <div class="welcome-icon">
                    <svg class="icon" viewBox="0 0 24 24"><path d="M12 2L2 7l10 5 10-5-10-5z"/><path d="M2 17l10 5 10-5"/><path d="M2 12l10 5 10-5"/></svg>
                </div>
                <h2>¡Hola!</h2>
                <p>Escribe abajo los datos de tu producto y lo que necesites: descripción, reseña o ideas de venta.</p>
            </div>
            <% } else { for (int mi = 0; mi < historial.size(); mi++) { MensajeChat m = historial.get(mi); %>
            <div class="message-wrapper user" id="msg-<%= mi %>">
                <div class="message-bubble"><%= m.getPreguntaHtml() %></div>
            </div>
            <% if (m.isError()) { %>
            <div class="message-wrapper ai">
                <div class="message-bubble" style="background:#C0392B;color:#fff;border:none;"><%= m.getErrorHtml() %></div>
            </div>
            <% } else { %>
            <div class="message-wrapper ai">
                <div class="message-bubble"><%= m.getRespuesta().getTextoHtml() %><br><br><small style="color:#7893A6;"><%= m.getTipo() %> · Tokens: <%= m.getRespuesta().getTokensTotal() %></small></div>
            </div>
            <% } } } %>
        </div>

        <!-- INPUT DEL CHAT: form real al Servlet /ia -->
        <div class="chat-input-area">
            <div class="input-box-wrapper">
                <form id="iaForm" action="ia" method="post">
                    <textarea placeholder="Ej: Producto: Audífonos $150.000, batería 20h. Dame una reseña." rows="1" id="userInput" name="pregunta"></textarea>

                    <!-- MARCA DE AGUA -->
                    <div class="input-watermark">
                        Nexus es una IA y puede cometer errores.
                    </div>

                    <!-- BOTÓN ENVIAR -->
                    <button class="send-btn" type="submit" aria-label="Enviar mensaje">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="22" y1="2" x2="11" y2="13"></line>
                        <polygon points="22 2 15 22 11 13 2 9 22 2"></polygon>
                        </svg>
                    </button>
                </form>
            </div>
        </div>
    </div>

    <!-- JAVASCRIPT -->
    <script>
        function sendMessage() {
            // Envío real: el form hace POST al Servlet /ia
            document.getElementById('iaForm').submit();
        }

        // Tema claro/oscuro: guarda tu elección en el navegador
        // (los íconos de luna/sol se alternan por CSS con la clase "dark")
        function toggleTheme() {
            var dark = !document.body.classList.contains('dark');
            document.body.classList.toggle('dark', dark);
            localStorage.setItem('nexus-theme', dark ? 'dark' : 'light');
        }
        (function () {
            if (localStorage.getItem('nexus-theme') === 'dark') {
                document.body.classList.add('dark');
            }
        })();

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

        // Al cargar, baja solo hasta la última respuesta
        var cm = document.getElementById('chatMessages');
        if (cm) { cm.scrollTop = cm.scrollHeight; }
    </script>
</body>
</html>