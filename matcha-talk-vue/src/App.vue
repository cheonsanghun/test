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
