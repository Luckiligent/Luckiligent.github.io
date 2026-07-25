(function () {
  var tablist = document.querySelector(".content-tabs");
  if (!tablist) return;

  var tabs = Array.prototype.slice.call(
    tablist.querySelectorAll('[role="tab"]')
  );
  var panels = Array.prototype.slice.call(
    document.querySelectorAll(".tab-panel[data-panel]")
  );

  function activate(name, pushUrl) {
    tabs.forEach(function (tab) {
      var selected = tab.getAttribute("data-tab") === name;
      tab.classList.toggle("is-active", selected);
      tab.setAttribute("aria-selected", selected ? "true" : "false");
      tab.tabIndex = selected ? 0 : -1;
    });

    panels.forEach(function (panel) {
      var selected = panel.getAttribute("data-panel") === name;
      panel.classList.toggle("is-active", selected);
      if (selected) {
        panel.removeAttribute("hidden");
      } else {
        panel.setAttribute("hidden", "");
      }
    });

    if (pushUrl && window.history && window.history.replaceState) {
      var url = new URL(window.location.href);
      if (name === "about") {
        url.searchParams.delete("tab");
      } else {
        url.searchParams.set("tab", name);
      }
      window.history.replaceState({}, "", url);
    }
  }

  tablist.addEventListener("click", function (event) {
    var tab = event.target.closest('[role="tab"]');
    if (!tab || !tablist.contains(tab)) return;
    activate(tab.getAttribute("data-tab"), true);
  });

  tablist.addEventListener("keydown", function (event) {
    var current = document.activeElement;
    var index = tabs.indexOf(current);
    if (index < 0) return;

    var next = index;
    if (event.key === "ArrowRight" || event.key === "ArrowDown") {
      next = (index + 1) % tabs.length;
    } else if (event.key === "ArrowLeft" || event.key === "ArrowUp") {
      next = (index - 1 + tabs.length) % tabs.length;
    } else if (event.key === "Home") {
      next = 0;
    } else if (event.key === "End") {
      next = tabs.length - 1;
    } else {
      return;
    }

    event.preventDefault();
    tabs[next].focus();
    activate(tabs[next].getAttribute("data-tab"), true);
  });

  var params = new URLSearchParams(window.location.search);
  var initial = params.get("tab");
  if (initial === "publications") {
    activate("publications", false);
  } else {
    activate("about", false);
  }
})();
