#!/usr/bin/env bash
set -e

APP_DIR="matcha-talk-vue"
echo "Creating $APP_DIR ..."
rm -rf "$APP_DIR"
mkdir -p "$APP_DIR"/{src/assets,src/components,src/views,src/router,src/stores,src/services,db}

# ---------- package.json ----------
cat > "$APP_DIR/package.json" <<'JSON'
{
  "name": "matcha-talk-vue",
  "version": "0.1.0",
  "private": true,
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "axios": "^1.7.2",
    "pinia": "^2.1.7",
    "vue": "^3.4.27",
    "vue-router": "^4.3.2",
    "vuetify": "^3.6.9"
  },
  "devDependencies": {
    "@vitejs/plugin-vue": "^5.0.5",
    "vite": "^5.4.2",
    "sass": "^1.77.8"
  }
}
JSON

# ---------- vite.config.js ----------
cat > "$APP_DIR/vite.config.js" <<'JS'
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [vue()],
  server: { port: 5173, open: true },
})
JS

# ---------- index.html ----------
cat > "$APP_DIR/index.html" <<'HTML'
<!doctype html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Matcha Talk</title>
  </head>
  <body>
    <div id="app"></div>
    <script type="module" src="/src/main.js"></script>
  </body>
</html>
HTML

# ---------- src/main.js ----------
cat > "$APP_DIR/src/main.js" <<'JS'
import { createApp } from 'vue'
import { createPinia } from 'pinia'
import { createVuetify } from 'vuetify'
import * as components from 'vuetify/components'
import * as directives from 'vuetify/directives'
import 'vuetify/styles'
import App from './App.vue'
import router from './router'

const vuetify = createVuetify({ components, directives })
createApp(App).use(createPinia()).use(router).use(vuetify).mount('#app')
JS

# ---------- src/App.vue ----------
cat > "$APP_DIR/src/App.vue" <<'VUE'
<template>
  <v-app>
    <AppHeader />
    <v-main class="bg-pink-lighten-5">
      <router-view />
    </v-main>
    <v-footer class="bg-pink-lighten-5">
      <v-container class="text-center py-6">
        <div class="text-caption">&copy; 2025 Matcha Talk. All rights reserved.</div>
      </v-container>
    </v-footer>
  </v-app>
</template>

<script setup>
import AppHeader from './components/AppHeader.vue'
</script>

<style>
html, body, #app { height: 100%; }
</style>
VUE

# ---------- src/router/index.js ----------
cat > "$APP_DIR/src/router/index.js" <<'JS'
import { createRouter, createWebHistory } from 'vue-router'
import Home from '../views/Home.vue'
import Login from '../views/Login.vue'
import Register from '../views/Register.vue'
import MatchingSetup from '../views/MatchingSetup.vue'
import MatchingResult from '../views/MatchingResult.vue'
import Chat from '../views/Chat.vue'
import Profile from '../views/Profile.vue'

const routes = [
  { path: '/', name: 'home', component: Home },
  { path: '/login', name: 'login', component: Login },
  { path: '/register', name: 'register', component: Register },
  { path: '/match', name: 'match', component: MatchingSetup },
  { path: '/match/result', name: 'match-result', component: MatchingResult },
  { path: '/chat', name: 'chat', component: Chat },
  { path: '/profile', name: 'profile', component: Profile },
]

export default createRouter({ history: createWebHistory(), routes })
JS

# ---------- src/stores/auth.js ----------
cat > "$APP_DIR/src/stores/auth.js" <<'JS'
import { defineStore } from 'pinia'
export const useAuthStore = defineStore('auth', {
  state: () => ({
    token: localStorage.getItem('token'),
    user: localStorage.getItem('user') ? JSON.parse(localStorage.getItem('user')) : null,
  }),
  getters: { isAuthenticated: (s) => !!s.token },
  actions: {
    login({ token, user }) {
      this.token = token; this.user = user
      localStorage.setItem('token', token)
      localStorage.setItem('user', JSON.stringify(user))
    },
    logout() {
      this.token = null; this.user = null
      localStorage.removeItem('token'); localStorage.removeItem('user')
    },
  },
})
JS

# ---------- src/services/api.js ----------
cat > "$APP_DIR/src/services/api.js" <<'JS'
import axios from 'axios'
const api = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL || 'http://localhost:8080/api',
  withCredentials: true,
})
api.interceptors.request.use((config) => {
  const token = localStorage.getItem('token')
  if (token) config.headers.Authorization = `Bearer ${token}`
  return config
})
export default api
JS

# ---------- src/components/AppHeader.vue ----------
cat > "$APP_DIR/src/components/AppHeader.vue" <<'VUE'
<template>
  <v-app-bar flat class="bg-pink-lighten-5">
    <v-container class="d-flex align-center justify-space-between">
      <div class="d-flex align-center">
        <v-icon class="me-2" color="pink">mdi-flower</v-icon>
        <router-link to="/" class="text-h6 text-decoration-none text-pink-darken-2">
          Matcha Talk
        </router-link>
      </div>

      <div v-if="!isAuth" class="d-flex ga-3">
        <v-btn variant="outlined" color="pink" to="/login">로그인</v-btn>
        <v-btn color="pink" to="/register">회원가입</v-btn>
      </div>

      <div v-else class="d-flex ga-3">
        <v-btn variant="tonal" color="pink" to="/match">매칭</v-btn>
        <v-btn variant="tonal" color="pink" to="/chat">채팅</v-btn>
        <v-btn variant="tonal" color="pink" to="/shop" disabled>상점</v-btn>
        <v-btn color="pink" to="/profile">프로필</v-btn>
      </div>
    </v-container>
  </v-app-bar>
</template>

<script setup>
import { storeToRefs } from 'pinia'
import { useAuthStore } from '../stores/auth'
const store = useAuthStore()
const { isAuthenticated: isAuth } = storeToRefs(store)
</script>
VUE

# ---------- src/views/Home.vue ----------
cat > "$APP_DIR/src/views/Home.vue" <<'VUE'
<template>
  <v-container class="py-10">
    <div class="text-center">
      <h1 class="text-h4 text-pink-darken-2 font-weight-bold">MatchaTalk</h1>
      <div class="text-subtitle-1 text-pink-darken-1 mt-2">문화 교류 랜덤 채팅</div>
      <v-img src="/src/assets/board_3.jpg" height="260" class="my-8 rounded-lg" cover />
      <p class="text-body-2">
        Matcha Talk에서 당신의 관심사와 취향이 맞는 특별한 인연을 찾아보세요.
        벚꽃처럼 아름다운 만남이 기다리고 있습니다.
      </p>
      <h3 class="text-h6 mt-8 text-pink-darken-2 font-weight-bold">새로운 인연을 만나는 가장 아름다운 방법</h3>
      <v-btn class="mt-4" color="pink" variant="elevated" size="large" :to="ctaTo">가입 하기</v-btn>
    </div>

    <v-row class="mt-12" justify="center" align="stretch" no-gutters>
      <v-col cols="12" sm="4" class="pa-4">
        <v-card class="pa-6" variant="outlined" >
          <div class="text-center">
            <v-icon size="36" color="pink">mdi-account-multiple</v-icon>
            <div class="text-subtitle-1 font-weight-bold mt-3">맞춤형 매칭</div>
            <div class="text-body-2 mt-2">관심사와 취향을 분석하여 가장 맞는 인연을 소개합니다.</div>
          </div>
        </v-card>
      </v-col>
      <v-col cols="12" sm="4" class="pa-4">
        <v-card class="pa-6" variant="outlined">
          <div class="text-center">
            <v-icon size="36" color="pink">mdi-chat-processing</v-icon>
            <div class="text-subtitle-1 font-weight-bold mt-3">실시간 채팅</div>
            <div class="text-body-2 mt-2">편안하고 안전한 환경에서 새로운 인연과 대화해보세요.</div>
          </div>
        </v-card>
      </v-col>
      <v-col cols="12" sm="4" class="pa-4">
        <v-card class="pa-6" variant="outlined">
          <div class="text-center">
            <v-icon size="36" color="pink">mdi-gift</v-icon>
            <div class="text-subtitle-1 font-weight-bold mt-3">특별한 선물</div>
            <div class="text-body-2 mt-2">상점에서 특별 상품을 구매하여 마음을 전해보세요.</div>
          </div>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script setup>
const ctaTo = '/register'
</script>
VUE

# ---------- src/views/Register.vue ----------
cat > "$APP_DIR/src/views/Register.vue" <<'VUE'
<template>
  <v-container class="py-10">
    <v-row justify="center">
      <v-col cols="12" md="8" lg="6">
        <v-card class="pa-8">
          <div class="text-center text-h6 text-pink-darken-2 mb-6">회원가입</div>

          <v-form @submit.prevent="onSubmit" v-model="valid">
            <v-text-field v-model="form.nick_name" label="이름" :rules="[r.required, r.len(2,30)]" variant="outlined" />
            <v-row>
              <v-col cols="9">
                <v-text-field v-model="form.login_id" label="아이디" :rules="[r.required, r.len(4,30)]" variant="outlined" />
              </v-col>
              <v-col cols="3" class="d-flex align-end">
                <v-btn block color="pink" variant="tonal" @click="checkDuplicate">중복 확인</v-btn>
              </v-col>
            </v-row>
            <v-row>
              <v-col cols="9">
                <v-text-field v-model="form.email" label="이메일" :rules="[r.required, r.email]" variant="outlined" />
              </v-col>
              <v-col cols="3" class="d-flex align-end">
                <v-btn block color="pink" variant="tonal" @click="verifyEmail">이메일 인증</v-btn>
              </v-col>
            </v-row>
            <v-text-field v-model="form.password" type="password" label="비밀번호" :rules="[r.required, r.len(8,100)]" variant="outlined" />
            <v-text-field v-model="form.password2" type="password" label="비밀번호 확인"
                          :rules="[r.required, (v)=> v === form.password || '비밀번호가 일치하지 않습니다.']" variant="outlined" />
            <v-row>
              <v-col cols="12" sm="6">
                <v-text-field v-model="form.birth_date" label="생년월일 (YYYY-MM-DD)" :rules="[r.required, r.date]" variant="outlined" />
              </v-col>
              <v-col cols="12" sm="6">
                <v-select v-model="form.gender" :items="genderItems" label="성별" :rules="[r.required]" variant="outlined" />
              </v-col>
            </v-row>
            <v-select v-model="form.country_code" :items="countryItems" label="국적" :rules="[r.required]" variant="outlined" />

            <v-btn type="submit" color="pink" block class="mt-4" :disabled="!valid">회원가입</v-btn>
          </v-form>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script setup>
import api from '../services/api'
import { ref } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
const valid = ref(false)
const genderItems = ['M','F']
const countryItems = ['KR','JP','US','CN','GB','DE','FR']

const form = ref({
  nick_name: '', login_id: '', email: '',
  password: '', password2: '', birth_date: '', gender: null, country_code: null
})

const r = {
  required: v => !!v || '필수 입력입니다.',
  len: (min,max) => v => (v && v.length>=min && v.length<=max) || `${min}~${max}자`,
  email: v => !!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(v) || '이메일 형식',
  date: v => !!/^\d{4}-\d{2}-\d{2}$/.test(v) || 'YYYY-MM-DD',
}

async function checkDuplicate(){ alert('중복 확인 API는 백엔드 연결 후 동작합니다.') }
async function verifyEmail(){ alert('이메일 인증은 백엔드 연결 후 동작합니다.') }

async function onSubmit(){
  const payload = {
    login_id: form.value.login_id,
    password: form.value.password,
    nick_name: form.value.nick_name,
    email: form.value.email,
    country_code: form.value.country_code,
    gender: form.value.gender,
    birth_date: form.value.birth_date,
  }
  try{
    // await api.post('/auth/register', payload)
    alert('회원가입 예시 완료 (백엔드 연결 필요)')
    router.push('/login')
  }catch(e){
    alert('회원가입 실패: ' + (e?.response?.data?.message || e.message))
  }
}
</script>
VUE

# ---------- src/views/Login.vue ----------
cat > "$APP_DIR/src/views/Login.vue" <<'VUE'
<template>
  <v-container class="py-10">
    <v-row justify="center">
      <v-col cols="12" md="6" lg="5">
        <v-card class="pa-8">
          <div class="text-center text-h6 text-pink-darken-2 mb-6">로그인</div>
          <v-form @submit.prevent="onLogin">
            <v-text-field v-model="login_id" label="아이디" variant="outlined" />
            <v-text-field v-model="password" type="password" label="비밀번호" variant="outlined" />
            <div class="d-flex ga-3 mt-4">
              <v-btn color="pink" type="submit">로그인</v-btn>
              <v-spacer/>
              <v-btn variant="tonal" color="pink">비밀번호 찾기</v-btn>
            </div>
          </v-form>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script setup>
import { ref } from 'vue'
import { useAuthStore } from '../stores/auth'
import { useRouter } from 'vue-router'

const router = useRouter()
const store = useAuthStore()
const login_id = ref('')
const password = ref('')

async function onLogin(){
  if(!login_id.value || !password.value){
    return alert('아이디/비밀번호를 입력하세요')
  }
  const fakeToken = 'demo-token'
  const user = { user_pid: 1, login_id: login_id.value, nick_name: 'Guest', email:'guest@example.com' }
  store.login({ token: fakeToken, user })
  router.push('/')
}
</script>
VUE

# ---------- src/views/MatchingSetup.vue ----------
cat > "$APP_DIR/src/views/MatchingSetup.vue" <<'VUE'
<template>
  <v-container class="py-10">
    <v-row justify="center">
      <v-col cols="12" md="8" lg="6">
        <v-card class="pa-8">
          <div class="text-center text-h6 text-pink-darken-2 mb-6">나에게 맞는 인연 찾기</div>

          <div class="mb-6">
            <div class="text-subtitle-2 mb-2">나이 범위</div>
            <v-slider v-model="age" :min="20" :max="99" :step="1" thumb-label />
            <div class="text-caption">{{ age }} 세</div>
          </div>

          <div class="mb-6">
            <div class="text-subtitle-2 mb-2">성별</div>
            <v-radio-group v-model="gender" inline>
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
            <v-btn color="green" variant="tonal" @click="dialog=true">보기</v-btn>
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
VUE

# ---------- src/views/MatchingResult.vue ----------
cat > "$APP_DIR/src/views/MatchingResult.vue" <<'VUE'
<template>
  <v-container class="py-10">
    <v-row justify="center">
      <v-col cols="12" md="10">
        <v-card class="pa-6">
          <div class="text-center text-h6 text-pink-darken-2 mb-6">매칭</div>

          <v-row>
            <v-col cols="12" md="9">
              <div class="rounded-lg bg-pink-lighten-5 d-flex align-center justify-center" style="height: 380px;">
                <div class="text-subtitle-1">매칭 이미지 / 영상 영역</div>
              </div>
            </v-col>
            <v-col cols="12" md="3">
              <v-card variant="outlined" class="pa-4" style="height: 380px;">
                <div class="text-subtitle-2">채팅 창</div>
                <div class="mt-2 text-caption">실시간 채팅은 WebSocket 연결 후 동작합니다.</div>
              </v-card>
            </v-col>
          </v-row>

          <div class="text-center mt-6">
            <v-btn color="pink" variant="tonal">매칭 수락</v-btn>
          </div>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>
<script setup>
</script>
VUE

# ---------- src/views/Chat.vue ----------
cat > "$APP_DIR/src/views/Chat.vue" <<'VUE'
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
VUE

# ---------- src/views/Profile.vue ----------
cat > "$APP_DIR/src/views/Profile.vue" <<'VUE'
<template>
  <v-container class="py-10">
    <v-row justify="center">
      <v-col cols="12" md="8">
        <v-card class="pa-6">
          <div class="d-flex align-center ga-4">
            <v-avatar size="64" class="bg-pink-lighten-4"><v-icon color="pink">mdi-account</v-icon></v-avatar>
            <div>
              <div class="text-subtitle-1">{{ user?.nick_name || 'Guest' }}</div>
              <div class="text-caption">{{ user?.email }}</div>
            </div>
            <v-spacer/>
            <v-btn color="pink" variant="tonal" @click="logout">로그아웃</v-btn>
          </div>
          <v-divider class="my-4"/>
          <div class="text-caption">프로필/친구/차단/언어 설정 등은 추후 확장</div>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script setup>
import { useAuthStore } from '../stores/auth'
import { storeToRefs } from 'pinia'
const store = useAuthStore()
const { user } = storeToRefs(store)
function logout(){ store.logout() }
</script>
VUE

# ---------- .env.example ----------
cat > "$APP_DIR/.env.example" <<'ENV'
VITE_API_BASE_URL=http://localhost:8080/api
ENV

# ---------- README.md ----------
cat > "$APP_DIR/README.md" <<'MD'
# Matcha Talk (Vue + Vuetify)

Vue 3 + Vite + Vuetify 3 프런트엔드입니다. 제공된 SQL 스키마(`/db/First_sql.sql`)를 기준으로
회원/매칭/채팅/프로필 화면을 설계했습니다. Spring Boot + MySQL 백엔드와 연동하면 실제 동작합니다.

## 실행
```bash
npm install
npm run dev
# http://localhost:5173
