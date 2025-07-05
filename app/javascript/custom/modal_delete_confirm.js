console.log('ファイル先頭テスト：modal_delete_confirm.js読み込み成功？');



document.addEventListener('turbo:load', () => {
  const deleteButtons = document.querySelectorAll('.delete-btn');
  const modalElement = document.getElementById('deleteConfirmModal');
  let targetForm;

  if (modalElement) {
    const modal = new bootstrap.Modal(modalElement);

    deleteButtons.forEach(button => {
      button.addEventListener('click', (event) => {
        event.preventDefault();
        targetForm = button.closest('form');
        modal.show();
      });
    });

    document.getElementById('modalDeleteOk').addEventListener('click', () => {
      if (targetForm) {
        targetForm.submit();
        modal.hide();
      }
    });
  }
});


