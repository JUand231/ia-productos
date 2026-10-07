<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<body>
    <h1>Resultado</h1>

    <p style="color:red">${error}</p>

    <p>${respuesta.texto}</p>
    <p>Tokens: ${respuesta.tokensEntrada} entrada
       + ${respuesta.tokensSalida} salida
       = ${respuesta.tokensTotal} total</p>

    <a href="index.jsp">Volver</a>
</body>
</html>