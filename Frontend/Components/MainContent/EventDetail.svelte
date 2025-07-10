<script>
  import { selectedCall } from "../../stores.js";
  import { getCallDetails } from "../../api.js";
  import MethodPill from "../MethodPill.svelte";
  import RequestDetails from "./RequestDetails.svelte";
  import { Inbox } from "@lucide/svelte";

  let detailedCall = null;
  let isLoading = false;

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
</script>

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
    <Inbox class="w-24 h-24 text-gray-300 dark:text-gray-600 animate-pulse" />
    <p class="text-gray-500 dark:text-gray-400 mt-4 text-lg">
      Waiting for incoming events...
    </p>
    <p class="text-gray-400 dark:text-gray-500 text-sm">
      Select an event from the list to see details here.
    </p>
  </div>
{/if}
