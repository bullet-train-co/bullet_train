import { Controller } from "stimulus";

export default class extends Controller {
  static targets = [
    "fileField",
    "removeFileFlag",
    "downloadFileButton",
    "removeFileButton",
    "selectFileButton",
    "progressBar",
  ];

  connect() {
    // Add upload event listeners
    const initializeListener = document.addEventListener(
      "direct-upload:initialize",
      (event) => {
        this.selectFileButtonTarget.classList.add("hidden");
        this.progressBarTarget.innerText = "0%";
        this.progressBarTarget.style.width = "0%";
        this.progressBarTarget.setAttribute("aria-valuenow", 0);
        this.progressBarTarget.parentNode.classList.remove("hidden");
      }
    );

    const progressListener = document.addEventListener(
      "direct-upload:progress",
      (event) => {
        const { progress } = event.detail;
        const width = `${progress.toFixed(1)}%`;

        this.progressBarTarget.innerText = width;
        this.progressBarTarget.setAttribute("aria-valuenow", progress);
        this.progressBarTarget.style.width = width;
      }
    );

    const errorListener = document.addEventListener(
      "direct-upload:error",
      (event) => {
        event.preventDefault();

        const { error } = event.detail;
        this.progressBarTarget.innerText = error;
      }
    );

    this.uploadListeners = {
      "direct-upload:initialize": initializeListener,
      "direct-upload:progress": progressListener,
      "direct-upload:error": errorListener,
    };
  }

  disconnect() {
    // Teardown event listeners
    for (const event in this.uploadListeners) {
      document.removeEventListener(event, this.uploadListeners[event]);
    }
  }

  uploadFile() {
    this.fileFieldTarget.click();
  }

  removeFile() {
    if (this.hasDownloadFileButtonTarget) {
      this.downloadFileButtonTarget.classList.add("hidden");
    }

    this.removeFileButtonTarget.classList.add("hidden");
    this.removeFileFlagTarget.value = true;
  }

  handleFileSelected() {
    const statusText = this.selectFileButtonTarget.querySelector("span");
    const icon = this.selectFileButtonTarget.querySelector("i");

    if (this.hasDownloadFileButtonTarget) {
      this.downloadFileButtonTarget.remove();
    }

    statusText.innerText = "Select Another File";
    icon.classList.remove("ti-upload");
    icon.classList.add("ti-check");
  }
}
