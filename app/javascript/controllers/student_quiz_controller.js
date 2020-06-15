import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["form"]

  connect() {
    console.log(this.formTarget);
  }

  getQuizId() {
    return this.formTarget.dataset.contentableId;
  }

  checkAnswers(event) {
    event.preventDefault();
    const quizId = this.getQuizId();
    fetch(`/quizzes/${quizId}/answers`, { 
      headers: { accept: 'application/json' },
    })
      .then(response => response.json())
      .then((data) => {
        this.printResult(data);
      });
  }

  printResult(data) {
    if (data["id"] != parseInt(this.getQuizId())) {
      return;
    }

    const checkboxes = this.formTarget.querySelectorAll("input[type='checkbox']")
    const userChoices = Array.from(checkboxes, answer => answer = { 
      id: parseInt(answer.value),
      checked: answer.checked, 
      question_id: parseInt(answer.dataset.questionId) 
    } )
    const correctAnswers = this.convertArrayToObject(data["answers"], "id");
    
    // Reset form before begin
    this.resetForm();

    userChoices.forEach((choice, index) => {
      const isUserCorrect = correctAnswers[choice.id].correct === choice.checked
      const correctIcon = `<span class="fa-li"><i class="fas fa-check-circle"></i></span>`;
      const incorrectIcon = `<span class="fa-li"><i class="fas fa-times"></i></span>`;

      // notify users if current choices are correct answers
      if (isUserCorrect && choice.checked) {
        checkboxes[index].parentElement.insertAdjacentHTML("afterbegin", correctIcon)
      } else if (!isUserCorrect && choice.checked) {
        checkboxes[index].parentElement.insertAdjacentHTML("afterbegin", incorrectIcon)
      }

    })

  }

  resetForm() {
    let checkCount = 0;
    let iconCount = 0;

    const checkboxes = this.formTarget.querySelectorAll("input[type='checkbox']")

    checkboxes.forEach((box, index) => {
      if (box.checked) checkCount += 1;
      iconCount += box.parentElement.querySelectorAll("label > span").count
      box.parentElement.querySelectorAll("label > span").forEach((icon) => {
        checkboxes[index].parentElement.removeChild(icon)
      })
    })

    if (checkCount && iconCount)
      this.formTarget.reset();
  }

  convertArrayToObject (array, key) {
    const initialValue = {};
    return array.reduce((obj, item) => {
      return {
        ...obj,
        [item[key]]: item,
      };
    }, initialValue);
  };
}
