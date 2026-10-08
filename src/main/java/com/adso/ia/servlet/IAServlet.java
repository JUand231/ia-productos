package com.adso.ia.servlet;

import com.adso.ia.model.RespuestaIA;
import com.adso.ia.service.GroqException;
import com.adso.ia.service.GroqService;
import java.io.IOException;
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
        String temperature = req.getParameter("temperature");

        if (producto == null) producto = "";
        if (pregunta == null || pregunta.isBlank()) pregunta = "Describe este producto.";
        req.setAttribute("pregunta", pregunta);

        try {
            double temp = Double.parseDouble(temperature);
            String system = "Eres asistente de tienda online. Responde en español basándote en los datos del producto que te dan: menciónalos en tu respuesta. Si un dato no está, dilo sin inventarlo."
                    + tono(tipoRespuesta);
            // Todo llega en una sola caja: datos + instrucción juntos
            String user = (producto == null || producto.isBlank()) ? pregunta
                    : producto + "\n\nInstrucción: " + pregunta;
            RespuestaIA r = new GroqService().preguntar(system, user, temp);
            req.setAttribute("respuesta", r);
            req.getRequestDispatcher("index.jsp").forward(req, res);

        } catch (GroqException e) {
            req.setAttribute("error", "Error " + e.getCodigoHttp() + ": " + e.getMessage());
            req.getRequestDispatcher("index.jsp").forward(req, res);

        } catch (NumberFormatException e) {
            req.setAttribute("error", "La temperatura no es un número válido");
            req.getRequestDispatcher("index.jsp").forward(req, res);

        } catch (Exception e) {
            req.setAttribute("error", "Error inesperado: " + e.getMessage());
            req.getRequestDispatcher("index.jsp").forward(req, res);
        }
    }

    // Normal = base neutra. Los demás agregan un matiz al system.
    private String tono(String tipo) {
        if ("tecnico".equals(tipo)) return " Sé técnico y directo, sin adjetivos.";
        if ("publicitario".equals(tipo)) return " Escribe de forma atractiva para vender, máximo 3 frases.";
        if ("resena".equals(tipo)) return " Da una reseña honesta con pros y contras.";
        if ("seo".equals(tipo)) return " Incluye un título corto y palabras clave para buscadores.";
        return "";
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        res.sendRedirect("index.jsp");
    }
}
