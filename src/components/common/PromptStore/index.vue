<script setup lang='ts'>
import type { DataTableColumns } from 'naive-ui'
import { computed, h, ref, watch } from 'vue'
import { NButton, NCard, NDataTable, NDivider, NInput, NLayoutContent, NMessageProvider, NModal, NPopconfirm, NSpace, NTabPane, NTabs, useMessage } from 'naive-ui'
import PromptRecommend from '../../../assets/recommend.json'
import { SvgIcon } from '..'
import { usePromptStore } from '@/store'
import { useBasicLayout } from '@/hooks/useBasicLayout'
import { t } from '@/locales'

interface DataProps {
  renderKey: string
  renderValue: string
  key: string
  value: string
}

interface Props {
  visible: boolean
}

interface Emit {
  (e: 'update:visible', visible: boolean): void
}

const props = defineProps<Props>()

const emit = defineEmits<Emit>()

const message = useMessage()

const show = computed({
  get: () => props.visible,
  set: (visible: boolean) => emit('update:visible', visible),
})

const showModal = ref(false)

const importLoading = ref(false)
const exportLoading = ref(false)

const searchValue = ref<string>('')

// Mobile Responsive
const { isMobile } = useBasicLayout()

const promptStore = usePromptStore()

// Import the recommended list online in Prompt and modify it according to the preferences of the deployer (assets/recommend.json)
const promptRecommendList = PromptRecommend
const promptList = ref<any>(promptStore.promptList)

// Temporary prompt parameters used for adding or modifying
const tempPromptKey = ref('')
const tempPromptValue = ref('')

// Modal mode, rendering different Modal content according to different modes
const modalMode = ref('')

// This is for later modification of the Prompt content, because it needs to be modified for the list without uuid, and considering that there cannot be conflicts between the title and the content, a temporary item is needed to record it
const tempModifiedItem = ref<any>({})

// A Modal is used for adding, modifying and importing. TempPromptKey is used to temporarily modify the content, and the content is clear before switching states.
const changeShowModal = (mode: 'add' | 'modify' | 'local_import', selected = { key: '', value: '' }) => {
  if (mode === 'add') {
    tempPromptKey.value = ''
    tempPromptValue.value = ''
  }
  else if (mode === 'modify') {
    tempModifiedItem.value = { ...selected }
    tempPromptKey.value = selected.key
    tempPromptValue.value = selected.value
  }
  else if (mode === 'local_import') {
    tempPromptKey.value = 'local_import'
    tempPromptValue.value = ''
  }
  showModal.value = !showModal.value
  modalMode.value = mode
}

// Online import related
const downloadURL = ref('')
const downloadDisabled = computed(() => downloadURL.value.trim().length < 1)
const setDownloadURL = (url: string) => {
  downloadURL.value = url
}

// control input button
const inputStatus = computed (() => tempPromptKey.value.trim().length < 1 || tempPromptValue.value.trim().length < 1)

// Prompt template related operations
const addPromptTemplate = () => {
  for (const i of promptList.value) {
    if (i.key === tempPromptKey.value) {
      message.error(t('store.addRepeatTitleTips'))
      return
    }
    if (i.value === tempPromptValue.value) {
      message.error(t('store.addRepeatContentTips', { msg: tempPromptKey.value }))
      return
    }
  }
  promptList.value.unshift({ key: tempPromptKey.value, value: tempPromptValue.value } as never)
  message.success(t('common.addSuccess'))
  changeShowModal('add')
}

const modifyPromptTemplate = () => {
  let index = 0

  // Extract the items to be modified through the temporary index
  for (const i of promptList.value) {
    if (i.key === tempModifiedItem.value.key && i.value === tempModifiedItem.value.value)
      break
    index = index + 1
  }

  const tempList = promptList.value.filter((_: any, i: number) => i !== index)

  // Search for conflicting parts
  for (const i of tempList) {
    if (i.key === tempPromptKey.value) {
      message.error(t('store.editRepeatTitleTips'))
      return
    }
    if (i.value === tempPromptValue.value) {
      message.error(t('store.editRepeatContentTips', { msg: i.key }))
      return
    }
  }

  promptList.value = [{ key: tempPromptKey.value, value: tempPromptValue.value }, ...tempList] as never
  message.success(t('common.editSuccess'))
  changeShowModal('modify')
}

const deletePromptTemplate = (row: { key: string; value: string }) => {
  promptList.value = [
    ...promptList.value.filter((item: { key: string; value: string }) => item.key !== row.key),
  ] as never
  message.success(t('common.deleteSuccess'))
}

const clearPromptTemplate = () => {
  promptList.value = []
  message.success(t('common.clearSuccess'))
}

const importPromptTemplate = () => {
  try {
    const jsonData = JSON.parse(tempPromptValue.value)
    let key = ''
    let value = ''
    // A key that can be extended to add more template dictionaries
    if ('key' in jsonData[0]) {
      key = 'key'
      value = 'value'
    }
    else if ('act' in jsonData[0]) {
      key = 'act'
      value = 'prompt'
    }
    else {
      // Unsupported dictionary keys prevent importing so as not to break prompt store opening
      message.warning('prompt key not supported.')
      throw new Error('prompt key not supported.')
    }

    for (const i of jsonData) {
      if (!('key' in i) || !('value' in i))
        throw new Error(t('store.importError'))
      let safe = true
      for (const j of promptList.value) {
        if (j.key === i[key]) {
          message.warning(t('store.importRepeatTitle', { msg: i[key] }))
          safe = false
          break
        }
        if (j.value === i[value]) {
          message.warning(t('store.importRepeatContent', { msg: i[key] }))
          safe = false
          break
        }
      }
      if (safe)
        promptList.value.unshift({ key: i[key], value: i[value] } as never)
    }
    message.success(t('common.importSuccess'))
  }
  catch {
    message.error('JSON 格式错误，请检查 JSON 格式')
  }
}

// template export
const exportPromptTemplate = () => {
  exportLoading.value = true
  const jsonDataStr = JSON.stringify(promptList.value)
  const blob = new Blob([jsonDataStr], { type: 'application/json' })
  const url = URL.createObjectURL(blob)
  const link = document.createElement('a')
  link.href = url
  link.download = 'ChatGPTPromptTemplate.json'
  link.click()
  URL.revokeObjectURL(url)
  exportLoading.value = false
}

// Template online import
const downloadPromptTemplate = async () => {
  try {
    importLoading.value = true
    const response = await fetch(downloadURL.value)
    const jsonData = await response.json()
    if ('key' in jsonData[0] && 'value' in jsonData[0])
      tempPromptValue.value = JSON.stringify(jsonData)
    if ('act' in jsonData[0] && 'prompt' in jsonData[0]) {
      const newJsonData = jsonData.map((item: { act: string; prompt: string }) => {
        return {
          key: item.act,
          value: item.prompt,
        }
      })
      tempPromptValue.value = JSON.stringify(newJsonData)
    }
    importPromptTemplate()
    downloadURL.value = ''
  }
  catch {
    message.error(t('store.downloadError'))
    downloadURL.value = ''
  }
  finally {
    importLoading.value = false
  }
}

// Adaptive related to mobile terminal
const renderTemplate = () => {
  const [keyLimit, valueLimit] = isMobile.value ? [6, 9] : [15, 50]

  return promptList.value.map((item: { key: string; value: string }) => {
    return {
      renderKey: item.key.length <= keyLimit ? item.key : `${item.key.substring(0, keyLimit)}...`,
      renderValue: item.value.length <= valueLimit ? item.value : `${item.value.substring(0, valueLimit)}...`,
      key: item.key,
      value: item.value,
    }
  })
}

const pagination = computed(() => {
  const [pageSize, pageSlot] = isMobile.value ? [6, 5] : [7, 15]
  return {
    pageSize, pageSlot,
  }
})

// table-related
const createColumns = (): DataTableColumns<DataProps> => {
  return [
    {
      title: t('store.title'),
      key: 'renderKey',
    },
    {
      title: t('store.description'),
      key: 'renderValue',
    },
    {
      title: t('common.action'),
      key: 'actions',
      width: 100,
      align: 'center',
      render(row) {
        return h('div', { class: 'flex items-center flex-col gap-2' }, {
          default: () => [h(
            NButton,
            {
              tertiary: true,
              size: 'small',
              type: 'info',
              onClick: () => changeShowModal('modify', row),
            },
            { default: () => t('common.edit') },
          ),
          h(
            NButton,
            {
              tertiary: true,
              size: 'small',
              type: 'error',
              onClick: () => deletePromptTemplate(row),
            },
            { default: () => t('common.delete') },
          ),
          ],
        })
      },
    },
  ]
}

const columns = createColumns()

watch(
  () => promptList,
  () => {
    promptStore.updatePromptList(promptList.value)
  },
  { deep: true },
)

const dataSource = computed(() => {
  const data = renderTemplate()
  const value = searchValue.value
  if (value && value !== '') {
    return data.filter((item: DataProps) => {
      return item.renderKey.includes(value) || item.renderValue.includes(value)
    })
  }
  return data
})
</script>

<template>
  <NMessageProvider>
    <NModal v-model:show="show" style="width: 90%; max-width: 900px;" preset="card">
      <div class="space-y-4">
        <NTabs type="segment">
          <NTabPane name="local" :tab="$t('store.local')">
            <div
              class="flex gap-3"
              :class="[isMobile ? 'flex-col' : 'flex-row justify-between']"
            >
              <div class="flex items-center space-x-4">
                <NButton
                  type="primary"
                  size="small"
                  @click="changeShowModal('add')"
                >
                  {{ $t('common.add') }}
                </NButton>
                <NButton
                  size="small"
                  @click="changeShowModal('local_import')"
                >
                  {{ $t('common.import') }}
                </NButton>
                <NButton
                  size="small"
                  :loading="exportLoading"
                  @click="exportPromptTemplate()"
                >
                  {{ $t('common.export') }}
                </NButton>
                <NPopconfirm @positive-click="clearPromptTemplate">
                  <template #trigger>
                    <NButton size="small">
                      {{ $t('common.clear') }}
                    </NButton>
                  </template>
                  {{ $t('store.clearStoreConfirm') }}
                </NPopconfirm>
              </div>
              <div class="flex items-center">
                <NInput v-model:value="searchValue" style="width: 100%" />
              </div>
            </div>
            <br>
            <NDataTable
              :max-height="400"
              :columns="columns"
              :data="dataSource"
              :pagination="pagination"
              :bordered="false"
            />
          </NTabPane>
          <NTabPane name="download" :tab="$t('store.online')">
            <p class="mb-4">
              {{ $t('store.onlineImportWarning') }}
            </p>
            <div class="flex items-center gap-4">
              <NInput v-model:value="downloadURL" placeholder="" />
              <NButton
                strong
                secondary
                :disabled="downloadDisabled"
                :loading="importLoading"
                @click="downloadPromptTemplate()"
              >
                {{ $t('common.download') }}
              </NButton>
            </div>
            <NDivider />
            <NLayoutContent
              style="height: 360px"
              content-style="background: none;"
              :native-scrollbar="false"
            >
              <NCard
                v-for="info in promptRecommendList"
                :key="info.key" :title="info.key"
                style="margin: 5px;"
                embedded
                :bordered="true"
              >
                <p
                  class="overflow-hidden text-ellipsis whitespace-nowrap"
                  :title="info.desc"
                >
                  {{ info.desc }}
                </p>
                <template #footer>
                  <div class="flex items-center justify-end space-x-4">
                    <NButton text>
                      <a
                        :href="info.url"
                        target="_blank"
                      >
                        <SvgIcon class="text-xl" icon="ri:link" />
                      </a>
                    </NButton>
                    <NButton text @click="setDownloadURL(info.downloadUrl) ">
                      <SvgIcon class="text-xl" icon="ri:add-fill" />
                    </NButton>
                  </div>
                </template>
              </NCard>
            </NLayoutContent>
          </NTabPane>
        </NTabs>
      </div>
    </NModal>
    <NModal v-model:show="showModal" style="width: 90%; max-width: 600px;" preset="card">
      <NSpace v-if="modalMode === 'add' || modalMode === 'modify'" vertical>
        {{ t('store.title') }}
        <NInput v-model:value="tempPromptKey" />
        {{ t('store.description') }}
        <NInput v-model:value="tempPromptValue" type="textarea" />
        <NButton
          block
          type="primary"
          :disabled="inputStatus"
          @click="() => { modalMode === 'add' ? addPromptTemplate() : modifyPromptTemplate() }"
        >
          {{ t('common.confirm') }}
        </NButton>
      </NSpace>
      <NSpace v-if="modalMode === 'local_import'" vertical>
        <NInput
          v-model:value="tempPromptValue"
          :placeholder="t('store.importPlaceholder')"
          :autosize="{ minRows: 3, maxRows: 15 }"
          type="textarea"
        />
        <NButton
          block
          type="primary"
          :disabled="inputStatus"
          @click="() => { importPromptTemplate() }"
        >
          {{ t('common.import') }}
        </NButton>
      </NSpace>
    </NModal>
  </NMessageProvider>
</template>
