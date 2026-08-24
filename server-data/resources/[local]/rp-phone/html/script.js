const phone = document.getElementById('phone');
const cashAmount = document.getElementById('cash-amount');
const bankAmount = document.getElementById('bank-amount');
const messagesList = document.getElementById('messages-list');
const messageForm = document.getElementById('message-form');
const targetIdInput = document.getElementById('target-id');
const messageTextInput = document.getElementById('message-text');
const notesArea = document.getElementById('notes-area');
const closeBtn = document.getElementById('close-btn');

const NOTES_STORAGE_KEY = 'rp-phone-notes';

function postNui(name, data) {
    return fetch(`https://${GetParentResourceName()}/${name}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
        body: JSON.stringify(data || {}),
    });
}

function formatMoney(amount) {
    return '$' + Math.floor(amount || 0).toLocaleString('fr-FR');
}

function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

function switchTab(tabName) {
    document.querySelectorAll('.tab-btn').forEach((btn) => {
        btn.classList.toggle('active', btn.dataset.tab === tabName);
    });
    document.querySelectorAll('.tab-content').forEach((content) => {
        content.classList.toggle('active', content.id === 'tab-' + tabName);
    });
}

document.querySelectorAll('.tab-btn').forEach((btn) => {
    btn.addEventListener('click', () => switchTab(btn.dataset.tab));
});

closeBtn.addEventListener('click', () => {
    phone.classList.add('hidden');
    postNui('close');
});

document.addEventListener('keydown', (event) => {
    if (event.key === 'Escape' && !phone.classList.contains('hidden')) {
        phone.classList.add('hidden');
        postNui('close');
    }
});

messageForm.addEventListener('submit', (event) => {
    event.preventDefault();
    const targetId = targetIdInput.value;
    const text = messageTextInput.value.trim();
    if (!targetId || !text) {
        return;
    }
    postNui('sendMessage', { targetId, text });
    messageTextInput.value = '';
});

function addMessage(direction, name, id, text) {
    const bubble = document.createElement('div');
    bubble.className = 'message-bubble ' + direction;

    const meta = document.createElement('span');
    meta.className = 'message-meta';
    meta.textContent = direction === 'in'
        ? `De ${name} (#${id})`
        : `À ${name} (#${id})`;

    const body = document.createElement('span');
    body.textContent = text;

    bubble.appendChild(meta);
    bubble.appendChild(document.createElement('br'));
    bubble.appendChild(body);
    messagesList.appendChild(bubble);
    messagesList.scrollTop = messagesList.scrollHeight;
}

function loadNotes() {
    try {
        notesArea.value = localStorage.getItem(NOTES_STORAGE_KEY) || '';
    } catch (e) {
        notesArea.value = '';
    }
}

notesArea.addEventListener('input', () => {
    try {
        localStorage.setItem(NOTES_STORAGE_KEY, notesArea.value);
    } catch (e) {
        // stockage indisponible (navigation privée, etc.) : tant pis, pas bloquant.
    }
});

window.addEventListener('message', (event) => {
    const data = event.data;
    if (!data || !data.action) {
        return;
    }

    if (data.action === 'open') {
        phone.classList.remove('hidden');
        loadNotes();
    } else if (data.action === 'close') {
        phone.classList.add('hidden');
    } else if (data.action === 'bankUpdate') {
        cashAmount.textContent = formatMoney(data.cash);
        bankAmount.textContent = formatMoney(data.bank);
    } else if (data.action === 'message') {
        addMessage(data.direction, escapeHtml(data.name), data.id, escapeHtml(data.text));
    }
});
