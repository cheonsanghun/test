<template>
  <v-container class="py-10 bg-pink-lighten-5">
    <v-row justify="center">
      <v-col cols="12" md="6">
        <v-card class="pa-8">
          <div class="text-center text-h6 text-pink-darken-2 mb-6">회원가입</div>

          <v-form @submit.prevent="onSubmit">
            <v-text-field
              v-model="form.nick_name"
              label="이름"
              variant="outlined"
              class="mb-4"
              :error-messages="errors.nick_name"
              @blur="validate('nick_name')"
            />

            <div class="d-flex align-end mb-4">
              <v-text-field
                v-model="form.login_id"
                label="아이디"
                variant="outlined"
                class="flex-grow-1 me-2"
                :error-messages="errors.login_id"
                @blur="validate('login_id')"
              />
              <v-btn variant="outlined" color="pink">중복 확인</v-btn>
            </div>

            <div class="d-flex align-end mb-4">
              <v-text-field
                v-model="form.email"
                label="이메일"
                variant="outlined"
                class="flex-grow-1 me-2"
                :error-messages="errors.email"
                @blur="validate('email')"
              />
              <v-btn variant="outlined" color="pink">이메일 인증</v-btn>
            </div>

            <v-text-field
              v-model="form.password"
              type="password"
              label="비밀번호"
              variant="outlined"
              class="mb-4"
              :error-messages="errors.password"
              @blur="validate('password')"
            />

            <v-text-field
              v-model="form.password2"
              type="password"
              label="비밀번호 확인"
              variant="outlined"
              class="mb-4"
              :error-messages="errors.password2"
              @blur="validate('password2')"
            />

            <div class="mb-4">
              <div class="d-flex" style="gap: 8px;">
                <v-select
                  v-model="birth.year"
                  :items="yearItems"
                  label="년도"
                  variant="outlined"
                  class="flex-grow-1"
                  @blur="validate('birth')"
                />
                <v-select
                  v-model="birth.month"
                  :items="monthItems"
                  label="월"
                  variant="outlined"
                  class="flex-grow-1"
                  @blur="validate('birth')"
                />
                <v-select
                  v-model="birth.day"
                  :items="dayItems"
                  label="일"
                  variant="outlined"
                  class="flex-grow-1"
                  @blur="validate('birth')"
                />
              </div>
              <span class="text-caption text-pink-darken-2">{{ errors.birth }}</span>
            </div>

            <v-select
              v-model="form.gender"
              :items="genderItems"
              label="성별"
              variant="outlined"
              class="mb-4"
              :error-messages="errors.gender"
              @blur="validate('gender')"
            />

            <v-select
              v-model="form.country_code"
              :items="countryItems"
              label="국적"
              variant="outlined"
              class="mb-6"
              :error-messages="errors.country_code"
              @blur="validate('country_code')"
            />

            <v-btn type="submit" color="pink" block :disabled="!valid">회원가입</v-btn>
          </v-form>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script setup>
import api from '../services/api'
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
const genderItems = ['M','F']
const countryItems = ['KR','JP','US','CN','GB','DE','FR']

const form = ref({
  nick_name: '', login_id: '', email: '',
  password: '', password2: '',
  gender: null, country_code: null
})

const birth = ref({ year: null, month: null, day: null })
const yearItems = Array.from({length: 100}, (_,i) => new Date().getFullYear() - i)
const monthItems = Array.from({length: 12}, (_,i) => i + 1)
const dayItems = Array.from({length: 31}, (_,i) => i + 1)

const errors = ref({
  nick_name: '', login_id: '', email: '', password: '', password2: '',
  birth: '', gender: '', country_code: ''
})

const valid = computed(() => Object.values(errors.value).every(e => !e))

const r = {
  required: v => !!v || '필수 입력입니다.',
  len: (min,max) => v => (v && v.length>=min && v.length<=max) || `${min}~${max}자`,
  email: v => !!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(v) || '이메일 형식'
}

function checkRules(value, rules){
  for(const rule of rules){
    const res = rule(value)
    if(res !== true) return res
  }
  return ''
}

function validate(field){
  switch(field){
    case 'nick_name':
      errors.value.nick_name = checkRules(form.value.nick_name, [r.required, r.len(2,30)])
      break
    case 'login_id':
      errors.value.login_id = checkRules(form.value.login_id, [r.required, r.len(4,30)])
      break
    case 'email':
      errors.value.email = checkRules(form.value.email, [r.required, r.email])
      break
    case 'password':
      errors.value.password = checkRules(form.value.password, [r.required, r.len(8,100)])
      break
    case 'password2':
      errors.value.password2 = form.value.password2 === form.value.password ? '' : '비밀번호가 일치하지 않습니다.'
      break
    case 'birth':
      const {year, month, day} = birth.value
      errors.value.birth = year && month && day ? '' : '생년월일을 입력하세요.'
      break
    case 'gender':
      errors.value.gender = form.value.gender ? '' : '성별을 선택하세요.'
      break
    case 'country_code':
      errors.value.country_code = form.value.country_code ? '' : '국적을 선택하세요.'
      break
  }
}

async function onSubmit(){
  ;['nick_name','login_id','email','password','password2','birth','gender','country_code'].forEach(validate)
  if(!valid.value) return

  const birth_date = `${birth.value.year}-${String(birth.value.month).padStart(2,'0')}-${String(birth.value.day).padStart(2,'0')}`
  const payload = {
    login_id: form.value.login_id,
    password: form.value.password,
    nick_name: form.value.nick_name,
    email: form.value.email,
    country_code: form.value.country_code,
    gender: form.value.gender,
    birth_date
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
