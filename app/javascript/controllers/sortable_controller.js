import { Controller } from "stimulus";
import Sortable from "sortablejs";

export default class extends Controller {
  connect() {
    Sortable.create(this.listTarget, {
      ghostClass: "ghost",
      animation: 150,
    });
  }
}
