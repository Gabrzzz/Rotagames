<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<div id="modalRuota" class="wheel-overlay">
    
    <div class="wheel-modal">
        
        <span class="wheel-close-btn" onclick="chiudiRuota()">&times;</span>
        
        <h2>Tenta la fortuna! 🎡</h2>
        <p>Gira la ruota una volta al giorno per vincere rotelline extra.</p>

        <div class="wheel-container">
            <div class="wheel-pointer"></div>
            
            <%-- Rimossa la pappardella del conic-gradient, ora è gestita nel CSS --%>
            <div id="ruota" class="wheel-graphics">
                <div class="spicchio" style="--i: 0;"><span>Niente</span></div>
                <div class="spicchio" style="--i: 1;"><span>5</span></div>
                <div class="spicchio" style="--i: 2;"><span>10</span></div>
                <div class="spicchio" style="--i: 3;"><span>20</span></div>
                <div class="spicchio" style="--i: 4;"><span>50</span></div>
                <div class="spicchio" style="--i: 5;"><span>Jackpot</span></div>
            </div>
        </div> 
        
        <button id="btn-gira" class="btn-spin">GIRA LA RUOTA!</button>
        
        <%-- Stile in linea rimosso, aggiunta la classe --%>
        <p id="messaggio-errore" class="wheel-error-msg"></p>
        
    </div> 
</div> 

<script src="${pageContext.request.contextPath}/js/ruota.js"></script>