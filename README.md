# IA Productos — Tema 12: Consumir una API de IA (LLM)

Mini-app web en Java (JSP + Servlets) que envía texto a un modelo de IA (Groq) y muestra la
respuesta en pantalla. Todo gira alrededor del ejemplo **"productos"**. SENA ADSO, CIMM Boyacá.

## Qué hace

- **Chat** (`/`): escribe un texto (con datos de un producto o sin ellos) y la IA responde.
  Tipo de respuesta (Normal, Técnico, Publicitario, Reseña, SEO) + creatividad (temperatura 0–2).
- **Comparador** (`/comparar`): el MISMO prompt se envía con 2 instrucciones distintas lado a lado.
  Demuestra que *cómo se pregunta* cambia la respuesta.
- **Galería de prompts** (`/prompts.jsp`): 20 tarjetas de productos listas para copiar: 15 con
  datos, 4 de memoria (Avon, Nokia, Coca/Pepsi, ruana) y parejas 1↔2, 3↔4 con el mismo producto
  y distinta instrucción.

## Requisitos

- Java 17, Maven, NetBeans (o cualquier IDE) y Tomcat 9.
- Una API key gratis de Groq: https://console.groq.com/keys

## Instalación (5 pasos)

1. Clona el repo.
2. Copia `src/main/resources/config.properties.example` a
   `src/main/resources/config.properties` (ese archivo NO se sube a Git).
3. Pega tu key: `groq.key=gsk_tu_clave_aqui`.
4. En NetBeans: Run sobre el proyecto (usa Tomcat 9.0.120).
5. Abre `http://localhost:8080/ia-productos/` (Ctrl+F5 si no ves cambios).

## Detalles técnicos

- Modelo: `qwen/qwen3.8-27b` (gratis, ver `GroqService.java`). Se cambia con 1 línea.
- Límites del plan gratis: 30 consultas/min, 1000/día, 8000 tokens/min. La app muestra las
  consultas restantes reales que reporta Groq.
- `POST → redirect` (PRG): recargar la página NO reenvía ni gasta consultas.
- La key nunca va al repo (ver `.gitignore` + `git log -S "gsk_"` limpio).

## Límites conocidos (material de expo)

- El modelo no navega: su memoria tiene fecha de corte (ej.: sabe de gpt-oss de ago-2025,
  pero no del iPhone 17 de sep-2025). La app lo advierte en cada respuesta de memoria.
- La misma pregunta puede dar respuestas distintas (temperatura + no determinismo).
