import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["form"]

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

    const checkboxes = this.formTarget.querySelectorAll("input[type='radio']")
    const userChoices = Array.from(checkboxes, answer => answer = {
      id: parseInt(answer.value),
      checked: answer.checked,
      question_id: parseInt(answer.dataset.questionId)
    } )
    const correctAnswers = this.convertArrayToObject(data["answers"], "id");

    // Reset form before begin
    this.resetForm();

    let correctCount = 0;
    userChoices.forEach((choice, index) => {
      const isUserCorrect = correctAnswers[choice.id].correct === choice.checked
      const correctIcon = `<span class="fa-li"><i class="fas fa-check-circle"></i></span>`;
      const incorrectIcon = `<span class="fa-li"><i class="fas fa-times"></i></span>`;

      if (isUserCorrect) correctCount += 1;
      // display if user choose the correct answers
      if (isUserCorrect && choice.checked) {
        checkboxes[index].parentElement.insertAdjacentHTML("afterbegin", correctIcon)
      } else if (!isUserCorrect && choice.checked) {
        // display if user choose the wrong answers
        checkboxes[index].parentElement.insertAdjacentHTML("afterbegin", incorrectIcon)
      }
    })

    if (correctCount === Object.keys(correctAnswers).length)
      this.letUserProceed();
  }

  letUserProceed() {
    // console.log("User can proceed");
    const navBtns = document.querySelectorAll(".module-nav-right");
    if (navBtns) {
      navBtns[0].style.display = "none";
      navBtns[1].style.display = "inline";
    }
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
