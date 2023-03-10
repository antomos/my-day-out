import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="edit-movie"
export default class extends Controller {
  static targets = ["infos", "form","formdiv", "card","details","forms"]

  displayDetails() {
    // this.infosTarget.classList.add("d-none")
    //console.log("displayDetails")
    this.detailsTarget.classList.remove("d-none")

  }

  displayForm() {
    console.log("displayForm")
    // this.infosTarget.classList.add("d-none")
    const forms = document.querySelectorAll("div.edit-form")
    forms.forEach((form) => {
      form.classList.add("d-none");
    });

    this.formdivTarget.classList.remove("d-none")

    this.detailsTarget.classList.add("d-none")
    this.cardTarget.classList.add("w-400")

  }
  hideDetails() {
    // this.infosTarget.classList.remove("d-none")
    //console.log("displayForm")
    this.detailsTarget.classList.add("d-none")
  }
  hideForm() {
    // this.infosTarget.classList.remove("d-none")
    this.formdivTarget.classList.add("d-none")
  }

  update(event) {
    event.preventDefault()
    console.log("update")
    const url = this.formTarget.action
    fetch(url, {
      method: "PATCH",
      headers: { "Accept": "text/plain" },
      body: new FormData(this.formTarget)
    })
      .then(response => response.text())
      .then((data) => {
        this.cardTarget.outerHTML = data
      })
  }
}
