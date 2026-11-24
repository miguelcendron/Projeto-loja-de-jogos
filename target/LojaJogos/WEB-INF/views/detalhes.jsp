<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<fmt:setLocale value="pt_BR" />
<jsp:include page="cabecalho.jsp" />

<a href="jogos" class="btn btn-sm btn-outline-light mb-3">&larr; Voltar ao catálogo</a>

<div class="row g-4">
	<div class="col-md-5">
		<div class="capa capa-grande" style="--h: ${(jogo.id * 47) % 360}">
			<span class="capa-inicial"><c:out value="${fn:toUpperCase(fn:substring(jogo.nome, 0, 1))}"/></span>
			<c:if test="${not empty jogo.imagem}">
				<img src="<c:out value='${jogo.imagem}'/>" alt="Capa de <c:out value='${jogo.nome}'/>" onerror="this.remove()">
			</c:if>
			<span class="selo-plataforma"><c:out value="${jogo.plataforma}"/></span>
		</div>
	</div>

	<div class="col-md-7">
		<h2 class="titulo"><c:out value="${jogo.nome}"/></h2>
		<div class="mb-3">
			<span class="badge text-bg-secondary"><c:out value="${jogo.plataforma}"/></span>
			<span class="badge text-bg-dark border"><c:out value="${jogo.genero}"/></span>
		</div>

		<p class="preco fs-2 mb-1"><fmt:formatNumber value="${jogo.preco}" type="currency"/></p>
		<p>
			<c:choose>
				<c:when test="${jogo.estoque == 0}"><span class="badge text-bg-danger">Esgotado</span></c:when>
				<c:when test="${jogo.estoque <= 5}"><span class="badge text-bg-warning">Restam apenas ${jogo.estoque}</span></c:when>
				<c:otherwise><span class="badge text-bg-success">${jogo.estoque} em estoque</span></c:otherwise>
			</c:choose>
		</p>

		<h6 class="text-secondary text-uppercase mt-4">Descrição</h6>
		<p class="descricao">
			<c:choose>
				<c:when test="${not empty jogo.descricao}"><c:out value="${jogo.descricao}"/></c:when>
				<c:otherwise><span class="text-secondary">Sem descrição cadastrada.</span></c:otherwise>
			</c:choose>
		</p>

		<p class="text-secondary small">
			Cadastrado em <fmt:formatDate value="${jogo.dataCadastro}" pattern="dd/MM/yyyy 'às' HH:mm"/>
		</p>

		<div class="d-flex gap-2">
			<a href="jogos?acao=editar&id=${jogo.id}" class="btn btn-neon">Editar</a>
			<button type="button" class="btn btn-outline-danger"
				data-excluir data-id="${jogo.id}" data-nome="<c:out value='${jogo.nome}'/>">Excluir</button>
		</div>
	</div>
</div>

<jsp:include page="rodape.jsp" />
