document.addEventListener("turbo:load", () => {
  const tooltip = document.querySelector(".guide-tooltip");
  const closeBtn = document.querySelector(".guide-close");

  if (!tooltip || !closeBtn) return;

  // 初期状態: d-none を外して show を付ける
  tooltip.classList.remove("d-none");
  tooltip.classList.add("show");

  closeBtn.addEventListener("click", () => {
    tooltip.classList.remove("show");
    tooltip.classList.add("d-none");
  });
});
