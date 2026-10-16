package com.adso.ia.model;

public class RespuestaIA {

    private final String texto;
    private final int tokensEntrada;
    private final int tokensSalida;
    private final int tokensTotal;
    private int consultasRestantes = -1; // dato real de Groq (-1 si no vino)
    private int limiteConsultas = -1;

    public RespuestaIA(String texto, int tokensEntrada, int tokensSalida, int tokensTotal) {
        this.texto = texto;
        this.tokensEntrada = tokensEntrada;
        this.tokensSalida = tokensSalida;
        this.tokensTotal = tokensTotal;
    }

    public void setCuotaConsultas(int restantes, int limite) {
        this.consultasRestantes = restantes;
        this.limiteConsultas = limite;
    }

    public int getConsultasRestantes() {
        return consultasRestantes;
    }

    public int getLimiteConsultas() {
        return limiteConsultas;
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
