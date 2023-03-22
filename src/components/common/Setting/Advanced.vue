<script lang="ts" setup>
import { computed, ref } from 'vue'
import { NButton, NInput, NRadioButton, NRadioGroup, NSlider, useMessage } from 'naive-ui'
import { useSettingStore, useUserStore } from '@/store'
import type { SettingsState } from '@/store/modules/settings/helper'
import type { UserInfo } from '@/store/modules/user/helper'
import { t } from '@/locales'

const settingStore = useSettingStore()
const userStore = useUserStore()
const userInfo = computed(() => userStore.userInfo)

const axiomai_top_p = ref(userInfo.value.axiomai_top_p ?? 100)
const axiomai_memory = ref(userInfo.value.axiomai_memory ?? 100)

const ms = useMessage()

function updateChatgptParams(options: Partial<UserInfo>) {
  userStore.updateUserInfo(options)
  ms.success(t('common.success'))
}

const systemMessage = ref(settingStore.systemMessage ?? '')
function updateSettings(options: Partial<SettingsState>) {
  settingStore.updateSetting(options)
  ms.success(t('common.success'))
}
function handleReset() {
  settingStore.resetSetting()
  ms.success(t('common.success'))
  window.location.reload()
}
</script>

<template>
  <div class="p-4 space-y-5 min-h-[200px]">
    <div class="space-y-6">
      <div class="flex flex-wrap items-center gap-4">
        <span class="flex-shrink-0 w-[100px]">{{ $t('setting.memory_title') }}</span>
        <div class="w-[300px]">
          <NSlider
            v-model:value="axiomai_memory"
            :marks="{
              1: $t('setting.memory1'),
              50: $t('setting.memory2'),
              99: $t('setting.memory3'),
            }"
            step="mark"
            @update:value="updateChatgptParams({ axiomai_memory })"
          />
        </div>
      </div>
      <div class="flex flex-wrap items-center gap-4">
        <span class="flex-shrink-0 w-[100px]" />
        <div class="w-[300px]  text-gray-500">
          {{ $t('setting.memory_memo') }}
        </div>
      </div>
      <div class="flex flex-wrap items-center gap-4">
        <span class="flex-shrink-0 w-[100px]">{{ $t('setting.top_p_title') }}</span>
        <div class="w-[400px] text-gray-500">
          <NRadioGroup
            v-model:value="axiomai_top_p"
            name="radiobuttongroup2"
            size="medium"
            @update:value="updateChatgptParams({ axiomai_top_p })"
          >
            <NRadioButton
              :key="0"
              :value="0"
            >
              {{ $t('setting.top_p1') }}
            </NRadioButton>
            <NRadioButton
              :key="50"
              :value="50"
            >
              {{ $t('setting.top_p2') }}
            </NRadioButton>
            <NRadioButton
              :key="100"
              :value="100"
            >
              {{ $t('setting.top_p3') }}
            </NRadioButton>
          </NRadioGroup>
        </div>
      </div>
      <div class="flex flex-wrap items-center gap-4">
        <span class="flex-shrink-0 w-[100px]" />
        <div class="w-[400px] text-gray-500">
          <span v-if="0 === axiomai_top_p">
            {{ $t('setting.top_p1_info') }}
          </span>
          <span v-else-if="50 === axiomai_top_p">
            {{ $t('setting.top_p2_info') }}
          </span>
          <span v-else>
            {{ $t('setting.top_p3_info') }}
          </span>
        </div>
      </div>
      <div class="flex flex-wrap items-center gap-4">
        <span class="flex-shrink-0 w-[100px]">{{ $t('setting.role') }}</span>
        <div class="flex-1">
          <NInput v-model:value="systemMessage" placeholder="" />
        </div>
        <NButton size="tiny" text type="primary" @click="updateSettings({ systemMessage })">
          {{ $t('common.save') }}
        </NButton>
      </div>
      <div class="flex flex-wrap items-center gap-4">
        <span class="flex-shrink-0 w-[100px]">&nbsp;</span>
        <NButton size="small" @click="handleReset">
          {{ $t('common.reset') }}
        </NButton>
      </div>
    </div>
  </div>
</template>
