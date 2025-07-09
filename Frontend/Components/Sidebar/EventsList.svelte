<script>
  import { onMount } from 'svelte';
  import { calls, selectedProject, selectedCall } from '../../stores.js';
  import EventItem from './EventItem.svelte';

  onMount(() => {
    calls.fetchCalls();
  });

  $: {
    if ($selectedProject) {
      calls.fetchCalls($selectedProject.id);
    } else {
      calls.fetchCalls();
    }
  }

  function handleSelect(event) {
    const selected = event.detail;
    selectedCall.set(selected);
  }
</script>

<div class="flex-grow overflow-y-auto no-scrollbar">
  <div class="p-4 border-b border-gray-200 dark:border-gray-700">
    <h1 id="events-title" class="text-lg font-bold text-gray-900 dark:text-white">
      {$selectedProject ? `Events for ${$selectedProject.name}` : 'All Recent Events'}
    </h1>
  </div>
  <nav>
    {#if $calls.loading}
      <div class="p-4 text-center text-gray-500 dark:text-gray-400">Loading...</div>
    {:else if $calls.error}
      <div class="p-4 text-center text-red-500">{$calls.error}</div>
    {:else if $calls.data.length === 0}
      <div class="p-8 text-center">
        <svg xmlns="http://www.w3.org/2000/svg" class="mx-auto h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
        </svg>
        <h3 class="mt-2 text-sm font-medium text-gray-900 dark:text-white">No Events</h3>
        <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">Get started by sending a request to your webhook URL.</p>
      </div>
    {:else}
      <ul>
        {#each $calls.data as call (call.id)}
          <EventItem event={call} active={call.id === $selectedCall?.id} on:select={handleSelect} />
        {/each}
      </ul>
    {/if}
  </nav>
</div>

