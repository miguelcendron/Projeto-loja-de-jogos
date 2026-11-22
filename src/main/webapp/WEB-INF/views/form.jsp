<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="cabecalho.jsp" />

<c:set var="editando" value="${not empty jogo and jogo.id > 0}" />

<h2 class="titulo mb-3">
	<c:choose>
		<c:when test="${editando}">Editar jogo</c:when>
		<c:otherwise>Novo jogo</c:otherwise>
	</c:choose>
</h2>

<c:if test="${not empty erro}">
	<div class="alert alert-danger"><c:out value="${erro}"/></div>
</c:if>

<div class="card cartao">
	<div class="card-body">
		<form action="jogos" method="post" class="row g-3">
			<input type="hidden" name="acao" value="salvar">
			<input type="hidden" name="id" value="${editando ? jogo.id : ''}">

			<div class="col-lg-8">
				<div class="row g-3">
					<div class="col-md-8">
						<label class="form-label" for="nome">Nome</label>
						<input type="text" id="nome" name="nome" class="form-control" maxlength="120" required
							value="<c:out value='${jogo.nome}'/>">
					</div>
					<div class="col-md-4">
						<label class="form-label" for="plataforma">Plataforma</label>
						<select id="plataforma" name="plataforma" class="form-select" required>
							<c:forEach var="p" items="${plataformas}">
								<option value="${p}" ${jogo.plataforma == p ? 'selected' : ''}>${p}</option>
							</c:forEach>
						</select>
					</div>
					<div class="col-md-4">
						<label class="form-label" for="genero">Gênero</label>
						<input type="text" id="genero" name="genero" class="form-control" maxlength="40" required
							placeholder="Ex.: Aventura" value="<c:out value='${jogo.genero}'/>">
					</div>
					<div class="col-md-4">
						<label class="form-label" for="preco">Preço (R$)</label>
						<input type="number" id="preco" name="preco" class="form-control" step="0.01" min="0" required
							value="${jogo.preco}">
					</div>
					<div class="col-md-4">
						<label class="form-label" for="estoque">Estoque</label>
						<input type="number" id="estoque" name="estoque" class="form-control" min="0" step="1" required
							value="${empty jogo ? 0 : jogo.estoque}">
					</div>
					<div class="col-12">
						<label class="form-label" for="imagem">URL da capa <span class="text-secondary">(opcional)</span></label>
						<input type="url" id="imagem" name="imagem" class="form-control" maxlength="500"
							placeholder="https://..." value="<c:out value='${jogo.imagem}'/>">
					</div>
					<div class="col-12">
						<label class="form-label" for="descricao">Descrição <span class="text-secondary">(opcional)</span></label>
						<textarea id="descricao" name="descricao" class="form-control" rows="4" maxlength="2000"><c:out value="${jogo.descricao}"/></textarea>
					</div>
				</div>
			</div>

			<div class="col-lg-4">
				<label class="form-label">Prévia da capa</label>
				<div class="capa capa-previa" style="--h: 260">
					<span class="capa-inicial">🎮</span>
					<img id="previa" class="d-none" alt="Prévia da capa" onerror="this.classList.add('d-none')">
				</div>
				<div class="form-text">Cole o endereço de uma imagem. Sem capa, o jogo aparece com um cartão colorido.</div>
			</div>

			<div class="col-12 d-flex gap-2">
				<button type="submit" class="btn btn-neon">Salvar</button>
				<a href="jogos" class="btn btn-outline-light">Cancelar</a>
			</div>
		</form>
	</div>
</div>

<script>
	var campoImagem = document.getElementById('imagem');
	var previa = document.getElementById('previa');
	function atualizarPrevia() {
		var url = campoImagem.value.trim();
		if (/^https?:\/\//i.test(url)) {
			previa.src = url;
			previa.classList.remove('d-none');
		} else {
			previa.classList.add('d-none');
		}
	}
	campoImagem.addEventListener('input', atualizarPrevia);
	atualizarPrevia();
</script>

<jsp:include page="rodape.jsp" />
