<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<fmt:setLocale value="pt_BR" />
<jsp:include page="cabecalho.jsp" />

<%-- Mensagem de sucesso/erro depois de criar, editar ou excluir --%>
<c:if test="${not empty mensagem}">
	<div class="alert alert-${tipoMensagem} alert-dismissible fade show" role="alert">
		<c:out value="${mensagem}"/>
		<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Fechar"></button>
	</div>
</c:if>

<%-- Painel com os números da loja --%>
<div class="row g-3 mb-4">
	<div class="col-6 col-lg-3">
		<div class="stat"><span class="stat-rotulo">Jogos cadastrados</span><span class="stat-valor">${resumo.totalJogos}</span></div>
	</div>
	<div class="col-6 col-lg-3">
		<div class="stat"><span class="stat-rotulo">Unidades em estoque</span><span class="stat-valor">${resumo.totalEstoque}</span></div>
	</div>
	<div class="col-6 col-lg-3">
		<div class="stat"><span class="stat-rotulo">Valor em estoque</span><span class="stat-valor"><fmt:formatNumber value="${resumo.valorEstoque}" type="currency"/></span></div>
	</div>
	<div class="col-6 col-lg-3">
		<div class="stat ${resumo.esgotados > 0 ? 'stat-alerta' : ''}"><span class="stat-rotulo">Esgotados</span><span class="stat-valor">${resumo.esgotados}</span></div>
	</div>
</div>

<div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-3">
	<h2 class="titulo m-0">Catálogo de jogos</h2>
	<a href="jogos?acao=novo" class="btn btn-neon">+ Novo jogo</a>
</div>

<%-- Busca, filtro e ordenação --%>
<form action="jogos" method="get" class="row g-2 mb-3">
	<input type="hidden" name="visao" value="${visao}">
	<div class="col-12 col-md-4">
		<input type="text" name="busca" class="form-control" placeholder="Buscar pelo nome..." value="<c:out value='${busca}'/>">
	</div>
	<div class="col-6 col-md-3">
		<select name="plataforma" class="form-select">
			<option value="">Todas as plataformas</option>
			<c:forEach var="p" items="${plataformas}">
				<option value="${p}" ${p == plataforma ? 'selected' : ''}>${p}</option>
			</c:forEach>
		</select>
	</div>
	<div class="col-6 col-md-3">
		<select name="ordem" class="form-select">
			<option value="nome" ${ordem == 'nome' || empty ordem ? 'selected' : ''}>Nome (A-Z)</option>
			<option value="preco_asc" ${ordem == 'preco_asc' ? 'selected' : ''}>Menor preço</option>
			<option value="preco_desc" ${ordem == 'preco_desc' ? 'selected' : ''}>Maior preço</option>
			<option value="estoque" ${ordem == 'estoque' ? 'selected' : ''}>Maior estoque</option>
			<option value="recentes" ${ordem == 'recentes' ? 'selected' : ''}>Mais recentes</option>
		</select>
	</div>
	<div class="col-12 col-md-2 d-flex gap-2">
		<button type="submit" class="btn btn-neon flex-fill">Filtrar</button>
		<a href="jogos" class="btn btn-outline-light">Limpar</a>
	</div>
</form>

<%-- Links para alternar entre cartões e tabela, mantendo os filtros --%>
<c:url var="urlCartoes" value="/jogos">
	<c:param name="busca" value="${busca}"/>
	<c:param name="plataforma" value="${plataforma}"/>
	<c:param name="ordem" value="${ordem}"/>
	<c:param name="visao" value="cartoes"/>
</c:url>
<c:url var="urlTabela" value="/jogos">
	<c:param name="busca" value="${busca}"/>
	<c:param name="plataforma" value="${plataforma}"/>
	<c:param name="ordem" value="${ordem}"/>
	<c:param name="visao" value="tabela"/>
</c:url>
<div class="d-flex justify-content-between align-items-center mb-3">
	<span class="text-secondary small">${fn:length(jogos)} jogo(s) encontrado(s)</span>
	<div class="btn-group btn-group-sm" role="group" aria-label="Modo de exibição">
		<a href="${urlCartoes}" class="btn btn-outline-light ${visao == 'cartoes' ? 'active' : ''}">Cartões</a>
		<a href="${urlTabela}" class="btn btn-outline-light ${visao == 'tabela' ? 'active' : ''}">Tabela</a>
	</div>
</div>

<c:choose>
	<c:when test="${empty jogos}">
		<div class="cartao text-center text-secondary py-5">
			<p class="fs-5 mb-2">Nenhum jogo encontrado.</p>
			<a href="jogos" class="btn btn-sm btn-outline-light">Limpar filtros</a>
		</div>
	</c:when>

	<%-- Modo cartões (também é o melhor para celular) --%>
	<c:when test="${visao == 'cartoes'}">
		<div class="row row-cols-1 row-cols-sm-2 row-cols-xl-3 g-4">
			<c:forEach var="j" items="${jogos}">
				<div class="col">
					<div class="card jogo-card h-100">
						<a href="jogos?acao=detalhes&id=${j.id}" class="capa" style="--h: ${(j.id * 47) % 360}">
							<span class="capa-inicial"><c:out value="${fn:toUpperCase(fn:substring(j.nome, 0, 1))}"/></span>
							<c:if test="${not empty j.imagem}">
								<img src="<c:out value='${j.imagem}'/>" alt="Capa de <c:out value='${j.nome}'/>" loading="lazy" onerror="this.remove()">
							</c:if>
							<span class="selo-plataforma"><c:out value="${j.plataforma}"/></span>
						</a>
						<div class="card-body d-flex flex-column">
							<h5 class="card-title"><c:out value="${j.nome}"/></h5>
							<div class="mb-3"><span class="badge text-bg-dark border"><c:out value="${j.genero}"/></span></div>
							<div class="mt-auto d-flex justify-content-between align-items-center">
								<span class="preco"><fmt:formatNumber value="${j.preco}" type="currency"/></span>
								<c:choose>
									<c:when test="${j.estoque == 0}"><span class="badge text-bg-danger">Esgotado</span></c:when>
									<c:when test="${j.estoque <= 5}"><span class="badge text-bg-warning">Restam ${j.estoque}</span></c:when>
									<c:otherwise><span class="badge text-bg-success">${j.estoque} em estoque</span></c:otherwise>
								</c:choose>
							</div>
						</div>
						<div class="card-footer d-flex gap-2">
							<a href="jogos?acao=detalhes&id=${j.id}" class="btn btn-sm btn-outline-light">Detalhes</a>
							<a href="jogos?acao=editar&id=${j.id}" class="btn btn-sm btn-outline-info">Editar</a>
							<button type="button" class="btn btn-sm btn-outline-danger ms-auto"
								data-excluir data-id="${j.id}" data-nome="<c:out value='${j.nome}'/>">Excluir</button>
						</div>
					</div>
				</div>
			</c:forEach>
		</div>
	</c:when>

	<%-- Modo tabela --%>
	<c:otherwise>
		<div class="card cartao">
			<div class="table-responsive">
				<table class="table table-dark table-hover align-middle m-0">
					<thead>
						<tr>
							<th>Nome</th>
							<th>Plataforma</th>
							<th>Gênero</th>
							<th class="text-end">Preço</th>
							<th class="text-center">Estoque</th>
							<th class="text-end">Ações</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="j" items="${jogos}">
							<tr>
								<td><a class="link-light link-underline-opacity-0" href="jogos?acao=detalhes&id=${j.id}"><c:out value="${j.nome}"/></a></td>
								<td><span class="badge text-bg-secondary"><c:out value="${j.plataforma}"/></span></td>
								<td><c:out value="${j.genero}"/></td>
								<td class="text-end"><fmt:formatNumber value="${j.preco}" type="currency"/></td>
								<td class="text-center">
									<c:choose>
										<c:when test="${j.estoque == 0}"><span class="badge text-bg-danger">Esgotado</span></c:when>
										<c:when test="${j.estoque <= 5}"><span class="badge text-bg-warning">${j.estoque}</span></c:when>
										<c:otherwise><span class="badge text-bg-success">${j.estoque}</span></c:otherwise>
									</c:choose>
								</td>
								<td class="text-end text-nowrap">
									<a href="jogos?acao=detalhes&id=${j.id}" class="btn btn-sm btn-outline-light">Detalhes</a>
									<a href="jogos?acao=editar&id=${j.id}" class="btn btn-sm btn-outline-info">Editar</a>
									<button type="button" class="btn btn-sm btn-outline-danger"
										data-excluir data-id="${j.id}" data-nome="<c:out value='${j.nome}'/>">Excluir</button>
								</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
		</div>
	</c:otherwise>
</c:choose>

<jsp:include page="rodape.jsp" />
