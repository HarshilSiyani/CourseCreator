// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
// require("trix")
require("@rails/actiontext")

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)


// ----------------------------------------------------
// Note(lewagon): ABOVE IS RAILS DEFAULT CONFIGURATION
// WRITE YOUR OWN JS STARTING FROM HERE 👇
// ----------------------------------------------------

// External imports
import "bootstrap";
import "cocoon-js";
// BEGIN - StimulusJS for nested form
import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"

const application = Application.start()
const context = require.context("../controllers", true, /\.js$/)
application.load(definitionsFromContext(context))
// END - StimulusJS for nested form

// Internal imports, e.g:
// import { initSelect2 } from '../components/init_select2';

document.addEventListener('turbolinks:load', () => {
  // Call your functions here, e.g:
  // initSelect2();
});

const Trix = require("trix")

window.addEventListener("trix-initialize", (event) => {

// https://www.youtube.com/embed/pPy0GQJLZUM
// https://www.youtube.com/watch?v=SQS4ji0TMtk
// https://www.youtube.com/watch?time_continue=848&v=2iGBuLQ3S0c&feature=emb_logo

  const embedBtn = document.createElement("button");
  embedBtn.innerHTML = "youtube";
  embedBtn.type = "button";
  embedBtn.classList.add("trix-button");
  embedBtn.classList.add("trix-button--icon");
  embedBtn.classList.add("trix-button--icon-link");
  embedBtn.addEventListener("click", (event) => {
    const youtubeUrl = window.prompt("Please put a youtube link");
    const results = youtubeUrl.match(/.*youtube\.com\/watch\?v=(.*)/);
    const trixEditor = document.querySelector("trix-editor")
    if (!results){
      return;
    }
    const embedUrl = `https://www.youtube.com/embed/${results[1]}`;
    // debugger
    const attachment = new Trix.Attachment({
      // sgid: trixEditor.closest("form").dataset.sgid,
      content: `<iframe width="560" height="315" src="${embedUrl}" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>`
    });

    trixEditor.editor.insertAttachment(attachment);
  });
  event.target.toolbarElement.querySelector(".trix-button-group.trix-button-group--text-tools").appendChild(embedBtn);
});
