package br.edu.ifc.videira.loja.model;

import java.math.BigDecimal;

/** Números mostrados no painel do topo da página. */
public class Resumo {

	private final int totalJogos;
	private final int totalEstoque;
	private final BigDecimal valorEstoque;
	private final int esgotados;

	public Resumo(int totalJogos, int totalEstoque, BigDecimal valorEstoque, int esgotados) {
		this.totalJogos = totalJogos;
		this.totalEstoque = totalEstoque;
		this.valorEstoque = valorEstoque;
		this.esgotados = esgotados;
	}

	public int getTotalJogos() {
		return totalJogos;
	}

	public int getTotalEstoque() {
		return totalEstoque;
	}

	public BigDecimal getValorEstoque() {
		return valorEstoque;
	}

	public int getEsgotados() {
		return esgotados;
	}
}
