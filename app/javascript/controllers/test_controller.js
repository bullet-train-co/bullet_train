import { Controller } from "@hotwired/stimulus"

console.log('test_controller.js loaded')

export default class extends Controller {
  connect() {
    console.log('test_controller.js reporting for duty')
    console.log("Hello, Stimulus!", this.element)
  }
}
