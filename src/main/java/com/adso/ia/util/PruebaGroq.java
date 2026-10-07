package com.adso.ia.util;

import com.adso.ia.model.RespuestaIA;
import com.adso.ia.service.GroqService;

public class PruebaGroq {

    public static void main(String[] args) throws Exception {
        GroqService servicio = new GroqService();
        RespuestaIA r = servicio.preguntar(
        "Eres un técnico, responde con datos y sin adjetivos, usa SOLO los datos que te doy. Si falta un dato, no lo inventes.",
        "Audífonos inalámbricos, $150.000, batería 20 horas",
        0.7);
        System.out.println(r.getTexto());
        System.out.println("Tokens: " + r.getTokensTotal());
    }
}
