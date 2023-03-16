<script setup lang='ts'>
import pkg from '@/../package.json'
</script>

<template>
  <div class="p-4 space-y-4">
    <h2 class="text-xl font-bold">
      Model : GPT-3.5-turbo
    </h2>
    <div class="p-2 space-y-2 rounded-md bg-neutral-100 dark:bg-neutral-700">
      <p>
        This project is open sourced from
        <a
          class="text-blue-600 dark:text-blue-500"
          href="https://github.com/miraz4300/AxiomAI"
          target="_blank"
        >
          Github
        </a>
        | Based on the MIT License agreement.
      </p>
      <p>
        If you think this project is helpful to you, please give me a star on Github.
      </p>
    </div>
    <p>Preview - {{ pkg.version }}</p>
  </div>
</template>
