import { ss } from '@/utils/storage'

const LOCAL_NAME = 'userStorage'

export interface UserInfo {
  avatar: string
  name: string
  description: string
  axiomai_top_p: number
  axiomai_memory: number
}

export interface UserState {
  userInfo: UserInfo
}

export function defaultSetting(): UserState {
  return {
    userInfo: {
      avatar: 'https://raw.githubusercontent.com/miraz4300/AxiomAI/master/src/assets/avatar.jpg',
      name: 'Miraz Hossain',
      description: 'Give a star on <a href="https://github.com/miraz4300/AxiomAI" class="text-blue-500" target="_blank" >GitHub</a>',
      axiomai_top_p: 50,
      axiomai_memory: 1,
    },
  }
}

export function getLocalState(): UserState {
  const localSetting: UserState | undefined = ss.get(LOCAL_NAME)
  return { ...defaultSetting(), ...localSetting }
}

export function setLocalState(setting: UserState): void {
  ss.set(LOCAL_NAME, setting)
}
