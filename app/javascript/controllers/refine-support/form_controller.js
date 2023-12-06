import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  requestSubmit({ detail }) {
    this.element.querySelector("input[name=stable_id]").value = detail.stableId
    this.element.requestSubmit()
  }
}
