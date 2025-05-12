import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { timeout: Number }

  connect() {
    if (this.timeoutValue) {
      setTimeout(() => {
        this.cleanup();
      }, this.timeoutValue);
    }
  }

  cleanup() {
    this.element.remove();
  }
}
