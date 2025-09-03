<template>
  <v-container fluid class="py-6">
    <v-row>
      <v-col cols="12">
        <v-card>
          <v-row no-gutters>
            <!-- Left : chat list -->
            <v-col cols="12" md="3" class="pa-4 bg-pink-lighten-5">
              <div class="d-flex align-center justify-space-between mb-4">
                <div class="text-h6">채팅</div>
                <v-btn icon variant="text"><v-icon>mdi-plus</v-icon></v-btn>
              </div>
              <v-text-field v-model="query" label="채팅 검색" density="comfortable" variant="outlined" />
              <v-divider class="my-2" />
              <v-list>
                <v-list-subheader>1:1 채팅</v-list-subheader>
                <v-list-item
                  v-for="item in chats"
                  :key="item.id"
                  :title="item.name"
                  :subtitle="item.last"
                  @click="openChat(item)"
                >
                  <template #prepend>
                    <v-avatar size="32"><v-icon color="pink">mdi-account</v-icon></v-avatar>
                  </template>
                </v-list-item>
              </v-list>
            </v-col>
            <!-- Right : chat window -->
            <v-col cols="12" md="9" class="pa-4">
              <div v-if="current" class="d-flex align-center justify-space-between mb-4">
                <div class="d-flex align-center ga-3">
                  <v-avatar size="40"><v-icon color="pink">mdi-account</v-icon></v-avatar>
                  <div>
                    <div class="text-subtitle-1">{{ current.name }}</div>
                    <div class="text-caption text-grey">온라인</div>
                  </div>
                </div>
                <div class="d-flex align-center ga-1">
                  <v-btn icon variant="text"><v-icon>mdi-magnify</v-icon></v-btn>
                  <v-btn icon variant="text"><v-icon>mdi-dots-vertical</v-icon></v-btn>
                </div>
              </div>
              <div v-else class="text-center py-12 text-grey">대화 상대를 선택하세요</div>
              <v-divider />
              <div class="pa-2" style="height: 420px; overflow-y: auto;">
                <div v-for="(m, i) in messages" :key="i" class="my-3">
                  <div v-if="!m.me" class="d-flex align-end">
                    <v-avatar size="32" class="mr-2"><v-icon color="pink">mdi-account</v-icon></v-avatar>
                    <div class="pa-3 bg-grey-lighten-3 rounded-lg">
                      {{ m.text }}
                    </div>
                    <div class="text-caption text-grey-darken-1 ml-2">
                      {{ m.time }}
                    </div>
                  </div>
                  <div v-else class="d-flex align-end justify-end">
                    <div class="text-caption text-grey-darken-1 mr-2">
                      {{ m.time }}
                    </div>
                    <div class="pa-3 bg-pink text-white rounded-lg">
                      {{ m.text }}
                    </div>
                  </div>
                </div>
              </div>
              <div class="d-flex ga-2 mt-3 align-center">
                <v-text-field
                  v-model="draft"
                  placeholder="메시지를 입력하세요..."
                  hide-details
                  variant="outlined"
                  density="comfortable"
                  class="flex-grow-1"
                />
                <v-btn icon variant="text"><v-icon>mdi-paperclip</v-icon></v-btn>
                <v-btn icon color="pink" @click="send"><v-icon>mdi-send</v-icon></v-btn>
              </div>
            </v-col>
          </v-row>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script setup>
import { ref } from 'vue'
const query = ref('')
const chats = ref([
  { id: 1, name: '김서연', last: '안녕하세요! 오늘 날씨가 정말 좋네요' },
  { id: 2, name: '대학 동기', last: '오늘은 다음 주 모임 관련 이야기' }
])
const current = ref(chats.value[0])
const draft = ref('')
const messages = ref([
  { text: '안녕하세요! 오늘 날씨가 정말 좋네요', time: '오전 10:03', me: false },
  { text: '네, 맞아요! 산책하기 좋은 날씨에요!', time: '오전 10:05', me: true },
  { text: '그럼 내일 우리 동네 카페에서 만날래요?', time: '오후 1:20', me: false },
  { text: '2시에 만나기 괜찮죠?', time: '오후 1:21', me: false },
  { text: '네, 내일 카페에서 만나요!', time: '오후 1:25', me: true }
])

function openChat(item) {
  current.value = item
}

function send() {
  if (!draft.value) return
  messages.value.push({ text: draft.value, time: new Date().toLocaleTimeString(), me: true })
  draft.value = ''
}
</script>
