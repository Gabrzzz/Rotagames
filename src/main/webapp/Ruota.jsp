<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<div id="modalRuota" class="wheel-overlay">
    
    <div class="wheel-modal">
        
        <span class="wheel-close-btn" onclick="chiudiRuota()">&times;</span>
        
        <h2>Tenta la fortuna! 🎡</h2>
        <p>Gira la ruota una volta al giorno per vincere rotelline extra.</p>

        <div class="wheel-container">
            <div class="wheel-pointer"></div>
            
            <div id="ruota" class="wheel-graphics" style="background: conic-gradient(
                #00E5FF 0deg 60deg,   /* Spicchio 0: Niente */
                #04142C 60deg 120deg, /* Spicchio 1: 5 Rotelline */
                #0088CC 120deg 180deg,/* Spicchio 2: 10 Rotelline */
                #00E5FF 180deg 240deg,/* Spicchio 3: 20 Rotelline */
                #04142C 240deg 300deg,/* Spicchio 4: 50 Rotelline */
                #0088CC 300deg 360deg /* Spicchio 5: Jackpot */
            );">
                <div class="spicchio" style="--i: 0;"><span>Niente</span></div>
                <div class="spicchio" style="--i: 1;"><span>5</span></div>
                <div class="spicchio" style="--i: 2;"><span>10</span></div>
                <div class="spicchio" style="--i: 3;"><span>20</span></div>
                <div class="spicchio" style="--i: 4;"><span>50</span></div>
                <div class="spicchio" style="--i: 5;"><span>Jackpot</span></div>
            </div> </div> <button id="btn-gira" class="btn-spin">GIRA LA RUOTA!</button>
        
        <p id="messaggio-errore" style="color: #E63946; display: none; margin-top: 15px; font-weight: bold;"></p>
        
    </div> </div> <script src="${pageContext.request.contextPath}/js/ruota.js"></script>