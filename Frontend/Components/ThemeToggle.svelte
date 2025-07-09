<script>
  import { theme } from '../stores.js';

  function toggleTheme() {
    theme.update(current => (current === 'light' ? 'dark' : 'light'));
  }
</script>

<button
  on:click={toggleTheme}
  class="p-2 rounded-full text-gray-500 dark:text-gray-400 hover:bg-gray-100 dark:hover:bg-gray-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 dark:focus:ring-offset-gray-900"
>
  {#if $theme === 'light'}
    <svg class="h-5 w-5" fill="currentColor" viewBox="0 0 20 20">
      <path d="M17.293 13.293A8 8 0 016.707 2.707a8.001 8.001 0 1010.586 10.586z"></path>
    </svg>
  {:else}
    <svg class="h-5 w-5" fill="currentColor" viewBox="0 0 20 20">
      <path
        d="M10 2a1 1 0 011 1v1a1 1 0 11-2 0V3a1 1 0 011-1zm4 8a4 4 0 11-8 0 4 4 0 018 0zm-.464 4.95l.707.707a1 1 0 001.414-1.414l-.707-.707a1 1 0 00-1.414 1.414zm2.12-10.607a1 1 0 010 1.414l-.706.707a1 1 0 11-1.414-1.414l.707-.707a1 1 0 011.414 0zM17 11a1 1 0 100-2h-1a1 1 0 100 2h1zm-7 4a1 1 0 011 1v1a1 1 0 11-2 0v-1a1 1 0 011-1zM5.05 14.464A1 1 0 106.465 13.05l-.707-.707a1 1 0 00-1.414 1.414l.707.707zM5 11a1 1 0 100-2H4a1 1 0 100 2h1zM8 16a1 1 0 011-1h2a1 1 0 110 2H9a1 1 0 01-1-1zM3 10a1 1 0 01-1-1V7a1 1 0 112 0v2a1 1 0 01-1 1zm14-1V7a1 1 0 112 0v2a1 1 0 11-2 0z"
        fill-rule="evenodd"
        clip-rule="evenodd"
      ></path>
    </svg>
  {/if}
</button>
