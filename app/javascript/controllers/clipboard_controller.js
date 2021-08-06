import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['source', 'input', 'button']

  copy() {
    this.inputTarget.value = this.sourceTarget.innerText
    this.inputTarget.select()
    document.execCommand('copy')
    this.buttonTarget.innerHTML = '<i id="copied" class="fas fa-check w-4 h-4 block text-green-600"></i>'
    setTimeout(function () {
      document.getElementById('copied').innerHTML = '<i class="far fa-copy w-4 h-4 block text-gray-600"></i>'
    }, 1500)
  }
}
