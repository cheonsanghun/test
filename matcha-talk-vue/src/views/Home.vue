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
