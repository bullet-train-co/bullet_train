// Load all the controllers within this directory and all subdirectories.
// Controller files must be named *_controller.js.

import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"
import { controllerDefinitions as bulletTrainFieldControllers } from "@bullet-train/fields"
import RevealController from 'stimulus-reveal'
import CableReady from 'cable_ready'
import consumer from '../channels/consumer'

const application = Application.start()
const context = require.context("controllers", true, /_controller\.js$/)
application.load(definitionsFromContext(context))
application.load(bulletTrainFieldControllers)
application.register('reveal', RevealController)
CableReady.initialize({ consumer })