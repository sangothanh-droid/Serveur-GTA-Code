window.addEventListener('message', (event) => {
  const data = event.data;
  if (data.action === 'show') {
    document.getElementById('rules-text').innerText = data.rules;
    document.getElementById('rules-container').classList.remove('hidden');
  }
});

document.getElementById('accept-btn').addEventListener('click', () => {
  fetch(`https://${window.location.hostname}/acceptRules`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json; charset=UTF-8' },
    body: JSON.stringify({}),
  });
  document.getElementById('rules-container').classList.add('hidden');
});
