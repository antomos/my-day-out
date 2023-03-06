var startAddressInputField = document.getElementById("element-name"); // input_field

function getLocation() {
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(showPosition);
  } else {
    x.innerHTML = "Geolocation is not supported by this browser.";
  }
}

function showPosition(position) {
  var latitude = position.coords.latitude;
  var longitude = position.coords.longitude;
  var userName = "username";
  var url = `http://api.geonames.org/findNearestAddress?lat=${latitude}&lng=${longitude}&username=${userName}`;

  var xmlDoc = "";
  fetch(url)
    .then((response) => response.text())
    .then((str) => new window.DOMParser().parseFromString(str, "text/xml"))
    .then((data) => (xmlDoc = data));

  var streetName = doc.getElementsByTagName("street")[0].textContent; // "123 Fake Street"

  startAddressInputField.value = streetName; // more like this.inputTarget.value = streetName
}
