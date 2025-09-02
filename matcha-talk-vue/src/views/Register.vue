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
