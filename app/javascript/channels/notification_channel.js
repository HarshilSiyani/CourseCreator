import consumer from "./consumer";

const initNotificationCable = () => {
  const notificationDropdown = document.querySelector('#notificationDropdown');
  const notificationCount = document.querySelector('.notification-count');
  let count = 0;
  if (notificationCount) {
    const id = notificationDropdown.dataset.userId;
    consumer.subscriptions.create({ channel: "NotificationChannel", id: id }, {
      received(data) {
        console.log(data);
        notificationDropdown.insertAdjacentHTML('afterbegin', data.notificationHtml);
        // count new msg & change notification count
        count = count + 1;
        notificationCount.classList.add("notification-count-show");
        notificationCount.innerText = count;
      },
    });
  }
}

export { initNotificationCable };
