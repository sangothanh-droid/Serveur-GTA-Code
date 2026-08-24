const TIPS = [
    "Respect entre joueurs : pas d'insultes ni de discrimination.",
    'Roleplay réaliste obligatoire : RDM et VDM sont interdits.',
    'Pas de méta-gaming ni de power-gaming.',
    "Aucune triche, exploit ou script tiers ne sera toléré.",
    'Le staff a le dernier mot en cas de litige.',
    "Astuce : tapez /streetrep pour connaître votre réputation de rue, ou tentez votre chance au Diamond Casino !",
];

const TIP_ROTATION_MS = 5000;
const TIP_FADE_MS = 400;

const progressFill = document.getElementById('progress-fill');
const progressLabel = document.getElementById('progress-label');
const tipText = document.getElementById('tip-text');

let tipIndex = 0;

function showTip(index) {
    tipText.textContent = TIPS[index];
}

function rotateTips() {
    tipText.classList.add('fade');
    setTimeout(() => {
        tipIndex = (tipIndex + 1) % TIPS.length;
        showTip(tipIndex);
        tipText.classList.remove('fade');
    }, TIP_FADE_MS);
}

showTip(tipIndex);
setInterval(rotateTips, TIP_ROTATION_MS);

window.addEventListener('message', (event) => {
    const data = event.data;
    if (!data || !data.eventName) {
        return;
    }

    if (data.eventName === 'loadProgress') {
        const percent = Math.round((data.loadFraction || 0) * 100);
        progressFill.style.width = percent + '%';
        progressLabel.textContent = 'Connexion en cours... ' + percent + '%';
    } else if (data.eventName === 'onLogLine' && data.message) {
        progressLabel.textContent = data.message;
    }
});
