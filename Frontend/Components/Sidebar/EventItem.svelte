<script>
  import { createEventDispatcher, onMount, onDestroy } from "svelte";
  import MethodPill from "../MethodPill.svelte";
  import { formatDistanceToNow } from "date-fns";

  export let event;
  export let active = false;

  const dispatch = createEventDispatcher();

  let timeAgo = "";
  let interval;

  onMount(() => {
    timeAgo = formatDistanceToNow(new Date(event.time), { addSuffix: true });
    interval = setInterval(() => {
      timeAgo = formatDistanceToNow(new Date(event.time), { addSuffix: true });
    }, 60000);
  });

  onDestroy(() => {
    clearInterval(interval);
  });

  function select() {
    dispatch("select", event);
  }
</script>

<li
  class="webhook-item border-b border-gray-200 dark:border-gray-700 transition-colors"
  class:bg-indigo-50={active}
  class:dark:bg-indigo-900={active}
  class:dark:bg-opacity-50={active}
  class:hover:bg-gray-50={!active}
  class:dark:hover:bg-gray-700={!active}
  class:dark:hover:bg-opacity-50={!active}
>
  <div
    role="button"
    tabindex="0"
    on:click={select}
    on:keydown={(e) => e.key === "Enter" && select()}
    class="block p-4"
  >
    <div class="flex items-center justify-between">
      <p class="font-semibold text-gray-900 dark:text-white truncate">
        {event.path}
      </p>
      <span
        class="text-xs text-gray-500 dark:text-gray-400 flex-shrink-0 ml-4"
        title={new Date(event.time).toLocaleString()}
      >
        {timeAgo}
      </span>
    </div>
    <div class="mt-2 flex items-center justify-between">
      <div class="flex items-center gap-2 text-sm">
        <MethodPill method={event.method} />
        <span class="font-mono text-gray-500 dark:text-gray-400"
          >{event.source}</span
        >
      </div>
      {#if event.project !== null}
        <span
          class="inline-flex items-center px-2 py-0.5 rounded-full text-xs font-medium"
          class:bg-indigo-100={event.project.color === "indigo"}
          class:text-indigo-800={event.project.color === "indigo"}
          class:dark:bg-indigo-900={event.project.color === "indigo"}
          class:dark:text-indigo-300={event.project.color === "indigo"}
          class:bg-emerald-100={event.project.color === "emerald"}
          class:text-emerald-800={event.project.color === "emerald"}
          class:dark:bg-emerald-900={event.project.color === "emerald"}
          class:dark:text-emerald-300={event.project.color === "emerald"}
          class:bg-rose-100={event.project.color === "rose"}
          class:text-rose-800={event.project.color === "rose"}
          class:dark:bg-rose-900={event.project.color === "rose"}
          class:dark:text-rose-300={event.project.color === "rose"}
          class:bg-amber-100={event.project.color === "amber"}
          class:text-amber-800={event.project.color === "amber"}
          class:dark:bg-amber-900={event.project.color === "amber"}
          class:dark:text-amber-300={event.project.color === "amber"}
          class:bg-sky-100={event.project.color === "sky"}
          class:text-sky-800={event.project.color === "sky"}
          class:dark:bg-sky-900={event.project.color === "sky"}
          class:dark:text-sky-300={event.project.color === "sky"}
          class:bg-purple-100={event.project.color === "purple"}
          class:text-purple-800={event.project.color === "purple"}
          class:dark:bg-purple-900={event.project.color === "purple"}
          class:dark:text-purple-300={event.project.color === "purple"}
        >
          {event.project.name}
        </span>
      {/if}
    </div>
  </div>
</li>
