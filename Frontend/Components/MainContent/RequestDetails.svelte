<script>
  export let headers;
  export let body;
  export let params;

  let formattedBody = body;
  try {
    // Try to parse and prettify if it's JSON
    const parsed = JSON.parse(body);
    formattedBody = JSON.stringify(parsed, null, 2);
  } catch (e) {
    // Not JSON, leave as is
  }
</script>

<div class="p-4">
  <div class="flex flex-wrap -mx-3">
    {#if params && Object.keys(params).length > 0}
      <div class="w-full md:w-1/2 px-3 mb-6">
        <h3 class="text-lg font-semibold text-gray-900 dark:text-white mb-2 border-b border-gray-200 dark:border-gray-700 pb-2">Query Parameters</h3>
        <div class="overflow-x-auto">
          <table class="min-w-full text-sm text-left text-gray-500 dark:text-gray-400">
            <thead class="text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400">
              <tr>
                <th scope="col" class="px-4 py-2">Key</th>
                <th scope="col" class="px-4 py-2">Value</th>
              </tr>
            </thead>
            <tbody>
              {#each Object.entries(params) as [key, value]}
                <tr class="bg-white border-b dark:bg-gray-800 dark:border-gray-700">
                  <th scope="row" class="px-4 py-2 font-medium text-gray-900 dark:text-white whitespace-nowrap">{key}</th>
                  <td class="px-4 py-2 font-mono">{value}</td>
                </tr>
              {/each}
            </tbody>
          </table>
        </div>
      </div>
    {/if}

    <div class="w-full md:w-1/2 px-3 mb-6">
      <h3 class="text-lg font-semibold text-gray-900 dark:text-white mb-2 border-b border-gray-200 dark:border-gray-700 pb-2">Headers</h3>
      <div class="overflow-x-auto">
        <table class="min-w-full text-sm text-left text-gray-500 dark:text-gray-400">
          <thead class="text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400">
            <tr>
              <th scope="col" class="px-4 py-2">Key</th>
              <th scope="col" class="px-4 py-2">Value</th>
            </tr>
          </thead>
          <tbody>
            {#each Object.entries(headers || {}) as [key, value]}
              <tr class="bg-white border-b dark:bg-gray-800 dark:border-gray-700">
                <th scope="row" class="px-4 py-2 font-medium text-gray-900 dark:text-white whitespace-nowrap">{key}</th>
                <td class="px-4 py-2 font-mono">{value}</td>
              </tr>
            {/each}
          </tbody>
        </table>
      </div>
    </div>
  </div>

  <div>
    <h3 class="text-lg font-semibold text-gray-900 dark:text-white mb-2 border-b border-gray-200 dark:border-gray-700 pb-2">Body</h3>
    {#if formattedBody}
      <pre class="bg-gray-50 dark:bg-gray-900 p-4 rounded-md overflow-x-auto text-sm text-gray-800 dark:text-gray-200 font-mono">{formattedBody}</pre>
    {:else}
      <p class="text-gray-500 dark:text-gray-400">No body provided.</p>
    {/if}
  </div>
</div>
