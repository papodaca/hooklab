<script>
  import ProjectsList from './Sidebar/ProjectsList.svelte';
  import EventsList from './Sidebar/EventsList.svelte';
</script>

<aside class="w-1/3 xl:w-1/4 bg-white dark:bg-gray-800 border-r border-gray-200 dark:border-gray-700 flex flex-col">
  <EventsList />
  <ProjectsList />
</aside>
