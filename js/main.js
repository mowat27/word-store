function dragstart_handler(ev) {
  ev.dataTransfer.setData("text/plain", ev.target.dataset.text);
}

function copyText(ev) {
  var cntr = ev.target.parentElement
  if(cntr.dataset.text) {
    textArea = document.createElement("textarea");
    textArea.value = cntr.dataset.text;
    cntr.appendChild(textArea);
    textArea.select();
    try {
      document.execCommand("copy");
      console.log('Copied ' + cntr.dataset.text);
    } catch (err) {
      console.log('Oops, unable to copy');
    }
    cntr.removeChild(textArea);
  }
}
