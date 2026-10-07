<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<body>
    <h1>Resultado</h1>

    <% if (request.getAttribute("error") != null) { %>
        <p style="color:red">${error}</p>
    <% } %>

    <% if (request.getAttribute("respuesta") != null) { %>
        <p>${respuesta.texto}</p>
        <p>Tokens: ${respuesta.tokensEntrada} entrada
           + ${respuesta.tokensSalida} salida
           = ${respuesta.tokensTotal} total</p>
    <% } %>

    <a href="index.jsp">Volver</a>
</body>
</html>