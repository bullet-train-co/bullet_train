import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "wrapper"]
  static classes = [ "hidden" ] // necessary because stimulus-reveal will mess with the [hidden] attribute on the wrapper
  static values = {
    showEventName: String,
    hideEventName: String,
  }

  toggle() {
    const eventName = this.isWrapperHidden? this.showEventNameValue: this.hideEventNameValue
    if (this.isWrapperHidden) {
      this.showWrapper()
    }
    
    this.wrapperTarget.dispatchEvent(new CustomEvent(eventName))
  }
  
  isWrapperHidden() {
    this.wrapperTarget.classList.has(this.hiddenClass)
  }
  
  showWrapper() {
    this.wrapperTarget.classList.remove(this.hiddenClass)
  }
  
  hideWrapper() {
    this.wrapperTarget.classList.add(this.hiddenClass)
  }
}