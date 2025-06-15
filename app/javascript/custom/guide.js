// app/javascript/custom/guide.js

document.addEventListener("turbo:load", () => {
  const tooltip = document.querySelector(".guide-tooltip");
  const closeBtn = document.querySelector(".guide-close");

  if (!tooltip || !closeBtn) return;

  if (!localStorage.getItem("guide_shown")) {
    tooltip.classList.remove("d-none");
    localStorage.setItem("guide_shown", "true");
  }

  closeBtn.addEventListener("click", () => {
    tooltip.classList.add("d-none");
  });
});
