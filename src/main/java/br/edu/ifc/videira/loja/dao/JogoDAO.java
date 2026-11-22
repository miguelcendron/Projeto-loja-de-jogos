package br.edu.ifc.videira.loja.dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import br.edu.ifc.videira.loja.model.Jogo;
import br.edu.ifc.videira.loja.model.Resumo;

public class JogoDAO {

	// CREATE
	public void inserir(Jogo j) throws SQLException {
		String sql = "INSERT INTO jogo (nome, plataforma, genero, preco, estoque, imagem, descricao) VALUES (?, ?, ?, ?, ?, ?, ?)";
		try (Connection c = Conexao.getConexao(); PreparedStatement ps = c.prepareStatement(sql)) {
			preencher(ps, j);
			ps.executeUpdate();
		}
	}

	// READ (lista com busca, filtro de plataforma e ordenação)
	public List<Jogo> listar(String busca, String plataforma, String ordem) throws SQLException {
		StringBuilder sql = new StringBuilder("SELECT * FROM jogo WHERE nome LIKE ?");
		boolean filtraPlataforma = plataforma != null && !plataforma.isBlank();
		if (filtraPlataforma) {
			sql.append(" AND plataforma = ?");
		}
		sql.append(" ORDER BY ").append(clausulaOrdem(ordem));

		List<Jogo> lista = new ArrayList<>();
		try (Connection c = Conexao.getConexao(); PreparedStatement ps = c.prepareStatement(sql.toString())) {
			ps.setString(1, "%" + (busca == null ? "" : busca) + "%");
			if (filtraPlataforma) {
				ps.setString(2, plataforma);
			}
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					lista.add(mapear(rs));
				}
			}
		}
		return lista;
	}

	// READ (um registro)
	public Jogo buscarPorId(int id) throws SQLException {
		String sql = "SELECT * FROM jogo WHERE id = ?";
		try (Connection c = Conexao.getConexao(); PreparedStatement ps = c.prepareStatement(sql)) {
			ps.setInt(1, id);
			try (ResultSet rs = ps.executeQuery()) {
				return rs.next() ? mapear(rs) : null;
			}
		}
	}

	// READ (números do painel)
	public Resumo resumo() throws SQLException {
		String sql = "SELECT COUNT(*) AS total, COALESCE(SUM(estoque), 0) AS unidades, "
				+ "COALESCE(SUM(preco * estoque), 0) AS valor, "
				+ "COALESCE(SUM(CASE WHEN estoque = 0 THEN 1 ELSE 0 END), 0) AS esgotados FROM jogo";
		try (Connection c = Conexao.getConexao();
				PreparedStatement ps = c.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {
			rs.next();
			BigDecimal valor = rs.getBigDecimal("valor");
			return new Resumo(rs.getInt("total"), rs.getInt("unidades"),
					valor == null ? BigDecimal.ZERO : valor, rs.getInt("esgotados"));
		}
	}

	// UPDATE
	public int atualizar(Jogo j) throws SQLException {
		String sql = "UPDATE jogo SET nome = ?, plataforma = ?, genero = ?, preco = ?, estoque = ?, imagem = ?, descricao = ? WHERE id = ?";
		try (Connection c = Conexao.getConexao(); PreparedStatement ps = c.prepareStatement(sql)) {
			preencher(ps, j);
			ps.setInt(8, j.getId());
			return ps.executeUpdate();
		}
	}

	// DELETE
	public int excluir(int id) throws SQLException {
		String sql = "DELETE FROM jogo WHERE id = ?";
		try (Connection c = Conexao.getConexao(); PreparedStatement ps = c.prepareStatement(sql)) {
			ps.setInt(1, id);
			return ps.executeUpdate();
		}
	}

	// Só aceita valores conhecidos, para nunca montar SQL com texto vindo do usuário.
	private String clausulaOrdem(String ordem) {
		if (ordem == null) {
			return "nome";
		}
		switch (ordem) {
		case "preco_asc":
			return "preco ASC, nome";
		case "preco_desc":
			return "preco DESC, nome";
		case "estoque":
			return "estoque DESC, nome";
		case "recentes":
			return "id DESC";
		default:
			return "nome";
		}
	}

	private void preencher(PreparedStatement ps, Jogo j) throws SQLException {
		ps.setString(1, j.getNome());
		ps.setString(2, j.getPlataforma());
		ps.setString(3, j.getGenero());
		ps.setBigDecimal(4, j.getPreco());
		ps.setInt(5, j.getEstoque());
		ps.setString(6, j.getImagem());
		ps.setString(7, j.getDescricao());
	}

	private Jogo mapear(ResultSet rs) throws SQLException {
		Jogo j = new Jogo();
		j.setId(rs.getInt("id"));
		j.setNome(rs.getString("nome"));
		j.setPlataforma(rs.getString("plataforma"));
		j.setGenero(rs.getString("genero"));
		j.setPreco(rs.getBigDecimal("preco"));
		j.setEstoque(rs.getInt("estoque"));
		j.setImagem(rs.getString("imagem"));
		j.setDescricao(rs.getString("descricao"));
		j.setDataCadastro(rs.getTimestamp("data_cadastro"));
		return j;
	}
}
