<template>
  <nav class="nav">
    <nav-link v-for="(navLink, index) in nav" 
      :key="getKey(index)"
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

        let match = 0

        this.children.forEach(child => {
          if(child.name === selectedName) {
            child.isActive = true
            match+= 1           
          } else {
            child.isActive = false
          }
        })
        
        if(match == 0) { 
          this.children[0].isActive = true 
          window.location.replace(`#${this.children[0].name}`)
        }
      }
    },

    getId (index) {
      return `nav-link-${this.id}-${index}`
    }
  }
</script>