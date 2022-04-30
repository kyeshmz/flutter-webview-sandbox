import "./style.css";

const app = document.querySelector<HTMLDivElement>("#app")!;

app.innerHTML = `
  <h1>${document.cookie}</h1>
  <a href="https://vitejs.dev/guide/features.html" target="_blank">Documentation</a>
  <button id="button">Cookie send button</button>
`;

const button = document.querySelector<HTMLButtonElement>("#button")!;

button.onclick = () => {
	console.log("sending to webview");
	window.Flutter.postMessage();
};
