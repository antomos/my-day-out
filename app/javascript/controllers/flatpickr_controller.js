import { Controller } from "@hotwired/stimulus";
import flatpickr from "flatpickr";

export default class extends Controller {
  static targets = [ "start", "end"]
  connect() {
   // Initialize Flatpickr on both inputs
    const date=document.getElementById('itinerary_date')
console.log(date)
    console.log("flatpickr controller connected!");
    if (date!==null) {


    new flatpickr(date, {minDate: "today",
                  dateFormat: "d-m-Y"
        });
    }

    // Initialize Flatpickr on the start time input
    const startMinTime = "08:00";
    const startMaxTime = "18:00";
    const endMinTime = "09:00";
    const endMaxTime = "19:00";
    const startTimeInput = flatpickr(this.startTarget, {
      enableTime: true,
      noCalendar: true,
      minTime: startMinTime,
      maxTime: startMaxTime,
      time_24hr: true,
      minuteIncrement: 15,
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
      minTime: endMinTime,
      maxTime: endMaxTime,
      time_24hr: true,
      minuteIncrement: 15,
      dateFormat: "H:i",
      onChange: function(selectedDates, dateStr, instance) {
        // When the end time changes, update the maximum allowed time for the start time input
        startTimeInput.set("maxTime", dateStr);
      }
    });

  }
}
