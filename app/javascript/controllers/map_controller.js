import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array
  }

  connect() {

    mapboxgl.accessToken = this.apiKeyValue
    const lat= this.markersValue[0].lat
    const  lng= this.markersValue[0].lng
    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v11",
      center: [lng, lat], // Specify the map center coordinates
      zoom: 14 // Specify the map zoom level
    })
    const marker = new mapboxgl.Marker({
      color: 'green' // Set the marker color
  })
  .setLngLat([lng, lat]) // Set the marker coordinates
  .addTo(this.map); // Add the marker to the map





  }
  // #addMarkersToMap() {
  //   console.log("Hello")

  //   this.markersValue.forEach((marker) => {


  //     // Create a HTML element for your custom marker
  //     const customMarker = document.createElement("div")
  //     customMarker.innerHTML = marker.marker_html

  //     // Pass the element as an argument to the new marker
  //     new mapboxgl.Marker(customMarker)
  //       .setLngLat([marker.lng, marker.lat])
  //       .addTo(this.map)
  //   })
  //  }
  //   #fitMapToMarkers() {
  //     const bounds = new mapboxgl.LngLatBounds()
  //     this.markersValue.forEach(marker => bounds.extend([ marker.lng, marker.lat ]))
  //     this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 })
  //   }

}
