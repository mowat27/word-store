function dragstart_handler(ev) {
  ev.dataTransfer.setData("text/plain", ev.target.dataset.text);
}

function markLastSelected(el, color) {
  var elements = document.querySelectorAll(".icon.copy > svg");
  for(var i=0; i < elements.length; i++) {
    elements[i].style.fill = "";
  }
  el.style.fill = color;
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
      markLastSelected(ev.target, "#ccffcc")
      console.log('Copied ' + cntr.dataset.text);
    } catch (err) {
      console.log('Oops, unable to copy');
    }
    cntr.removeChild(textArea);
  }
}

function clearSelection()
{
  if (window.getSelection) {
    window.getSelection().removeAllRanges();
  } else if (document.selection) {
    document.selection.empty();
  }
}

function copyCli(ev) {
  var cntr = ev.target.parentElement.parentElement
  var textArea = cntr.querySelector("textarea.cli");

  if(textArea) {
    textArea.select();
    document.execCommand("copy");
    clearSelection();
    markLastSelected(cntr.querySelector("span.icon > svg"), "#ccffcc");
    console.log('Copied ' + textArea.value);
  }
}
