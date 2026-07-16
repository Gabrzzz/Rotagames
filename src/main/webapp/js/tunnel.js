
const canvas = document.getElementById('tunnelCanvas');
const ctx = canvas.getContext('2d');

let width = canvas.width = window.innerWidth;
let height = canvas.height = window.innerHeight;

// Gestione del ridimensionamento della finestra del browser
window.addEventListener('resize', () => {
    width = canvas.width = window.innerWidth;
    height = canvas.height = window.innerHeight;
});

let tick = 0;
let colorTick = 0; // Gestisce il cambiamento lento del colore

const RAGGI = 48;
const ANELLI = 30;

// Velocità di cambiamento del colore base (più basso = più lento)
const VELOCITA_COLORE = 0.001; 

function draw() {
    // Effetto scia (motion blur) mantenendo lo sfondo scuro
    ctx.fillStyle = 'rgba(0, 0, 0, 0.1)'; 
    ctx.fillRect(0, 0, width, height);

    const centerX = width / 2;
    const centerY = height / 2;
    const maxRadius = Math.max(width, height);

    tick += 0.015; // Velocità di movimento del tunnel
    colorTick += VELOCITA_COLORE; // Avanzamento del colore

    // Calcolo del colore globale lento (valore da 0 a 360)
    const baseHue = (colorTick % 1) * 360;

    for (let i = 1; i < ANELLI; i++) {
        const r = Math.pow(i / ANELLI, 2) * maxRadius * 0.8;
        const rSuccessivo = Math.pow((i + 1) / ANELLI, 2) * maxRadius * 0.8;
        
        const pulse = Math.sin(i * 0.2 - tick * 1.5) * 4;
        const rCorretto = r + pulse;
        const rSuccCorretto = rSuccessivo + pulse;

        for (let j = 0; j < RAGGI; j++) {
            const angolo1 = (j / RAGGI) * Math.PI * 2 + (tick * 0.05) * (i * 0.02);
            const angolo2 = ((j + 1) / RAGGI) * Math.PI * 2 + (tick * 0.05) * (i * 0.02);

            const x1 = centerX + Math.cos(angolo1) * rCorretto;
            const y1 = centerY + Math.sin(angolo1) * rCorretto;
            const x2 = centerX + Math.cos(angolo2) * rCorretto;
            const y2 = centerY + Math.sin(angolo2) * rCorretto;
            
            const x3 = centerX + Math.cos(angolo2) * rSuccCorretto;
            const y3 = centerY + Math.sin(angolo2) * rSuccCorretto;
            const x4 = centerX + Math.cos(angolo1) * rSuccCorretto;
            const y4 = centerY + Math.sin(angolo1) * rSuccCorretto;

            // Tonalità del tassello legata al tempo lento
            const hueVariabile = (baseHue + (j / RAGGI * 60) + (i * 2)) % 360; 
            
            // Luminosità bassa per non sparare negli occhi (mantiene l'effetto opaco)
            const lightnessBase = (j % 2 === 0) ? 25 : 10; 
            
            ctx.beginPath();
            ctx.moveTo(x1, y1);
            ctx.lineTo(x2, y2);
            ctx.lineTo(x3, y3);
            ctx.lineTo(x4, y4);
            ctx.closePath();

            // Colore del tassello
            ctx.fillStyle = `hsl(${hueVariabile}, 70%, ${lightnessBase}%)`;
            ctx.fill();
            
            // Bordo scuro e sottile per dare definizione geometrica
            ctx.strokeStyle = `hsl(${(hueVariabile + 180) % 360}, 60%, 15%)`; 
            ctx.lineWidth = 0.3;
            ctx.stroke();
        }
    }

    // Loop continuo dell'animazione
    requestAnimationFrame(draw);
}

// Avvio immediato
draw();