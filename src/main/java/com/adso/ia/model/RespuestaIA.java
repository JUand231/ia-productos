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
