package model;
import java.io.Serializable;

public class Libreria implements Serializable {
    private static final long serialVersionUID = 1L; //Versione

    //Variabili d'istanza corrispondenti agli attributi dell'ER
    private int idUtente;
    private int idVideogioco;
    private String statoAvanzamento;
    private String productKeyPosseduta;

    private Videogioco videogioco;
    
    public Libreria() {
    }

    //Getter e Setter per ogni attributo
    public int getIdUtente() {
        return idUtente;
    }

    public void setIdUtente(int idUtente) {
        this.idUtente = idUtente;
    }

    public int getIdVideogioco() {
        return idVideogioco;
    }

    public void setIdVideogioco(int idVideogioco) {
        this.idVideogioco = idVideogioco;
    }

    public String getStatoAvanzamento() {
        return statoAvanzamento;
    }

    public void setStatoAvanzamento(String statoAvanzamento) {
        this.statoAvanzamento = statoAvanzamento;
    }

    public String getProductKeyPosseduta() {
        return productKeyPosseduta;
    }

    public void setProductKeyPosseduta(String productKeyPosseduta) {
        this.productKeyPosseduta = productKeyPosseduta;
    }
    
    public Videogioco getVideogioco() {
        return videogioco;
    }

    public void setVideogioco(Videogioco videogioco) {
        this.videogioco = videogioco;
    }
}