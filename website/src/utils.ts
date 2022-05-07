export default function listCookies() {
	const theCookies = document.cookie.split(";");
	let aString = "";
	for (var i = 1; i <= theCookies.length; i++) {
		aString += i + " " + theCookies[i - 1] + "\n";
	}
	return aString;
}
