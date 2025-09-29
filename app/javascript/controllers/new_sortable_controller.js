import { Controller } from "@hotwired/stimulus"
import { post } from '@rails/request.js'

// These are defaults so that we don't have to require people to update their templates.
// If the template does contain values for any of these the template values will be used instead.
const defaultClasses = {
  "activeDropzoneClasses": "border-dashed bg-gray-50 border-slate-400",
  "activeItemClasses": "shadow bg-white cursor-grabbing bg-white *:bg-white opacity-100 *:opacity-100",
  "dropTargetClasses": "shadow-inner shadow-gray-500 hover:shadow-inner bg-gray-100 *:opacity-0 *:bg-gray-100"
};

// Connects to data-controller="new-sortable"
export default class extends Controller {
  static values = {
    reorderPath: String,
    saveOnReorder: { type: Boolean, default: true },
    // This is used to get a hold of the draggable elements (tr by default) inside of the draggable container (tbody by default).
    draggableSelector: { type: String, default: "tr" }
  }
  static classes = ["activeDropzone", "activeItem", "dropTarget"];

  // will be reissued as native dom events name prepended with 'sortable:' e.g. 'sortable:drag', 'sortable:drop', etc
  // TODO: I'm not sure all of these events are useful outside of a dragulat context.
  static pluginEventsToReissue = [ "drag", "dragend", "drop", "cancel", "remove", "shadow", "over", "out", "cloned" ];

  dragHandleMouseDown(event){
    const draggableItem = getDataNode(event.target);
    draggableItem.setAttribute('draggable', true);
  }

  dragHandleMouseUp(event){
    const draggableItem = getDataNode(event.target);
    draggableItem.setAttribute('draggable', false);
  }

  dragstart(event) {
    event.stopPropagation();
    this.element.classList.add(...this.activeDropzoneClassesWithDefaults);
    const draggableItem = getDataNode(event.target);
    draggableItem.classList.add(...this.activeItemClassesWithDefaults);
    event.dataTransfer.setData(
      "application/drag-key",
      draggableItem.dataset.id
    );
    event.dataTransfer.effectAllowed = "move";
    // For most browsers we could rely on the dataTransfer.setData call above,
    // but Safari doesn't seem to allow us access to that data at any time other
    // than during a drop. But we need it during dragenter to reorder the list
    // as the drag happens. So, we just stash the value here and then use it later.
    this.draggingDataId = draggableItem.dataset.id;
  }

  drag(event){ }

  dragover(event) {
    event.stopPropagation();
    event.preventDefault();
    return true;
  }

  dragenter(event) {
    event.stopPropagation();
    let parent = getDataNode(event.target);

    // We keep a count of the `dragenter` events for the row being dragged to fix jank. When dragging between cells
    // (or cell content) within a row a dragenter event is fired before the dragleave event from the previous cell.
    // If we removed the activeItemClasses when the dragleave happens then the UI doesn't match expectations.
    if(parent.dataset.dragEnterCount){
      parent.dataset.dragEnterCount = parseInt(parent.dataset.dragEnterCount) + 1;
    }else{
      parent.dataset.dragEnterCount = 1;
    }

    if (parent != null && parent.dataset.id != null) {
      parent.classList.add(...this.dropTargetClassesWithDefaults);
      var data = this.draggingDataId;
      const draggedItem = this.element.querySelector(
        `[data-id='${data}']`
      );

      if (draggedItem) {
        draggedItem.classList.remove(...this.activeItemClassesWithDefaults);

        if (
          parent.compareDocumentPosition(draggedItem) &
          Node.DOCUMENT_POSITION_FOLLOWING
        ) {
          let result = parent.insertAdjacentElement(
            "beforebegin",
            draggedItem
          );
        } else if (
          parent.compareDocumentPosition(draggedItem) &
          Node.DOCUMENT_POSITION_PRECEDING
        ) {
          let result = parent.insertAdjacentElement("afterend", draggedItem);
        }

      }
      event.preventDefault();
    }
  }

  dragleave(event) {
    event.stopPropagation();
    let parent = getDataNode(event.target);

    if(parent.dataset.dragEnterCount > 0){
      parent.dataset.dragEnterCount = parseInt(parent.dataset.dragEnterCount) - 1;
    }

    if (parent != null && parent.dataset.id != null && parent.dataset.dragEnterCount == 0) {
      parent.classList.remove(...this.dropTargetClassesWithDefaults);
      event.preventDefault();
    }
  }

  drop(event) {
    event.stopPropagation();
    this.element.classList.remove(...this.activeDropzoneClassesWithDefaults);

    const dropTarget = getDataNode(event.target);
    dropTarget.classList.remove(...this.dropTargetClassesWithDefaults);

    var data = this.draggingDataId;
    const draggedItem = this.element.querySelector(
      `[data-id='${data}']`
    );

    if (draggedItem) {
      draggedItem.classList.remove(...this.activeItemClassesWithDefaults);

      if (
        dropTarget.compareDocumentPosition(draggedItem) &
        Node.DOCUMENT_POSITION_FOLLOWING
      ) {
        let result = dropTarget.insertAdjacentElement(
          "beforebegin",
          draggedItem
        );
      } else if (
        dropTarget.compareDocumentPosition(draggedItem) &
        Node.DOCUMENT_POSITION_PRECEDING
      ) {
        let result = dropTarget.insertAdjacentElement("afterend", draggedItem);
      }

      if (this.saveOnReorderValue) {
        this.saveSortOrder()
      }
    }
    event.preventDefault();
  }

  saveSortOrder() {
    var idsInOrder = Array.from(this.element.childNodes).map((el) => { return parseInt(el.dataset?.id) });
    post(this.reorderPathValue, { body: JSON.stringify({ids_in_order: idsInOrder}) })
  }

  dragend(event) {
    event.stopPropagation();
    this.element.classList.remove(...this.activeDropzoneClassesWithDefaults);

    const draggableItem = getDataNode(event.target);
    draggableItem.setAttribute('draggable', false);
    draggableItem.dataset.dragEnterCount = 0;
  }

  connect() {
    // We do this to ease the upgrade path so that people aren't required to udpate their templates.
    this.activeDropzoneClassesWithDefaults = this.activeDropzoneClasses.length == 0 ? defaultClasses["activeDropzoneClasses"].split(" ") : this.activeDropzoneClasses;
    this.activeItemClassesWithDefaults = this.activeItemClasses.length == 0 ? defaultClasses["activeItemClasses"].split(" ") : this.activeItemClasses;
    this.dropTargetClassesWithDefaults = this.dropTargetClasses.length == 0 ? defaultClasses["dropTargetClasses"].split(" ") : this.dropTargetClasses;

    // Normally with Stimulus we'd wire these up via the data-action attribute. We're doing it this way to make
    // the transition to this new controller easier.
    this.element.addEventListener('dragstart', this.dragstart.bind(this));
    this.element.addEventListener('drag', this.drag.bind(this));
    this.element.addEventListener('dragover', this.dragover.bind(this));
    this.element.addEventListener('dragenter', this.dragenter.bind(this));
    this.element.addEventListener('dragleave', this.dragleave.bind(this));
    this.element.addEventListener('dragend', this.dragend.bind(this));
    this.element.addEventListener('drop', this.drop.bind(this));

    this.addDragHandles();

    let handles = this.element.querySelectorAll('.dragHandle')
    for (const handle of handles) {
      handle.addEventListener('mousedown', this.dragHandleMouseDown.bind(this));
      handle.addEventListener('mouseup', this.dragHandleMouseUp.bind(this));
    }

    this.initReissuePluginEventsAsNativeEvents();
  }

  addDragHandles(){

    // Here we assume that this controller is connected to a tbody element
    const table = this.element.parentNode;
    const thead = table.querySelector('thead');
    const headRow = thead.querySelector('tr');
    const newTh = document.createElement('th');
    headRow.prepend(newTh);

    const draggables = this.element.querySelectorAll('tr');
    for (const draggable of draggables) {
      console.log('draggable', draggable);

      const newCell = document.createElement('td');
      newCell.classList.add(...'dragHandle cursor-grab'.split(' '));

      const iconSpan = document.createElement('span');
      iconSpan.classList.add(...'h-6 w-6 text-center'.split(' '));
      newCell.append(iconSpan);

      const icon = document.createElement('i');
      icon.classList.add(...'ti ti-line-double'.split(' '));

      iconSpan.append(icon);

      draggable.prepend(newCell);
    }
  }

  // TODO: I'm not sure this is adequate. I think we may need to "manually" dispatch these from within the
  // approriate event handles so that we can add more info to `args`. For instance, the "drop" event may
  // need to include the sibling that the dropped element was dropped in front of. Related, do people actually
  // use these re-issued events?
  initReissuePluginEventsAsNativeEvents() {
    this.constructor.pluginEventsToReissue.forEach((eventName) => {
      this.element.addEventListener(eventName, (...args) => {
        console.log('reissuing event', eventName);
        this.dispatch(eventName, { detail: { type: eventName, args: args }})
      })
    })
  }

  disconnect() {
    this.element.removeEventListener('dragstart', this.dragstart.bind(this));
    this.element.removeEventListener('drag', this.drag.bind(this));
    this.element.removeEventListener('dragover', this.dragover.bind(this));
    this.element.removeEventListener('dragenter', this.dragenter.bind(this));
    this.element.removeEventListener('dragleave', this.dragleave.bind(this));
    this.element.removeEventListener('dragend', this.dragend.bind(this));
    this.element.removeEventListener('drop', this.drop.bind(this));

    let handles = this.element.querySelectorAll('.dragHangle')
    for (const handle of handles) {
      handle.removeEventListener('mousedown', this.dragHandleMouseDown.bind(this));
      handle.removeEventListener('mouseup', this.dragHandleMouseUp.bind(this));
    }
  }
}

function getDataNode(node) {
  return node.closest("[data-id]");
}

function getMetaValue(name) {
  const element = document.head.querySelector(`meta[name="${name}"]`);
  return element.getAttribute("content");
}
