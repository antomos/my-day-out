import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['list'];
  static values = {

    events: Array
  }

  connect() {
    console.log(this.eventsValue.title)

    // this.eventsValue.forEach((event) => {
    //   console.log("hello")
    //   const movieTag = `<li class="list-group-item border-0">
    //     <img src="${event.url_image}" alt="" width="100"></img> Hello
    //   </li>`;
    //   this.listTarget.insertAdjacentHTML('beforeend', movieTag);
    // });
  }


}
