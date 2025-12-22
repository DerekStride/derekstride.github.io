import { Application } from "https://unpkg.com/@hotwired/stimulus@3.2.2/dist/stimulus.js"
import FlashcardController from "./controllers/flashcard_controller.js"

const application = Application.start()
application.register("flashcard", FlashcardController)
