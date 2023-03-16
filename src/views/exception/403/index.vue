<script lang="ts" setup>
import { NButton } from 'naive-ui'
import { useRouter } from 'vue-router'
import Icon500 from '@/icons/403.vue'

const router = useRouter()

function goHome() {
  router.push('/')
}
</script>

<template>
  <div class="flex h-full dark:bg-neutral-800">
    <div class="px-4 m-auto space-y-4 text-center max-[400px]">
      <header class="space-y-2">
        <h2 class="text-2xl font-bold text-center text-slate-800 dark:text-neutral-200">
          Error 403 - Forbidden
        </h2>
        <p class="text-base text-center text-slate-500 dark:text-slate-500">
          You dont have persmission to access on this server.
        </p>
        <div class="flex items-center justify-center text-center">
          <Icon500 class="w-[300px]" />
        </div>
      </header>
      <NButton type="primary" @click="goHome">
        Back to Home
      </NButton>
    </div>
  </div>
</template>
