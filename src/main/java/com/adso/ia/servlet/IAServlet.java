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
        String tipoPrompt = req.getParameter("tipoPrompt");
        String temperature = req.getParameter("temperature");

        try {
            double temp = Double.parseDouble(temperature);
            RespuestaIA r = new GroqService().preguntar(elegirSystem(tipoPrompt), producto, temp);
            req.setAttribute("respuesta", r);
            req.getRequestDispatcher("resultado.jsp").forward(req, res);

        } catch (GroqException e) {
            req.setAttribute("error", "Error " + e.getCodigoHttp() + ": " + e.getMessage());
            req.getRequestDispatcher("resultado.jsp").forward(req, res);

        } catch (NumberFormatException e) {
            req.setAttribute("error", "La temperatura no es un número válido");
            req.getRequestDispatcher("resultado.jsp").forward(req, res);

        } catch (Exception e) {
            req.setAttribute("error", "Error inesperado: " + e.getMessage());
            req.getRequestDispatcher("resultado.jsp").forward(req, res);
        }
    }

    private String elegirSystem(String tipoPrompt) {
        String regla = " Usa SOLO los datos que te doy. Si falta un dato, no lo inventes.";

        if (tipoPrompt == null) {
            return "Eres un redactor de tienda online." + regla;
        }

        switch (tipoPrompt) {
            case "tecnico":
                return "Eres un redactor técnico. Responde con datos y sin adjetivos." + regla;
            case "publicitario":
                return "Eres un redactor publicitario de una tienda online. "
                        + "Escribe una descripción atractiva en máximo 3 frases." + regla;
            case "seo":
                return "Eres un experto en SEO. Escribe un título corto y una descripción "
                        + "que incluya palabras clave." + regla;
            default:
                return "Eres un redactor de tienda online." + regla;
        }
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        res.sendRedirect("index.jsp");
    }
}