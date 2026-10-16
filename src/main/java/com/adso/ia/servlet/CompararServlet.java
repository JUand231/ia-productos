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
    if (tipoA == null) tipoA = "normal";
    if (tipoB == null) tipoB = "normal";
    String tempParam = req.getParameter("temperature");
    if (tempParam == null || tempParam.isBlank()) tempParam = "0.7";

    // En sesión (no en request): así sobreviven a la redirección de abajo
    javax.servlet.http.HttpSession ses = req.getSession();
    ses.setAttribute("tipoAVal", tipoA);
    ses.setAttribute("tipoBVal", tipoB);
    ses.setAttribute("tempVal", tempParam);

    double temp = 0.7;
    try { temp = Double.parseDouble(tempParam); }
    catch (NumberFormatException e) { temp = 0.7; }

    try {
      GroqService s = new GroqService();
      // Misma base neutra para los dos lados: con datos se basa en ellos, sin datos usa su memoria
      String base = "Eres asistente de tienda online. Responde en español de forma neutra y directa, sin adjetivos emocionales. Si te dan datos de un producto, basate en ellos y menciónalos. Si no te dan datos, responde con tu conocimiento general; si preguntan por datos actuales (precios, rankings, top de ventas), responde con lo más conocido aclarando que tu información puede estar desactualizada y debe verificarse. Separa las ideas con saltos de línea.";
      // Mismo user, distinto system: ahí se ve que "cómo se pregunta" importa
      RespuestaIA a = s.preguntar(base + tono(tipoA), pregunta, temp);
      RespuestaIA b = s.preguntar(base + tono(tipoB), pregunta, temp);
      // Consultas restantes reales (de la última llamada)
      req.getSession().setAttribute("consultasRestantes", b.getConsultasRestantes());
      req.getSession().setAttribute("limiteConsultas", b.getLimiteConsultas());
      ses.setAttribute("respuestaA", a);
      ses.setAttribute("respuestaB", b);
      ses.setAttribute("tipoA", nombre(tipoA));
      ses.setAttribute("tipoB", nombre(tipoB));
      ses.setAttribute("pregunta", pregunta);
      ses.removeAttribute("error");
    } catch (GroqException e) {
      ses.setAttribute("error", "Error " + e.getCodigoHttp() + ": " + e.getMessage());
      ses.removeAttribute("respuestaA");
      ses.removeAttribute("respuestaB");
    } catch (Exception e) {
      ses.setAttribute("error", "Error inesperado: " + e.getMessage());
      ses.removeAttribute("respuestaA");
      ses.removeAttribute("respuestaB");
    }
    // PRG: redirigir en vez de reenviar. Así recargar NO repite las 2 consultas.
    res.sendRedirect("comparar.jsp");
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
    if ("1".equals(req.getParameter("limpiar"))) {
      javax.servlet.http.HttpSession ses = req.getSession();
      ses.removeAttribute("respuestaA");
      ses.removeAttribute("respuestaB");
      ses.removeAttribute("tipoA");
      ses.removeAttribute("tipoB");
      ses.removeAttribute("pregunta");
      ses.removeAttribute("error");
    }
    res.sendRedirect("comparar.jsp");
  }
}