import { Application } from "@hotwired/stimulus"
import { identifierForContextKey } from "stimulus/webpack-helpers"
import { controllerDefinitions as bulletTrainControllers } from "@bullet-train/bullet-train"
import { controllerDefinitions as bulletTrainFieldControllers } from "@bullet-train/fields"
import { controllerDefinitions as bulletTrainSortableControllers } from "@bullet-train/bullet-train-sortable"
import RevealController from 'stimulus-reveal'
import CableReady from 'cable_ready'
import consumer from '../channels/consumer'

const application = Application.start()

// https://stimulus.hotwired.dev/handbook/installing#debugging
// Use `window.Stimulus.debug = true` in the console to log actions and lifecycle hooks
// on subsequent user interactions and Turbo page views.
// Use `window.Stimulus.router.modulesByIdentifier` for a list of loaded controllers.
window.Stimulus = application

// Load all the controllers within this directory and all subdirectories.
// Controller files must be named *_controller.js.
import { context as controllersContext } from './**/*_controller.js';

application.load(bulletTrainControllers)
application.load(bulletTrainFieldControllers)
application.load(bulletTrainSortableControllers)

application.register('reveal', RevealController)

const controllers = Object.keys(controllersContext).map((filename) => ({
  identifier: identifierForContextKey(filename),
  controllerConstructor: controllersContext[filename] }))

application.load(controllers)

CableReady.initialize({ consumer })
