<script setup lang='ts'>
import { computed, onMounted, ref } from 'vue'
import { NSpin } from 'naive-ui'
import { fetchChatConfig } from '@/api'
import pkg from '@/../package.json'
import { useAuthStore } from '@/store'
interface ConfigState {
  apiModel?: string
  usage?: string
}
const authStore = useAuthStore()
const loading = ref(false)
const config = ref<ConfigState>()
const isChatGPTAPI = computed<boolean>(() => !!authStore.isChatGPTAPI)
async function fetchConfig() {
  try {
    loading.value = true
    const { data } = await fetchChatConfig<ConfigState>()
    config.value = data
  }
  finally {
    loading.value = false
  }
}
onMounted(() => {
  fetchConfig()
})
</script>

<template>
  <NSpin :show="loading">
    <div class="p-4 space-y-4">
      <h2 class="text-2xl font-bold">
        <center> AxiomAI </center>
      </h2>
      <div class="p-2 space-y-2 rounded-md bg-neutral-200 dark:bg-stone-700">
        <center>
          <p>This is an open source project based on the MIT License agreement.</p>
          <p>If you find this project helpful, please give a Star on <a class="text-blue-600 dark:text-blue-500" href="https://github.com/miraz4300/AxiomAI" target="_blank">GitHub.</a></p>
        </center>
      </div>
      <p v-if="isChatGPTAPI">
        {{ $t("setting.api") }}：{{ config?.apiModel ?? '-' }} <br>
        Model：gpt-3.5-turbo <br>
        {{ $t("setting.monthlyUsage") }}：{{ config?.usage ?? '-' }} <br>
        Environment：Development <br>
        Version：{{ pkg.version }} - preview
      </p>
    </div>
  </NSpin>
</template>
