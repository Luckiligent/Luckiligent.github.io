(() => {
  const dialog = document.getElementById('life-gallery-dialog');
  if (!dialog) return;
  const image = document.getElementById('life-gallery-image');
  const title = document.getElementById('life-gallery-title');
  const count = document.getElementById('life-gallery-count');
  const previous = dialog.querySelector('[data-life-previous]');
  const next = dialog.querySelector('[data-life-next]');
  const close = dialog.querySelector('[data-life-close]');
  let activeImages = []; let index = 0; let trigger = null; let albumTitle = '';
  const render = () => { const item = activeImages[index]; image.src = item.src; image.alt = item.alt || albumTitle; title.textContent = item.caption || albumTitle; count.textContent = `${index + 1} / ${activeImages.length}`; previous.disabled = activeImages.length < 2; next.disabled = activeImages.length < 2; };
  const move = (delta) => { index = (index + delta + activeImages.length) % activeImages.length; render(); };
  document.querySelectorAll('[data-life-album]').forEach((card) => card.addEventListener('click', () => { activeImages = JSON.parse(card.dataset.lifeAlbum); if (!activeImages.length) return; trigger = card; albumTitle = card.dataset.lifeTitle; index = Number(card.dataset.lifeIndex || 0); render(); dialog.showModal(); }));
  previous.addEventListener('click', () => move(-1)); next.addEventListener('click', () => move(1)); close.addEventListener('click', () => dialog.close());
  dialog.addEventListener('close', () => { if (trigger) trigger.focus(); });
  dialog.addEventListener('keydown', (event) => { if (event.key === 'Escape') dialog.close(); if (event.key === 'ArrowLeft') move(-1); if (event.key === 'ArrowRight') move(1); });
})();
