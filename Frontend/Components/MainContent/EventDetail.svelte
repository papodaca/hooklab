<script>
  import { selectedCall, selectedProject } from "../../stores.js";
  import { getCallDetails } from "../../api.js";
  import MethodPill from "../MethodPill.svelte";
  import ThemeToggle from "../ThemeToggle.svelte";
  import RequestDetails from "./RequestDetails.svelte";

  let webhookUrl = "";
  let copySuccess = false;
  let detailedCall = null;
  let isLoading = false;

  $: {
    if ($selectedProject) {
      webhookUrl = `${window.location.origin}/api/hook/${$selectedProject.id}`;
    } else {
      webhookUrl = "Select a project to see its webhook URL";
    }
  }

  $: {
    if ($selectedCall) {
      // Check if we already have the detailed view or if it's a different call
      if (!detailedCall || detailedCall.id !== $selectedCall.id) {
        isLoading = true;
        detailedCall = null; // Clear previous details
        getCallDetails($selectedCall.id)
          .then((data) => {
            detailedCall = data;
          })
          .catch((err) => {
            console.error("Failed to get call details", err);
            // Optionally, show an error state in the UI
          })
          .finally(() => {
            isLoading = false;
          });
      }
    } else {
      detailedCall = null;
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

<div
  class="border-b border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-800"
>
  <div class="p-2 flex items-center justify-center text-sm">
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
    <div class="flex-grow"></div>
    <ThemeToggle />
  </div>
</div>

{#if $selectedCall}
  <header
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
  </header>

  <div class="flex-grow overflow-y-auto no-scrollbar">
    {#if isLoading}
      <div class="p-8 text-center text-gray-500 dark:text-gray-400">
        Loading details...
      </div>
    {:else if detailedCall}
      <RequestDetails
        headers={detailedCall.headers}
        body={detailedCall.body}
        params={Object.fromEntries(new URLSearchParams(detailedCall.params))}
      />
    {/if}
  </div>
{:else}
  <div class="flex flex-col items-center justify-center h-full text-center">
    <svg
      xmlns="http://www.w3.org/2000/svg"
      class="w-24 h-24 text-gray-300 dark:text-gray-600 animate-pulse"
      fill="none"
      viewBox="0 0 24 24"
      stroke="currentColor"
      stroke-width="1"
    >
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        d="M3 15v4a2 2 0 002 2h14a2 2 0 002-2v-4M17 9l-5 5-5-5M12 14.25V3"
      />
    </svg>
    <p class="text-gray-500 dark:text-gray-400 mt-4 text-lg">
      Waiting for incoming events...
    </p>
    <p class="text-gray-400 dark:text-gray-500 text-sm">
      Select an event from the list to see details here.
    </p>
  </div>
{/if}
