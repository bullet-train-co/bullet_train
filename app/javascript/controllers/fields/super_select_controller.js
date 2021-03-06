import { Controller } from "stimulus"
require("select2/dist/css/select2.min.css");
import $ from 'jquery';
import 'select2';

export default class extends Controller {
  static targets = [ "select" ]
  static values = {
    acceptsNew: Boolean,
    enableSearch: Boolean
  }

  connect() {
    this.initPluginInstance()
  }

  disconnect() {
    this.teardownPluginInstance()
  }

  cleanupBeforeInit() {
    $(this.element).find('.select2-container--default').remove()
  }

  initPluginInstance() {
    let options = {};

    if (!this.enableSearchValue) {
      options.minimumResultsForSearch = -1;
    }

    options.tags = this.acceptsNewValue

    options.templateResult = this.formatState;
    options.templateSelection = this.formatState;
    options.width = 'style';

    this.cleanupBeforeInit() // in case improperly torn down
    this.pluginMainEl = this.selectTarget // required because this.selectTarget is unavailable on disconnect()
    $(this.pluginMainEl).select2(options);
  }

  teardownPluginInstance() {
    if (this.pluginMainEl === undefined) { return }

    // revert to original markup, remove any event listeners
    $(this.pluginMainEl).select2('destroy');
  }

  // https://stackoverflow.com/questions/29290389/select2-add-image-icon-to-option-dynamically
  formatState(opt) {
    var imageUrl = $(opt.element).attr('data-image');
    var imageHtml = "";
    if (imageUrl) {
      imageHtml = '<img src="' + imageUrl + '" /> ';
    }
    return $('<span>' + imageHtml + opt.text + '</span>');
  }
}
