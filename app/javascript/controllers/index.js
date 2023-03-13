import { application } from "./application"

import EditEventController from "./edit_event_controller"
application.register("edit-event", EditEventController)

import AddressController from "./address_controller"
application.register("address", AddressController)

import FlatpickrController from "./flatpickr_controller"
application.register("flatpickr", FlatpickrController)

import HelloController from "./hello_controller"
application.register("hello", HelloController)

import MapController from "./map_controller"
application.register("map", MapController)


import { initSortable } from "./sortable"
initSortable()

import { Application } from "@hotwired/stimulus"
import { definitionsFromContext } from "@hotwired/stimulus-webpack-helpers"

window.Stimulus = Application.start()
const context = require.context("./", true, /\.js$/)
Stimulus.load(definitionsFromContext(context))
