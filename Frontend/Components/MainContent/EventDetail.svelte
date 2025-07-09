<script>
  import { selectedEvent } from '../../stores.js';
  import ThemeToggle from '../ThemeToggle.svelte';
</script>

{#if $selectedEvent}
  <header
    class="p-4 border-b border-gray-200 dark:border-gray-700 flex items-center justify-between sticky top-0 bg-slate-50/80 dark:bg-slate-900/80 backdrop-blur-sm z-10"
  >
    <div>
      <h2 class="text-xl font-semibold text-gray-900 dark:text-white">{$selectedEvent.name}</h2>
      <p class="text-sm text-gray-500 dark:text-gray-400">ID: {$selectedEvent.id}</p>
    </div>
    <div class="flex items-center gap-4">
      <span
        class="px-3 py-1 text-sm font-semibold text-green-800 bg-green-100 rounded-full dark:bg-green-900 dark:text-green-300"
      >
        {$selectedEvent.status}
      </span>
      <ThemeToggle />
    </div>
  </header>

  <div class="flex-grow overflow-y-auto no-scrollbar">
    <!-- TODO: Add RequestDetails and ResponseDetails components -->
  </div>
{:else}
  <div class="flex items-center justify-center h-full">
    <p class="text-gray-500">Select an event to view details</p>
  </div>
{/if}
