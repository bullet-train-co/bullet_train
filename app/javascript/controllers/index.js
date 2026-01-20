import { application } from "controllers/application"
// Eager load all controllers defined in the import map under controllers/**/*_controller
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)


//import { Application } from "@hotwired/stimulus"
//import { identifierForContextKey } from "stimulus/webpack-helpers"
//import { controllerDefinitions as bulletTrainControllers } from "@bullet-train/bullet-train"
//import { controllerDefinitions as bulletTrainFieldControllers } from "@bullet-train/fields"
//import { controllerDefinitions as bulletTrainSortableControllers } from "@bullet-train/bullet-train-sortable"
//import ScrollReveal from 'stimulus-scroll-reveal'
//import RevealController from 'stimulus-reveal'
//import CableReady from 'cable_ready'
//import consumer from '../channels/consumer'

//const application = Application.start()
console.log('controllers/index.js reporting')
// In the browser console:
// * Type `window.Stimulus.debug = true` to log actions and lifecycle hooks
//   on subsequent user interactions and Turbo page views.
// * Type `window.Stimulus.router.modulesByIdentifier` for a list of loaded controllers.
// See https://stimulus.hotwired.dev/handbook/installing#debugging
//window.Stimulus = application

// Load all the controllers within this directory and all subdirectories.
// Controller files must be named *_controller.js.
//import { context as controllersContext } from './**/*_controller.js';

/*
application.register('reveal', RevealController)
application.register('scroll-reveal', ScrollReveal)

let controllers = Object.keys(controllersContext).map((filename) => ({
  identifier: identifierForContextKey(filename),
  controllerConstructor: controllersContext[filename] }))

controllers = overrideByIdentifier([
  ...bulletTrainControllers,
  ...bulletTrainFieldControllers,
  ...bulletTrainSortableControllers,
  ...controllers,
])

application.load(controllers)

CableReady.initialize({ consumer })

function overrideByIdentifier(controllers) {
  const byIdentifier = {}

  controllers.forEach(item => {
    byIdentifier[item.identifier] = item
  })

  console.log('------------------')
  console.log(byIdentifier)

  return Object.values(byIdentifier)
}
*/
