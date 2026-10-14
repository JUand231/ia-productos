package com.adso.ia.model;

public class RespuestaIA {

    private final String texto;
    private final int tokensEntrada;
    private final int tokensSalida;
    private final int tokensTotal;

    public RespuestaIA(String texto, int tokensEntrada, int tokensSalida, int tokensTotal) {
        this.texto = texto;
        this.tokensEntrada = tokensEntrada;
        this.tokensSalida = tokensSalida;
        this.tokensTotal = tokensTotal;
    }

    public String getTexto() {
        return texto;
    }

    // Texto listo para pintarlo en el JSP: respeta negrillas y saltos de línea.
    // Primero escapa el HTML (seguridad) y luego convierte el markdown básico.
    public String getTextoHtml() {
        if (texto == null) return "";
        String h = texto.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
        h = h.replaceAll("\\*\\*(.+?)\\*\\*", "<strong>$1</strong>");
        h = h.replaceAll("(?m)^\\* ", "• ");
        h = h.replace("\n", "<br>");
        return h;
    }

    public int getTokensEntrada() {
        return tokensEntrada;
    }

    public int getTokensSalida() {
        return tokensSalida;
    }

    public int getTokensTotal() {
        return tokensTotal;
    }
}
