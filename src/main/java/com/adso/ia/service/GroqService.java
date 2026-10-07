package com.adso.ia.service;

import com.adso.ia.model.RespuestaIA;
import com.adso.ia.util.Configuracion;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;

public class GroqService {

    private static final String URL = "https://api.groq.com/openai/v1/chat/completions";
    private static final String MODELO = "openai/gpt-oss-20b";

    private final HttpClient cliente = HttpClient.newBuilder()
            .connectTimeout(Duration.ofSeconds(10))
            .build();

    public RespuestaIA preguntar(String system, String user, double temperature)
            throws GroqException {

        // 1. Armar el JSON que se envía: {model, messages, temperature, max_tokens}
        JsonObject mensajeSystem = new JsonObject();
        mensajeSystem.addProperty("role", "system");
        mensajeSystem.addProperty("content", system);
        
        JsonObject mensajeUser = new JsonObject();
        mensajeUser.addProperty("role", "user");
        mensajeUser.addProperty("content", user);

        JsonArray mensajes = new JsonArray();
        mensajes.add(mensajeSystem);
        mensajes.add(mensajeUser);

        JsonObject cuerpo = new JsonObject();
        cuerpo.addProperty("model", MODELO);
        cuerpo.add("messages", mensajes);
        cuerpo.addProperty("temperature", temperature);
        cuerpo.addProperty("max_completion_tokens", 1024);
        cuerpo.addProperty("reasoning_effort", "low");

        // 2. Armar la petición HTTP POST con la key en la cabecera Authorization
        HttpRequest peticion = HttpRequest.newBuilder()
                .uri(URI.create(URL))
                .timeout(Duration.ofSeconds(30))
                .header("Content-Type", "application/json")
                .header("Authorization", "Bearer " + Configuracion.getGroqKey())
                .POST(HttpRequest.BodyPublishers.ofString(cuerpo.toString()))
                .build();

        // 3. Enviarla y revisar el código de estado
        HttpResponse<String> respuesta;
        try {
            respuesta = cliente.send(peticion,
                    HttpResponse.BodyHandlers.ofString());
        } catch (IOException e) {
            throw new GroqException(503, "No se pudo conectar con Groq: " + e.getMessage());
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new GroqException(503, "La consulta fue interrumpida");
        }

        int codigo = respuesta.statusCode();
        if (codigo == 401) {
            throw new GroqException(401, "API key inválida o vencida");
        }
        if (codigo == 429) {
            throw new GroqException(429, "Límite de consultas alcanzado, espera un momento");
        }
        if (codigo == 400) {
            throw new GroqException(400, "Petición inválida (revisa el modelo o los parámetros)");
        }
        if (codigo != 200) {
            throw new GroqException(codigo, "Error de Groq (código " + codigo + ")");
        }

        // 4. Leer la respuesta: choices[0].message.content y usage
        JsonObject json = JsonParser.parseString(respuesta.body()).getAsJsonObject();
        String texto = json.getAsJsonArray("choices").get(0).getAsJsonObject()
                .getAsJsonObject("message").get("content").getAsString();
        JsonObject usage = json.getAsJsonObject("usage");

        return new RespuestaIA(texto,
                usage.get("prompt_tokens").getAsInt(),
                usage.get("completion_tokens").getAsInt(),
                usage.get("total_tokens").getAsInt());
    }
}
