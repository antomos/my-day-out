import { Controller } from "@hotwired/stimulus"


export default class extends Controller {
  static targets = ['modalTitle', 'modalBody'];

  showDetails(event) {
    console.log('showDetails');
    console.log(event.target.dataset.cardId);
    const cardId = event.target.dataset.cardId;
    const modal = document.getElementById('card-details-modal');
    const modalTitle = this.modalTitleTarget;
    const modalBody = this.modalBodyTarget;

    // Set the title and body of the modal
    modalTitle.textContent = `Details for Card #${cardId}`;
    modalBody.innerHTML = '<p>Loading details...</p>';

    // Retrieve the details of the card using an AJAX request
    fetch(`/cards/${cardId}.json`)
      .then(response => response.json())
      .then(card => {
        // Update the modal body with the card details
        modalBody.innerHTML = `
          <ul>
            <li><strong>Name:</strong> ${card.name}</li>
            <li><strong>Description:</strong> ${card.description}</li>
            <li><strong>Category:</strong> ${card.category}</li>
            <li><strong>Price:</strong> ${card.price}</li>
          </ul>`;
      })
      .catch(error => {
        // Show an error message if the AJAX request fails
        modalBody.textContent = `Error retrieving details for Card #${cardId}`;
      });

    // Show the modal
    const bootstrapModal = new bootstrap.Modal(modal);
    bootstrapModal.show();
  }
}
