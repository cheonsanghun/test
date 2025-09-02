<template>
  <v-container class="py-6">
    <v-row>
      <v-col cols="12">
        <v-card>
          <v-row no-gutters>
            <v-col cols="12" md="3" class="pa-4 bg-pink-lighten-5">
              <v-text-field v-model="query" label="채팅 검색" density="comfortable" variant="outlined" />
              <v-divider class="my-2" />
              <v-list>
                <v-list-subheader>1:1 채팅</v-list-subheader>
                <v-list-item v-for="(item,i) in chats" :key="i" :title="item.name" :subtitle="item.last"
                             @click="openChat(item)">
                  <template #prepend>
                    <v-avatar size="32"><v-icon color="pink">mdi-account</v-icon></v-avatar>
                  </template>
                </v-list-item>
              </v-list>
            </v-col>
            <v-col cols="12" md="9" class="pa-4">
              <div class="d-flex align-center justify-space-between">
                <div class="text-subtitle-1">{{ current?.name || '대화 상대 없음' }}</div>
                <div class="text-caption">{{ today }}</div>
              </div>
              <v-divider class="my-3"/>
              <div class="pa-2" style="height: 420px; overflow:auto;">
                <div v-for="(m, i) in messages" :key="i" class="my-2">
                  <div :class="m.me ? 'text-right' : 'text-left'">
                    <v-chip :color="m.me ? 'pink' : ''" :variant="m.me ? 'elevated' : 'outlined'">
                      {{ m.text }}
                    </v-chip>
                  </div>
                </div>
              </div>
              <div class="d-flex ga-2 mt-3">
                <v-text-field v-model="draft" placeholder="메시지를 입력하세요..." hide-details
                              variant="outlined" density="comfortable" />
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
  { id:1, name:'김서연', last:'안녕하세요! 오늘 날씨가 정말 좋네요' },
  { id:2, name:'대학 동기', last:'오늘은 다음 주 모임 관련 이야기' },
])
const today = new Date().toLocaleDateString()
const current = ref(null)
const draft = ref('')
const messages = ref([
  { text:'안녕하세요! 오늘 날씨가 정말 좋네요', me:false },
  { text:'네, 맞아요! 산책하기 좋은 날씨에요!', me:true },
])
function openChat(item){ current.value = item }
function send(){ if(!draft.value) return; messages.value.push({ text: draft.value, me:true }); draft.value = '' }
</script>
