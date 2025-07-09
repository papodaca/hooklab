<script>
  import { createEventDispatcher } from "svelte";
  import { projects } from "../../stores.js";
  import { createProject, updateProject, deleteProject } from "../../api.js";
  import { fade, slide } from "svelte/transition";

  const dispatch = createEventDispatcher();

  let newProject = null;
  let editingProject = null;
  let deletingProjectId = null;
  let isSubmitting = false;
  let errorMessage = "";
  let errorTimeout;

  const availableColors = [
    "indigo",
    "emerald",
    "rose",
    "amber",
    "sky",
    "purple",
  ];

  function close() {
    dispatch("close");
  }

  function showError(message) {
    errorMessage = message;
    clearTimeout(errorTimeout);
    errorTimeout = setTimeout(() => {
      errorMessage = "";
    }, 3000);
  }

  function handleCreateProject() {
    newProject = {
      name: "",
      color: "indigo",
    };
  }

  async function handleConfirmCreate() {
    if (!newProject.name.trim()) {
      showError("Project name cannot be empty.");
      return;
    }
    isSubmitting = true;
    try {
      const createdProject = await createProject(newProject);
      projects.update((p) => ({ ...p, data: [createdProject, ...p.data] }));
      newProject = null;
    } catch (error) {
      console.error("Failed to create project:", error);
      showError("Failed to create project. Please try again.");
    } finally {
      isSubmitting = false;
    }
  }

  function handleEdit(project) {
    editingProject = { ...project };
  }

  async function handleConfirmUpdate() {
    if (!editingProject.name.trim()) {
      showError("Project name cannot be empty.");
      return;
    }
    isSubmitting = true;
    try {
      const updated = await updateProject(editingProject);
      projects.update((p) => ({
        ...p,
        data: p.data.map((prj) => (prj.id === updated.id ? updated : prj)),
      }));
      editingProject = null;
    } catch (error) {
      console.error("Failed to update project:", error);
      showError("Failed to update project. Please try again.");
    } finally {
      isSubmitting = false;
    }
  }

  function handleDelete(projectId) {
    deletingProjectId = projectId;
  }

  async function handleConfirmDelete() {
    isSubmitting = true;
    try {
      await deleteProject(deletingProjectId);
      projects.update((p) => ({
        ...p,
        data: p.data.filter((proj) => proj.id !== deletingProjectId),
      }));
      deletingProjectId = null;
    } catch (error) {
      console.error("Failed to delete project:", error);
      showError("Failed to delete project. Please try again.");
    } finally {
      isSubmitting = false;
    }
  }

  function handleCancel() {
    newProject = null;
    editingProject = null;
    deletingProjectId = null;
  }
</script>

<div
  class="fixed inset-0 bg-black/30 backdrop-blur-sm z-50 flex items-center justify-center"
  on:click={close}
>
  <div
    class="bg-white dark:bg-gray-800 rounded-lg shadow-xl p-6 w-full max-w-2xl"
    on:click|stopPropagation
  >
    <div
      class="flex justify-between items-center border-b pb-3 border-gray-200 dark:border-gray-700"
    >
      <h2 class="text-xl font-bold text-gray-900 dark:text-white">
        Manage Projects
      </h2>
      <div class="flex items-center gap-4">
        <button
          on:click={handleCreateProject}
          disabled={!!newProject || !!editingProject || isSubmitting}
          class="px-4 py-2 bg-indigo-600 text-white rounded-md hover:bg-indigo-700 text-sm font-medium disabled:bg-gray-400 disabled:cursor-not-allowed"
        >
          Create Project
        </button>
        <button
          on:click={close}
          class="text-gray-400 hover:text-gray-600 dark:hover:text-gray-200"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="h-6 w-6"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M6 18L18 6M6 6l12 12"
            />
          </svg>
        </button>
      </div>
    </div>
    <div class="mt-4">
      {#if errorMessage}
        <div
          transition:slide|fade
          class="mb-4 p-3 rounded-md bg-red-50 dark:bg-red-900/30 text-red-700 dark:text-red-300 text-sm"
        >
          {errorMessage}
        </div>
      {/if}
      <div class="overflow-x-auto">
        {#if $projects.data.length === 0 && !newProject}
          <div class="text-center py-12">
            <svg xmlns="http://www.w3.org/2000/svg" class="mx-auto h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2H7a2 2 0 00-2 2v2" />
            </svg>
            <h3 class="mt-2 text-sm font-medium text-gray-900 dark:text-white">No Projects</h3>
            <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">Get started by creating a new project.</p>
          </div>
        {:else}
          <table class="min-w-full divide-y divide-gray-200 dark:divide-gray-700">
            <thead class="bg-gray-50 dark:bg-gray-700">
              <tr>
                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">Name</th>
                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">Color</th>
                <th scope="col" class="relative px-6 py-3">
                  <span class="sr-only">Actions</span>
                </th>
              </tr>
            </thead>
            <tbody class="bg-white dark:bg-gray-800 divide-y divide-gray-200 dark:divide-gray-700">
              {#if newProject}
                <tr transition:slide={{ duration: 200 }}>
                  <td class="px-6 py-4 whitespace-nowrap">
                    <input type="text" bind:value={newProject.name} placeholder="Project Name" class="w-full bg-gray-50 dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-md px-3 py-2 text-sm text-gray-900 dark:text-white focus:ring-indigo-500 focus:border-indigo-500">
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap">
                    <select bind:value={newProject.color} class="w-full bg-gray-50 dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-md px-3 py-2 text-sm text-gray-900 dark:text-white focus:ring-indigo-500 focus:border-indigo-500">
                      {#each availableColors as color}
                        <option value={color}>{color.charAt(0).toUpperCase() + color.slice(1)}</option>
                      {/each}
                    </select>
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                    <button on:click={handleConfirmCreate} disabled={isSubmitting} class="text-green-600 hover:text-green-900 dark:text-green-400 dark:hover:text-green-200 disabled:opacity-50">
                      {isSubmitting ? 'Saving...' : 'Confirm'}
                    </button>
                    <button on:click={handleCancel} disabled={isSubmitting} class="ml-4 text-gray-600 hover:text-gray-900 dark:text-gray-400 dark:hover:text-gray-200 disabled:opacity-50">Cancel</button>
                  </td>
                </tr>
              {/if}
              {#each $projects.data as project (project.id)}
                {#if editingProject && editingProject.id === project.id}
                  <tr transition:slide={{ duration: 200 }}>
                    <td class="px-6 py-4 whitespace-nowrap">
                      <input type="text" bind:value={editingProject.name} class="w-full bg-gray-50 dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-md px-3 py-2 text-sm text-gray-900 dark:text-white focus:ring-indigo-500 focus:border-indigo-500">
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap">
                      <select bind:value={editingProject.color} class="w-full bg-gray-50 dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-md px-3 py-2 text-sm text-gray-900 dark:text-white focus:ring-indigo-500 focus:border-indigo-500">
                        {#each availableColors as color}
                          <option value={color}>{color.charAt(0).toUpperCase() + color.slice(1)}</option>
                        {/each}
                      </select>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                      <button on:click={handleConfirmUpdate} disabled={isSubmitting} class="text-green-600 hover:text-green-900 dark:text-green-400 dark:hover:text-green-200 disabled:opacity-50">
                        {isSubmitting ? 'Saving...' : 'Confirm'}
                      </button>
                      <button on:click={handleCancel} disabled={isSubmitting} class="ml-4 text-gray-600 hover:text-gray-900 dark:text-gray-400 dark:hover:text-gray-200 disabled:opacity-50">Cancel</button>
                    </td>
                  </tr>
                {:else}
                  <tr>
                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900 dark:text-white">{project.name}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-300">
                      <span class="flex items-center">
                      <span class="w-4 h-4 rounded-full mr-2" class:bg-indigo-500={project.color === 'indigo'} class:bg-emerald-500={project.color === 'emerald'} class:bg-rose-500={project.color === 'rose'} class:bg-amber-500={project.color === 'amber'} class:bg-sky-500={project.color === 'sky'} class:bg-purple-500={project.color === 'purple'}></span>
                      {project.color}
                    </span>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                      {#key deletingProjectId}
                        {#if deletingProjectId === project.id}
                          <div in:fade={{ duration: 150 }} out:fade={{ duration: 150 }}>
                            <span class="text-gray-600 dark:text-gray-300">Delete?</span>
                            <button on:click={handleConfirmDelete} disabled={isSubmitting} class="ml-4 text-red-600 hover:text-red-900 dark:text-red-400 dark:hover:text-red-200 disabled:opacity-50">Yes</button>
                            <button on:click={handleCancel} disabled={isSubmitting} class="ml-2 text-gray-600 hover:text-gray-900 dark:text-gray-400 dark:hover:text-gray-200 disabled:opacity-50">No</button>
                          </div>
                        {:else}
                          <div in:fade={{ duration: 150 }} out:fade={{ duration: 150 }}>
                            <button on:click={() => handleEdit(project)} disabled={!!editingProject || !!newProject || isSubmitting || !!deletingProjectId} class="text-indigo-600 hover:text-indigo-900 dark:text-indigo-400 dark:hover:text-indigo-200 disabled:opacity-50">Edit</button>
                            <button on:click={() => handleDelete(project.id)} disabled={!!editingProject || !!newProject || isSubmitting || !!deletingProjectId} class="ml-4 text-red-600 hover:text-red-900 dark:text-red-400 dark:hover:text-red-200 disabled:opacity-50">Delete</button>
                          </div>
                        {/if}
                      {/key}
                    </td>
                  </tr>
                {/if}
              {/each}
            </tbody>
          </table>
        {/if}
      </div>
    </div>
  </div>
</div>
