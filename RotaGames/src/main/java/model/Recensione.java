package model;

import java.sql.Timestamp;

public class Recensione {
    private int idRecensione;
    private int idVideogioco;
    private String nicknameUtente;
    private int voto; // il voto va da 1 a 5
    private String testo;
    private Timestamp dataCreazione;

    public Recensione() {}

    public int getIdRecensione() { return idRecensione; }
    public void setIdRecensione(int idRecensione) { this.idRecensione = idRecensione; }

    public int getIdVideogioco() { return idVideogioco; }
    public void setIdVideogioco(int idVideogioco) { this.idVideogioco = idVideogioco; }

    public String getNicknameUtente() { return nicknameUtente; }
    public void setNicknameUtente(String nicknameUtente) { this.nicknameUtente = nicknameUtente; }

    public int getVoto() { return voto; }
    public void setVoto(int voto) { this.voto = voto; }

    public String getTesto() { return testo; }
    public void setTesto(String testo) { this.testo = testo; }

    public Timestamp getDataCreazione() { return dataCreazione; }
    public void setDataCreazione(Timestamp dataCreazione) { this.dataCreazione = dataCreazione; }
}