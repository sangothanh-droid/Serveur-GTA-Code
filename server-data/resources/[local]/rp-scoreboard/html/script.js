const scoreboard = document.getElementById('scoreboard');
const countLabel = document.getElementById('scoreboard-count');
const body = document.getElementById('scoreboard-body');

function pingClass(ping) {
    if (ping <= 80) return 'ping-good';
    if (ping <= 150) return 'ping-medium';
    return 'ping-bad';
}

function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

function renderPlayers(players, maxSlots) {
    countLabel.textContent = players.length + ' / ' + maxSlots + ' joueurs connectés';

    body.innerHTML = players.map((player) => (
        '<tr>' +
            '<td>' + escapeHtml(player.name) + '</td>' +
            '<td>' + player.id + '</td>' +
            '<td class="' + pingClass(player.ping) + '">' + player.ping + ' ms</td>' +
        '</tr>'
    )).join('');
}

window.addEventListener('message', (event) => {
    const data = event.data;
    if (!data || !data.action) {
        return;
    }

    if (data.action === 'show') {
        scoreboard.classList.remove('hidden');
    } else if (data.action === 'hide') {
        scoreboard.classList.add('hidden');
    } else if (data.action === 'update') {
        renderPlayers(data.players || [], data.maxSlots || 0);
    }
});
