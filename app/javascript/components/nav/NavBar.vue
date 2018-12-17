<template>
  <nav class="nav">
    <nav-link v-for="navLink in nav" 
      :title="navLink.title" 
      :name="navLink.name">
    </nav-link>
  </nav>  
</template>

<script>
  import { eventHub } from '../../packs/application.js'
  import NavLink from './NavLink.vue'

  export default {
    name: 'nav-bar',

    components: { NavLink },

    props: {
      nav: {
        type: Array,
        required: true
      }
    },

    data () {
      return {
        children: []
      }
    },

    created () {
      this.children = this.$children

      eventHub.$on('changeHabitat', this.updateNav)
    },

    watch: {
      children () {
        if(this.children.length > 0) { this.updateNav(this.children[0].name) }
      }
    },

    methods: {
      updateNav (selectedName) {
        this.children.forEach(child => {
          child.isActive = child.name === selectedName
        })
      }
    }
  }
</script>