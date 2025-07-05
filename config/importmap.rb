

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
# pin "@hotwired/stimulus-loading", to: "stimulus-loading.js" # ←これを追加！

pin_all_from "app/javascript/controllers", under: "controllers"

# BootstrapとPopper.js
pin "bootstrap", to: "https://ga.jspm.io/npm:bootstrap@5.3.3/dist/js/bootstrap.esm.js"
pin "@popperjs/core", to: "https://ga.jspm.io/npm:@popperjs/core@2.11.8/dist/esm/popper.js"

# ✅ カスタムJSファイル群（ここが自分で追加する場所）
pin "custom/guide"
pin "custom/step_form"
pin "custom/modal_delete_confirm"