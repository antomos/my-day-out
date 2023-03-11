import Sortable from "sortablejs"

const list = document.getElementById('event');

const initSortable = () => {
  const list = document.getElementById('event');

  Sortable.create(list, {
    ghostClass: "ghost",
    animation: 150,
    onEnd: (event) => {
      console.log(`${event.oldIndex} moved to ${event.newIndex}`)
      // alert(`${event.oldIndex} moved to ${event.newIndex}`)
    }
  })
}
export { initSortable }
