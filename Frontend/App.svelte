<script>
  import { onMount } from 'svelte';
  import Sidebar from "./Components/Sidebar.svelte";
  import MainContent from "./Components/MainContent.svelte";
  import TopBar from "./Components/TopBar.svelte";
  import { theme, initializeRealtime } from "./stores.js";

  onMount(() => {
    initializeRealtime();
  });

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

<div class="flex flex-col h-screen">
  <TopBar />
  <div class="flex flex-grow overflow-hidden">
    <Sidebar />
    <MainContent />
  </div>
</div>
