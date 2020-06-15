import consumer from "./consumer";

const initChatroomCable = () => {
  const messagesContainer = document.querySelector('#messages');
  // const notificationDropdown = document.querySelector('#notificationDropdown')
  // const notificationCount = document.querySelector('.notification-count')
  let count = 0;
  if (messagesContainer) {
    const id = messagesContainer.dataset.chatroomId;

    consumer.subscriptions.create({ channel: "ChatroomChannel", id: id }, {
      received(data) {
        console.log(data);
        messagesContainer.insertAdjacentHTML('beforeend', data.messageHtml);
        // notificationDropdown.insertAdjacentHTML('afterbegin', data.notificationHtml);
        // // count new msg & change notification count
        // count = count + 1;
        // notificationCount.classList.add("notification-count-show");
        // notificationCount.innerText = count;
      }
    });

    // consumer.subscriptions.create({ channel: "ChatroomChannel" }, {
    //   received(data) {
    //     console.log(data);
    //     // messagesContainer.insertAdjacentHTML('beforeend', data.messageHtml);
    //     notificationDropdown.insertAdjacentHTML('afterbegin', data.notificationHtml);
    //     // count new msg & change notification count
    //     count = count + 1;
    //     notificationCount.classList.add("notification-count-show");
    //     notificationCount.innerText = count;
    //   }
    // });
  }
}

export { initChatroomCable };
