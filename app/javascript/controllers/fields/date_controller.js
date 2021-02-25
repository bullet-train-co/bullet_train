import { Controller } from "stimulus"
require("daterangepicker/daterangepicker.css");
require("../../stylesheets/account/fields/date_field.scss");

// requires jQuery, moment, might want to consider a vanilla JS alternative
import 'daterangepicker';

export default class extends Controller {
  static targets = [ "field", "clearButton" ]
  static values = { includeTime: Boolean }
  
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
    const format = this.includeTimeValue? 'MM/DD/YYYY h:mm A' : 'MM/DD/YYYY'
    $(this.fieldTarget).val(picker.startDate.format(format))
  }
  
  initPluginInstance() {
    $(this.fieldTarget).daterangepicker({
      singleDatePicker: true,
      timePicker: this.includeTimeValue,
      autoUpdateInput: true,
      locale: {
        cancelLabel: 'Clear'
      }
    })
    
    $(this.fieldTarget).on('apply.daterangepicker', this.applyDateToField.bind(this))
    $(this.fieldTarget).on('cancel.daterangepicker', this.clearDate.bind(this))
    
    this.pluginMainEl = this.fieldTarget
    this.plugin = $(this.pluginMainEl).data('daterangepicker') // weird
    
  }
  
  teardownPluginInstance() {
    if (this.plugin === undefined) { return }
    
    $(this.pluginMainEl).off('apply.daterangepicker')
    $(this.pluginMainEl).off('cancel.daterangepicker')
    
    // revert to original markup, remove any event listeners
    this.plugin.remove()
  }
}