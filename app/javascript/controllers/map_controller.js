import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array
  }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue
    const lat= "51.528239"
    const  lng= "-0.130928"
    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v10",
      center: [lng, lat], // Specify the map center coordinates
      zoom: 14
    })
    const marker = new mapboxgl.Marker({
      color: 'red' // Set the marker color
  })
  .setLngLat([lng, lat]) // Set the marker coordinates
  .addTo(this.map); // Add the marker to the map





  }

}
