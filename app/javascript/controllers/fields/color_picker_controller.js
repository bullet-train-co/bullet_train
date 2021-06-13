import { Controller } from "stimulus"
import '@simonwep/pickr/dist/themes/monolith.min.css'

import Pickr from '@simonwep/pickr';

export default class extends Controller {
  static targets = [ "colorPickerValue", "colorField", "colorInput", "userSelectedColor", "colorOptions" ];
  static values = { initialColor: String }

  connect() {
    this.initPluginInstance()
    this.colorOptions = $(this.colorOptionsTarget).find('button').map(function (_, button) { return $(button).attr('data-color'); }).get()
  }

  disconnect() {
    this.teardownPluginInstance()
  }

  pickColor(event) {
    event.preventDefault();

    const targetEl = event.target;
    const color = targetEl.dataset.color;

    $(this.colorInputTarget).val(color);
    $(this.colorPickerValueTarget).val(color);
    $(this.userSelectedColorTarget).data('color', color);
    $('.button-color').removeClass('ring-2 ring-offset-2');

    this.pickr.setColor(color);

    targetEl.classList.add('ring-2', 'ring-offset-2');
  }

  pickRandomColor(event) {
    event.preventDefault();

    const r = Math.floor(Math.random() * 256);
    const g = Math.floor(Math.random() * 256);
    const b = Math.floor(Math.random() * 256);

    this.pickr.setColor(`rgb ${r} ${g} ${b}`);
    const hexColor = this.pickr.getColor().toHEXA().toString();
    this.pickr.setColor(hexColor);

    this.showUserSelectedColor(hexColor);
  }

  showUserSelectedColor(color) {
    $(this.colorInputTarget).val(color);
    $(this.colorPickerValueTarget).val(color);

    $('.button-color').removeClass('ring-2 ring-offset-2');

    $(this.userSelectedColorTarget)
      .addClass('ring-2')
      .addClass('ring-offset-2')
      .css('background-color', color)
      .css('--tw-ring-color', color)
      .attr('data-color', color)
      .show();
  }

  unpickColor(event) {
    event.preventDefault();
    $(this.colorPickerValueTarget).val('');
    $(this.colorInputTarget).val('');
    $(this.userSelectedColorTarget).hide();
    $('.button-color').removeClass('ring-2 ring-offset-2');
  }

  togglePickr(event) {
    event.preventDefault();
  }

  initPluginInstance() {
    this.pickr = Pickr.create({
      el: '.btn-pickr',
      theme: 'monolith',
      useAsButton: true,
      default: this.initialColorValue || '#1E90FF',
      components: {
        // Main components
        preview: true,
        hue: true,

        // Input / output Options
        interaction: {
          input: true,
          save: true,
        },
      }
    });

    this.pickr.on('save', (color, _instance) => {
      const hexaColor = color.toHEXA().toString()
      if (!this.colorOptions.includes(hexaColor)) {
        this.showUserSelectedColor(hexaColor);
      }
      this.pickr.hide();
    });

    const that = this

    $('input[type="text"].pcr-result').on('keydown', function (e) {
      if (e.key === 'Enter') {
        that.pickr.applyColor(false)
      }
    })
  }

  teardownPluginInstance() {
    this.pickr.destroy()
  }
}
