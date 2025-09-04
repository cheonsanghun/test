<template>
  <v-container fluid class="chat-page pa-0">
    <v-row no-gutters>
      <!-- Sidebar -->
      <v-col cols="12" md="4" class="chat-sidebar d-flex flex-column">
        <div class="user-bar d-flex align-center pa-4">
          <v-avatar size="40"><v-icon color="primary">mdi-account</v-icon></v-avatar>
          <div class="ml-3">
            <div class="text-subtitle-1 font-weight-medium">김서연</div>
            <div class="text-caption text-primary">온라인</div>
          </div>
          <v-spacer />
          <v-btn icon variant="text"><v-icon>mdi-dots-vertical</v-icon></v-btn>
        </div>
        <v-divider />
        <v-text-field
          v-model="query"
          placeholder="검색"
          prepend-inner-icon="mdi-magnify"
          variant="solo"
          density="comfortable"
          hide-details
          class="ma-4"
        />
        <v-list class="flex-grow-1 overflow-y-auto">
          <v-list-item
            v-for="item in chats"
            :key="item.id"
            @click="openChat(item)"
            lines="two"
          >
            <template #prepend>
              <v-avatar size="40"><v-icon color="primary">mdi-account</v-icon></v-avatar>
            </template>
            <v-list-item-title>{{ item.name }}</v-list-item-title>
            <v-list-item-subtitle>{{ item.last }}</v-list-item-subtitle>
          </v-list-item>
        </v-list>
      </v-col>

      <!-- Conversation -->
      <v-col cols="12" md="8" class="chat-main d-flex flex-column">
        <div class="chat-header d-flex align-center pa-4">
          <v-avatar size="40"><v-icon color="primary">mdi-account</v-icon></v-avatar>
          <div class="ml-3">
            <div class="text-subtitle-1 font-weight-medium">{{ current.name }}</div>
            <div class="text-caption text-grey">온라인</div>
          </div>
          <v-spacer />
          <v-btn icon variant="text"><v-icon>mdi-magnify</v-icon></v-btn>
          <v-btn icon variant="text"><v-icon>mdi-phone</v-icon></v-btn>
          <v-btn icon variant="text"><v-icon>mdi-video</v-icon></v-btn>
        </div>
        <v-divider />
        <div class="chat-messages flex-grow-1 pa-4 overflow-y-auto">
          <div class="text-center my-4 text-caption text-grey">2023년 1월 18일</div>
          <div
            v-for="(m, i) in messages"
            :key="i"
            class="d-flex mb-4"
            :class="{ 'justify-end': m.me }"
          >
            <template v-if="!m.me">
              <v-avatar size="32" class="mr-2"><v-icon color="primary">mdi-account</v-icon></v-avatar>
              <div>
                <div class="pa-3 bg-grey-lighten-4 rounded-xl">{{ m.text }}</div>
                <div class="text-caption text-grey mt-1">{{ m.time }}</div>
              </div>
            </template>
            <template v-else>
              <div>
                <div class="pa-3 bg-primary text-white rounded-xl">{{ m.text }}</div>
                <div class="text-caption text-grey mt-1 text-right">{{ m.time }}</div>
              </div>
            </template>
          </div>
        </div>
        <div class="chat-input d-flex align-center pa-4 ga-2">
          <v-btn icon variant="text"><v-icon>mdi-plus</v-icon></v-btn>
          <v-text-field
            v-model="draft"
            variant="solo"
            density="comfortable"
            hide-details
            placeholder="메시지를 입력하세요..."
            class="flex-grow-1"
            @keydown.enter.prevent="send"
          />
          <v-btn icon variant="text"><v-icon>mdi-emoticon-outline</v-icon></v-btn>
          <v-btn icon color="primary" @click="send"><v-icon>mdi-send</v-icon></v-btn>
        </div>
      </v-col>
    </v-row>
  </v-container>
</template>

<script setup>
import { ref, computed } from 'vue'

const query = ref('')
const chats = ref([
  { id: 1, name: '김서연', last: '안녕하세요! 오늘 날씨가 정말 좋네요' },
  { id: 2, name: '대학 동기', last: '오늘은 다음 주 모임 관련 이야기' }
])
const current = ref(chats.value[0])
const draft = ref('')
const conversations = ref({
  1: [
    { text: '영재씨에게 연락 넣어놨어', time: '오전 9:01', me: false },
    { text: '확인되면 바로 알려줘', time: '오전 9:02', me: true },
    { text: '내일 몇 시에 만나는게 좋을까?', time: '오전 9:05', me: false },
    { text: '3시에 카페 앞에서 만나자', time: '오전 9:06', me: true }
  ],
  2: []
})

const messages = computed(() => conversations.value[current.value.id] || [])

function openChat(item) {
  current.value = item
  if (!conversations.value[item.id]) conversations.value[item.id] = []
}

function send() {
  if (!draft.value) return
  const formatted = new Date().toLocaleTimeString([], {
    hour: '2-digit',
    minute: '2-digit'
  })
  const msg = { text: draft.value, time: formatted, me: true }
  conversations.value[current.value.id].push(msg)
  const chat = chats.value.find(c => c.id === current.value.id)
  if (chat) chat.last = draft.value
  draft.value = ''
}
</script>

<style scoped>
.chat-page {
  background: #f7f7f9;
  height: 100%;
}
.chat-sidebar {
  border-right: 1px solid #e0e0e0;
  background: #fff;
  height: 100%;
}
.chat-main {
  background: #fff;
  height: 100%;
}
.chat-messages {
  background: #fafafa;
}
</style>

