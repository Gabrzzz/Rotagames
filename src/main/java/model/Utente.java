package model;

import java.util.Date;

public class Utente {

    private int idUtente;
    private String email;
    private String nome;
    private String cognome;
    
    // Indirizzo di fatturazione
    private String via;
    private String cap;
    private String citta;
    
    // Dati di accesso e profilo
    private String ruolo; // sviluppatore, admin oppure utente
    private String nickname;
    private String passwordHash;
    private int saldoRotelline;
    private Date dataUltimoGiroRuota;
    private String generePreferito;
    private String nomeStudioSviluppo; // Attributo specifico per gli sviluppatori
    
    // Dati per il questionario
    private String badgePersonalita;
    
    // Dati per il negozio
    private String avatarAttivo;
    private String titoloAttivo;
    
    // Costruttore vuoto
    public Utente() {
    }

    // Costruttore completo
    public Utente(int idUtente, String email, String nome, String cognome, String via, String cap,
            String citta, String ruolo, String nickname, String passwordHash, int saldoRotelline,
            Date dataUltimoGiroRuota, String generePreferito, String nomeStudioSviluppo) {
        this.idUtente = idUtente;
        this.email = email;
        this.nome = nome;
        this.cognome = cognome;
        this.via = via;
        this.cap = cap;
        this.citta = citta;
        this.ruolo = ruolo;
        this.nickname = nickname;
        this.passwordHash = passwordHash;
        this.saldoRotelline = saldoRotelline;
        this.dataUltimoGiroRuota = dataUltimoGiroRuota;
        this.generePreferito = generePreferito;
        this.nomeStudioSviluppo = nomeStudioSviluppo;
    }

    public int getIdUtente() {
        return idUtente;
    }

    public void setIdUtente(int idUtente) {
        this.idUtente = idUtente;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getCognome() {
        return cognome;
    }

    public void setCognome(String cognome) {
        this.cognome = cognome;
    }

    public String getVia() {
        return via;
    }

    public void setVia(String via) {
        this.via = via;
    }

    public String getCap() {
        return cap;
    }

    public void setCap(String cap) {
        this.cap = cap;
    }

    public String getCitta() {
        return citta;
    }

    public void setCitta(String citta) {
        this.citta = citta;
    }

    public String getRuolo() {
        return ruolo;
    }

    public void setRuolo(String ruolo) {
        this.ruolo = ruolo;
    }

    public String getNickname() {
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public int getSaldoRotelline() {
        return saldoRotelline;
    }

    public void setSaldoRotelline(int saldoRotelline) {
        this.saldoRotelline = saldoRotelline;
    }

    public Date getDataUltimoGiroRuota() {
        return dataUltimoGiroRuota;
    }

    public void setDataUltimoGiroRuota(Date dataUltimoGiroRuota) {
        this.dataUltimoGiroRuota = dataUltimoGiroRuota;
    }

    public String getGenerePreferito() {
        return generePreferito;
    }

    public void setGenerePreferito(String generePreferito) {
        this.generePreferito = generePreferito;
    }

    public String getNomeStudioSviluppo() {
        return nomeStudioSviluppo;
    }

    public void setNomeStudioSviluppo(String nomeStudioSviluppo) {
        this.nomeStudioSviluppo = nomeStudioSviluppo;
    }

    @Override
    public String toString() {
        return "Utente [idUtente=" + idUtente + ", email=" + email + ", nickname=" + nickname + ", ruolo=" + ruolo + "]";
    }
    
    public String getBadgePersonalita() { return badgePersonalita; }
    public void setBadgePersonalita(String badgePersonalita) { this.badgePersonalita = badgePersonalita; }
    
    //getter e setter negozio
    public String getAvatarAttivo() { return avatarAttivo; }
    public void setAvatarAttivo(String avatarAttivo) { this.avatarAttivo = avatarAttivo; }

    public String getTitoloAttivo() { return titoloAttivo; }
    public void setTitoloAttivo(String titoloAttivo) { this.titoloAttivo = titoloAttivo; }
}