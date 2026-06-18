const pageScript = document.createElement('script');
pageScript.textContent = `
(function() {
  const SUFFIX = ' - Qobuz Web Player';
  let lastTrack = null;

  function parseTitle() {
    const t = document.title;
    if (!t.endsWith(SUFFIX)) return null;
    const s = t.slice(0, -SUFFIX.length);
    const i = s.lastIndexOf(' - ');
    if (i === -1) return null;
    return { title: s.slice(0, i), artist: s.slice(i + 3) };
  }

  function clickPlayPause() {
    document.dispatchEvent(new KeyboardEvent('keydown', { key: ' ', code: 'Space', keyCode: 32, bubbles: true, cancelable: true }));
  }

  function update() {
    const parsed = parseTitle();
    const track = parsed || lastTrack;
    if (!track) return;

    if (parsed) lastTrack = parsed;

    navigator.mediaSession.metadata = new MediaMetadata({
      title: track.title,
      artist: track.artist,
      album: parsed ? 'playing' : 'paused',
    });
    navigator.mediaSession.playbackState = parsed ? 'playing' : 'paused';
    navigator.mediaSession.setActionHandler('play', clickPlayPause);
    navigator.mediaSession.setActionHandler('pause', clickPlayPause);
  }

  new MutationObserver(update).observe(
    document.querySelector('title'),
    { childList: true, characterData: true, subtree: true }
  );
  update();
})();
`;
document.documentElement.appendChild(pageScript);
pageScript.remove();
