package model;

import java.io.Serializable;

public class OggettoShop implements Serializable {
    private static final long serialVersionUID = 1L;

    private int idOggetto;
    private String nome;
    private String descrizione;
    private String tipo; // TITOLO, COUPON, AVATAR
    private String valore;
    private int costoRotelline;

    public OggettoShop() {}

    // Getter e Setter
    public int getIdOggetto() { return idOggetto; }
    public void setIdOggetto(int idOggetto) { this.idOggetto = idOggetto; }

    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }

    public String getDescrizione() { return descrizione; }
    public void setDescrizione(String descrizione) { this.descrizione = descrizione; }

    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }

    public String getValore() { return valore; }
    public void setValore(String valore) { this.valore = valore; }

    public int getCostoRotelline() { return costoRotelline; }
    public void setCostoRotelline(int costoRotelline) { this.costoRotelline = costoRotelline; }
}