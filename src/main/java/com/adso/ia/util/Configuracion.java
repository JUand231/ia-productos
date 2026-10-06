package com.adso.ia.util;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class Configuracion {

    // Ajusta la ruta al nombre real de tu paquete dentro de resources
    private static final String RUTA = "/config/config.properties";

    public static String getGroqKey() {
        Properties props = new Properties();
        try (InputStream in = Configuracion.class.getResourceAsStream(RUTA)) {
            if (in == null) {
                throw new IllegalStateException(
                        "No se encontró config.properties. Copia el .example y pega tu key.");
            }
            props.load(in);
        } catch (IOException e) {
            throw new IllegalStateException("No se pudo leer config.properties", e);
        }
        String key = props.getProperty("GROQ_API_KEY");
        if (key == null || key.isBlank() || key.startsWith("TU_CLAVE_GROQ")) {
            throw new IllegalStateException("Falta la GROQ_API_KEY en config.properties");
        }
        return key.trim();
    }
}
