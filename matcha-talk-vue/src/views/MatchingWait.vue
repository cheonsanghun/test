<template>
  <v-container class="py-10">
    <v-row justify="center">
      <v-col cols="12" md="8">
        <v-card class="pa-6 text-center">
          <template v-if="!matchFound">
            <div class="text-h6 mb-4">매칭 대기 중...</div>
            <v-progress-circular indeterminate color="pink" />
            <v-btn
              v-if="readyToStart"
              color="pink"
              class="mt-6"
              @click="startRandomChat"
            >채팅 시작</v-btn>
          </template>

          <template v-else>
            <div class="text-h6 mb-4">{{ partnerName }}님과 매칭되었습니다</div>
            <v-avatar size="80" class="mx-auto mb-4">
              <v-img :src="partnerAvatar" alt="avatar" />
            </v-avatar>
            <div class="d-flex justify-center gap-4">
              <v-btn color="pink" variant="tonal" @click="acceptMatch">수락</v-btn>
              <v-btn color="grey" variant="outlined" @click="declineMatch">거절</v-btn>
            </div>
          </template>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
const readyToStart = ref(false)
const matchFound = ref(false)
const partnerName = ref('홍길동')
const partnerAvatar = ref('https://via.placeholder.com/150')

setTimeout(() => {
  readyToStart.value = true
}, 2000)

function startRandomChat() {
  // TODO: 실제 랜덤 매칭 로직 연동
  matchFound.value = true
}

function acceptMatch() {
  router.push('/chat')
}

function declineMatch() {
  matchFound.value = false
}
</script>
