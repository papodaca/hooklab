<script>
  import { selectedCall, selectedProject } from "../stores.js";
  import { getCallDetails } from "../api.js";
  import MethodPill from "./MethodPill.svelte";
  import ThemeToggle from "./ThemeToggle.svelte";

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

<header class="w-full" style="--header-height: 4rem;">
  <div
    class="p-2 flex items-center justify-between text-sm border-b border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-800"
  >
    <div class="flex items-center">
      <svg
        class="h-8 w-8 text-blue-500 mr-2"
        fill="none"
        viewBox="0 0 24 24"
        stroke="currentColor"
      >
        <path
          stroke-linecap="round"
          stroke-linejoin="round"
          stroke-width="2"
          d="M15 15l-2 5L9 9l11 4-5 2zm0 0l5 5M7.188 2.239l.777 2.897M5.136 7.965l-2.898-.777M13.95 4.05l-2.122 2.122m-5.657 5.656l-2.12 2.122"
        />
      </svg>
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
    <ThemeToggle />
  </div>
  {#if $selectedCall}
    <div
      class="p-4 border-b border-gray-200 dark:border-gray-700 flex items-center justify-between sticky top-0 bg-slate-50/80 dark:bg-slate-900/80 backdrop-blur-sm z-10"
    >
      <div>
        <h2 class="text-xl font-semibold text-gray-900 dark:text-white">
          {$selectedCall.path}
        </h2>
        <p class="text-sm text-gray-500 dark:text-gray-400">
          ID: {$selectedCall.id} &bull; IP: {$selectedCall.source}
        </p>
      </div>
      <div class="flex items-center gap-4">
        <MethodPill method={$selectedCall.method} />
      </div>
    </div>
  {/if}
</header>
