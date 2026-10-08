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
                    <span>Tu asistente de productos</span>
                </div>
            </div>
            <div class="history-category">Menú</div>
            <ul class="history-list">
                <li class="history-item"><a href="index.jsp" style="color:inherit;text-decoration:none">💬 Pregunta libre</a></li>
                <li class="history-item"><a href="comparar.jsp" style="color:inherit;text-decoration:none">⚖️ Comparador</a></li>
                <li class="history-item active"><a href="prompts.jsp" style="color:inherit;text-decoration:none">💡 Prompts</a></li>
            </ul>
        </div>
        <div class="sidebar-footer">
            <span>Equipo ADSO</span>
            <button id="themeBtn" onclick="toggleTheme()" title="Cambiar entre modo claro y oscuro" style="background:transparent;border:none;cursor:pointer;font-size:1rem;">🌙</button>
        </div>
    </sidebar>

    <!-- GALERÍA DE PROMPTS -->
    <div class="chat-container">
        <div class="chat-header">
            <span class="chat-title">💡 Galería de prompts</span>
        </div>

        <div class="chat-messages" id="chatMessages" style="align-items:stretch;">
            <style>
                .prompt-grid { display:grid; grid-template-columns:1fr 1fr; gap:12px; width:100%; }
                .p-card { background:var(--bg-card); border:1px solid var(--border-color); border-radius:10px; padding:14px; display:flex; flex-direction:column; gap:8px; }
                .p-card h3 { color:var(--accent-blue); font-size:0.95rem; }
                .p-card p { font-size:0.85rem; white-space:pre-wrap; background:var(--bg-main); border-radius:8px; padding:10px; flex:1; }
                .p-card button { align-self:flex-end; background:var(--chat-user-bg); color:var(--accent-blue); border:1px solid var(--border-color); border-radius:20px; padding:5px 14px; cursor:pointer; font-size:0.8rem; }
                .p-card button:hover { background:var(--accent-blue); color:#fff; }
            </style>
            <p style="color:var(--text-muted);font-size:0.9rem;">Copia uno, pégalo en el chat y envíalo. Cada uno muestra una respuesta distinta.</p>
            <div class="prompt-grid">

<div class="p-card"><h3>1. Descripción corta</h3><p>Producto: Tenis deportivos
Precio: $280.000
Suela antideslizante, tallas 38 a 44.
Descríbelo en 2 frases.</p><button onclick="copiar(this)">📋 Copiar</button></div>

<div class="p-card"><h3>2. Descripción publicitaria</h3><p>Producto: Café orgánico 500g
Precio: $32.000
Origen Huila, tueste medio.
Escribe una descripción publicitaria corta para tienda online.</p><button onclick="copiar(this)">📋 Copiar</button></div>

<div class="p-card"><h3>3. Reseña honesta</h3><p>Producto: Audífonos inalámbricos
Precio: $150.000
Batería 20 horas, Bluetooth 5.3.
Dame una reseña honesta con pros y contras.</p><button onclick="copiar(this)">📋 Copiar</button></div>

<div class="p-card"><h3>4. Pros y contras</h3><p>Producto: Mochila escolar
Precio: $95.000
Capacidad 25 litros, material impermeable.
Dame 3 pros y 3 contras en lista.</p><button onclick="copiar(this)">📋 Copiar</button></div>

<div class="p-card"><h3>5. Título + bullets</h3><p>Producto: Reloj inteligente
Precio: $199.000
Monitor de sueño y ritmo cardíaco.
Dame un título atractivo y 3 bullets de venta.</p><button onclick="copiar(this)">📋 Copiar</button></div>

<div class="p-card"><h3>6. Texto SEO</h3><p>Producto: Jabón artesanal de avena
Precio: $12.000
Piel sensible, 100g.
Escribe título SEO y descripción con palabras clave.</p><button onclick="copiar(this)">📋 Copiar</button></div>

<div class="p-card"><h3>7. Post Instagram</h3><p>Producto: Gorra bordada
Precio: $45.000
Talla única ajustable.
Escríbeme un post corto para Instagram con 3 hashtags.</p><button onclick="copiar(this)">📋 Copiar</button></div>

<div class="p-card"><h3>8. Mensaje WhatsApp</h3><p>Producto: Anchetas de cumpleaños
Precio: $75.000
Incluye tarjeta personalizada.
Escríbelo en 1 frase para vender por WhatsApp.</p><button onclick="copiar(this)">📋 Copiar</button></div>

<div class="p-card"><h3>9. Correo lanzamiento</h3><p>Producto: Termo acero 750ml
Precio: $60.000
Frío 24h, calor 12h.
Redacta un correo corto anunciando su lanzamiento.</p><button onclick="copiar(this)">📋 Copiar</button></div>

<div class="p-card"><h3>10. Sugerir precio</h3><p>Producto: Velas aromáticas
Me cuesta hacerlo: $18.000
Quiero ganar el 40%.
¿A cuánto lo vendo y por qué?</p><button onclick="copiar(this)">📋 Copiar</button></div>

<div class="p-card"><h3>11. Comparar 2 productos</h3><p>Producto A: Audífonos $150.000, batería 20h.
Producto B: Audífonos $220.000, batería 40h y cancelación de ruido.
¿Cuál conviene y por qué?</p><button onclick="copiar(this)">📋 Copiar</button></div>

<div class="p-card"><h3>12. Ideas de nombre</h3><p>Producto: Mermelada de mora hecha en casa
Precio: $15.000 frasco.
Dame 5 ideas de nombre para la marca.</p><button onclick="copiar(this)">📋 Copiar</button></div>

<div class="p-card"><h3>13. Eslogan</h3><p>Producto: Panadería de barrio
Pan fresco desde las 5am.
Dame 3 eslóganes cortos.</p><button onclick="copiar(this)">📋 Copiar</button></div>

<div class="p-card"><h3>14. Responder objeción</h3><p>Producto: Curso de repostería
Precio: $120.000, 4 clases.
Un cliente dice "está muy caro". Dame una respuesta amable que lo convenza.</p><button onclick="copiar(this)">📋 Copiar</button></div>

<div class="p-card"><h3>15. Ficha técnica</h3><p>Producto: Bicicleta urbana
Precio: $850.000
Rin 29, 21 cambios, freno de disco.
Haz una ficha técnica ordenada.</p><button onclick="copiar(this)">📋 Copiar</button></div>

<div class="p-card"><h3>16. Traducir al inglés</h3><p>Producto: Ruana de lana
Precio: $110.000
Tejido a mano en Boyacá.
Traduce su descripción al inglés para vender a turistas.</p><button onclick="copiar(this)">📋 Copiar</button></div>

<div class="p-card"><h3>17. Ideas de fotos</h3><p>Producto: Aretes de plata
Precio: $55.000
Dame 5 ideas de fotos para publicarlos en redes.</p><button onclick="copiar(this)">📋 Copiar</button></div>

<div class="p-card"><h3>18. Armar combo</h3><p>Producto A: Shampoo sólido $25.000.
Producto B: Acondicionador sólido $28.000.
Arma una oferta combo con precio y texto de venta.</p><button onclick="copiar(this)">📋 Copiar</button></div>

<div class="p-card"><h3>19. Preguntas frecuentes</h3><p>Producto: Domicilios de almuerzo
Precio: $14.000, entrega 30 min.
Escríbeme 3 preguntas frecuentes con sus respuestas.</p><button onclick="copiar(this)">📋 Copiar</button></div>

<div class="p-card"><h3>20. Para regalo</h3><p>Producto: Kit de cuidado facial
Precio: $89.000, 4 pasos.
Véndelo como regalo del día de la madre en 2 frases emotivas.</p><button onclick="copiar(this)">📋 Copiar</button></div>

            </div>
        </div>
    </div>

    <!-- JAVASCRIPT -->
    <script>
        function copiar(btn) {
            var t = btn.parentElement.querySelector('p').innerText;
            navigator.clipboard.writeText(t).then(function() {
                btn.textContent = '✅ ¡Copiado! Pégalo en el chat';
                setTimeout(function(){ btn.textContent = '📋 Copiar'; }, 2000);
            });
        }

        // Tema claro/oscuro: guarda tu elección en el navegador
        function toggleTheme() {
            var dark = !document.body.classList.contains('dark');
            document.body.classList.toggle('dark', dark);
            localStorage.setItem('nexus-theme', dark ? 'dark' : 'light');
            document.getElementById('themeBtn').textContent = dark ? '☀️' : '🌙';
        }
        (function() {
            if (localStorage.getItem('nexus-theme') === 'dark') {
                document.body.classList.add('dark');
                document.getElementById('themeBtn').textContent = '☀️';
            }
        })();
    </script>
</body>
</html>