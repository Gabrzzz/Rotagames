package model;

public class ElementoCarrello {
    private Videogioco videogioco;
    private String piattaformaSelezionata;
    private int quantita;

    public ElementoCarrello() {}

    public ElementoCarrello(Videogioco videogioco, String piattaformaSelezionata, int quantita) {
        this.videogioco = videogioco;
        this.piattaformaSelezionata = piattaformaSelezionata;
        this.quantita = quantita;
    }

    public Videogioco getVideogioco() { return videogioco; }
    public void setVideogioco(Videogioco videogioco) { this.videogioco = videogioco; }

    public String getPiattaformaSelezionata() { return piattaformaSelezionata; }
    public void setPiattaformaSelezionata(String piattaformaSelezionata) { this.piattaformaSelezionata = piattaformaSelezionata; }

    public int getQuantita() { return quantita; }
    public void setQuantita(int quantita) { this.quantita = quantita; }
}