<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="cabecalho.jsp" />

<div class="cartao text-center py-5 px-3">
	<p class="display-4 mb-2">😵</p>
	<h2 class="titulo">Ops! Algo deu errado</h2>
	<p class="text-secondary mb-1">A página não pôde ser carregada.</p>
	<p class="text-secondary small">
		Se o problema continuar, confira se o MySQL está ligado e se o script <code>loja_jogos.sql</code> foi executado.
	</p>
	<c:if test="${not empty pageContext.exception}">
		<p class="small text-secondary">Detalhe técnico: <c:out value="${pageContext.exception.message}"/></p>
	</c:if>
	<a href="${pageContext.request.contextPath}/jogos" class="btn btn-neon mt-2">Voltar ao catálogo</a>
</div>

<jsp:include page="rodape.jsp" />
