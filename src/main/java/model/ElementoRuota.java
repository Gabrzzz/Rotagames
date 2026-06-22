package model;

import java.io.Serializable;

public class ElementoRuota implements Serializable {
    private static final long serialVersionUID = 1L;

	int idElemento;
	String nomePremio;
	double prob;
	int valorePremio;
	
	public ElementoRuota() {}
	
	 public int getIdElemento() { return idElemento; }
	    public void setIdElemento(int idElemento) { this.idElemento = idElemento; }
	
	    public String getNomePremio() { return nomePremio; }
	    public void setNomePremio(String nomePremio) { this.nomePremio = nomePremio; }
	    
	    public double getProb() { return prob; }
	    public void setProb(double prob) { this.prob = prob; } 
	    
	    public int getValorePremio() { return valorePremio; }
	    public void setValorePremio(int valorePremio) { this.valorePremio = valorePremio; } 
	     
}
