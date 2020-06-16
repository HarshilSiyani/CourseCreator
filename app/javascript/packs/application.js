// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
require("trix")
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

// Internal imports, e.g:
import "../controllers/index";
import "bootstrap";
// import "cocoon-js";
// import { initSelect2 } from '../components/init_select2';
import "../components/trix_youtube_plugins";
import { initChatroomCable } from '../channels/chatroom_channel'
import { initNotificationCable } from '../channels/notification_channel'

document.addEventListener('turbolinks:load', () => {
  // Call your functions here, e.g:
  initChatroomCable();
  initNotificationCable();
});


const hero = document.querySelector(".hero");
const slider = document.querySelector(".slider");


const tl = new TimelineMax();

tl.from(hero,1, {height: "0%"}, {height: "80%", ease: Power2.easeInOut})
.fromTo(hero, 1.2, {width: "100%"}, {width: "80%", ease: Power2.easeInOut})
.fromTo(slider, 1.2, {x: "-100%"}, {x: "0%", ease: Power2.easeInOut}, "-=1.2");

new ClipboardJS('.copy');







