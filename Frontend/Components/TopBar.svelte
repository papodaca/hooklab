<script>
  import { selectedProject } from "../stores.js";
  import ThemeToggle from "./ThemeToggle.svelte";
  import logoUrl from "../icons/favicon.svg";
  import { Copy } from "@lucide/svelte";

  let webhookUrl = "";
  let copySuccess = false;

  $: {
    if ($selectedProject) {
      webhookUrl = `${window.location.origin}/api/hook/${$selectedProject.id}`;
    } else {
      webhookUrl = "Select a project to see its webhook URL";
    }
  }

  function copyToClipboard() {
    if ($selectedProject) {
      navigator.clipboard.writeText(webhookUrl).then(() => {
        copySuccess = true;
        setTimeout(() => (copySuccess = false), 2000);
      });
    }
  }
</script>

<header
  class="border-b border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-800 p-2 flex items-center text-sm w-full"
>
  <div class="flex items-center">
    <img
      src={logoUrl}
      alt="HookLab logo"
      class="h-8 w-8 mr-2"
    />
    <span
      class="text-2xl font-extrabold uppercase tracking-wider dark:text-white"
      >HOOKLAB</span
    >
  </div>
  <div class="flex-grow flex items-center justify-center">
    <span class="text-gray-500 dark:text-gray-400 mr-2">Webhook URL:</span>
    <code
      class="font-mono bg-gray-200 dark:bg-gray-700 text-gray-800 dark:text-gray-200 rounded px-2 py-1"
    >
      {webhookUrl}
    </code>
    {#if $selectedProject}
      <button
        on:click={copyToClipboard}
        aria-label="Copy webhook URL to clipboard"
        class="ml-2 p-1 rounded hover:bg-gray-200 dark:hover:bg-gray-700 transition-colors"
      >
        <span class="h-5 w-5 text-gray-500 dark:text-gray-400"
          ><Copy size={16} /></span
        >
      </button>
    {/if}
    <span
      class="ml-2 text-xs text-green-600 dark:text-green-400 transition-opacity duration-200"
      class:opacity-0={!copySuccess}>Copied!</span
    >
  </div>
  <div class="flex items-center">
    <ThemeToggle />
  </div>
</header>
