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
          AxiomAI is an advanced language model based on GPT-3 that provides cutting-edge natural language processing
          capabilities to businesses.
          With AxiomAI, businesses can unlock new opportunities for data analysis, decision-making, and innovation.
        </p>
      </center>
    </div>
    <p>
      <a class="text-[#0083A0] dark:text-[#00B2DB]">Environment:</a> Production <br>
      <a class="text-[#0083A0] dark:text-[#00B2DB]">Version:</a> {{ pkg.version }} - production
    </p>
    <div class="grid grid-cols-4 gap-4">
      <div class="col-span-3">
        <p>
          If you have found this project to be beneficial, please consider making a modest donation to assist with the
          costs of maintaining the server and ensuring that the project remains operational. <br>
          <br>
          For collaboration or business query, please contact me <a class="text-blue-600 dark:text-blue-500" href="mailto:miraz4300@gmail.com">here</a>
        </p>
      </div>
      <div class="col-span-1 flex justify-end">
        <img src="src/assets/bKash.svg" alt="Donate with bKash" class="w-40 border-2 border-black">
      </div>
    </div>
  </div>
</template>
