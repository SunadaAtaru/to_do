document.addEventListener("DOMContentLoaded", () => {
  const step1 = document.querySelector(".step-1");
  const step2 = document.querySelector(".step-2");
  const nextBtn = document.querySelector(".next-step");
  const prevBtn = document.querySelector(".prev-step");

  if (nextBtn) {
    nextBtn.addEventListener("click", () => {
      step1.classList.add("d-none");
      step2.classList.remove("d-none");
    });
  }

  if (prevBtn) {
    prevBtn.addEventListener("click", () => {
      step2.classList.add("d-none");
      step1.classList.remove("d-none");
    });
  }
});