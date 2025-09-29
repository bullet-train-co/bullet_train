import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "sortable" ]

  connect() {
    console.log('confirm-reorder connect!')
  }

  requestConfirmation(event) {
    console.log('requestConfirmation!!!!!', event);
    //return;

    const [el, target, source, sibling] = event.detail?.args

    // sibling will be undefined if dropped in last position, taking a shortcut here
    const areYouSure = `Are you sure you want to place ${el.dataset.name} before ${sibling.dataset.name}?`
    //const areYouSure = `Are you sure you want to move ${el.dataset.name}?`

    // let's suppose each <tr> in sortable has a data-name attribute
    if (confirm(areYouSure)) {
      this.sortableTarget.dispatchEvent(new CustomEvent('save-sort-order'))
    } else {
      this.revertToOriginalOrder()
    }
  }

  prepareForRevertOnCancel(event) {
    // we're assuming we can swap out the HTML safely
    this.originalSortableHTML = this.sortableTarget.innerHTML
  }

  revertToOriginalOrder() {
    if (this.originalSortableHTML === undefined) { return }
    this.sortableTarget.innerHTML = this.originalSortableHTML
    this.originalSortableHTML = undefined
  }
}
