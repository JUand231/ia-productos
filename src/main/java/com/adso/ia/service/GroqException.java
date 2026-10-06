package com.adso.ia.service;

public class GroqException extends Exception {
    private final int codigoHttp;

    public GroqException(int codigoHttp, String mensaje) {
        super(mensaje);
        this.codigoHttp = codigoHttp;
    }

    public int getCodigoHttp() { return codigoHttp; }
}