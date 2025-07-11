document.addEventListener("turbo:load", () => {
  const tooltip = document.querySelector(".guide-tooltip");
  const closeBtn = document.querySelector(".guide-close");

  if (!tooltip || !closeBtn) return;

  // ページがロードされたら毎回表示
  tooltip.classList.remove("d-none");

  closeBtn.addEventListener("click", () => {
    tooltip.classList.add("d-none");
  });
});
