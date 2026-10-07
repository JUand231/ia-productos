package com.adso.ia.util;

import com.adso.ia.model.RespuestaIA;
import com.adso.ia.service.GroqService;

public class PruebaGroq {

    public static void main(String[] args) throws Exception {
        GroqService servicio = new GroqService();
        RespuestaIA r = servicio.preguntar(
                "\"Audífonos inalámbricos\", $150.000, \n batería 20 horas, Bluetooth 5.3",
                "Escribe una descripción publicitaria para tienda online.",
                0.7);
        System.out.println(r.getTexto());
        System.out.println("Tokens: " + r.getTokensTotal());
    }
}
