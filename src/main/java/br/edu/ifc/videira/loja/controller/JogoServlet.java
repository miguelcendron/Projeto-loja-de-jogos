package br.edu.ifc.videira.loja.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.SQLException;
import java.util.List;

import br.edu.ifc.videira.loja.dao.JogoDAO;
import br.edu.ifc.videira.loja.model.Jogo;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Controller único do CRUD.
 *
 * GET  /jogos                      -> lista (R)
 * GET  /jogos?acao=detalhes&id=N   -> detalhes de um jogo (R)
 * GET  /jogos?acao=novo            -> formulário vazio
 * GET  /jogos?acao=editar&id=N     -> formulário preenchido
 * POST /jogos (acao=salvar)        -> cria (C) ou atualiza (U)
 * POST /jogos (acao=excluir)       -> exclui (D)
 */
@WebServlet("/jogos")
public class JogoServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	private static final List<String> PLATAFORMAS = List.of("PC", "PlayStation 5", "PlayStation 4",
			"Xbox Series X", "Xbox One", "Nintendo Switch");
	private static final BigDecimal PRECO_MAXIMO = new BigDecimal("99999999.99");

	private final JogoDAO dao = new JogoDAO();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.setCharacterEncoding("UTF-8");
		String acao = valor(req.getParameter("acao"));
		try {
			switch (acao) {
			case "novo":
				abrirFormulario(req, resp, null);
				break;
			case "editar": {
				Jogo jogo = buscar(req.getParameter("id"));
				if (jogo == null) {
					naoEncontrado(req, resp);
					return;
				}
				abrirFormulario(req, resp, jogo);
				break;
			}
			case "detalhes": {
				Jogo jogo = buscar(req.getParameter("id"));
				if (jogo == null) {
					naoEncontrado(req, resp);
					return;
				}
				req.setAttribute("jogo", jogo);
				req.getRequestDispatcher("/WEB-INF/views/detalhes.jsp").forward(req, resp);
				break;
			}
			default:
				listar(req, resp);
			}
		} catch (SQLException e) {
			throw new ServletException("Erro ao acessar o banco de dados", e);
		}
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.setCharacterEncoding("UTF-8");
		String acao = valor(req.getParameter("acao"));
		try {
			if ("excluir".equals(acao)) {
				excluir(req);
				resp.sendRedirect("jogos");
			} else {
				salvar(req, resp);
			}
		} catch (SQLException e) {
			throw new ServletException("Erro ao salvar no banco de dados", e);
		}
	}

	// ---------- ações ----------

	private void listar(HttpServletRequest req, HttpServletResponse resp)
			throws SQLException, ServletException, IOException {
		String busca = valor(req.getParameter("busca"));
		String plataforma = valor(req.getParameter("plataforma"));
		String ordem = valor(req.getParameter("ordem"));
		String visao = "tabela".equals(req.getParameter("visao")) ? "tabela" : "cartoes";

		req.setAttribute("jogos", dao.listar(busca, plataforma, ordem));
		req.setAttribute("resumo", dao.resumo());
		req.setAttribute("plataformas", PLATAFORMAS);
		req.setAttribute("busca", busca);
		req.setAttribute("plataforma", plataforma);
		req.setAttribute("ordem", ordem);
		req.setAttribute("visao", visao);
		transferirMensagem(req);
		req.getRequestDispatcher("/WEB-INF/views/lista.jsp").forward(req, resp);
	}

	private void abrirFormulario(HttpServletRequest req, HttpServletResponse resp, Jogo jogo)
			throws ServletException, IOException {
		if (jogo != null) {
			req.setAttribute("jogo", jogo);
		}
		req.setAttribute("plataformas", PLATAFORMAS);
		req.getRequestDispatcher("/WEB-INF/views/form.jsp").forward(req, resp);
	}

	private void salvar(HttpServletRequest req, HttpServletResponse resp)
			throws SQLException, ServletException, IOException {
		Jogo jogo = new Jogo();
		jogo.setId(converterId(req.getParameter("id")));
		jogo.setNome(valor(req.getParameter("nome")));
		jogo.setPlataforma(valor(req.getParameter("plataforma")));
		jogo.setGenero(valor(req.getParameter("genero")));
		String imagem = valor(req.getParameter("imagem"));
		String descricao = valor(req.getParameter("descricao"));
		jogo.setImagem(imagem.isEmpty() ? null : imagem);
		jogo.setDescricao(descricao.isEmpty() ? null : descricao);

		String erro = validar(jogo, valor(req.getParameter("preco")), valor(req.getParameter("estoque")));
		if (erro != null) {
			req.setAttribute("erro", erro);
			abrirFormulario(req, resp, jogo);
			return;
		}

		if (jogo.getId() == 0) {
			dao.inserir(jogo);
			guardarMensagem(req, "success", "Jogo \"" + jogo.getNome() + "\" cadastrado com sucesso!");
		} else if (dao.atualizar(jogo) > 0) {
			guardarMensagem(req, "success", "Jogo \"" + jogo.getNome() + "\" atualizado com sucesso!");
		} else {
			guardarMensagem(req, "danger", "Jogo não encontrado.");
		}
		resp.sendRedirect("jogos");
	}

	private void excluir(HttpServletRequest req) throws SQLException {
		Jogo jogo = buscar(req.getParameter("id"));
		if (jogo == null) {
			guardarMensagem(req, "danger", "Jogo não encontrado.");
			return;
		}
		dao.excluir(jogo.getId());
		guardarMensagem(req, "success", "Jogo \"" + jogo.getNome() + "\" excluído com sucesso.");
	}

	// ---------- validação ----------

	/** Confere os dados e preenche preço e estoque no jogo. Devolve a mensagem de erro, ou null se estiver tudo certo. */
	private String validar(Jogo j, String precoTxt, String estoqueTxt) {
		if (j.getNome().isEmpty() || j.getGenero().isEmpty()) {
			return "Preencha o nome e o gênero do jogo.";
		}
		if (j.getNome().length() > 120) {
			return "O nome pode ter no máximo 120 caracteres.";
		}
		if (j.getGenero().length() > 40) {
			return "O gênero pode ter no máximo 40 caracteres.";
		}
		if (!PLATAFORMAS.contains(j.getPlataforma())) {
			return "Escolha uma plataforma válida.";
		}
		if (precoTxt.length() > 15) {
			return "Informe um preço válido.";
		}
		try {
			j.setPreco(new BigDecimal(precoTxt.replace(",", ".")).setScale(2, RoundingMode.HALF_UP));
		} catch (NumberFormatException e) {
			return "Informe um preço válido.";
		}
		if (j.getPreco().signum() < 0 || j.getPreco().compareTo(PRECO_MAXIMO) > 0) {
			return "O preço deve estar entre 0 e 99.999.999,99.";
		}
		try {
			j.setEstoque(Integer.parseInt(estoqueTxt));
		} catch (NumberFormatException e) {
			return "Informe um estoque válido (número inteiro).";
		}
		if (j.getEstoque() < 0) {
			return "O estoque não pode ser negativo.";
		}
		if (j.getImagem() != null) {
			String img = j.getImagem().toLowerCase();
			if (!img.startsWith("http://") && !img.startsWith("https://")) {
				return "A URL da capa deve começar com http:// ou https://.";
			}
			if (img.length() > 500) {
				return "A URL da capa é muito longa (máximo de 500 caracteres).";
			}
		}
		if (j.getDescricao() != null && j.getDescricao().length() > 2000) {
			return "A descrição pode ter no máximo 2000 caracteres.";
		}
		return null;
	}

	// ---------- utilitários ----------

	private Jogo buscar(String id) throws SQLException {
		try {
			return dao.buscarPorId(Integer.parseInt(id));
		} catch (NumberFormatException e) {
			return null;
		}
	}

	private int converterId(String id) {
		try {
			return Integer.parseInt(id);
		} catch (NumberFormatException e) {
			return 0;
		}
	}

	private String valor(String texto) {
		return texto == null ? "" : texto.trim();
	}

	private void naoEncontrado(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		guardarMensagem(req, "danger", "Jogo não encontrado.");
		resp.sendRedirect("jogos");
	}

	// Mensagem "de uma vez só": fica na sessão até a próxima lista ser exibida.
	private void guardarMensagem(HttpServletRequest req, String tipo, String texto) {
		HttpSession sessao = req.getSession();
		sessao.setAttribute("mensagem", texto);
		sessao.setAttribute("tipoMensagem", tipo);
	}

	private void transferirMensagem(HttpServletRequest req) {
		HttpSession sessao = req.getSession(false);
		if (sessao == null || sessao.getAttribute("mensagem") == null) {
			return;
		}
		req.setAttribute("mensagem", sessao.getAttribute("mensagem"));
		req.setAttribute("tipoMensagem", sessao.getAttribute("tipoMensagem"));
		sessao.removeAttribute("mensagem");
		sessao.removeAttribute("tipoMensagem");
	}
}
