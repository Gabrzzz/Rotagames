package model;

import java.sql.Timestamp;

public class Ordine {
	private int idOrdine;
    private double totaleOrdine;
    private String urlFattura;
    private Timestamp dataOrdine;
    private int idUtente;
    private String emailUtente;
    private String nicknameUtente;
    
    public Ordine() {}

    public int getIdOrdine() { return idOrdine; }
    public void setIdOrdine(int idOrdine) { this.idOrdine = idOrdine; }

    public Timestamp getDataOrdine() { return dataOrdine; }
    public void setDataOrdine(Timestamp dataOrdine) { this.dataOrdine = dataOrdine; }

    public double getTotaleOrdine() { return totaleOrdine; }
    public void setTotaleOrdine(double totaleOrdine) { this.totaleOrdine = totaleOrdine; }

    public int getIdUtente() { return idUtente; }
    public void setIdUtente(int idUtente) { this.idUtente = idUtente; }

    public String getUrlFattura() { return urlFattura; }
    public void setUrlFattura(String urlFattura) { this.urlFattura = urlFattura; }
    
    public String getNicknameUtente() { return nicknameUtente; }
    public void setNicknameUtente(String nicknameUtente) { this.nicknameUtente = nicknameUtente; }
    
    public String getEmailUtente() { return emailUtente; }
    public void setEmailUtente(String emailUtente) { this.emailUtente = emailUtente; }
}