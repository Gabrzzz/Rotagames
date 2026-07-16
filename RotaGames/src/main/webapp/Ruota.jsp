<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<div id="modalRuota" class="wheel-overlay">
    
    <div class="wheel-modal">
        
        <span class="wheel-close-btn" onclick="chiudiRuota()">&times;</span>
        
        <h2>Tenta la fortuna! 🎡</h2>
        <p>Gira la ruota una volta al giorno per vincere rotelline extra.</p>

        <div class="wheel-container">
            <div class="wheel-pointer"></div>
            
            <div id="ruota" class="wheel-graphics" style="background: conic-gradient(
                #00E5FF 0deg 60deg,   
                #0088CC 60deg 120deg, 
                #04142C 120deg 180deg,
                #00E5FF 180deg 240deg, 
                #0088CC 240deg 300deg, 
                #04142C 300deg 360deg
            );"></div>
        </div>

        <button id="btn-gira" class="btn-spin">GIRA LA RUOTA!</button>
        
        <p id="messaggio-errore" style="color: #E63946; display: none; margin-top: 15px; font-weight: bold;"></p>
    </div>
    
</div>

<script src="${pageContext.request.contextPath}/js/ruota.js"></script>