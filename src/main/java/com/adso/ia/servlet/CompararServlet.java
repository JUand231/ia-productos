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

@WebServlet("/comparar")
public class CompararServlet extends HttpServlet {

  protected void doPost(HttpServletRequest req, HttpServletResponse res)
      throws IOException, ServletException {
    req.setCharacterEncoding("UTF-8");
    res.setContentType("text/html;charset=UTF-8");

    // Un solo prompt para los dos lados
    String pregunta = req.getParameter("pregunta");
    String tipoA = req.getParameter("tipoA");
    String tipoB = req.getParameter("tipoB");
    if (pregunta == null || pregunta.isBlank()) pregunta = "Producto: Audífonos $150.000. Descríbelo.";

    double temp = 0.7;
    try { temp = Double.parseDouble(req.getParameter("temperature")); }
    catch (NumberFormatException e) { temp = 0.7; }

    try {
      GroqService s = new GroqService();
      String base = "Eres asistente de tienda online. Responde en español basándote en los datos del producto que te dan: menciónalos en tu respuesta. Si un dato no está, dilo sin inventarlo.";
      // Mismo user, distinto system: ahí se ve que "cómo se pregunta" importa
      RespuestaIA a = s.preguntar(base + tono(tipoA), pregunta, temp);
      RespuestaIA b = s.preguntar(base + tono(tipoB), pregunta, temp);
      req.setAttribute("respuestaA", a);
      req.setAttribute("respuestaB", b);
      req.setAttribute("tipoA", nombre(tipoA));
      req.setAttribute("tipoB", nombre(tipoB));
      req.setAttribute("pregunta", pregunta);
    } catch (GroqException e) {
      req.setAttribute("error", "Error " + e.getCodigoHttp() + ": " + e.getMessage());
    } catch (Exception e) {
      req.setAttribute("error", "Error inesperado: " + e.getMessage());
    }
    req.getRequestDispatcher("comparar.jsp").forward(req, res);
  }

  private String tono(String tipo) {
    if ("tecnico".equals(tipo)) return " Sé técnico y directo, sin adjetivos.";
    if ("publicitario".equals(tipo)) return " Escribe de forma atractiva para vender, máximo 3 frases.";
    if ("resena".equals(tipo)) return " Da una reseña honesta con pros y contras.";
    if ("seo".equals(tipo)) return " Incluye un título corto y palabras clave para buscadores.";
    return ""; // normal
  }

  private String nombre(String tipo) {
    if ("tecnico".equals(tipo)) return "Técnico";
    if ("publicitario".equals(tipo)) return "Publicitario";
    if ("resena".equals(tipo)) return "Reseña";
    if ("seo".equals(tipo)) return "SEO";
    return "Normal";
  }

  protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
    res.sendRedirect("comparar.jsp");
  }
}
