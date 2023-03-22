import { computed } from 'vue'
import { enGB, enUS } from 'naive-ui'
import { useAppStore } from '@/store'
import { setLocale } from '@/locales'

export function useLanguage() {
  const appStore = useAppStore()

  const language = computed(() => {
    switch (appStore.language) {
      case 'en-US':
        setLocale('en-US')
        return enUS
      case 'bn-BD':
        setLocale('bn-BD')
        return enGB
      default:
        setLocale('en-US')
        return enUS
    }
  })

  return { language }
}
