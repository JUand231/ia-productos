package com.adso.ia.servlet;

import com.adso.ia.model.MensajeChat;
import com.adso.ia.model.RespuestaIA;
import com.adso.ia.service.GroqException;
import com.adso.ia.service.GroqService;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/ia")
public class IAServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException {

        req.setCharacterEncoding("UTF-8");
        res.setContentType("text/html;charset=UTF-8");

        String producto = req.getParameter("producto");
        String pregunta = req.getParameter("pregunta");
        String tipoRespuesta = req.getParameter("tipoRespuesta");
        if (tipoRespuesta == null) tipoRespuesta = "normal";
        if (pregunta == null || pregunta.isBlank()) pregunta = "Describe este producto.";

        // Para que el sidebar no se reinicie: devolvemos lo que eligió
        req.setAttribute("tipoSel", tipoRespuesta);

        RespuestaIA r = null;
        String error = null;
        try {
            double temp = 0.7;
            // Normal: tono neutro, sin emoción. Con datos se basa en ellos, sin datos usa su memoria.
            String system = "Eres asistente de tienda online. Responde en español de forma neutra y directa, sin adjetivos emocionales. Si te dan datos de un producto, basate en ellos y menciónalos. Si no te dan datos, responde con tu conocimiento general; si preguntan por datos actuales (precios, rankings, top de ventas), responde con lo más conocido aclarando que tu información llega hasta 2024 y debe verificarse. Separa las ideas con saltos de línea."
                    + tono(tipoRespuesta);
            // Todo llega en una sola caja: datos + instrucción juntos
            String user = (producto == null || producto.isBlank()) ? pregunta
                    : producto + "\n\nInstrucción: " + pregunta;
            r = new GroqService().preguntar(system, user, temp);
            // Consultas restantes reales (dato oficial de Groq)
            req.getSession().setAttribute("consultasRestantes", r.getConsultasRestantes());
            req.getSession().setAttribute("limiteConsultas", r.getLimiteConsultas());

        } catch (GroqException e) {
            error = "Error " + e.getCodigoHttp() + ": " + e.getMessage();

        } catch (Exception e) {
            error = "Error inesperado: " + e.getMessage();
        }

        // Historial en la sesión: cada envío se suma a la lista (máximo 20)
        List<MensajeChat> historial =
                (List<MensajeChat>) req.getSession().getAttribute("historial");
        if (historial == null) {
            historial = new ArrayList<>();
            req.getSession().setAttribute("historial", historial);
        }
        historial.add(new MensajeChat(pregunta, r, error, nombre(tipoRespuesta)));
        if (historial.size() > 20) historial.remove(0);

        req.getRequestDispatcher("index.jsp").forward(req, res);
    }

    // Normal = base neutra. Los demás agregan un matiz al system.
    private String tono(String tipo) {
        if ("tecnico".equals(tipo)) return " Sé técnico y directo, sin adjetivos.";
        if ("publicitario".equals(tipo)) return " Escribe de forma atractiva para vender, máximo 3 frases.";
        if ("resena".equals(tipo)) return " Da una reseña honesta con pros y contras.";
        if ("seo".equals(tipo)) return " Incluye un título corto y palabras clave para buscadores.";
        return "";
    }

    private String nombre(String tipo) {
        if ("tecnico".equals(tipo)) return "Técnico";
        if ("publicitario".equals(tipo)) return "Publicitario";
        if ("resena".equals(tipo)) return "Reseña";
        if ("seo".equals(tipo)) return "SEO";
        return "Normal";
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        // ?limpiar=1 borra el historial y empieza un chat nuevo de verdad
        if ("1".equals(req.getParameter("limpiar"))) {
            req.getSession().removeAttribute("historial");
        }
        res.sendRedirect("index.jsp");
    }
}
