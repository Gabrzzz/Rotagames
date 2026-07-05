package controller;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.itextpdf.kernel.geom.PageSize;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.element.Cell;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.element.Table;
import com.itextpdf.layout.properties.TextAlignment;
import com.itextpdf.layout.properties.UnitValue;

import util.DBConnection;

@WebServlet("/FatturaServlet")
public class FatturaServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendRedirect("index.jsp");
            return;
        }
        
        int idOrdine = Integer.parseInt(idStr);

        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        PdfWriter writer = new PdfWriter(baos);
        PdfDocument pdf = new PdfDocument(writer);
        Document document = new Document(pdf, PageSize.A4);
        document.setMargins(36, 36, 36, 36);

        try (Connection con = DBConnection.getConnection()) {
            
            // 1. Estrazione Dati Cliente e Ordine
            String queryCliente = "SELECT o.data_acquisto, u.nome, u.cognome, u.email " +
                                  "FROM ordine o JOIN utente u ON o.id_utente = u.id_utente WHERE o.id_ordine = ?";
            PreparedStatement psCliente = con.prepareStatement(queryCliente);
            psCliente.setInt(1, idOrdine);
            ResultSet rsCliente = psCliente.executeQuery();

            if (rsCliente.next()) {
                // Intestazione Venditore
                document.add(new Paragraph("FATTURA ORDINE N. " + idOrdine).setBold().setFontSize(18));
                document.add(new Paragraph("RotaGames Store\nVia Roma 1, Salerno\nP.IVA: 01234567890\n"));
                
                // Intestazione Cliente
                document.add(new Paragraph("Fatturato a:").setBold());
                document.add(new Paragraph(rsCliente.getString("nome") + " " + rsCliente.getString("cognome")));
                document.add(new Paragraph(rsCliente.getString("email")));
                document.add(new Paragraph("Data Acquisto: " + rsCliente.getTimestamp("data_acquisto") + "\n"));
            }

            // 2. Creazione della Tabella con lo scorporo dell'IVA
            document.add(new Paragraph("Dettaglio Prodotti").setBold().setMarginTop(15).setMarginBottom(10));
            Table productTable = new Table(UnitValue.createPercentArray(new float[]{2, 5, 2, 2, 2}))
                    .useAllAvailableWidth();
            
            productTable.addHeaderCell(new Cell().add(new Paragraph("ID").setBold()));
            productTable.addHeaderCell(new Cell().add(new Paragraph("Prodotto").setBold()));
            productTable.addHeaderCell(new Cell().add(new Paragraph("Netto").setBold()));
            productTable.addHeaderCell(new Cell().add(new Paragraph("IVA (22%)").setBold()));
            productTable.addHeaderCell(new Cell().add(new Paragraph("Totale").setBold()));

            double totaleNettoComplessivo = 0;
            double totaleIvaComplessiva = 0;
            double totaleLordoComplessivo = 0;

            // 3. Estrazione dei giochi acquistati
            String queryGiochi = "SELECT v.id_videogioco, v.titolo, c.prezzo_acquisto FROM composizione c " +
                                 "JOIN videogioco v ON c.id_videogioco = v.id_videogioco WHERE c.id_ordine = ?";
            PreparedStatement psGiochi = con.prepareStatement(queryGiochi);
            psGiochi.setInt(1, idOrdine);
            ResultSet rs = psGiochi.executeQuery();

            while (rs.next()) {
                int idProdotto = rs.getInt("id_videogioco");
                String nome = rs.getString("titolo");
                
                //Calcolo iva
                double prezzoLordo = rs.getDouble("prezzo_acquisto"); // Quello pagato dall'utente
                double prezzoNetto = prezzoLordo / 1.22;              // Togliamo il 22%
                double iva = prezzoLordo - prezzoNetto;               // La differenza è l'IVA
                
                totaleLordoComplessivo += prezzoLordo;
                totaleNettoComplessivo += prezzoNetto;
                totaleIvaComplessiva += iva;

                // Riempimento celle
                productTable.addCell(new Cell().add(new Paragraph(String.valueOf(idProdotto))).setTextAlignment(TextAlignment.CENTER));
                productTable.addCell(new Cell().add(new Paragraph(nome)).setTextAlignment(TextAlignment.LEFT));
                productTable.addCell(new Cell().add(new Paragraph(String.format("€ %.2f", prezzoNetto))).setTextAlignment(TextAlignment.RIGHT));
                productTable.addCell(new Cell().add(new Paragraph(String.format("€ %.2f", iva))).setTextAlignment(TextAlignment.RIGHT));
                productTable.addCell(new Cell().add(new Paragraph(String.format("€ %.2f", prezzoLordo))).setTextAlignment(TextAlignment.RIGHT));
            }
            
            document.add(productTable);
            
            // 4. Riepilogo Finale
            document.add(new Paragraph("\nTotale Imponibile (Netto): € " + String.format("%.2f", totaleNettoComplessivo)).setTextAlignment(TextAlignment.RIGHT));
            document.add(new Paragraph("Totale IVA (22%): € " + String.format("%.2f", totaleIvaComplessiva)).setTextAlignment(TextAlignment.RIGHT));
            document.add(new Paragraph("TOTALE PAGATO: € " + String.format("%.2f", totaleLordoComplessivo))
                    .setBold().setFontSize(14).setTextAlignment(TextAlignment.RIGHT));

        } catch (Exception e) {
            e.printStackTrace();
            document.add(new Paragraph("Errore durante l'estrazione dei dati della fattura."));
        }

        document.close();

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "inline; filename=Fattura_RotaGames_" + idOrdine + ".pdf");
        response.setContentLength(baos.size());
        response.getOutputStream().write(baos.toByteArray());
        response.getOutputStream().flush();
    }
}