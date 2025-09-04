import { createRouter, createWebHistory } from 'vue-router'
import Home from '../views/Home.vue'
import Login from '../views/Login.vue'
import Register from '../views/Register.vue'
import MatchingSetup from '../views/MatchingSetup.vue'
import MatchingWait from '../views/MatchingWait.vue'
import Chat from '../views/Chat.vue'
import Profile from '../views/Profile.vue'

const routes = [
  { path: '/', name: 'home', component: Home },
  { path: '/login', name: 'login', component: Login },
  { path: '/register', name: 'register', component: Register },
  { path: '/match', name: 'match', component: MatchingSetup },
  { path: '/match/wait', name: 'match-wait', component: MatchingWait },
  { path: '/chat', name: 'chat', component: Chat },
  { path: '/profile', name: 'profile', component: Profile },
]

export default createRouter({ history: createWebHistory(), routes })
