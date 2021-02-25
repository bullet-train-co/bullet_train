import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "shadowField" ]

  clickShadowField(event) {
    // we have to stop safari from doing what we originally expected.
    event.preventDefault();

    // then we need to manually click the hidden checkbox or radio button ourselves.
    this.shadowFieldTarget.click()
  }
}