<script>
  let { method } = $props();
</script>

<span
  class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-bold"
  class:bg-green-100={method === "GET"}
  class:text-green-800={method === "GET"}
  class:dark:bg-green-900={method === "GET"}
  class:dark:text-green-300={method === "GET"}
  class:bg-blue-100={method === "POST"}
  class:text-blue-800={method === "POST"}
  class:dark:bg-blue-900={method === "POST"}
  class:dark:text-blue-300={method === "POST"}
  class:bg-orange-100={method === "PUT"}
  class:text-orange-800={method === "PUT"}
  class:dark:bg-orange-900={method === "PUT"}
  class:dark:text-orange-300={method === "PUT"}
  class:bg-red-100={method === "DELETE"}
  class:text-red-800={method === "DELETE"}
  class:dark:bg-red-900={method === "DELETE"}
  class:dark:text-red-300={method === "DELETE"}>{method}</span
>
