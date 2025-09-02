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
