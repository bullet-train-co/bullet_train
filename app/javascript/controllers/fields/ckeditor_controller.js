import { Controller } from "stimulus"

require("../../stylesheets/account/fields/ckeditor.scss")

import 'regenerator-runtime/runtime'

import ClassicEditorBase from '@ckeditor/ckeditor5-editor-classic/src/classiceditor'
import EssentialsPlugin from '@ckeditor/ckeditor5-essentials/src/essentials'
import UploadAdapterPlugin from '@ckeditor/ckeditor5-adapter-ckfinder/src/uploadadapter'
import AutoformatPlugin from '@ckeditor/ckeditor5-autoformat/src/autoformat'
import BoldPlugin from '@ckeditor/ckeditor5-basic-styles/src/bold'
import ItalicPlugin from '@ckeditor/ckeditor5-basic-styles/src/italic'
import BlockQuotePlugin from '@ckeditor/ckeditor5-block-quote/src/blockquote'
import EasyImagePlugin from '@ckeditor/ckeditor5-easy-image/src/easyimage'
import HeadingPlugin from '@ckeditor/ckeditor5-heading/src/heading'
import ImagePlugin from '@ckeditor/ckeditor5-image/src/image'
import ImageCaptionPlugin from '@ckeditor/ckeditor5-image/src/imagecaption'
import ImageStylePlugin from '@ckeditor/ckeditor5-image/src/imagestyle'
import ImageToolbarPlugin from '@ckeditor/ckeditor5-image/src/imagetoolbar'
import ImageUploadPlugin from '@ckeditor/ckeditor5-image/src/imageupload'
import LinkPlugin from '@ckeditor/ckeditor5-link/src/link'
import ListPlugin from '@ckeditor/ckeditor5-list/src/list'
import ParagraphPlugin from '@ckeditor/ckeditor5-paragraph/src/paragraph'

class ClassicEditor extends ClassicEditorBase {}

ClassicEditor.builtinPlugins = [
  EssentialsPlugin,
  UploadAdapterPlugin,
  AutoformatPlugin,
  BoldPlugin,
  ItalicPlugin,
  BlockQuotePlugin,
  EasyImagePlugin,
  HeadingPlugin,
  ImagePlugin,
  ImageCaptionPlugin,
  ImageStylePlugin,
  ImageToolbarPlugin,
  ImageUploadPlugin,
  LinkPlugin,
  ListPlugin,
  ParagraphPlugin
]

ClassicEditor.defaultConfig = {
  toolbar: {
    items: [
      'heading',
      '|',
      'bold',
      'italic',
      'link',
      'bulletedList',
      'numberedList',
      'imageUpload',
      'blockQuote',
      'undo',
      'redo'
    ]
  },
  image: {
    toolbar: [
      'imageStyle:full',
      'imageStyle:side',
      '|',
      'imageTextAlternative'
    ]
  },
  language: 'en'
}

export default class extends Controller {
  static targets = [ "field" ]
  
  connect() {
    this.initPluginInstance()
  }
  
  disconnect() {
    this.teardownPluginInstance()
  }
  
  cleanupBeforeInit() {
    $(this.element).find('.ck').remove()
  }
  
  initPluginInstance() {
    if (!this.hasFieldTarget) { return }
    
    this.cleanupBeforeInit() // in case improperly torn down
    
    ClassicEditor.create(this.fieldTarget).then((editor) => {
      if (this.fieldTarget.getAttribute('autofocus')) {
        editor.editing.view.focus();
      }
      
      this.plugin = editor
    });
  }
  
  teardownPluginInstance() {
    if (this.plugin === undefined) { return }
    
    // revert to original markup, remove any event listeners
    this.plugin.destroy()
  }
}

