# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "bootstrap" # @5.3.5
pin "@popperjs/core", to: "@popperjs--core.js" # @2.11.8

# ↓↓↓ ここを追記
pin "@popperjs/core/utils/getMainAxisFromPlacement.js", to: "https://ga.jspm.io/npm:@popperjs/core@2.11.8/lib/utils/getMainAxisFromPlacement.js"
pin "@popperjs/core/utils/getOppositePlacement.js", to: "https://ga.jspm.io/npm:@popperjs/core@2.11.8/lib/utils/getOppositePlacement.js"
pin "@popperjs/core/utils/getOppositeVariationPlacement.js", to: "https://ga.jspm.io/npm:@popperjs/core@2.11.8/lib/utils/getOppositeVariationPlacement.js"

pin "@rails/ujs", to: "https://ga.jspm.io/npm:@rails/ujs@7.0.4/lib/assets/compiled/rails-ujs.js"
