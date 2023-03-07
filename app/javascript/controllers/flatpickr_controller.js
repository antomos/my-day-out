import { Controller } from "@hotwired/stimulus";
import flatpickr from "flatpickr";

export default class extends Controller {
  static targets = ["date", "start", "end"]
  connect() {
   // Initialize Flatpickr on both inputs


    console.log("flatpickr controller connected!");
    new flatpickr(this.dateTarget, {minDate: "today",
                  dateFormat: "d-m-Y"
        });

    // Initialize Flatpickr on the start time input
    const minTime = "08:00";
    const maxTime = "19:00";
    const startTimeInput = flatpickr(this.startTarget, {
      enableTime: true,
      noCalendar: true,
      minTime: minTime,
      maxTime: maxTime,
      time_24hr: true,
      dateFormat: "H:i",
      onChange: function(selectedDates, dateStr, instance) {
        // When the start time changes, update the minimum allowed time for the end time input
        endTimeInput.set("minTime", dateStr);
      }
    });

  // Initialize Flatpickr on the end time input
    const endTimeInput = flatpickr(this.endTarget, {
      enableTime: true,
      noCalendar: true,
      minTime: minTime,
      maxTime: maxTime,
      time_24hr: true,
      dateFormat: "H:i",
      onChange: function(selectedDates, dateStr, instance) {
        // When the end time changes, update the maximum allowed time for the start time input
        startTimeInput.set("maxTime", dateStr);
      }
    });

  }
}
