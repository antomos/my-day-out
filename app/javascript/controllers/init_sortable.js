import Sortable from "sortablejs"

const list = document.getElementById('event')



const initSortable = () => {
  Sortable.create(list, {
    ghostClass: "ghost",
    animation: 150,

  })
}
export { initSortable }
