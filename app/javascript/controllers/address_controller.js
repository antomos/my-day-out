import { Controller } from "@hotwired/stimulus"
import MapboxGeocoder from "@mapbox/mapbox-gl-geocoder"



export default class extends Controller {
  static values = { apiKey: String }

  static targets = ["address"]

  connect() {
    this.geocoder = new MapboxGeocoder({
      accessToken: this.apiKeyValue,
      types: "country,region,place,postcode,locality,neighborhood,address"
    })
    this.geocoder.addTo(this.element)

    this.geocoder.on("result", event => this.#setInputValue(event))
    this.geocoder.on("clear", () => this.#clearInputValue())
  }

  #setInputValue(event) {
    this.addressTarget.value = event.result["place_name"]
  }

  #clearInputValue() {
    this.addressTarget.value = ""
  }

  getLocation(event) {
    event.preventDefault();
    console.log(event);

    navigator.geolocation.getCurrentPosition((data) => {
      console.log(data.coords.latitude, data.coords.longitude);
      this.addressTarget.classList.remove("d-none")


    });
  }

}
/*
// Initialize the Geocoder function
var geocoder = new MapboxGeocoder({
  accessToken: 'YOUR_ACCESS_TOKEN',
  mapboxgl: mapboxgl
});

// Attach the Geocoder function to the input field
document.getElementById('address-input').appendChild(geocoder.onAdd(map));

// Attach a click event listener to the current location button
document.getElementById('current-location-btn').addEventListener('click', function() {
  // Get the user's current location
  navigator.geolocation.getCurrentPosition(function(position) {
    var lngLat = [position.coords.longitude, position.coords.latitude];
    // Set the map's center to the user's current location
    map.setCenter(lngLat);
    // Fill the current location into the address input field
    geocoder.queryReverse(lngLat, function(err, result) {
      if (err) throw err;
      document.getElementById('address-input').value = result.features[0].place_name;
    });
  });
}); */
