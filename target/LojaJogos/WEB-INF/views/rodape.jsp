	</main>

	<footer class="text-center text-secondary small py-4">
		GameVault &copy; 2026 - Projeto CRUD (Java, Servlets/JSP, MySQL e Bootstrap)
	</footer>

	<!-- Janela de confirmação usada por todos os botões "Excluir" -->
	<div class="modal fade" id="modalExcluir" tabindex="-1" aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content cartao">
				<div class="modal-header border-secondary">
					<h5 class="modal-title">Excluir jogo</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Fechar"></button>
				</div>
				<div class="modal-body">
					Deseja realmente excluir <strong id="modalNome"></strong>? Esta ação não pode ser desfeita.
				</div>
				<div class="modal-footer border-secondary">
					<button type="button" class="btn btn-outline-light" data-bs-dismiss="modal">Cancelar</button>
					<form action="jogos" method="post" class="m-0">
						<input type="hidden" name="acao" value="excluir">
						<input type="hidden" name="id" id="modalId">
						<button type="submit" class="btn btn-danger">Excluir</button>
					</form>
				</div>
			</div>
		</div>
	</div>

	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
	<script>
		document.addEventListener('click', function (e) {
			var botao = e.target.closest('[data-excluir]');
			if (!botao) { return; }
			document.getElementById('modalId').value = botao.dataset.id;
			document.getElementById('modalNome').textContent = botao.dataset.nome;
			bootstrap.Modal.getOrCreateInstance(document.getElementById('modalExcluir')).show();
		});
	</script>
</body>
</html>
