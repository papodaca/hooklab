<script>
  import { projects, selectedProject } from '../../stores.js';

  function selectProject(projectName) {
    selectedProject.set(projectName);
    projects.update(items =>
      items.map(p => ({ ...p, active: p.name === projectName }))
    );
  }
</script>

<div class="p-4 border-t border-gray-200 dark:border-gray-700">
  <h2 class="mb-2 text-lg font-bold text-gray-900 dark:text-white">Projects</h2>
  <ul id="project-list" class="space-y-1">
    {#each $projects as project}
      <li>
        <div
          role="button"
          tabindex="0"
          on:click={() => selectProject(project.name)}
          on:keydown={(e) => e.key === 'Enter' && selectProject(project.name)}
          class="project-item flex items-center px-3 py-2 text-sm font-medium rounded-md"
          class:bg-gray-100={project.active}
          class:dark:bg-gray-700={project.active}
          class:text-gray-900={project.active}
          class:dark:text-white={project.active}
          class:text-gray-600={!project.active}
          class:dark:text-gray-300={!project.active}
          class:hover:bg-gray-50={!project.active}
          class:dark:hover:bg-gray-700={!project.active}
          class:dark:hover:bg-opacity-50={!project.active}
          data-project-name={project.name}
        >
          {#if project.name === 'All Projects'}
            <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 mr-2.5" viewBox="0 0 20 20" fill="currentColor">
              <path d="M7 3a1 1 0 000 2h6a1 1 0 100-2H7zM4 7a1 1 0 011-1h10a1 1 0 110 2H5a1 1 0 01-1-1zM2 11a1 1 0 011-1h14a1 1 0 110 2H3a1 1 0 01-1-1z" />
            </svg>
          {:else}
            <span
              class="w-2 h-2 mr-3 rounded-full flex-shrink-0"
              class:bg-indigo-500={project.color === 'indigo'}
              class:bg-emerald-500={project.color === 'emerald'}
              class:bg-rose-500={project.color === 'rose'}
            ></span>
          {/if}
          <span class="truncate">{project.name}</span>
        </div>
      </li>
    {/each}
  </ul>
</div>
