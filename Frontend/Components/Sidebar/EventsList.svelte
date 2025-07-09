<script>
  import { events, selectedProject, selectedEvent } from '../../stores.js';

  let filteredEvents;
  $: {
    if ($selectedProject === 'All Projects') {
      filteredEvents = $events;
    } else {
      filteredEvents = $events.filter(e => e.project === $selectedProject);
    }
  }

  function selectEvent(event) {
    selectedEvent.set(event);
    events.update(items =>
      items.map(e => ({ ...e, active: e.name === event.name }))
    );
  }
</script>

<div class="flex-grow overflow-y-auto no-scrollbar">
  <div class="p-4 border-b border-gray-200 dark:border-gray-700">
    <h1 id="events-title" class="text-lg font-bold text-gray-900 dark:text-white">
      {$selectedProject === 'All Projects' ? 'All Recent Events' : `Events for ${$selectedProject}`}
    </h1>
  </div>
  <nav>
    <ul>
      {#each filteredEvents as event}
        <li
          class="webhook-item border-b border-gray-200 dark:border-gray-700"
          class:bg-indigo-50={event.active}
          class:dark:bg-indigo-900={event.active}
          class:dark:bg-opacity-50={event.active}
          class:hover:bg-gray-50={!event.active}
          class:dark:hover:bg-gray-700={!event.active}
          class:dark:hover:bg-opacity-50={!event.active}
        >
          <div
            role="button"
            tabindex="0"
            on:click={() => selectEvent(event)}
            on:keydown={(e) => e.key === 'Enter' && selectEvent(event)}
            class="block p-4"
          >
            <div class="flex items-start justify-between">
              <div class="flex items-center">
                <span
                  class="inline-flex items-center justify-center rounded-full px-2.5 py-1 text-xs font-semibold text-white ring-4 ring-white dark:ring-gray-800"
                  class:bg-green-500={event.status === 200}
                  class:bg-red-500={event.status !== 200}
                >
                  {event.status}
                </span>
                <div class="ml-3">
                  <p class="font-semibold text-gray-900 dark:text-white">{event.name}</p>
                  <p class="text-sm text-gray-500 dark:text-gray-400">{event.path}</p>
                </div>
              </div>
              <span class="text-xs text-gray-500 dark:text-gray-400">{event.time}</span>
            </div>
            <div class="mt-2 pl-10">
              <span
                class="inline-flex items-center px-2 py-0.5 rounded-full text-xs font-medium"
                class:bg-indigo-100={event.projectColor === 'indigo'}
                class:text-indigo-800={event.projectColor === 'indigo'}
                class:dark:bg-indigo-900={event.projectColor === 'indigo'}
                class:dark:text-indigo-300={event.projectColor === 'indigo'}
                class:bg-emerald-100={event.projectColor === 'emerald'}
                class:text-emerald-800={event.projectColor === 'emerald'}
                class:dark:bg-emerald-900={event.projectColor === 'emerald'}
                class:dark:text-emerald-300={event.projectColor === 'emerald'}
                class:bg-rose-100={event.projectColor === 'rose'}
                class:text-rose-800={event.projectColor === 'rose'}
                class:dark:bg-rose-900={event.projectColor === 'rose'}
                class:dark:text-rose-300={event.projectColor === 'rose'}
              >
                {event.project}
              </span>
            </div>
          </div>
        </li>
      {/each}
    </ul>
  </nav>
</div>
