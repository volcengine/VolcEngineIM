export function download(link: string, filename?: string) {
  if (!link) {
    console.log('missing src');
    return;
  }

  let img = new Image();
  img.setAttribute('crossOrigin', 'Anonymous');

  img.onload = function() {
    let canvas = document.createElement('canvas');
    let context = canvas.getContext('2d');
    canvas.width = img.width;
    canvas.height = img.height;
    context.drawImage(img, 0, 0, img.width, img.height);
    let url = canvas.toDataURL('images/png');
    let a = document.createElement('a');
    let event = new MouseEvent('click');
    a.download = filename || 'default.png';
    a.href = url;
    a.dispatchEvent(event);
  };
  img.src = link + '?v=' + Date.now();
}
