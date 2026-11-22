package br.edu.ifc.videira.loja.dao;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * Abre conexões JDBC. Os dados de acesso ficam em src/main/resources/db.properties,
 * então não é preciso mexer no código para trocar usuário, senha ou banco.
 */
public class Conexao {

	private static final String URL_PADRAO = "jdbc:mysql://localhost:3306/portfolio?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
	private static final Properties CONFIG = new Properties();

	static {
		try (InputStream in = Conexao.class.getClassLoader().getResourceAsStream("db.properties")) {
			if (in != null) {
				CONFIG.load(in);
			}
		} catch (IOException e) {
			// sem o arquivo, valem os valores padrão (XAMPP)
		}
	}

	public static Connection getConexao() throws SQLException {
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			throw new SQLException("Driver do MySQL não encontrado", e);
		}
		return DriverManager.getConnection(
				CONFIG.getProperty("db.url", URL_PADRAO),
				CONFIG.getProperty("db.usuario", "root"),
				CONFIG.getProperty("db.senha", ""));
	}
}
