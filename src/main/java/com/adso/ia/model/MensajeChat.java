package com.adso.ia.model;

import java.io.Serializable;

// Un intercambio del chat: lo que preguntó el usuario y lo que respondió la IA.
// Se guarda en la sesión para armar el historial.
public class MensajeChat implements Serializable {

    private final String pregunta;
    private final RespuestaIA respuesta; // null si hubo error
    private final String error;          // null si todo salió bien
    private final String tipo;

    public MensajeChat(String pregunta, RespuestaIA respuesta, String error, String tipo) {
        this.pregunta = pregunta;
        this.respuesta = respuesta;
        this.error = error;
        this.tipo = tipo;
    }

    public RespuestaIA getRespuesta() {
        return respuesta;
    }

    public String getTipo() {
        return tipo;
    }

    public boolean isError() {
        return error != null;
    }

    // Título corto para el sidebar Historial (sin HTML, máx 30 caracteres)
    public String getTituloCorto() {
        if (pregunta == null || pregunta.isBlank()) return "Chat sin título";
        String t = pregunta.replaceAll("\\s+", " ").trim();
        return t.length() <= 30 ? t : t.substring(0, 30) + "…";
    }

    // Versiones escapadas para pintarlas en el JSP sin romper el HTML
    public String getPreguntaHtml() {
        if (pregunta == null) return "";
        return pregunta.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
                .replace("\n", "<br>");
    }

    public String getErrorHtml() {
        if (error == null) return "";
        return error.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
    }
}
