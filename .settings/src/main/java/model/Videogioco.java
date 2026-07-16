package model;

public class Videogioco {
    private int idVideogioco;
    private String titolo;
    private String descrizione;
    private double prezzoBase;
    private int scontoAttivo;
    private String piattaforma;
    private String requisitiSistema;
    private String statoApprovazione;
    private Integer idSviluppatore;
    private byte[] copertina;
    private String base64Copertina;

    // Costruttore vuoto
    public Videogioco() {}

    public int getIdVideogioco() { return idVideogioco; }
    public void setIdVideogioco(int idVideogioco) { this.idVideogioco = idVideogioco; }

    public String getTitolo() { return titolo; }
    public void setTitolo(String titolo) { this.titolo = titolo; }

    public String getDescrizione() { return descrizione; }
    public void setDescrizione(String descrizione) { this.descrizione = descrizione; }

    public double getPrezzoBase() { return prezzoBase; }
    public void setPrezzoBase(double prezzoBase) { this.prezzoBase = prezzoBase; }

    public int getScontoAttivo() { return scontoAttivo; }
    public void setScontoAttivo(int scontoAttivo) { this.scontoAttivo = scontoAttivo; }

    public String getPiattaforma() { return piattaforma; }
    public void setPiattaforma(String piattaforma) { this.piattaforma = piattaforma; }

    public String getRequisitiSistema() { return requisitiSistema; }
    public void setRequisitiSistema(String requisitiSistema) { this.requisitiSistema = requisitiSistema; }

    public String getStatoApprovazione() { return statoApprovazione; }
    public void setStatoApprovazione(String statoApprovazione) { this.statoApprovazione = statoApprovazione; }

    public Integer getIdSviluppatore() { return idSviluppatore; }
    public void setIdSviluppatore(Integer idSviluppatore) { this.idSviluppatore = idSviluppatore; }

    // Metodo per calcolare il prezzo scontato
    public double getPrezzoFinale() {
        if (scontoAttivo > 0) {
            return prezzoBase - (prezzoBase * scontoAttivo / 100.0);
        }
        return prezzoBase;
    }
    
    public byte[] getCopertina() { return copertina; }
    public void setCopertina(byte[] copertina) { this.copertina = copertina; }

    public String getBase64Copertina() { return base64Copertina; }
    public void setBase64Copertina(String base64Copertina) { this.base64Copertina = base64Copertina;}
    
}