import consumer from "./consumer";

const initChatroomCable = () => {
  const messagesContainer = document.querySelector('#messages');
  if (messagesContainer) {
    const id = messagesContainer.dataset.chatroomId; // <- current chatroom
    // Subscribe for current chatroom
    consumer.subscriptions.create({ channel: "ChatroomChannel", id: id }, {
      received(data) {
        console.log(data);
        messagesContainer.insertAdjacentHTML('beforeend', data);
      }
    });
  }
}

export { initChatroomCable };

