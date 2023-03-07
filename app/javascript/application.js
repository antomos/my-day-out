// Entry point for the build script in your package.json
import "@hotwired/turbo-rails";
import "./controllers";
import "bootstrap";
// import "flatpickr/dist/flatpickr";
// import "flatpickr/dist/themes/airbnb";

// $(document).ready(function() {
//   $(".datepicker").datepicker({
//     dateFormat: "yy-mm-dd",
//     onSelect: function(dateText, inst) {
//       // When a date is selected, set the minDate/maxDate of the other input to it
//       var minDate = $(this).data("min-date");
//       if (minDate) {
//         $(minDate).datepicker("option", "minDate", dateText);
//       }
//       var maxDate = $(this).data("max-date");
//       if (maxDate) {
//         $(maxDate).datepicker("option", "maxDate", dateText);
//       }
//     }
//   });
// });
