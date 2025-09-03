<template>
  <v-container class="py-10">
    <v-row justify="center">
      <v-col cols="12" md="8" lg="6">
        <v-card class="pa-8">
          <div class="text-center text-h6 text-pink-darken-2 mb-6">나에게 맞는 인연 찾기</div>

          <div class="mb-6">
            <div class="text-subtitle-2 mb-2">나이 범위</div>
            <v-slider v-model="age" :min="20" :max="99" :step="1" thumb-label color="pink" track-color="pink-lighten-4" />
            <div class="text-caption">{{ age }} 세</div>
          </div>

          <div class="mb-6">
            <div class="text-subtitle-2 mb-2">성별</div>
            <v-radio-group v-model="gender" inline color="pink">
              <v-radio label="남성" value="M"/>
              <v-radio label="여성" value="F"/>
              <v-radio label="상관없음" value="A"/>
            </v-radio-group>
          </div>

          <div class="mb-6">
            <div class="text-subtitle-2 mb-2">희망 지역</div>
            <v-chip-group v-model="region" selected-class="bg-pink text-white" inline>
              <v-chip value="SEOUL" variant="outlined">서울</v-chip>
              <v-chip value="BUSAN" variant="outlined">부산</v-chip>
              <v-chip value="TOKYO" variant="outlined">도쿄</v-chip>
              <v-chip value="OSAKA" variant="outlined">오사카</v-chip>
              <v-chip value="FUKUOKA" variant="outlined">후쿠오카</v-chip>
              <v-chip value="JEJU" variant="outlined">제주</v-chip>
              <v-chip value="OTHER" variant="outlined">기타</v-chip>
            </v-chip-group>
          </div>

          <div class="mb-6 text-center">
            <div class="text-subtitle-2 mb-2">관심사</div>
            <v-btn color="pink" variant="tonal" @click="dialog=true">보기</v-btn>
            <div class="text-caption mt-2" v-if="interests.length">선택: {{ interests.join(', ') }}</div>
          </div>

          <v-btn color="pink" block size="large" @click="startMatch">매칭 시작</v-btn>
          <div class="text-center text-caption mt-2">매칭 시작 시 대기열에 입력합니다</div>
        </v-card>
      </v-col>
    </v-row>

    <v-dialog v-model="dialog" width="420">
      <v-card>
        <v-card-title>관심사 선택</v-card-title>
        <v-card-text>
          <v-chip-group v-model="interests" multiple>
            <v-chip v-for="i in interestPool" :key="i" :value="i" class="ma-1" variant="outlined">{{ i }}</v-chip>
          </v-chip-group>
        </v-card-text>
        <v-card-actions>
          <v-spacer/>
          <v-btn color="pink" variant="tonal" @click="dialog=false">확인</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-container>
</template>

<script setup>
import { ref } from 'vue'
import api from '../services/api'
import { useRouter } from 'vue-router'

const router = useRouter()
const age = ref(20)
const gender = ref('A')
const region = ref('BUSAN')
const dialog = ref(false)
const interestPool = ['음악','영화','게임','여행','요리','운동','독서']
const interests = ref([])

async function startMatch(){
  const payload = {
    choice_gender: gender.value,
    min_age: 20, max_age: age.value,
    region_code: region.value,
    interests_json: interests.value,
  }
  try{
    // await api.post('/match/requests', payload)
    router.push('/match/result')
  }catch(e){
    alert('매칭 실패: ' + (e?.response?.data?.message || e.message))
  }
}
</script>
