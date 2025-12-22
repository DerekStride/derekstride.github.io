import { Controller } from "https://unpkg.com/@hotwired/stimulus@3.2.2/dist/stimulus.js"

export default class extends Controller {
  static targets = ["cloze", "answer", "button"]

  reveal(event) {
    const target = event.currentTarget
    target.classList.remove("cloze-hidden")
    target.classList.add("cloze-revealed")
  }

  showAnswer() {
    this.answerTarget.classList.remove("hidden")
    this.answerTarget.classList.add("block")
    if (this.hasButtonTarget) {
      this.buttonTarget.classList.add("hidden")
    }
  }
}
