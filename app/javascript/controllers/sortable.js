import Sortable from "sortablejs"



const initSortable = () => {
  const list = document.getElementById('event');
  if (list){

  const itinerary = document.getElementById('event').getAttribute('data-target-id');

  Sortable.create(list, {
    ghostClass: "ghost",
    animation: 150,
    onEnd: (event) => {
      const data = `${event.oldIndex},${event.newIndex}`
      // const data: { old: event.oldIndex, new: event.newIndex }

      const url = `${itinerary}/edit_order`

      fetch(url, {
        method: "POST",
        headers: {  "Content-Type": "application/json", "Accept": "application/json" , "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content},
        body: JSON.stringify(data)
        // method: "POST",
        // headers: { "Accept": "text/plain", "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content },
        // body: data
      })
      setTimeout(function() {
        location.reload();
      }, 2000);
    }
  })
}
}
export { initSortable }
