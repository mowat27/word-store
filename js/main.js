function dragstart_handler(ev) {
  ev.dataTransfer.setData("text/plain", ev.target.textContent);
}
