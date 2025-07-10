<script>
  import { onMount } from "svelte";
  import { projects, selectedProject } from "../../stores.js";
  import ManageProjectsModal from "./ManageProjectsModal.svelte";
  import { List } from "@lucide/svelte";

  let showModal = false;

  onMount(() => {
    projects.fetchProjects();
  });

  function selectProject(project) {
    selectedProject.set(project);
  }
</script>

<div class="p-4 border-t border-gray-200 dark:border-gray-700">
  <div class="flex justify-between items-center mb-2">
    <h2 class="text-lg font-bold text-gray-900 dark:text-white">Projects</h2>
    <button
      on:click={() => (showModal = true)}
      class="text-sm font-medium text-indigo-600 hover:text-indigo-500 dark:text-indigo-400 dark:hover:text-indigo-300"
    >
      Manage
    </button>
  </div>
  <ul id="project-list" class="space-y-1">
    <button
      on:click={() => selectProject(null)}
      on:keydown={(e) => e.key === "Enter" && selectProject(null)}
      class="project-item flex items-center px-3 py-2 text-sm font-medium rounded-md w-full"
      class:bg-gray-100={!$selectedProject}
      class:dark:bg-gray-700={!$selectedProject}
      class:text-gray-900={!$selectedProject}
      class:dark:text-white={!$selectedProject}
      class:text-gray-600={$selectedProject}
      class:dark:text-gray-300={$selectedProject}
      class:hover:bg-gray-50={$selectedProject}
      class:dark:hover:bg-gray-700={$selectedProject}
      class:dark:hover:bg-opacity-50={$selectedProject}
    >
      <List class="w-4 h-4 mr-2.5" />
      <span class="truncate">All Projects</span>
    </button>
    {#each $projects.data as project (project.id)}
      <li>
        <button
          on:click={() => selectProject(project)}
          on:keydown={(e) => e.key === "Enter" && selectProject(project)}
          class="project-item flex items-center px-3 py-2 text-sm font-medium rounded-md w-full"
          class:bg-gray-100={$selectedProject?.id === project.id}
          class:dark:bg-gray-700={$selectedProject?.id === project.id}
          class:text-gray-900={$selectedProject?.id === project.id}
          class:dark:text-white={$selectedProject?.id === project.id}
          class:text-gray-600={$selectedProject?.id !== project.id}
          class:dark:text-gray-300={$selectedProject?.id !== project.id}
          class:hover:bg-gray-50={$selectedProject?.id !== project.id}
          class:dark:hover:bg-gray-700={$selectedProject?.id !== project.id}
          class:dark:hover:bg-opacity-50={$selectedProject?.id !== project.id}
          data-project-name={project.name}
        >
          <span
            class="w-2 h-2 mr-3 rounded-full flex-shrink-0"
            class:bg-indigo-500={project.color === "indigo"}
            class:bg-emerald-500={project.color === "emerald"}
            class:bg-rose-500={project.color === "rose"}
            class:bg-amber-500={project.color === "amber"}
            class:bg-sky-500={project.color === "sky"}
            class:bg-purple-500={project.color === "purple"}
          ></span>
          <span class="truncate">{project.name}</span>
        </button>
      </li>
    {/each}
  </ul>
</div>

{#if showModal}
  <ManageProjectsModal on:close={() => (showModal = false)} />
{/if}
