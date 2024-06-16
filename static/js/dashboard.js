document.addEventListener("DOMContentLoaded", () => {
  const btnOpen = document.getElementById("btn_open");
  const sideMenu = document.getElementById("menu_side");
  const body = document.getElementById("body");
  const btnSwitch = document.querySelector("#switch");

  // Function to open/close the menu
  function open_close_menu() {
    body.classList.toggle("body_move");
    sideMenu.classList.toggle("menu__side_move");
  }

  // Initialize dark mode based on local storage
  function initializeDarkMode() {
    const darkMode = localStorage.getItem("darkMode");
    if (darkMode === "enabled") {
      document.body.classList.add("dark");
      btnSwitch.classList.add("active");
    } else {
      document.body.classList.remove("dark");
      btnSwitch.classList.remove("active");
    }
  }

  // Toggle dark mode and save preference to local storage
  function toggleDarkMode() {
    document.body.classList.toggle("dark");
    btnSwitch.classList.toggle("active");

    if (document.body.classList.contains("dark")) {
      localStorage.setItem("darkMode", "enabled");
    } else {
      localStorage.setItem("darkMode", "disabled");
    }
  }

  // Attach event listeners
  btnOpen.addEventListener("click", open_close_menu);
  btnSwitch.addEventListener("click", toggleDarkMode);

  // Initialize dark mode on page load
  initializeDarkMode();
});
