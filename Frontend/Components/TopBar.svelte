<script>
  import { selectedProject } from "../stores.js";
  import ThemeToggle from "./ThemeToggle.svelte";
  import logoUrl from '../icons/favicon.svg';

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
        <svg
          xmlns="http://www.w3.org/2000/svg"
          class="h-5 w-5 text-gray-500 dark:text-gray-400"
          fill="none"
          viewBox="0 0 24 24"
          stroke="currentColor"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z"
          />
        </svg>
      </button>
    {/if}
    {#if copySuccess}
      <span class="ml-2 text-xs text-green-600 dark:text-green-400"
        >Copied!</span
      >
    {/if}
  </div>
  <div class="flex items-center">
    <ThemeToggle />
  </div>
</header>
