<script>
  import Sidebar from "./Components/Sidebar.svelte";
  import MainContent from "./Components/MainContent.svelte";
  import { theme } from "./stores.js";

  $: {
    if (typeof document !== "undefined") {
      let classList = document.body.classList;
      if ($theme === "dark") {
        classList.add("dark");
      } else {
        classList.remove("dark");
      }
    }
  }
</script>

<div class="flex h-screen">
  <Sidebar />
  <MainContent />
</div>
