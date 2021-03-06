import { Controller } from "stimulus"
import 'intl-tel-input/build/css/intlTelInput.css';
import intlTelInput from 'intl-tel-input';

export default class extends Controller {
  static targets = [ "field" ]

  connect() {
    this.initPluginInstance()
  }

  disconnect() {
    this.teardownPluginInstance()
  }

  initPluginInstance() {
    this.plugin = intlTelInput(this.fieldTarget, {
      hiddenInput: this.fieldTarget.dataset.method,
      // See `config/webpack/environment.js` for where we copy this into place.
      // TODO Wish we could somehow incorporate webpacker's cache-breaking hash into this. Anyone know how?
      utilsScript: "/assets/intl-tel-input/utils.js",
      customContainer: "w-full"
    });
  }

  teardownPluginInstance() {
    if (this.plugin === undefined) { return }

    // revert to original markup, remove any event listeners
    this.plugin.destroy()
  }
}
