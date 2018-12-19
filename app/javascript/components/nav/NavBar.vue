<template>
  <nav class="nav">
    <nav-link v-for="navLink in nav" 
      :title="navLink.title" 
      :name="navLink.name"
      :theme="navLink.theme">
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
      },
      default: {
        type: String,
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
        if(this.children.length > 0) { this.updateNav(this.default) }
      }
    },

    methods: {
      updateNav (selectedName) {
        window.location.replace(`#${selectedName}`)

        this.children.forEach(child => {
          child.isActive = child.name === selectedName
        })
      }
    }
  }
</script>