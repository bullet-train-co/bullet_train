import { Controller } from "stimulus"
import I18n from "i18n-js/index.js.erb"
require("daterangepicker/daterangepicker.css");

// requires jQuery, moment, might want to consider a vanilla JS alternative
import 'daterangepicker';

export default class extends Controller {
  static targets = [ "field", "clearButton", "currentTimeZoneWrapper", "timeZoneButtons", "timeZoneSelectWrapper", "timeZoneField" ]
  static values = { includeTime: Boolean, defaultTimeZones: Array }

  connect() {
    this.initPluginInstance()
  }

  disconnect() {
    this.teardownPluginInstance()
  }

  clearDate(event) {
    // don't submit the form, unless it originated from the cancel/clear button
    event.preventDefault()

    $(this.fieldTarget).val('')
  }

  applyDateToField(event, picker) {
    const format = this.includeTimeValue ? 'MM/DD/YYYY h:mm A' : 'MM/DD/YYYY'
    $(this.fieldTarget).val(picker.startDate.format(format))
  }

  showTimeZoneButtons(event) {
    // don't follow the anchor
    event.preventDefault()

    $(this.currentTimeZoneWrapperTarget).toggleClass('hidden')
    $(this.timeZoneButtonsTarget).toggleClass('hidden')
  }

  showTimeZoneSelectWrapper(event) {
    // don't follow the anchor
    event.preventDefault()

    $(this.timeZoneButtonsTarget).toggleClass('hidden')

    if (this.hasTimeZoneSelectWrapperTarget) {
      $(this.timeZoneSelectWrapperTarget).toggleClass('hidden')
    }
  }

  resetTimeZoneUI(e) {
    e && e.preventDefault()

    $(this.currentTimeZoneWrapperTarget).removeClass('hidden')
    $(this.timeZoneButtonsTarget).addClass('hidden')

    if (this.hasTimeZoneSelectWrapperTarget) {
      $(this.timeZoneSelectWrapperTarget).addClass('hidden')
    }
  }

  setTimeZone(event) {
    // don't follow the anchor
    event.preventDefault()

    const currentTimeZoneEl = this.currentTimeZoneWrapperTarget.querySelector('a')
    const {value} = event.target.dataset

    $(this.timeZoneFieldTarget).val(value)
    $(currentTimeZoneEl).text(value)

    $('.time-zone-button').removeClass('button').addClass('button-alternative')
    $(event.target).removeClass('button-alternative').addClass('button')

    this.resetTimeZoneUI()
  }

  initPluginInstance() {
    $(this.fieldTarget).daterangepicker({
      singleDatePicker: true,
      timePicker: this.includeTimeValue,
      timePickerIncrement: 5,
      autoUpdateInput: false,
      locale: {
        cancelLabel: I18n.t('fields.date_field.cancel'),
        applyLabel: I18n.t('fields.date_field.apply'),
        format: this.includeTimeValue ? 'MM/DD/YYYY h:mm A' : 'MM/DD/YYYY'
      }
    })

    $(this.fieldTarget).on('apply.daterangepicker', this.applyDateToField.bind(this))
    $(this.fieldTarget).on('cancel.daterangepicker', this.clearDate.bind(this))

    this.pluginMainEl = this.fieldTarget
    this.plugin = $(this.pluginMainEl).data('daterangepicker') // weird

    // Init time zone select
    if (this.includeTimeValue && this.hasTimeZoneSelectWrapperTarget) {
      this.timeZoneSelect = this.timeZoneSelectWrapperTarget.querySelector('select.select2')

      $(this.timeZoneSelect).select2({
        width: 'style'
      })

      const self = this

      $(this.timeZoneSelect).on('change.select2', function(event) {
        const currentTimeZoneEl = self.currentTimeZoneWrapperTarget.querySelector('a')
        const {value} = event.target

        $(self.timeZoneFieldTarget).val(value)
        $(currentTimeZoneEl).text(value)

        const selectedOptionTimeZoneButton = $('.selected-option-time-zone-button')

        if (self.defaultTimeZonesValue.includes(value)) {
          $('.time-zone-button').removeClass('button').addClass('button-alternative')
          selectedOptionTimeZoneButton.addClass('hidden').attr('hidden', true)
          $(`a[data-value="${value}"`).removeClass('button-alternative').addClass('button')
        } else {
          // deselect any selected button
          $('.time-zone-button').removeClass('button').addClass('button-alternative')

          selectedOptionTimeZoneButton.text(value)
          selectedOptionTimeZoneButton.attr('data-value', value).removeAttr('hidden')
          selectedOptionTimeZoneButton.removeClass(['hidden', 'button-alternative']).addClass('button')
        }

        self.resetTimeZoneUI()
      })
    }
  }

  teardownPluginInstance() {
    if (this.plugin === undefined) { return }

    $(this.pluginMainEl).off('apply.daterangepicker')
    $(this.pluginMainEl).off('cancel.daterangepicker')

    // revert to original markup, remove any event listeners
    this.plugin.remove()

    if (this.includeTimeValue) {
      $(this.timeZoneSelect).select2('destroy');
    }
  }
}
