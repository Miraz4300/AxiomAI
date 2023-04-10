<script setup lang='ts'>
import pkg from '@/../package.json'
</script>

<template>
  <div class="p-4 space-y-4">
    <h2 class="text-2xl font-bold">
      <center> AxiomAI </center>
    </h2>
    <div class="p-2 space-y-2 rounded-md bg-neutral-200 dark:bg-stone-700">
      <center>
        <p>
          AxiomAI is an advanced language model based on GPT-3 that provides cutting-edge natural language processing capabilities to businesses.
          It can be integrated into various applications and platforms to enhance customer interaction, automate tasks, and improve productivity.
          With AxiomAI, businesses can unlock new opportunities for data analysis, decision-making, and innovation.
        </p>
      </center>
    </div>
    <p>
      Environment: Production <br>
      Version: {{ pkg.version }} - production
    </p>
  </div>
</template>
