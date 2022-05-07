import { useState } from "react";
import logo from "./logo.svg";
import "./App.css";
import { Link } from "react-router-dom";
import listCookies from "./utils";

function App() {
	return (
		<div className="App">
			<header className="App-header">
				<img src={logo} className="App-logo" alt="logo" />
				<h1> Other Page</h1>
				<p style={{ maxWidth: "70vw", wordWrap: "break-word" }}>
					{listCookies()}
				</p>

				<p>
					Edit <code>App.tsx</code> and save to test HMR updates.
				</p>
				<p>
					<Link to="/">Go to HomePage</Link>
				</p>
			</header>
		</div>
	);
}

export default App;
