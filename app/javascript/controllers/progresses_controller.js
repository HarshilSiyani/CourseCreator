import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["bar", "list"]

  connect() {
    this.checkProgress();
  }

  checkProgress() {
    fetch(`/study/progresses/${this.getCourseId()}`, { 
      headers: { accept: 'application/json' },
    })
      .then(response => response.json())
      .then((data) => {
        this.updateProgressBar(data);
        this.updateCourseList(data);
      });
  }

  getCourseId() {
    return this.barTarget.dataset.courseId;
  }

  updateProgressBar(data) {
    const percentage = Math.round((data.current_index / data.total) * 100)

    const bar = this.barTarget.children[0];
    bar.style.width = `${percentage}%`;
    bar.ariaValueNow = percentage;
  }

  updateCourseList(data) {
    // console.log(data);
    const currentModule = data["current_index"];
    const icons = this.listTarget.querySelectorAll("span.fa-li")
    icons.forEach((icon, index) => {
      if (currentModule <= (index + 1)) icons[index].innerHTML = `<i class="fas fa-square text-white"></i>`;
      if (currentModule >= (index + 1)) icons[index].innerHTML = `<i class="far fa-check-square text-body"></i>`;
    })
  }

}
