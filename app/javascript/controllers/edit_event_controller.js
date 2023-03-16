import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="edit-movie"
export default class extends Controller {
  static targets = ["formdiv"]
 connect(){
  const editButtons = document.querySelectorAll(".edit-button");
  const editForm = document.getElementById("edit-form");
  const editTitle = document.getElementById("edit-title");
  const editDetails = document.getElementById("edit-details");
  const editId = document.getElementById("edit-id");

  editButtons.forEach((button) => {
    button.addEventListener("click", () => {
      // Get the card's data
      this.formdivTarget.classList.remove("d-none")
      const card = button.parentNode;
      const title = card.querySelector("h2").textContent;
      const details = card.querySelector("p").textContent;
      const id = card.getAttribute("data-id");
      const array = [1, 2, 3];

      // Populate the form with the card's data
      editTitle.value = title;
      editDetails.value = details;
      editId.value = id;
      // Pass array to form
      editForm.array = array;

      // Display the form
      editForm.style.display = "block";
    });
  });

  editForm.addEventListener("submit", (event) => {
    // Prevent the form from submitting
    event.preventDefault();
    this.formdivTarget.classList.add("d-none")

    // Hide the form
    editForm.style.display = "none";
  });



 }








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
