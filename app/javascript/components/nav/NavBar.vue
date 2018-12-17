<template>
  <nav class="nav">
    <nav-link v-for="navItem in nav">{{ nav.title }}</nav-link>
  </nav>  
</template>

<script>
  import NavItem from './NavItem.vue'
  
  export default {
    name: 'nav-bar',

    props: {
      nav: {
        type: Array,
        required: true
      }
    }
  }
</script>