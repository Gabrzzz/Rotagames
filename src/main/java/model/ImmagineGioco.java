package model;

public class ImmagineGioco {
    private int idImmagine;
    private int idVideogioco;
    private String base64Immagine;

    public int getIdImmagine() { return idImmagine; }
    public void setIdImmagine(int idImmagine) { this.idImmagine = idImmagine; }

    public int getIdVideogioco() { return idVideogioco; }
    public void setIdVideogioco(int idVideogioco) { this.idVideogioco = idVideogioco; }

    public String getBase64Immagine() { return base64Immagine; }
    public void setBase64Immagine(String base64Immagine) { this.base64Immagine = base64Immagine; }
}